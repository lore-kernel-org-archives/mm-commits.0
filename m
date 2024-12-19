Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6958BE7
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 00:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734566516; cv=none; b=nNAThlVsMuE4iw8hRaL/+KbbUsflidSD39EGS9BEm2WxXqj7XjFmfWQNg3CEUsTx/iDlfBqaWsx40QS0MYjxU/qEYkr8l0cZBYUBsN3sNNA1Gt2RsB0VWSTRYpU0CxNSNOi7YpZl4M/wpU+IraMiYiEPMS8eKOqi5JTNB1Qb59c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734566516; c=relaxed/simple;
	bh=5lRh9xLSQjHK29CRIIb2p7c9YNRIkXIdYpAmnqGa9AI=;
	h=Date:To:From:Subject:Message-Id; b=hti//hPVKwN7IkjRAzNJ9kPNeuZl5Q24XN1V7Jg9G+nL9GH5X8MncMSouqajFt74EFc9u2EXK2vWk9yaJnZ1yP7X5tFJMsTbOzIWWf1PF97dAjjF4+Jy4EcHViUbVUhjzJSlC+NBfRXtv8C/FiZh4bVW2LmerXmRMHZ4NY68gss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kb1QVkeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kb1QVkeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F7EC4CECD;
	Thu, 19 Dec 2024 00:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734566516;
	bh=5lRh9xLSQjHK29CRIIb2p7c9YNRIkXIdYpAmnqGa9AI=;
	h=Date:To:From:Subject:From;
	b=Kb1QVkeDYINrDW/x1scrTW+23nnEyx6R6Eyb00KpvB+eYYN6BlMIAMge0wpT8kwJB
	 x8XTWccNHJ0ULip2nq33+TK5Z1+JeTdDCI+shEv8V1qN2R6BQB3Ti2VMcDXmFGv24R
	 CAdBq4sOnnVBpXBxEL43G6PInHxpLvbQuFRt9gHk=
Date: Wed, 18 Dec 2024 16:01:55 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,lkp@intel.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests-fix.patch added to mm-unstable branch
Message-Id: <20241219000156.10F7EC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests-fix.patch

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
Subject: selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests-fix
Date: Wed, 18 Dec 2024 15:36:15 +0000

Dereferencing a null pointer on Clang is not a good idea - it will
entirely optimise out the dereference.  Make the pointer volatile to force
the access (and fault).

Link: https://lkml.kernel.org/r/20241218153615.2267571-1-kevin.brodsky@arm.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412140850.4TW4YBqc-lkp@intel.com/
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

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests-fix
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -163,7 +163,7 @@ static void *thread_segv_with_pkey0_disa
 	__write_pkey_reg(pkey_reg_restrictive_default());
 
 	/* Segfault (with SEGV_MAPERR) */
-	*(int *)NULL = 1;
+	*(volatile int *)NULL = 1;
 	return NULL;
 }
 
@@ -194,7 +194,7 @@ static void *thread_segv_maperr_ptr(void
 	__write_pkey_reg(pkey_reg);
 
 	/* Segfault */
-	*(int *)NULL = 1;
+	*(volatile int *)NULL = 1;
 	syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
 	return NULL;
 }
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

selftests-mm-fix-condition-in-uffd_move_test_common.patch
selftests-mm-fix-wmaybe-uninitialized-warnings.patch
selftests-mm-fix-strncpy-length.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests-fix.patch
selftests-mm-build-with-o2.patch
selftests-mm-remove-unused-pkey-helpers.patch
selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch
selftests-mm-ensure-pkey-h-define-inline-functions-only.patch
selftests-mm-remove-empty-pkey-helper-definition.patch
selftests-mm-ensure-non-global-pkey-symbols-are-marked-static.patch
selftests-mm-use-sys_pkey-helpers-consistently.patch
selftests-mm-use-sys_pkey-helpers-consistently-fix.patch
selftests-mm-rename-pkey-register-macro.patch
selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch
selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch

