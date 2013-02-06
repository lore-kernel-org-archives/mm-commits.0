From: akpm@linux-foundation.org
Subject: [to-be-updated] idr-deprecate-idr_remove_all.patch removed from -mm tree
Date: Wed, 06 Feb 2013 14:01:15 -0800
Message-ID: <20130206220115.A16695A41FB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:51968 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab3BFWBR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:01:17 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so206247qeb.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:01:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: deprecate idr_remove_all()
has been removed from the -mm tree.  Its filename was
     idr-deprecate-idr_remove_all.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: idr: deprecate idr_remove_all()

There was only one legitimate use of idr_remove_all() and a lot more
of incorrect uses (or lack of it).  Now that idr_destroy() implies
idr_remove_all() and all the in-kernel users updated not to use it,
there's no reason to keep it around.  Mark it deprecated so that we
can later unexport it.

idr_remove_all() is made an inline function calling __idr_remove_all()
to avoid triggering deprecated warning on EXPORT_SYMBOL().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   14 +++++++++++++-
 lib/idr.c           |   10 +++-------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff -puN include/linux/idr.h~idr-deprecate-idr_remove_all include/linux/idr.h
--- a/include/linux/idr.h~idr-deprecate-idr_remove_all
+++ a/include/linux/idr.h
@@ -110,10 +110,22 @@ int idr_for_each(struct idr *idp,
 void *idr_get_next(struct idr *idp, int *nextid);
 void *idr_replace(struct idr *idp, void *ptr, int id);
 void idr_remove(struct idr *idp, int id);
-void idr_remove_all(struct idr *idp);
 void idr_destroy(struct idr *idp);
 void idr_init(struct idr *idp);
 
+void __idr_remove_all(struct idr *idp);	/* don't use */
+
+/**
+ * idr_remove_all - remove all ids from the given idr tree
+ * @idp: idr handle
+ *
+ * If you're trying to destroy @idp, calling idr_destroy() is enough.
+ * This is going away.  Don't use.
+ */
+static inline void __deprecated idr_remove_all(struct idr *idp)
+{
+	__idr_remove_all(idp);
+}
 
 /*
  * IDA - IDR based id allocator, use when translation from id to
diff -puN lib/idr.c~idr-deprecate-idr_remove_all lib/idr.c
--- a/lib/idr.c~idr-deprecate-idr_remove_all
+++ a/lib/idr.c
@@ -433,11 +433,7 @@ void idr_remove(struct idr *idp, int id)
 }
 EXPORT_SYMBOL(idr_remove);
 
-/**
- * idr_remove_all - remove all ids from the given idr tree
- * @idp: idr handle
- */
-void idr_remove_all(struct idr *idp)
+void __idr_remove_all(struct idr *idp)
 {
 	int n, id, max;
 	int bt_mask;
@@ -470,7 +466,7 @@ void idr_remove_all(struct idr *idp)
 	}
 	idp->layers = 0;
 }
-EXPORT_SYMBOL(idr_remove_all);
+EXPORT_SYMBOL(__idr_remove_all);
 
 /**
  * idr_destroy - release all cached layers within an idr tree
@@ -487,7 +483,7 @@ EXPORT_SYMBOL(idr_remove_all);
  */
 void idr_destroy(struct idr *idp)
 {
-	idr_remove_all(idp);
+	__idr_remove_all(idp);
 
 	while (idp->id_free_cnt) {
 		struct idr_layer *p = get_from_free_list(idp);
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

