Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D13436E469
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498801; cv=none; b=TjI5v69aVmiG6u6TbLo/K02UdhAb9MtSr92lsHRAxqSS5eO0N02VSL259D+Q8DQSiqksev5FXVjYmdF6lGn9EjGf9DEcHVI/9jpzNdkxTiQrYGfyj+bcZxXCgk8nsm40Q4GODc61LEgqk3wl3FALr+jek3YYFkkOfL7DcKV8jY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498801; c=relaxed/simple;
	bh=tnZIPzUBfyjM/j1bhRULY36D02nKa3nKTEydcxFYSto=;
	h=Date:To:From:Subject:Message-Id; b=fAum/8K6V514TBSh8HlCZ/hOA/iuY6z+fLTXucROzd2OgxkxYrFHOnboeG19OLRPrb8zSgxKSWFziSx2/hSCVibzvAPiCj6cTteZS8a5244ytCkIp/Xqd7GIK905aH9Ju9ixk/agVPWN2XzctLXObRWEzUt+FagLPRC5KS65Mp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RcI9p5GB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RcI9p5GB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4850EC19424;
	Sat, 18 Apr 2026 07:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498801;
	bh=tnZIPzUBfyjM/j1bhRULY36D02nKa3nKTEydcxFYSto=;
	h=Date:To:From:Subject:From;
	b=RcI9p5GBBPAlEKoWu0YKu8YGoaVAw0FOx8RWDi+K8YEK0kyGe5YNyXHGJsjO1zJFP
	 Di3giKUPaDEZeGmXfhajdwWMYhOECdEuCAP+Bg229OmkBvCu2KJWB1pMq++lgrLgpR
	 +X8inaR0JNzMvnTVUTKKg6rM/rLnKTWjGvksHKPg=
Date: Sat, 18 Apr 2026 00:53:16 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] liveupdate-remove-luo_session_quiesce.patch removed from -mm tree
Message-Id: <20260418075320.4850EC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: remove luo_session_quiesce()
has been removed from the -mm tree.  Its filename was
     liveupdate-remove-luo_session_quiesce.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: remove luo_session_quiesce()
Date: Fri, 27 Mar 2026 03:33:30 +0000

Now that FLB module references are handled dynamically during active
sessions, we can safely remove the luo_session_quiesce() and
luo_session_resume() mechanism.

Link: https://lore.kernel.org/20260327033335.696621-7-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c     |   21 ----------
 kernel/liveupdate/luo_flb.c      |   59 ++++-------------------------
 kernel/liveupdate/luo_internal.h |    2 
 kernel/liveupdate/luo_session.c  |   43 ---------------------
 4 files changed, 11 insertions(+), 114 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-remove-luo_session_quiesce
+++ a/kernel/liveupdate/luo_file.c
@@ -875,14 +875,6 @@ int liveupdate_register_file_handler(str
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
 	down_write(&luo_register_rwlock);
 	/* Check for duplicate compatible strings */
 	list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
@@ -905,15 +897,12 @@ int liveupdate_register_file_handler(str
 	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	up_write(&luo_register_rwlock);
 
-	luo_session_resume();
-
 	liveupdate_test_register(fh);
 
 	return 0;
 
 err_unlock:
 	up_write(&luo_register_rwlock);
-	luo_session_resume();
 	return err;
 }
 
@@ -925,14 +914,12 @@ err_unlock:
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
- * this file handler.
+ * update is in progress, FLB is registred with this file handler.
  */
 int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
@@ -943,9 +930,6 @@ int liveupdate_unregister_file_handler(s
 
 	liveupdate_test_unregister(fh);
 
-	if (!luo_session_quiesce())
-		goto err_register;
-
 	down_write(&luo_register_rwlock);
 	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
 		goto err_unlock;
@@ -954,14 +938,11 @@ int liveupdate_unregister_file_handler(s
 	up_write(&luo_register_rwlock);
 
 	module_put(fh->ops->owner);
-	luo_session_resume();
 
 	return 0;
 
 err_unlock:
 	up_write(&luo_register_rwlock);
-	luo_session_resume();
-err_register:
 	liveupdate_test_register(fh);
 	return err;
 }
--- a/kernel/liveupdate/luo_flb.c~liveupdate-remove-luo_session_quiesce
+++ a/kernel/liveupdate/luo_flb.c
@@ -348,7 +348,6 @@ int liveupdate_register_flb(struct liveu
 	struct luo_flb_link *link __free(kfree) = NULL;
 	struct liveupdate_flb *gflb;
 	struct luo_flb_link *iter;
-	int err;
 
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
@@ -369,21 +368,12 @@ int liveupdate_register_flb(struct liveu
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
-	down_write(&luo_register_rwlock);
+	guard(rwsem_write)(&luo_register_rwlock);
 
 	/* Check that this FLB is not already linked to this file handler */
-	err = -EEXIST;
 	list_for_each_entry(iter, flb_list, list) {
 		if (iter->flb == flb)
-			goto err_resume;
+			return -EEXIST;
 	}
 
 	/*
@@ -391,20 +381,16 @@ int liveupdate_register_flb(struct liveu
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
@@ -415,15 +401,8 @@ int liveupdate_register_flb(struct liveu
 	private->users++;
 	link->flb = flb;
 	list_add_tail(&no_free_ptr(link)->list, flb_list);
-	up_write(&luo_register_rwlock);
-	luo_session_resume();
 
 	return 0;
-
-err_resume:
-	up_write(&luo_register_rwlock);
-	luo_session_resume();
-	return err;
 }
 
 /**
@@ -439,12 +418,9 @@ err_resume:
  * the FLB is removed from the global registry and the reference to its
  * owner module (acquired during registration) is released.
  *
- * Context: This function ensures the session is quiesced (no active FDs
- *          being created) during the update. It is typically called from a
- *          subsystem's module exit function.
+ * Context: It is typically called from a subsystem's module exit function.
  * Return: 0 on success.
  *         -EOPNOTSUPP if live update is disabled.
- *         -EBUSY if the live update session is active and cannot be quiesced.
  *         -ENOENT if the FLB was not found in the file handler's list.
  */
 int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
@@ -458,14 +434,7 @@ int liveupdate_unregister_flb(struct liv
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
-	/*
-	 * Ensure the system is quiescent (no active sessions).
-	 * This acts as a global lock for unregistration.
-	 */
-	if (!luo_session_quiesce())
-		return -EBUSY;
-
-	down_write(&luo_register_rwlock);
+	guard(rwsem_write)(&luo_register_rwlock);
 
 	/* Find and remove the link from the file handler's list */
 	list_for_each_entry(iter, flb_list, list) {
@@ -478,7 +447,7 @@ int liveupdate_unregister_flb(struct liv
 	}
 
 	if (err)
-		goto err_resume;
+		return err;
 
 	private->users--;
 	/*
@@ -490,15 +459,7 @@ int liveupdate_unregister_flb(struct liv
 		luo_flb_global.count--;
 	}
 
-	up_write(&luo_register_rwlock);
-	luo_session_resume();
-
 	return 0;
-
-err_resume:
-	up_write(&luo_register_rwlock);
-	luo_session_resume();
-	return err;
 }
 
 /**
--- a/kernel/liveupdate/luo_internal.h~liveupdate-remove-luo_session_quiesce
+++ a/kernel/liveupdate/luo_internal.h
@@ -85,8 +85,6 @@ int __init luo_session_setup_outgoing(vo
 int __init luo_session_setup_incoming(void *fdt);
 int luo_session_serialize(void);
 int luo_session_deserialize(void);
-bool luo_session_quiesce(void);
-void luo_session_resume(void);
 
 int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
 void luo_file_unpreserve_files(struct luo_file_set *file_set);
--- a/kernel/liveupdate/luo_session.c~liveupdate-remove-luo_session_quiesce
+++ a/kernel/liveupdate/luo_session.c
@@ -602,46 +602,3 @@ err_undo:
 	return err;
 }
 
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

liveupdate-fix-return-value-on-session-allocation-failure.patch

