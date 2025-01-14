Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8597233522
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836097; cv=none; b=lVqai1521M2rEWb4VemA1k/Yq1cBowo4/fOZ0Hq1CRC5OG7dN9vftuXEd+NOLp3vAkBHEe8UB7+uzx59kqYHykRRNpSGdcA8dojQcnykxoMh0cFw/Ceu+78Shd6eY7pwOTukBKplZSGYVhc2Dv8+lbYSnbG8es4VKsx3UXuFe7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836097; c=relaxed/simple;
	bh=te5LjaUKFLSISuUoP17Fluf40NCyoqvq9OwgWGUOVPc=;
	h=Date:To:From:Subject:Message-Id; b=rqs3pnA+7a94J0gFGQNw55SHLM3KcOvM+Yj3ODRBoK1Ni517xoq9TtUQiuDzaY6MaO6O8XNaJHCLxGYh49L8FazDrlkCwIphHWURAkE451y7SFNH/wEF/N0hK/+HBoPoFBNDumX2NjvcJoXGyPYqbSPtVnYCKyEIzHbOKtNmWHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yy2goi5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yy2goi5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CA7C4CEE1;
	Tue, 14 Jan 2025 06:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836097;
	bh=te5LjaUKFLSISuUoP17Fluf40NCyoqvq9OwgWGUOVPc=;
	h=Date:To:From:Subject:From;
	b=Yy2goi5WDqDO0dfenLm6EoxzJRHwOjbFtBg3jpKs3LfCteIUSEZHppqMILGi/WkWp
	 +P9ckclIuAe5Dtmgq+48T2GL7WUbmWRDspnEJqE6Wu1kKo2uxdRnFB4YXY6ql3QQkN
	 wSRnS7IOoLt9SSIe+WroCYfkgUM3v1fg7Oq3TU5k=
Date: Mon, 13 Jan 2025 22:28:17 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,lkp@intel.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests-fix.patch removed from -mm tree
Message-Id: <20250114062817.89CA7C4CEE1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests-fix.patch

This patch was dropped because it was folded into selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch

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
selftests-mm-build-with-o2.patch
selftests-mm-build-with-o2-fix.patch
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
riscv-mm-skip-pgtable-level-check-in-pudp4d_alloc_one.patch
asm-generic-pgalloc-provide-generic-p4d_alloc_onefree.patch
mm-move-common-part-of-pagetable__ctor-to-helper.patch
parisc-mm-ensure-pagetable_pmd_tor-are-called.patch
m68k-mm-add-calls-to-pagetable_pmd_tor.patch
arm-mm-rename-pgd-helpers.patch
asm-generic-pgalloc-provide-generic-__pgd_allocfree.patch
mm-introduce-ctor-dtor-at-pgd-level.patch

