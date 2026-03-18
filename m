Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0A01D6193
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 18:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773857158; cv=none; b=gcLhvx+65O34YYNXX+eTsTvr5wIzl4zYprxFiB5F98Z4EKoznJS2Mb8efZ0LINXygSWqL4WlRQRFbtAO1+QPkjp2oa0HWb3+FM6RPGiynz9KuXjmaln/5PkPh1yVvQ6p44sWs3g6LQ0qtpnEQejytsliiyYQxQJCQdoiuo6XzNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773857158; c=relaxed/simple;
	bh=mn6wqTzaGtYoUolOnFSC6L2WTKpPaMg0FPUzrMM2iLE=;
	h=Date:To:From:Subject:Message-Id; b=H8/d8tLDsTwW97naiRQelb1y/wummjlsvEV8OQlsooqUJCw4JCmVXLWNNs6fC0qW7I8XYTnmeoG/eE/yb5rqDSIaFtX2r2BAXnVZqeLqKC1ME+IOh5nm3AwoO/qKfPo9YwgPjCEErhgw1ajdTcJgp4N4rq97P8HciXUSKVFOFTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0fQrwrtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0fQrwrtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF3EC2BC87;
	Wed, 18 Mar 2026 18:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773857157;
	bh=mn6wqTzaGtYoUolOnFSC6L2WTKpPaMg0FPUzrMM2iLE=;
	h=Date:To:From:Subject:From;
	b=0fQrwrtVqjR0vcNDthSmvBnqy7Tmu5IQ2m+fo72igLjYe8+qJrE9rwxQQqhx2Quvn
	 XEraf31etH9t7BKeZKMLUcra6+3drZwnRqxYimoLcXfLv2Hu6RWKtrFQR215MSDBzZ
	 7To0qTqKWUkJ4mLATU4gNtUjJYCw6ZeXpEW597I4=
Date: Wed, 18 Mar 2026 11:05:57 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch added to mm-new branch
Message-Id: <20260318180557.9EF3EC2BC87@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: auto unregister FLBs on file handler unregistration
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: auto unregister FLBs on file handler unregistration
Date: Wed, 18 Mar 2026 10:16:44 -0400

To ensure that unregistration is always successful and doesn't leave
dangling resources, introduce auto-unregistration of FLBs: when a file
handler is unregistered, all FLBs associated with it are automatically
unregistered.

Introduce a new helper luo_flb_unregister_all() which unregisters all FLBs
linked to the given file handler.

Link: https://lkml.kernel.org/r/20260318141637.1870220-16-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c     |   17 -----
 kernel/liveupdate/luo_flb.c      |   93 ++++++++++++++++++-----------
 kernel/liveupdate/luo_internal.h |    1 
 3 files changed, 61 insertions(+), 50 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-auto-unregister-flbs-on-file-handler-unregistration
+++ a/kernel/liveupdate/luo_file.c
@@ -873,15 +873,6 @@ int liveupdate_register_file_handler(str
  *
  * Unregisters the file handler from the liveupdate core. This function
  * reverses the operations of liveupdate_register_file_handler().
- *
- * It ensures safe removal by checking that:
- * No FLB registered with this file handler.
- *
- * If the unregistration fails, the internal test state is reverted.
- *
- * Return: 0 Success. -EOPNOTSUPP when live update is not enabled. -EBUSY A live
- * update is in progress, FLB is registred with
- * this file handler.
  */
 int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
@@ -891,15 +882,9 @@ int liveupdate_unregister_file_handler(s
 	liveupdate_test_unregister(fh);
 
 	scoped_guard(rwsem_write, &luo_file_handler_lock) {
-		if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
-			goto err_register;
-
+		luo_flb_unregister_all(fh);
 		list_del(&ACCESS_PRIVATE(fh, list));
 	}
 
 	return 0;
-
-err_register:
-	liveupdate_test_register(fh);
-	return -EBUSY;
 }
--- a/kernel/liveupdate/luo_flb.c~liveupdate-auto-unregister-flbs-on-file-handler-unregistration
+++ a/kernel/liveupdate/luo_flb.c
@@ -316,6 +316,64 @@ void luo_flb_file_finish(struct liveupda
 		luo_flb_file_finish_one(iter->flb);
 }
 
+static void luo_flb_unregister_one(struct liveupdate_file_handler *fh,
+				   struct liveupdate_flb *flb)
+{
+	struct luo_flb_private *private = luo_flb_get_private(flb);
+	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
+	struct luo_flb_link *iter;
+	bool found = false;
+
+	/* Find and remove the link from the file handler's list */
+	list_for_each_entry(iter, flb_list, list) {
+		if (iter->flb == flb) {
+			list_del(&iter->list);
+			kfree(iter);
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		pr_warn("Failed to unregister FLB '%s': not found in file handler '%s'\n",
+			flb->compatible, fh->compatible);
+		return;
+	}
+
+	private->users--;
+
+	/*
+	 * If this is the last file-handler with which we are registred, remove
+	 * from the global list.
+	 */
+	if (!private->users) {
+		list_del_init(&private->list);
+		luo_flb_global.count--;
+	}
+}
+
+/**
+ * luo_flb_unregister_all - Unregister all FLBs associated with a file handler.
+ * @fh: The file handler whose FLBs should be unregistered.
+ *
+ * This function iterates through the list of FLBs associated with the given
+ * file handler and unregisters them all one by one.
+ */
+void luo_flb_unregister_all(struct liveupdate_file_handler *fh)
+{
+	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
+	struct luo_flb_link *iter, *tmp;
+
+	if (!liveupdate_enabled())
+		return;
+
+	guard(rwsem_write)(&luo_flb_lock);
+	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
+
+	list_for_each_entry_safe(iter, tmp, flb_list, list)
+		luo_flb_unregister_one(fh, iter->flb);
+}
+
 /**
  * liveupdate_register_flb - Associate an FLB with a file handler and register it globally.
  * @fh:   The file handler that will now depend on the FLB.
@@ -417,50 +475,17 @@ int liveupdate_register_flb(struct liveu
  * the FLB is removed from the global registry and the reference to its
  * owner module (acquired during registration) is released.
  *
- * Context: This function ensures the session is quiesced (no active FDs
- *          being created) during the update. It is typically called from a
- *          subsystem's module exit function.
- * Return: 0 on success.
- *         -EOPNOTSUPP if live update is disabled.
- *         -EBUSY if the live update session is active and cannot be quiesced.
- *         -ENOENT if the FLB was not found in the file handler's list.
  */
 int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 			      struct liveupdate_flb *flb)
 {
-	struct luo_flb_private *private = luo_flb_get_private(flb);
-	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
-	struct luo_flb_link *iter;
-	int err = -ENOENT;
-
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
 	guard(rwsem_write)(&luo_flb_lock);
 	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
 
-	/* Find and remove the link from the file handler's list */
-	list_for_each_entry(iter, flb_list, list) {
-		if (iter->flb == flb) {
-			list_del(&iter->list);
-			kfree(iter);
-			err = 0;
-			break;
-		}
-	}
-
-	if (err)
-		return err;
-
-	private->users--;
-	/*
-	 * If this is the last file-handler with which we are registred, remove
-	 * from the global list.
-	 */
-	if (!private->users) {
-		list_del_init(&private->list);
-		luo_flb_global.count--;
-	}
+	luo_flb_unregister_one(fh, flb);
 
 	return 0;
 }
--- a/kernel/liveupdate/luo_internal.h~liveupdate-auto-unregister-flbs-on-file-handler-unregistration
+++ a/kernel/liveupdate/luo_internal.h
@@ -101,6 +101,7 @@ void luo_file_set_destroy(struct luo_fil
 int luo_flb_file_preserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_finish(struct liveupdate_file_handler *fh);
+void luo_flb_unregister_all(struct liveupdate_file_handler *fh);
 int __init luo_flb_setup_outgoing(void *fdt);
 int __init luo_flb_setup_incoming(void *fdt);
 void luo_flb_serialize(void);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-vmalloc-export-clear_vm_uninitialized_flag.patch
kho-fix-kasan-support-for-restored-vmalloc-regions.patch
liveupdate-protect-file-handler-list-with-rwsem.patch
liveupdate-protect-flb-lists-with-rwsem.patch
liveupdate-remove-file-handler-module-refcounting.patch
liveupdate-defer-flb-module-refcounting-to-active-sessions.patch
liveupdate-remove-luo_session_quiesce.patch
liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch
liveupdate-remove-liveupdate_test_unregister.patch
liveupdate-make-unregister-functions-return-void.patch

