Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D24B235BE8
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836202; cv=none; b=sg/HjqDRG6XIvw2ZGZtalmBn2RYC3PnW3ZK7SOZCnMFwy01CY7d8BlBR6GK3kX+qFZcfgtK4L+6JwDrbNeBtp6pCXgksE1r/+8M2SXiDzEcus/mYHTpyNDIBKLgngNod/sNxRdW1yqDEd5ez9pbNbwZhdOb7dIe+v/YsWyeoGF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836202; c=relaxed/simple;
	bh=2PI8TVZzYHdQeJ2YKySH814698Qit/wwiRttiH7X+kw=;
	h=Date:To:From:Subject:Message-Id; b=Bd2001ESp1jKnUPEJx+7glnYDvXRMemCRrKKFiax93HCrFaePNDfi9poDANcicivJUJhNZ6m/FXVwCEqb5xQ/2GKJVABV0V9YQxLBHNnffBQXMzhvgPSFEOY2G5UrCL3X/XXFYda2v8YASpnP0ezZfoub9jnMxUuIaCovCxvVjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pJN5vM5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pJN5vM5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A9EC4CEDD;
	Tue, 14 Jan 2025 06:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836202;
	bh=2PI8TVZzYHdQeJ2YKySH814698Qit/wwiRttiH7X+kw=;
	h=Date:To:From:Subject:From;
	b=pJN5vM5eBnDd5T51W+JrqvYKENYvWhish9oCTHGQhwCFH26Xehwmw3lPlq6viVie9
	 l5DZl5E2+/sZGPB+MYUrqzvFdlQ87lP0q72pYMbGwnxZVdBHG5sCU6+6BQWjGNqa/4
	 ON8RZ1ShGRYEa9apN+qLAhhZDBcCJGyok0da5hBo=
Date: Mon, 13 Jan 2025 22:30:01 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-use-sys_pkey-helpers-consistently-fix.patch removed from -mm tree
Message-Id: <20250114063002.03A9EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix dependency on pkey_util.c
has been removed from the -mm tree.  Its filename was
     selftests-mm-use-sys_pkey-helpers-consistently-fix.patch

This patch was dropped because it was folded into selftests-mm-use-sys_pkey-helpers-consistently.patch

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: fix dependency on pkey_util.c
Date: Mon, 16 Dec 2024 09:28:49 +0000

The pkey* files can only be built on architectures that support pkeys
(pkey-helpers.h #error's otherwise).  Adding pkey_util.c as dependency to
all $(TEST_GEN_FILES) is therefore a bad idea.  Make it a dependency of
the pkeys tests only.

Those tests are built in 32/64-bit variants on x86_64 so we need to add an
explicit dependency there as well.

Link: https://lkml.kernel.org/r/20241216092849.2140850-1-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-use-sys_pkey-helpers-consistently-fix
+++ a/tools/testing/selftests/mm/Makefile
@@ -153,16 +153,20 @@ TEST_FILES += write_hugetlb_memory.sh
 
 include ../lib.mk
 
-$(TEST_GEN_PROGS): vm_util.c thp_settings.c pkey_util.c
-$(TEST_GEN_FILES): vm_util.c thp_settings.c pkey_util.c
+$(TEST_GEN_PROGS): vm_util.c thp_settings.c
+$(TEST_GEN_FILES): vm_util.c thp_settings.c
 
 $(OUTPUT)/uffd-stress: uffd-common.c
 $(OUTPUT)/uffd-unit-tests: uffd-common.c
+$(OUTPUT)/protection_keys: pkey_util.c
+$(OUTPUT)/pkey_sighandler_tests: pkey_util.c
 
 ifeq ($(ARCH),x86_64)
 BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
 BINARIES_64 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
 
+$(BINARIES_32) $(BINARIES_64): pkey_util.c
+
 define gen-target-rule-32
 $(1) $(1)_32: $(OUTPUT)/$(1)_32
 .PHONY: $(1) $(1)_32
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
riscv-mm-skip-pgtable-level-check-in-pudp4d_alloc_one.patch
asm-generic-pgalloc-provide-generic-p4d_alloc_onefree.patch
mm-move-common-part-of-pagetable__ctor-to-helper.patch
parisc-mm-ensure-pagetable_pmd_tor-are-called.patch
m68k-mm-add-calls-to-pagetable_pmd_tor.patch
arm-mm-rename-pgd-helpers.patch
asm-generic-pgalloc-provide-generic-__pgd_allocfree.patch
mm-introduce-ctor-dtor-at-pgd-level.patch

