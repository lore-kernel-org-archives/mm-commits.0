Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726F9378832
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632171; cv=none; b=pWQQHEngVoYGNIbhB2kf6cEAdUmc/64s8mz2cEStLTduvflTYzn4NrwuJZ0LKFWR6rRgnbbKffG599ManOy5HjPwxRhySqLbOwZdt7vEw091SnReAs1cnq9or5vkTCcIUp7Q+opWlTVB2XJ/tKHzn7KA4c24rmgZb5ZiYnayK2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632171; c=relaxed/simple;
	bh=959X2p9K2eIcpwVDhnbm2kDCf2liBKfwvcrqBIRRrzQ=;
	h=Date:To:From:Subject:Message-Id; b=Q55TeZhKwa++aUqqLus7eLFxTyWrdYCaO2DLF2jnYCmzp1JOr5s05JTJ4QC9A+6t2Gw9RDzu5aNzR6LSTFrmDLLQpO0iYKvsRsamfXNZD5OPPYDGkgyyZD9BrNBHX2k8URxyUrD9lHdRfTpCgq3A0mF39JaPBuOuHFx5lDefb8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ewiCRxh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ewiCRxh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A75C19423;
	Fri, 27 Mar 2026 17:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632171;
	bh=959X2p9K2eIcpwVDhnbm2kDCf2liBKfwvcrqBIRRrzQ=;
	h=Date:To:From:Subject:From;
	b=ewiCRxh2ErLO7FuAMSEK+nJLdEqQb9/RMmT7EPi+GHhupXjT1T0sON4K+EhgnIPXd
	 Eybj4rF4CkYJ2d9CpaqyopuFB44ROaq40rIb5lIo2DfuVItbHKnrpnM7UxPvQKxBOp
	 +qtXiQNzTjHWKidsOfwfH2JcVI5QU5HfKaR/Ok6o=
Date: Fri, 27 Mar 2026 10:22:50 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-remove-liveupdate_test_unregister.patch added to mm-new branch
Message-Id: <20260327172251.04A75C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: remove liveupdate_test_unregister()
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-remove-liveupdate_test_unregister.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-remove-liveupdate_test_unregister.patch

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
Subject: liveupdate: remove liveupdate_test_unregister()
Date: Fri, 27 Mar 2026 03:33:32 +0000

Now that file handler unregistration automatically unregisters all
associated file handlers (FLBs), the liveupdate_test_unregister() function
is no longer needed.  Remove it along with its usages and declarations.

Link: https://lkml.kernel.org/r/20260327033335.696621-9-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c     |    2 --
 kernel/liveupdate/luo_internal.h |    2 --
 lib/tests/liveupdate.c           |   18 ------------------
 3 files changed, 22 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-remove-liveupdate_test_unregister
+++ a/kernel/liveupdate/luo_file.c
@@ -926,8 +926,6 @@ int liveupdate_unregister_file_handler(s
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
-	liveupdate_test_unregister(fh);
-
 	guard(rwsem_write)(&luo_register_rwlock);
 	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
--- a/kernel/liveupdate/luo_internal.h~liveupdate-remove-liveupdate_test_unregister
+++ a/kernel/liveupdate/luo_internal.h
@@ -110,10 +110,8 @@ void luo_flb_serialize(void);
 
 #ifdef CONFIG_LIVEUPDATE_TEST
 void liveupdate_test_register(struct liveupdate_file_handler *fh);
-void liveupdate_test_unregister(struct liveupdate_file_handler *fh);
 #else
 static inline void liveupdate_test_register(struct liveupdate_file_handler *fh) { }
-static inline void liveupdate_test_unregister(struct liveupdate_file_handler *fh) { }
 #endif
 
 #endif /* _LINUX_LUO_INTERNAL_H */
--- a/lib/tests/liveupdate.c~liveupdate-remove-liveupdate_test_unregister
+++ a/lib/tests/liveupdate.c
@@ -135,24 +135,6 @@ void liveupdate_test_register(struct liv
 		TEST_NFLBS, fh->compatible);
 }
 
-void liveupdate_test_unregister(struct liveupdate_file_handler *fh)
-{
-	int err, i;
-
-	for (i = 0; i < TEST_NFLBS; i++) {
-		struct liveupdate_flb *flb = &test_flbs[i];
-
-		err = liveupdate_unregister_flb(fh, flb);
-		if (err) {
-			pr_err("Failed to unregister %s %pe\n",
-			       flb->compatible, ERR_PTR(err));
-		}
-	}
-
-	pr_info("Unregistered %d FLBs from file handler: [%s]\n",
-		TEST_NFLBS, fh->compatible);
-}
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pasha Tatashin <pasha.tatashin@soleen.com>");
 MODULE_DESCRIPTION("In-kernel test for LUO mechanism");
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

