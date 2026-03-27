Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52155378D97
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632168; cv=none; b=uLiaR2vootXTpidM0lte6ABS8G6epqlqkw4p/Q6akJu7ygjSqlg8BjEgjeCuF/g+3qNkJ9BMcy8qr/59QXfAU8FwNUapLS0AbM8v5NVRiH4NcFP1bb8ctXqGZZ2kO9NuGQYTxRBGdhRssSw2qEGFl8euZIceUAFeccqlFg9R8C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632168; c=relaxed/simple;
	bh=WbWcw4YruSRsE562Tn8t2uCjIESPv7IBO4C/pOzYhR4=;
	h=Date:To:From:Subject:Message-Id; b=AfPTAJbmJrdaJvkAJh18N9hUfhCtq8s4e+oimtgiH2WWlNW4VMtR2ttoSVk1ZiZxJfGPdxznBO1IUza0P5oloubpyRmZYr6JGaR5mRRzl7VQ+S7DmHkpA/sICIsZB2ZP5XG1qoPnOd9kCUrK1hUqpwjYHitw9sXw9qjGzXaI098=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ImgQ5dAb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ImgQ5dAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA22C19423;
	Fri, 27 Mar 2026 17:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632168;
	bh=WbWcw4YruSRsE562Tn8t2uCjIESPv7IBO4C/pOzYhR4=;
	h=Date:To:From:Subject:From;
	b=ImgQ5dAbIH6xGK4yzqDQ2wmVNeMEG/1QRZqWMMb1CDQ5tosKQh52y0/yc7DtIh5DU
	 qUftAPmzRypUFPSfJIRtWR9y44pzrQ3R0Oq5YQYXF2n4yNBULI0JSzJ/W8LPQ4OtPO
	 gpK7uu8mSr10L6rvvjV9VoNScqyUncrBVrDEkkEE=
Date: Fri, 27 Mar 2026 10:22:47 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch added to mm-new branch
Message-Id: <20260327172248.0FA22C19423@smtp.kernel.org>
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
Date: Fri, 27 Mar 2026 03:33:31 +0000

To ensure that unregistration is always successful and doesn't leave
dangling resources, introduce auto-unregistration of FLBs: when a file
handler is unregistered, all FLBs associated with it are automatically
unregistered.

Introduce a new helper luo_flb_unregister_all() which unregisters all FLBs
linked to the given file handler.

Link: https://lkml.kernel.org/r/20260327033335.696621-8-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c     |   14 ----
 kernel/liveupdate/luo_flb.c      |   84 +++++++++++++++++++----------
 kernel/liveupdate/luo_internal.h |    1 
 3 files changed, 60 insertions(+), 39 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-auto-unregister-flbs-on-file-handler-unregistration
+++ a/kernel/liveupdate/luo_file.c
@@ -923,26 +923,16 @@ err_unlock:
  */
 int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
-	int err = -EBUSY;
-
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
 	liveupdate_test_unregister(fh);
 
-	down_write(&luo_register_rwlock);
-	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
-		goto err_unlock;
-
+	guard(rwsem_write)(&luo_register_rwlock);
+	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
-	up_write(&luo_register_rwlock);
 
 	module_put(fh->ops->owner);
 
 	return 0;
-
-err_unlock:
-	up_write(&luo_register_rwlock);
-	liveupdate_test_register(fh);
-	return err;
 }
--- a/kernel/liveupdate/luo_flb.c~liveupdate-auto-unregister-flbs-on-file-handler-unregistration
+++ a/kernel/liveupdate/luo_flb.c
@@ -335,6 +335,62 @@ void luo_flb_file_finish(struct liveupda
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
+	lockdep_assert_held_write(&luo_register_rwlock);
+	list_for_each_entry_safe(iter, tmp, flb_list, list)
+		luo_flb_unregister_one(fh, iter->flb);
+}
+
 /**
  * liveupdate_register_flb - Associate an FLB with a file handler and register it globally.
  * @fh:   The file handler that will now depend on the FLB.
@@ -443,38 +499,12 @@ int liveupdate_register_flb(struct liveu
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
 
 	guard(rwsem_write)(&luo_register_rwlock);
 
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
@@ -103,6 +103,7 @@ void luo_file_set_destroy(struct luo_fil
 int luo_flb_file_preserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_finish(struct liveupdate_file_handler *fh);
+void luo_flb_unregister_all(struct liveupdate_file_handler *fh);
 int __init luo_flb_setup_outgoing(void *fdt);
 int __init luo_flb_setup_incoming(void *fdt);
 void luo_flb_serialize(void);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-prevent-double-management-of-files.patch
memfd-implement-get_id-for-memfd_luo.patch
selftests-liveupdate-add-test-for-double-preservation.patch
liveupdate-safely-print-untrusted-strings.patch
liveupdate-synchronize-lazy-initialization-of-flb-private-state.patch
liveupdate-protect-file-handler-list-with-rwsem.patch
liveupdate-protect-flb-lists-with-luo_register_rwlock.patch
liveupdate-defer-flb-module-refcounting-to-active-sessions.patch
liveupdate-remove-luo_session_quiesce.patch
liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch
liveupdate-remove-liveupdate_test_unregister.patch
liveupdate-make-unregister-functions-return-void.patch
liveupdate-defer-file-handler-module-refcounting-to-active-sessions.patch

