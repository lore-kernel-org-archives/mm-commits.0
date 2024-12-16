Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18C2148FF0
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734368473; cv=none; b=NNnw2bezBfiLHWMKauXXyatmRX3lc6eByygdHwEPLoR6u2ON4Kjs8EkSb0PJeKMDfh7147B5j2TBF1PtnA7mMP564x3QMvqReQQbvAqrvoGNXf4qGXRaGUHUQMX/RgNJmURtdjpnxOmtKij3U3T7nB42ss4L4bPg+6sqh6H3BHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734368473; c=relaxed/simple;
	bh=4kNnHfd5ZK162LdKNaTVpz4olYBW1iLvLDtwsLwHcFo=;
	h=Date:To:From:Subject:Message-Id; b=oitFqNksJ06Lm6QTrwpEpeqYxeyYC3tcS86/ulWvcRw6grctOwE1BVvnTOjGj3jM2xV1qABu8H9lsXoGO02FRJHdzW//V7QCWaXfmNr7MRntOoCRpiIbcS10zlT3f8Ya88ux9o7UUa9RHzXTvg9GWrWgk8YiqXlGgLpAIzon/eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=keO9f5DY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="keO9f5DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8FDC4CED0;
	Mon, 16 Dec 2024 17:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734368473;
	bh=4kNnHfd5ZK162LdKNaTVpz4olYBW1iLvLDtwsLwHcFo=;
	h=Date:To:From:Subject:From;
	b=keO9f5DYpmYmAbnIO/Nx78O+BXz/YNLOuS+TCZbrO3bN8xQRMqjUPX6hxnYaqqjV+
	 Tq3C9P7AV+QiPf7PAzpvyH1VnEED+78j5HJc2RWQ/mEOiwKNBhAEg07zBTh3JcK9Gy
	 i0a2cFjiU/Fpz6VZZS9/kJhdFmw34NpLKabO2n0w=
Date: Mon, 16 Dec 2024 09:01:12 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-use-sys_pkey-helpers-consistently-fix.patch added to mm-unstable branch
Message-Id: <20241216170113.3E8FDC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix dependency on pkey_util.c
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-use-sys_pkey-helpers-consistently-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-use-sys_pkey-helpers-consistently-fix.patch

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
@@ -146,16 +146,20 @@ TEST_FILES += write_hugetlb_memory.sh
 
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
selftests-mm-use-sys_pkey-helpers-consistently-fix.patch
selftests-mm-rename-pkey-register-macro.patch
selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch
selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch

