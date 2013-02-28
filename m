From: akpm@linux-foundation.org
Subject: [merged] idr-fix-top-layer-handling.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:04 -0800
Message-ID: <20130228201605.19B3431C25A@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:52048 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab3B1UQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:16:06 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so245404qea.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:16:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, rusty@rustcorp.com.au, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: fix top layer handling
has been removed from the -mm tree.  Its filename was
     idr-fix-top-layer-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

