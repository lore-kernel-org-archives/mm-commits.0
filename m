From: akpm@linux-foundation.org
Subject: [merged] idr-make-idr_destroy-imply-idr_remove_all.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:28 -0800
Message-ID: <20130228201228.AA6145A4242@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:58053 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab3B1UM3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:29 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so246269yhz.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: make idr_destroy() imply idr_remove_all()
has been removed from the -mm tree.  Its filename was
     idr-make-idr_destroy-imply-idr_remove_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

