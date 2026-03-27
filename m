Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458A8175A9E
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632174; cv=none; b=tivR6atQ2YwzuPYiS/uSRWitRXUNQ7QRFDet/fRPxV+VSo+FWEnKnal5NEd24n/Bz7WNvE6H/evxwgG8LwWC7OIENfuz5quJZtFNQzem7GoVSkqT+LQaXl8pckkMunGYMGJ9DONr7XjMqow7Rhb9XGdyxv8DQdUyVaJoqZXxuBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632174; c=relaxed/simple;
	bh=dJ2i2Vm/CzR7cVJ0rreGDcOQwVkSpS1jlx0mq/YJqj8=;
	h=Date:To:From:Subject:Message-Id; b=OCaIqRBbVtBhI+LkR96GJQKi1wvYYnZaL2AP9lgQcotLA4XGbVWyAiBX23z9OIGkzbDqg6/+re7DlP4/B8nbU1PYJayC3TbQ74hGeYkV2dg/ukQJJJ/XSxDM7cLPyBRNoBfN5yVIU0+KsfOGMhcXvX88iMvUTcF8I2cDkupgg7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bsmQgoQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bsmQgoQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B15C19423;
	Fri, 27 Mar 2026 17:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632173;
	bh=dJ2i2Vm/CzR7cVJ0rreGDcOQwVkSpS1jlx0mq/YJqj8=;
	h=Date:To:From:Subject:From;
	b=bsmQgoQBw2JCWjnMdQToVtdu+vrkJ9uOAiXaVF4diy7O7xduLwitPXzfZjXUYOFeE
	 1jlfJ8RlVCwyhwFQADlMOVOO7XOu5OsPm5Tc9nWjeUfbxCekmSwNp9oSFFT3BycvIm
	 YC6HlnJyGsaiP7fwzk1KqKp3t+0X0q/f7+mS2vMU=
Date: Fri, 27 Mar 2026 10:22:53 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-make-unregister-functions-return-void.patch added to mm-new branch
Message-Id: <20260327172253.D0B15C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: make unregister functions return void
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-make-unregister-functions-return-void.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-make-unregister-functions-return-void.patch

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
Subject: liveupdate: make unregister functions return void
Date: Fri, 27 Mar 2026 03:33:33 +0000

Change liveupdate_unregister_file_handler and liveupdate_unregister_flb to
return void instead of an error code.  This follows the design principle
that unregistration during module unload should not fail, as the unload
cannot be stopped at that point.

Link: https://lkml.kernel.org/r/20260327033335.696621-10-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/liveupdate.h   |   14 ++++++--------
 kernel/liveupdate/luo_file.c |   14 ++------------
 kernel/liveupdate/luo_flb.c  |   11 +++--------
 3 files changed, 11 insertions(+), 28 deletions(-)

--- a/include/linux/liveupdate.h~liveupdate-make-unregister-functions-return-void
+++ a/include/linux/liveupdate.h
@@ -231,12 +231,12 @@ bool liveupdate_enabled(void);
 int liveupdate_reboot(void);
 
 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh);
-int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh);
+void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh);
 
 int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 			    struct liveupdate_flb *flb);
-int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-			      struct liveupdate_flb *flb);
+void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+			       struct liveupdate_flb *flb);
 
 int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp);
 int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp);
@@ -258,9 +258,8 @@ static inline int liveupdate_register_fi
 	return -EOPNOTSUPP;
 }
 
-static inline int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
+static inline void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
-	return -EOPNOTSUPP;
 }
 
 static inline int liveupdate_register_flb(struct liveupdate_file_handler *fh,
@@ -269,10 +268,9 @@ static inline int liveupdate_register_fl
 	return -EOPNOTSUPP;
 }
 
-static inline int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-					    struct liveupdate_flb *flb)
+static inline void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+					     struct liveupdate_flb *flb)
 {
-	return -EOPNOTSUPP;
 }
 
 static inline int liveupdate_flb_get_incoming(struct liveupdate_flb *flb,
--- a/kernel/liveupdate/luo_file.c~liveupdate-make-unregister-functions-return-void
+++ a/kernel/liveupdate/luo_file.c
@@ -912,25 +912,15 @@ err_unlock:
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
- * update is in progress, FLB is registred with this file handler.
  */
-int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
+void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
 	if (!liveupdate_enabled())
-		return -EOPNOTSUPP;
+		return;
 
 	guard(rwsem_write)(&luo_register_rwlock);
 	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
 
 	module_put(fh->ops->owner);
-
-	return 0;
 }
--- a/kernel/liveupdate/luo_flb.c~liveupdate-make-unregister-functions-return-void
+++ a/kernel/liveupdate/luo_flb.c
@@ -492,21 +492,16 @@ int liveupdate_register_flb(struct liveu
  * owner module (acquired during registration) is released.
  *
  * Context: It is typically called from a subsystem's module exit function.
- * Return: 0 on success.
- *         -EOPNOTSUPP if live update is disabled.
- *         -ENOENT if the FLB was not found in the file handler's list.
  */
-int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-			      struct liveupdate_flb *flb)
+void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+			       struct liveupdate_flb *flb)
 {
 	if (!liveupdate_enabled())
-		return -EOPNOTSUPP;
+		return;
 
 	guard(rwsem_write)(&luo_register_rwlock);
 
 	luo_flb_unregister_one(fh, flb);
-
-	return 0;
 }
 
 /**
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

