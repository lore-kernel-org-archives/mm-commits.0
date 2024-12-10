Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF72233129
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 02:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733796494; cv=none; b=Anz4pP6o4dgWWBwENfs2jLG638wWuMU4cj8EvO0NpwsjBGN5Ume/EQ9E4UWgm4Akh6UfrJORxdrKVpAnTplVm8BDZu/0qOBsGZ9ceHr3chP0XHuh6+qSTKxh9ZiHo50/QVvPiT1n2sX8lEYLyOe8v3LkmGwalMGz3rtDZFbzugw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733796494; c=relaxed/simple;
	bh=woijWcR3guTWiy8b07wpUkMB3ocRHWbgDoFRf/pjUhQ=;
	h=Date:To:From:Subject:Message-Id; b=m6DexMife56SWdPbSjtX1YUKNLfvU0ERKgA71j/2jiJ8rFm0Ffiw8Cxqr9M5s+uX5P9j4ms5FD/Ji01y6FBsMWE6qebX+A0517EAUE1zTeNR4Xx9QPY3UguPpD3CSiZBnu+R+ZHfFDGEbJHNygdcxKvIPls/jMJXyrB/h4t6UOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=koULC+xw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="koULC+xw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A13DC4CED1;
	Tue, 10 Dec 2024 02:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733796494;
	bh=woijWcR3guTWiy8b07wpUkMB3ocRHWbgDoFRf/pjUhQ=;
	h=Date:To:From:Subject:From;
	b=koULC+xwhUNTM+PfpC0yG+ix9qJRRO2+t7ZfazMTWph/Wo/abEP8JF80qR/uEXGiC
	 d89AnFd5aZFRtlilr5gVUK6p+NBOWITyA8oaGRYEbfYIOfz3YIlWTEVVys2Scx1AFy
	 gnyRP0213MwhHGhDNs5a85FTZcecD9mTPTGLJhfE=
Date: Mon, 09 Dec 2024 18:08:13 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-rename-pkey-register-macro.patch added to mm-unstable branch
Message-Id: <20241210020814.4A13DC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: rename pkey register macro
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-rename-pkey-register-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-rename-pkey-register-macro.patch

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
Subject: selftests/mm: rename pkey register macro
Date: Mon, 9 Dec 2024 09:50:17 +0000

PKEY_ALLOW_ALL is meant to represent the pkey register value that allows
all accesses (enables all pkeys).  However its current naming suggests
that the value applies to *one* key only (like PKEY_DISABLE_ACCESS for
instance).

Rename PKEY_ALLOW_ALL to PKEY_REG_ALLOW_ALL to avoid such
misunderstanding.  This is consistent with the PKEY_REG_ALLOW_NONE macro
introduced by commit 6e182dc9f268 ("selftests/mm: Use generic pkey
register manipulation").

Link: https://lkml.kernel.org/r/20241209095019.1732120-13-kevin.brodsky@arm.com
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

 tools/testing/selftests/mm/pkey-arm64.h      |    2 +-
 tools/testing/selftests/mm/protection_keys.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/pkey-arm64.h~selftests-mm-rename-pkey-register-macro
+++ a/tools/testing/selftests/mm/pkey-arm64.h
@@ -30,7 +30,7 @@
 #define NR_PKEYS		8
 #define NR_RESERVED_PKEYS	1 /* pkey-0 */
 
-#define PKEY_ALLOW_ALL		0x77777777
+#define PKEY_REG_ALLOW_ALL	0x77777777
 #define PKEY_REG_ALLOW_NONE	0x0
 
 #define PKEY_BITS_PER_PKEY	4
--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-rename-pkey-register-macro
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -396,7 +396,7 @@ static void signal_handler(int signum, s
 	/* restore access and let the faulting instruction continue */
 	pkey_access_allow(siginfo_pkey);
 #elif defined(__aarch64__)
-	aarch64_write_signal_pkey(uctxt, PKEY_ALLOW_ALL);
+	aarch64_write_signal_pkey(uctxt, PKEY_REG_ALLOW_ALL);
 #endif /* arch */
 	pkey_faults++;
 	dprintf1("<<<<==================================================\n");
@@ -842,7 +842,7 @@ void expected_pkey_fault(int pkey)
 	 */
 	if (__read_pkey_reg() != 0)
 #elif defined(__aarch64__)
-	if (__read_pkey_reg() != PKEY_ALLOW_ALL)
+	if (__read_pkey_reg() != PKEY_REG_ALLOW_ALL)
 #else
 	if (__read_pkey_reg() != shadow_pkey_reg)
 #endif /* arch */
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

