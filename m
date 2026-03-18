Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694BB3AA1A4
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 18:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773857154; cv=none; b=aB8yJ8L/hibn8My4UPSApOriXkIYV5lVulknLwaIpbcr8vZUraImSgUkWRtbnyfSB+yMru53jMQnA0tWbsU4S2wkMwKVccxs0nF/Hx8cRQfKZvGFgV7fFruXrUK3pxXNj+JJK+6Q/EryQjitPleNSfRoxT4D8afQrD0Pccxb4uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773857154; c=relaxed/simple;
	bh=yv7o1V4hYxh/iP0NKDoxDI1xDTpgGoX+MS7Q/EH+/8M=;
	h=Date:To:From:Subject:Message-Id; b=Y2bGHfEbEbNnln/AvBJ7brOqjxu+5Vs6P5VNEY/iFrlTAmhE+O6I5SxtAaU1aih7ZJ4G1SdxqcxcXjC8PRcR1psu7mFLiYp6R+N/t3JrYmePPQ5SXMfv9b4gqCCFoAeTY3gOqtymuc9ALh2fnjRzQ/OBgpfP8ODSdbfiAAIOv5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uSTT+Rz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uSTT+Rz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB87C19421;
	Wed, 18 Mar 2026 18:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773857154;
	bh=yv7o1V4hYxh/iP0NKDoxDI1xDTpgGoX+MS7Q/EH+/8M=;
	h=Date:To:From:Subject:From;
	b=uSTT+Rz5Cau8JUuJsOM6Jys/c5WYfyh0vfMRxGt7YK91HMsg6RdOUHoaz1lR/6ReZ
	 aEPEwic9wB8qi0Sf8whrXgLx9cntxkbcOkm9o02Su3sIqGbsYK0inrf8FBFNu/rGxt
	 IdbEHKdbZcSb432eewEjaLkcls0nobzL8y8NB7vc=
Date: Wed, 18 Mar 2026 11:05:53 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-remove-luo_session_quiesce.patch added to mm-new branch
Message-Id: <20260318180554.2CB87C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: remove luo_session_quiesce()
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-remove-luo_session_quiesce.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-remove-luo_session_quiesce.patch

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
Subject: liveupdate: remove luo_session_quiesce()
Date: Wed, 18 Mar 2026 10:16:43 -0400

Now that FLB module references are handled dynamically during active
sessions, we can safely remove the luo_session_quiesce() and
luo_session_resume() mechanism.

Link: https://lkml.kernel.org/r/20260318141637.1870220-15-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c     |   21 +------------
 kernel/liveupdate/luo_flb.c      |   46 ++++-------------------------
 kernel/liveupdate/luo_internal.h |    2 -
 kernel/liveupdate/luo_session.c  |   44 ---------------------------
 4 files changed, 9 insertions(+), 104 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-remove-luo_session_quiesce
+++ a/kernel/liveupdate/luo_file.c
@@ -846,21 +846,12 @@ int liveupdate_register_file_handler(str
 		return -EINVAL;
 	}
 
-	/*
-	 * Ensure the system is quiescent (no active sessions).
-	 * This prevents registering new handlers while sessions are active or
-	 * while deserialization is in progress.
-	 */
-	if (!luo_session_quiesce())
-		return -EBUSY;
-
 	scoped_guard(rwsem_write, &luo_file_handler_lock) {
 		/* Check for duplicate compatible strings */
 		list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
 			if (!strcmp(fh_iter->compatible, fh->compatible)) {
 				pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
 				       fh->compatible);
-				luo_session_resume();
 				return -EEXIST;
 			}
 		}
@@ -870,7 +861,6 @@ int liveupdate_register_file_handler(str
 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
 		list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	}
-	luo_session_resume();
 
 	liveupdate_test_register(fh);
 
@@ -885,13 +875,12 @@ int liveupdate_register_file_handler(str
  * reverses the operations of liveupdate_register_file_handler().
  *
  * It ensures safe removal by checking that:
- * No live update session is currently in progress.
  * No FLB registered with this file handler.
  *
  * If the unregistration fails, the internal test state is reverted.
  *
  * Return: 0 Success. -EOPNOTSUPP when live update is not enabled. -EBUSY A live
- * update is in progress, can't quiesce live update or FLB is registred with
+ * update is in progress, FLB is registred with
  * this file handler.
  */
 int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
@@ -901,18 +890,12 @@ int liveupdate_unregister_file_handler(s
 
 	liveupdate_test_unregister(fh);
 
-	if (!luo_session_quiesce())
-		goto err_register;
-
 	scoped_guard(rwsem_write, &luo_file_handler_lock) {
-		if (!list_empty(&ACCESS_PRIVATE(fh, flb_list))) {
-			luo_session_resume();
+		if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
 			goto err_register;
-		}
 
 		list_del(&ACCESS_PRIVATE(fh, list));
 	}
-	luo_session_resume();
 
 	return 0;
 
--- a/kernel/liveupdate/luo_flb.c~liveupdate-remove-luo_session_quiesce
+++ a/kernel/liveupdate/luo_flb.c
@@ -346,7 +346,6 @@ int liveupdate_register_flb(struct liveu
 	struct luo_flb_link *link __free(kfree) = NULL;
 	struct liveupdate_flb *gflb;
 	struct luo_flb_link *iter;
-	int err;
 
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
@@ -367,22 +366,13 @@ int liveupdate_register_flb(struct liveu
 	if (!link)
 		return -ENOMEM;
 
-	/*
-	 * Ensure the system is quiescent (no active sessions).
-	 * This acts as a global lock for registration: no other thread can
-	 * be in this section, and no sessions can be creating/using FDs.
-	 */
-	if (!luo_session_quiesce())
-		return -EBUSY;
-
 	guard(rwsem_write)(&luo_flb_lock);
 	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
 
 	/* Check that this FLB is not already linked to this file handler */
-	err = -EEXIST;
 	list_for_each_entry(iter, flb_list, list) {
 		if (iter->flb == flb)
-			goto err_resume;
+			return -EEXIST;
 	}
 
 	/*
@@ -390,20 +380,16 @@ int liveupdate_register_flb(struct liveu
 	 * is registered
 	 */
 	if (!private->users) {
-		if (WARN_ON(!list_empty(&private->list))) {
-			err = -EINVAL;
-			goto err_resume;
-		}
+		if (WARN_ON(!list_empty(&private->list)))
+			return -EINVAL;
 
-		if (luo_flb_global.count == LUO_FLB_MAX) {
-			err = -ENOSPC;
-			goto err_resume;
-		}
+		if (luo_flb_global.count == LUO_FLB_MAX)
+			return -ENOSPC;
 
 		/* Check that compatible string is unique in global list */
 		list_private_for_each_entry(gflb, &luo_flb_global.list, private.list) {
 			if (!strcmp(gflb->compatible, flb->compatible))
-				goto err_resume;
+				return -EEXIST;
 		}
 
 		list_add_tail(&private->list, &luo_flb_global.list);
@@ -414,13 +400,8 @@ int liveupdate_register_flb(struct liveu
 	private->users++;
 	link->flb = flb;
 	list_add_tail(&no_free_ptr(link)->list, flb_list);
-	luo_session_resume();
 
 	return 0;
-
-err_resume:
-	luo_session_resume();
-	return err;
 }
 
 /**
@@ -455,13 +436,6 @@ int liveupdate_unregister_flb(struct liv
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
-	/*
-	 * Ensure the system is quiescent (no active sessions).
-	 * This acts as a global lock for unregistration.
-	 */
-	if (!luo_session_quiesce())
-		return -EBUSY;
-
 	guard(rwsem_write)(&luo_flb_lock);
 	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
 
@@ -476,7 +450,7 @@ int liveupdate_unregister_flb(struct liv
 	}
 
 	if (err)
-		goto err_resume;
+		return err;
 
 	private->users--;
 	/*
@@ -488,13 +462,7 @@ int liveupdate_unregister_flb(struct liv
 		luo_flb_global.count--;
 	}
 
-	luo_session_resume();
-
 	return 0;
-
-err_resume:
-	luo_session_resume();
-	return err;
 }
 
 /**
--- a/kernel/liveupdate/luo_internal.h~liveupdate-remove-luo_session_quiesce
+++ a/kernel/liveupdate/luo_internal.h
@@ -83,8 +83,6 @@ int __init luo_session_setup_outgoing(vo
 int __init luo_session_setup_incoming(void *fdt);
 int luo_session_serialize(void);
 int luo_session_deserialize(void);
-bool luo_session_quiesce(void);
-void luo_session_resume(void);
 
 int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
 void luo_file_unpreserve_files(struct luo_file_set *file_set);
--- a/kernel/liveupdate/luo_session.c~liveupdate-remove-luo_session_quiesce
+++ a/kernel/liveupdate/luo_session.c
@@ -600,47 +600,3 @@ err_undo:
 
 	return err;
 }
-
-/**
- * luo_session_quiesce - Ensure no active sessions exist and lock session lists.
- *
- * Acquires exclusive write locks on both incoming and outgoing session lists.
- * It then validates no sessions exist in either list.
- *
- * This mechanism is used during file handler un/registration to ensure that no
- * sessions are currently using the handler, and no new sessions can be created
- * while un/registration is in progress.
- *
- * This prevents registering new handlers while sessions are active or
- * while deserialization is in progress.
- *
- * Return:
- * true  - System is quiescent (0 sessions) and locked.
- * false - Active sessions exist. The locks are released internally.
- */
-bool luo_session_quiesce(void)
-{
-	down_write(&luo_session_global.incoming.rwsem);
-	down_write(&luo_session_global.outgoing.rwsem);
-
-	if (luo_session_global.incoming.count ||
-	    luo_session_global.outgoing.count) {
-		up_write(&luo_session_global.outgoing.rwsem);
-		up_write(&luo_session_global.incoming.rwsem);
-		return false;
-	}
-
-	return true;
-}
-
-/**
- * luo_session_resume - Unlock session lists and resume normal activity.
- *
- * Releases the exclusive locks acquired by a successful call to
- * luo_session_quiesce().
- */
-void luo_session_resume(void)
-{
-	up_write(&luo_session_global.outgoing.rwsem);
-	up_write(&luo_session_global.incoming.rwsem);
-}
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

