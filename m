From: akpm@linux-foundation.org
Subject: + idr-fix-top-layer-handling.patch added to -mm tree
Date: Mon, 11 Feb 2013 15:42:17 -0800
Message-ID: <20130211234218.5872C31C1D6@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:41342 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760215Ab3BKXmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Feb 2013 18:42:21 -0500
Received: by mail-ie0-f201.google.com with SMTP id 16so1220718iea.4
        for <mm-commits@vger.kernel.org>; Mon, 11 Feb 2013 15:42:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, rusty@rustcorp.com.au, stable@vger.kernel.org


The patch titled
     Subject: idr: fix top layer handling
has been added to the -mm tree.  Its filename is
     idr-fix-top-layer-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: idr: fix top layer handling

Most functions in idr fail to deal with the high bits when the idr
tree grows to the maximum height.

* idr_get_empty_slot() stops growing idr tree once the depth reaches
  MAX_IDR_LEVEL - 1, which is one depth shallower than necessary to
  cover the whole range.  The function doesn't even notice that it
  didn't grow the tree enough and ends up allocating the wrong ID
  given sufficiently high @starting_id.

  For example, on 64 bit, if the starting id is 0x7fffff01,
  idr_get_empty_slot() will grow the tree 5 layer deep, which only
  covers the 30 bits and then proceed to allocate as if the bit 30
  wasn't specified.  It ends up allocating 0x3fffff01 without the bit
  30 but still returns 0x7fffff01.

* __idr_remove_all() will not remove anything if the tree is fully
  grown.

* idr_find() can't find anything if the tree is fully grown.

* idr_for_each() and idr_get_next() can't iterate anything if the tree
  is fully grown.

Fix it by introducing idr_max() which returns the maximum possible ID
given the depth of tree and replacing the id limit checks in all
affected places.

As the idr_layer pointer array pa[] needs to be 1 larger than the
maximum depth, enlarge pa[] arrays by one.

While this plugs the discovered issues, the whole code base is
horrible and in desparate need of rewrite.  It's fragile like hell,

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: <stable@vger.kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff -puN lib/idr.c~idr-fix-top-layer-handling lib/idr.c
--- a/lib/idr.c~idr-fix-top-layer-handling
+++ a/lib/idr.c
@@ -43,6 +43,14 @@ static DEFINE_PER_CPU(struct idr_layer *
 static DEFINE_PER_CPU(int, idr_preload_cnt);
 static DEFINE_SPINLOCK(simple_ida_lock);
 
+/* the maximum ID which can be allocated given idr->layers */
+static int idr_max(int layers)
+{
+	int bits = min_t(int, layers * IDR_BITS, MAX_IDR_SHIFT);
+
+	return (1 << bits) - 1;
+}
+
 static struct idr_layer *get_from_free_list(struct idr *idp)
 {
 	struct idr_layer *p;
@@ -290,7 +298,7 @@ build_up:
 	 * Add a new layer to the top of the tree if the requested
 	 * id is larger than the currently allocated space.
 	 */
-	while ((layers < (MAX_IDR_LEVEL - 1)) && (id >= (1 << (layers*IDR_BITS)))) {
+	while (id > idr_max(layers)) {
 		layers++;
 		if (!p->count) {
 			/* special case: if the tree is currently empty,
@@ -361,7 +369,7 @@ static void idr_fill_slot(void *ptr, int
  */
 int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id)
 {
-	struct idr_layer *pa[MAX_IDR_LEVEL];
+	struct idr_layer *pa[MAX_IDR_LEVEL + 1];
 	int rv;
 
 	rv = idr_get_empty_slot(idp, starting_id, pa, 0, idp);
@@ -457,7 +465,7 @@ EXPORT_SYMBOL(idr_preload);
 int idr_alloc(struct idr *idr, void *ptr, int start, int end, gfp_t gfp_mask)
 {
 	int max = end > 0 ? end - 1 : INT_MAX;	/* inclusive upper limit */
-	struct idr_layer *pa[MAX_IDR_LEVEL];
+	struct idr_layer *pa[MAX_IDR_LEVEL + 1];
 	int id;
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
@@ -490,7 +498,7 @@ static void idr_remove_warning(int id)
 static void sub_remove(struct idr *idp, int shift, int id)
 {
 	struct idr_layer *p = idp->top;
-	struct idr_layer **pa[MAX_IDR_LEVEL];
+	struct idr_layer **pa[MAX_IDR_LEVEL + 1];
 	struct idr_layer ***paa = &pa[0];
 	struct idr_layer *to_free;
 	int n;
@@ -571,16 +579,16 @@ void __idr_remove_all(struct idr *idp)
 	int n, id, max;
 	int bt_mask;
 	struct idr_layer *p;
-	struct idr_layer *pa[MAX_IDR_LEVEL];
+	struct idr_layer *pa[MAX_IDR_LEVEL + 1];
 	struct idr_layer **paa = &pa[0];
 
 	n = idp->layers * IDR_BITS;
 	p = idp->top;
 	rcu_assign_pointer(idp->top, NULL);
-	max = 1 << n;
+	max = idr_max(idp->layers);
 
 	id = 0;
-	while (id < max) {
+	while (id >= 0 && id <= max) {
 		while (n > IDR_BITS && p) {
 			n -= IDR_BITS;
 			*paa++ = p;
@@ -650,7 +658,7 @@ void *idr_find(struct idr *idp, int id)
 	/* Mask off upper bits we don't use for the search. */
 	id &= MAX_IDR_MASK;
 
-	if (id >= (1 << n))
+	if (id > idr_max(p->layer + 1))
 		return NULL;
 	BUG_ON(n == 0);
 
@@ -686,15 +694,15 @@ int idr_for_each(struct idr *idp,
 {
 	int n, id, max, error = 0;
 	struct idr_layer *p;
-	struct idr_layer *pa[MAX_IDR_LEVEL];
+	struct idr_layer *pa[MAX_IDR_LEVEL + 1];
 	struct idr_layer **paa = &pa[0];
 
 	n = idp->layers * IDR_BITS;
 	p = rcu_dereference_raw(idp->top);
-	max = 1 << n;
+	max = idr_max(idp->layers);
 
 	id = 0;
-	while (id < max) {
+	while (id >= 0 && id <= max) {
 		while (n > 0 && p) {
 			n -= IDR_BITS;
 			*paa++ = p;
@@ -732,7 +740,7 @@ EXPORT_SYMBOL(idr_for_each);
  */
 void *idr_get_next(struct idr *idp, int *nextidp)
 {
-	struct idr_layer *p, *pa[MAX_IDR_LEVEL];
+	struct idr_layer *p, *pa[MAX_IDR_LEVEL + 1];
 	struct idr_layer **paa = &pa[0];
 	int id = *nextidp;
 	int n, max;
@@ -742,9 +750,9 @@ void *idr_get_next(struct idr *idp, int 
 	if (!p)
 		return NULL;
 	n = (p->layer + 1) * IDR_BITS;
-	max = 1 << n;
+	max = idr_max(p->layer + 1);
 
-	while (id < max) {
+	while (id >= 0 && id <= max) {
 		while (n > 0 && p) {
 			n -= IDR_BITS;
 			*paa++ = p;
@@ -918,7 +926,7 @@ EXPORT_SYMBOL(ida_pre_get);
  */
 int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
 {
-	struct idr_layer *pa[MAX_IDR_LEVEL];
+	struct idr_layer *pa[MAX_IDR_LEVEL + 1];
 	struct ida_bitmap *bitmap;
 	unsigned long flags;
 	int idr_id = starting_id / IDA_BITMAP_BITS;
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-fast-hierarchy-aware-child-test-fix-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock-fix.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
idr-fix-a-subtle-bug-in-idr_get_next.patch
idr-make-idr_destroy-imply-idr_remove_all.patch
atm-nicstar-dont-use-idr_remove_all.patch
block-loop-dont-use-idr_remove_all.patch
firewire-dont-use-idr_remove_all.patch
drm-dont-use-idr_remove_all.patch
dm-dont-use-idr_remove_all.patch
remoteproc-dont-use-idr_remove_all.patch
rpmsg-dont-use-idr_remove_all.patch
dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch
dlm-dont-use-idr_remove_all.patch
nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
inotify-dont-use-idr_remove_all.patch
cgroup-dont-use-idr_remove_all.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch
idr-cosmetic-updates-to-struct-initializer-definitions.patch
idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch
idr-remove-_idr_rc_to_errno-hack.patch
idr-refactor-idr_get_new_above.patch
idr-implement-idr_preload-and-idr_alloc.patch
idr-implement-idr_preload-and-idr_alloc-fix.patch
block-fix-synchronization-and-limit-check-in-blk_alloc_devt.patch
block-convert-to-idr_alloc.patch
block-loop-convert-to-idr_alloc.patch
atm-nicstar-convert-to-idr_alloc.patch
drbd-convert-to-idr_alloc.patch
dca-convert-to-idr_alloc.patch
dmaengine-convert-to-idr_alloc.patch
firewire-add-minor-number-range-check-to-fw_device_init.patch
firewire-convert-to-idr_alloc.patch
gpio-convert-to-idr_alloc.patch
drm-convert-to-idr_alloc.patch
drm-exynos-convert-to-idr_alloc.patch
drm-i915-convert-to-idr_alloc.patch
drm-sis-convert-to-idr_alloc.patch
drm-via-convert-to-idr_alloc.patch
drm-vmwgfx-convert-to-idr_alloc.patch
i2c-convert-to-idr_alloc.patch
i2c-convert-to-idr_alloc-fix.patch
ib-core-convert-to-idr_alloc.patch
ib-amso1100-convert-to-idr_alloc.patch
ib-cxgb3-convert-to-idr_alloc.patch
ib-cxgb4-convert-to-idr_alloc.patch
ib-ehca-convert-to-idr_alloc.patch
ib-ipath-convert-to-idr_alloc.patch
ib-mlx4-convert-to-idr_alloc.patch
ib-ocrdma-convert-to-idr_alloc.patch
ib-qib-convert-to-idr_alloc.patch
dm-convert-to-idr_alloc.patch
memstick-convert-to-idr_alloc.patch
mfd-convert-to-idr_alloc.patch
misc-c2port-convert-to-idr_alloc.patch
misc-tifm_core-convert-to-idr_alloc.patch
mmc-convert-to-idr_alloc.patch
mtd-convert-to-idr_alloc.patch
macvtap-convert-to-idr_alloc.patch
ppp-convert-to-idr_alloc.patch
power-convert-to-idr_alloc.patch
pps-convert-to-idr_alloc.patch
remoteproc-convert-to-idr_alloc.patch
rpmsg-convert-to-idr_alloc.patch
scsi-bfa-convert-to-idr_alloc.patch
scsi-convert-to-idr_alloc.patch
target-iscsi-convert-to-idr_alloc.patch
scsi-lpfc-convert-to-idr_alloc.patch
thermal-convert-to-idr_alloc.patch
uio-convert-to-idr_alloc.patch
vfio-convert-to-idr_alloc.patch
dlm-convert-to-idr_alloc.patch
inotify-convert-to-idr_alloc.patch
ocfs2-convert-to-idr_alloc.patch
ipc-convert-to-idr_alloc.patch
ipc-convert-to-idr_alloc-fix.patch
cgroup-convert-to-idr_alloc.patch
events-convert-to-idr_alloc.patch
posix-timers-convert-to-idr_alloc.patch
net-9p-convert-to-idr_alloc.patch
mac80211-convert-to-idr_alloc.patch
sctp-convert-to-idr_alloc.patch
nfs4client-convert-to-idr_alloc.patch
idr-fix-top-layer-handling.patch
idr-remove-max_idr_mask-and-move-left-max_idr_-into-idrc.patch
idr-remove-length-restriction-from-idr_layer-bitmap.patch
idr-make-idr_layer-larger.patch
idr-add-idr_layer-prefix.patch
idr-implement-lookup-hint.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch

