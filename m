From: akpm@linux-foundation.org
Subject: + idr-make-idr_destroy-imply-idr_remove_all.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:36:33 -0800
Message-ID: <20130206223634.23CF05A42B7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:63022 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab3BFWgf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:36:35 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so209728vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:36:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org


The patch titled
     Subject: idr: make idr_destroy() imply idr_remove_all()
has been added to the -mm tree.  Its filename is
     idr-make-idr_destroy-imply-idr_remove_all.patch

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
Subject: idr: make idr_destroy() imply idr_remove_all()

idr is silly in quite a few ways, one of which is how it's supposed to
be destroyed - idr_destroy() doesn't release IDs and doesn't even
whine if the idr isn't empty.  If the caller forgets idr_remove_all(),
it simply leaks memory.

Even ida gets this wrong and leaks memory on destruction.  There is
absoltely no reason not to call idr_remove_all() from idr_destroy().
Nobody is abusing idr_destroy() for shrinking free layer buffer and
continues to use idr after idr_destroy(), so it's safe to do
remove_all from destroy.

In the whole kernel, there is only one place where idr_remove_all() is
legitimiately used without following idr_destroy() while there are
quite a few places where the caller forgets either idr_remove_all() or
idr_destroy() leaking memory.

This patch makes idr_destroy() call idr_destroy_all() and updates the
function description accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN lib/idr.c~idr-make-idr_destroy-imply-idr_remove_all lib/idr.c
--- a/lib/idr.c~idr-make-idr_destroy-imply-idr_remove_all
+++ a/lib/idr.c
@@ -436,15 +436,6 @@ EXPORT_SYMBOL(idr_remove);
 /**
  * idr_remove_all - remove all ids from the given idr tree
  * @idp: idr handle
- *
- * idr_destroy() only frees up unused, cached idp_layers, but this
- * function will remove all id mappings and leave all idp_layers
- * unused.
- *
- * A typical clean-up sequence for objects stored in an idr tree will
- * use idr_for_each() to free all objects, if necessay, then
- * idr_remove_all() to remove all ids, and idr_destroy() to free
- * up the cached idr_layers.
  */
 void idr_remove_all(struct idr *idp)
 {
@@ -484,9 +475,20 @@ EXPORT_SYMBOL(idr_remove_all);
 /**
  * idr_destroy - release all cached layers within an idr tree
  * @idp: idr handle
+ *
+ * Free all id mappings and all idp_layers.  After this function, @idp is
+ * completely unused and can be freed / recycled.  The caller is
+ * responsible for ensuring that no one else accesses @idp during or after
+ * idr_destroy().
+ *
+ * A typical clean-up sequence for objects stored in an idr tree will use
+ * idr_for_each() to free all objects, if necessay, then idr_destroy() to
+ * free up the id mappings and cached idr_layers.
  */
 void idr_destroy(struct idr *idp)
 {
+	idr_remove_all(idp);
+
 	while (idp->id_free_cnt) {
 		struct idr_layer *p = get_from_free_list(idp);
 		kmem_cache_free(idr_layer_cache, p);
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
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
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
idr-deprecate-idr_remove_all.patch
idr-cosmetic-updates-to-struct-initializer-definitions.patch
idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch
idr-remove-_idr_rc_to_errno-hack.patch
idr-refactor-idr_get_new_above.patch
idr-implement-idr_preload-and-idr_alloc.patch
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
cgroup-convert-to-idr_alloc.patch
events-convert-to-idr_alloc.patch
posix-timers-convert-to-idr_alloc.patch
net-9p-convert-to-idr_alloc.patch
mac80211-convert-to-idr_alloc.patch
sctp-convert-to-idr_alloc.patch
nfs4client-convert-to-idr_alloc.patch

