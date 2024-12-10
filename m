Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92E3136326
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 02:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733796498; cv=none; b=U8Nh3uzhKFqhwTVTJTRmc82DmRj1sAKXpQVf4xIeEbkDnNJn46LSNMShP4TFkXureTmKZgO7xU61Yp8F948Gg4/KhaObk02NCoXKGC6WxqWJCgrQuT/XPj6S1ssacfpPQra4h4tVwVgP0cy148W6xdQX8zK+uXc94nNnV9wmvqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733796498; c=relaxed/simple;
	bh=jeWOYF1S23GFC4tmOXYkFZSRW04EP2JWqG1VNX9dPlQ=;
	h=Date:To:From:Subject:Message-Id; b=VPIBaQWBJSL8ExoW92RfZ4muHrSghuZAgaaNDB7HLwkTa8fLxlZnt4nEI28OVfCLloGtbYhTN8wgpnY6sagoFZFyJ5M80zTf4s1RjxNDgtS3rBHaYcpx/p4NcO4YZHdUOyGmN+2sziWlB31K24Y4ZWvpjZ98ezw68nduyx8MUPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kh1nehj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kh1nehj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5D0C4CED1;
	Tue, 10 Dec 2024 02:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733796498;
	bh=jeWOYF1S23GFC4tmOXYkFZSRW04EP2JWqG1VNX9dPlQ=;
	h=Date:To:From:Subject:From;
	b=kh1nehj3QkpOaDsDKEyMVp0WI5qm1EtYMIUMGqL/eFeEWaCVTuUlJyXG7/a9wNhXK
	 3T+XhFesSaoQ0YzLU9STFWAmF16IGSi+U5jVadjE+mm/W94DuZrIRqRSL30ZJGPCql
	 Dg/KGWXKN/AE2NJG05c1TxVufBiCKndfVArTTT5w=
Date: Mon, 09 Dec 2024 18:08:18 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch added to mm-unstable branch
Message-Id: <20241210020818.8D5D0C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove X permission from sigaltstack mapping
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch

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
Subject: selftests/mm: remove X permission from sigaltstack mapping
Date: Mon, 9 Dec 2024 09:50:19 +0000

There is no reason why the alternate signal stack should be mapped as RWX.
Map it as RW instead.

Link: https://lkml.kernel.org/r/20241209095019.1732120-15-kevin.brodsky@arm.com
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

 tools/testing/selftests/mm/pkey_sighandler_tests.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-remove-x-permission-from-sigaltstack-mapping
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -315,7 +315,7 @@ static void test_sigsegv_handler_with_di
 	sys_mprotect_pkey(stack, STACK_SIZE, PROT_READ | PROT_WRITE, pkey);
 
 	/* Set up alternate signal stack that will use the default MPK */
-	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE | PROT_EXEC,
+	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
@@ -488,7 +488,7 @@ static void test_pkru_sigreturn(void)
 	sys_mprotect_pkey(stack, STACK_SIZE, PROT_READ | PROT_WRITE, pkey);
 
 	/* Set up alternate signal stack that will use the default MPK */
-	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE | PROT_EXEC,
+	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
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

