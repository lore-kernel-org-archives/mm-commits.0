From: akpm@linux-foundation.org
Subject: + idr-make-idr_destroy-imply-idr_remove_all.patch added to -mm tree
Date: Mon, 28 Jan 2013 16:06:57 -0800
Message-ID: <20130129000657.8A67A5A419C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:55440 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab3A2AHA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 19:07:00 -0500
Received: by mail-ob0-f202.google.com with SMTP id lz20so707214obb.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 16:07:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, agk@redhat.com, airlied@linux.ie, arnd@arndb.de, axboe@kernel.dk, bfields@fieldses.org, ccaulfie@redhat.com, chas@cmf.nrl.navy.mil, eparis@parisplace.org, inki.dae@samsung.com, john@johnmccutchan.com, jy0922.shim@samsung.com, kyungmin.park@samsung.com, lizefan@huawei.com, ohad@wizery.com, rlove@rlove.org, stefanr@s5r6.in-berlin.de, sw0312.kim@samsung.com, teigland@redhat.com


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

idr is silly in quite a few ways, one of which is how it's supposed to be
destroyed - idr_destroy() doesn't release IDs and doesn't even whine if
the idr isn't empty.  If the caller forgets idr_remove_all(), it simply
leaks memory.

Even ida gets this wrong and leaks memory on destruction.  There is
absoltely no reason not to call idr_remove_all() from idr_destroy(). 
Nobody is abusing idr_destroy() for shrinking free layer buffer and
continues to use idr after idr_destroy(), so it's safe to do remove_all
from destroy.

In the whole kernel, there is only one place where idr_remove_all() is
legitimiately used without following idr_destroy() while there are quite a
few places where the caller forgets either idr_remove_all() or
idr_destroy() leaking memory.

This patch makes idr_destroy() call idr_destroy_all() and updates the
function description accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Airlie <airlied@linux.ie>
Cc: David Teigland <teigland@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
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

