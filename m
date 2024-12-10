Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C42828E37
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 02:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733796473; cv=none; b=DCTUypS+j+0+dfYC6kTu2lVWJb+GH+8sArn/dqsSnE97CMHgoNzTheFdGS8SjGDh+PPQOWB+DCHvcmKcinMW3PysZoKiAupiZDBN2u6uSLRG1Qf+zeTM86WP/UjWl7WCJnh/92MnDfHG8BTXvgC60gzNSwaD92AOUEXhBfLH2Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733796473; c=relaxed/simple;
	bh=KBcsShtcRcxP2bTsCM0TYWr9ss1F5w6ssSa89TaOU/Q=;
	h=Date:To:From:Subject:Message-Id; b=ORG+3ZyJ4NlCmBPVurl6mFxb1I9dVNBMWuEXtjLgNIDhLcTWIodVf/fPL1xURWg1jukMN8KtB1XLxbJlpi4xy8qJTsGVMucarafG4B6uWq9JhyDDjn6Dl4mr9bFhs/ANoQyEefq3HIA/4aP4few0YV4okLOAr7Xphg3/YBi6R1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IFxFlYNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IFxFlYNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8F8C4CED1;
	Tue, 10 Dec 2024 02:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733796473;
	bh=KBcsShtcRcxP2bTsCM0TYWr9ss1F5w6ssSa89TaOU/Q=;
	h=Date:To:From:Subject:From;
	b=IFxFlYNW9my0bMk6pPlkWlY63UD7p8RJbig1KYTCGsX4+pPl7C9/c4QsHzKJi8KIi
	 jvaArjWUvcDDhjczpTp98Bi6NzpfX67HC5gWvk/emvGaby2KB541kDWIc7kzIaE7ti
	 EJ/f3OFQUY1ftBrXyQW9IgRU7JIPrh0KKxF4vIE4=
Date: Mon, 09 Dec 2024 18:07:52 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch added to mm-unstable branch
Message-Id: <20241210020752.EE8F8C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix -Warray-bounds warnings in pkey_sighandler_tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: fix -Warray-bounds warnings in pkey_sighandler_tests
Date: Mon, 9 Dec 2024 09:50:09 +0000

GCC doesn't like dereferencing a pointer set to 0x1 (when building
at -O2):

pkey_sighandler_tests.c:166:9: warning: array subscript 0 is outside array bounds of 'int[0]' [-Warray-bounds=]
  166 |         *(int *) (0x1) = 1;
      |         ^~~~~~~~~~~~~~
cc1: note: source object is likely at address zero

Using NULL instead seems to make it happy.  This should make no difference
in practice (SIGSEGV with SEGV_MAPERR will be the outcome regardless), we
just need to update the expected si_addr.

Link: https://lkml.kernel.org/r/20241209095019.1732120-5-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey_sighandler_tests.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -163,7 +163,7 @@ static void *thread_segv_with_pkey0_disa
 	__write_pkey_reg(pkey_reg_restrictive_default());
 
 	/* Segfault (with SEGV_MAPERR) */
-	*(int *) (0x1) = 1;
+	*(int *)NULL = 1;
 	return NULL;
 }
 
@@ -179,7 +179,6 @@ static void *thread_segv_pkuerr_stack(vo
 static void *thread_segv_maperr_ptr(void *ptr)
 {
 	stack_t *stack = ptr;
-	int *bad = (int *)1;
 	u64 pkey_reg;
 
 	/*
@@ -195,7 +194,7 @@ static void *thread_segv_maperr_ptr(void
 	__write_pkey_reg(pkey_reg);
 
 	/* Segfault */
-	*bad = 1;
+	*(int *)NULL = 1;
 	syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
 	return NULL;
 }
@@ -234,7 +233,7 @@ static void test_sigsegv_handler_with_pk
 
 	ksft_test_result(siginfo.si_signo == SIGSEGV &&
 			 siginfo.si_code == SEGV_MAPERR &&
-			 siginfo.si_addr == (void *)1,
+			 siginfo.si_addr == NULL,
 			 "%s\n", __func__);
 }
 
@@ -349,7 +348,7 @@ static void test_sigsegv_handler_with_di
 
 	ksft_test_result(siginfo.si_signo == SIGSEGV &&
 			 siginfo.si_code == SEGV_MAPERR &&
-			 siginfo.si_addr == (void *)1,
+			 siginfo.si_addr == NULL,
 			 "%s\n", __func__);
 }
 
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

selftests-mm-fix-condition-in-uffd_move_test_common.patch
selftests-mm-fix-wmaybe-uninitialized-warnings.patch
selftests-mm-fix-strncpy-length.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch
selftests-mm-build-with-o2.patch
selftests-mm-remove-unused-pkey-helpers.patch
selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch
selftests-mm-ensure-pkey-h-define-inline-functions-only.patch
selftests-mm-remove-empty-pkey-helper-definition.patch
selftests-mm-ensure-non-global-pkey-symbols-are-marked-static.patch
selftests-mm-use-sys_pkey-helpers-consistently.patch
selftests-mm-rename-pkey-register-macro.patch
selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch
selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch

