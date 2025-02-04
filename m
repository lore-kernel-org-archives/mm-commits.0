Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B107A25A642
	for <mm-commits@vger.kernel.org>; Tue,  4 Feb 2025 00:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738630543; cv=none; b=CHR/bbIZnEnEE8Fd1j5xsBoAmlUf15BMPI9HXjhagIcPjAnCcxEr1Vkcj4nEHQtluXV33lVbTgBqGdyR6qrGziGG6fTnfOrCdjPgSzvNvB4TjUOFu/ynk8GMvaTQpKpcQWXkIXi88qnsyb4h/pXkqdQNDK9mfGApSHwyOmVPZQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738630543; c=relaxed/simple;
	bh=+b4mUTsJ6cy5d7T4KXREtVI7X8H3hqaaTiCk1k1XZgE=;
	h=Date:To:From:Subject:Message-Id; b=EplRRuEKMKg1hWAx6iRAnYS/uG08d8MiZf9yIvkMnU+caCjbda9FVRu/FholgXFBTfT/w/fejlUdsALriTPcgkonwOhKQhyG7fnWdyn/YQg/4vq2U3UxqA9knFsVHCa/o40aNcCL2vlIRSzKXHb79RQZHBiWh3oBN2Q+AHCAz/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mpRLBTjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mpRLBTjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13872C4CEE4;
	Tue,  4 Feb 2025 00:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738630543;
	bh=+b4mUTsJ6cy5d7T4KXREtVI7X8H3hqaaTiCk1k1XZgE=;
	h=Date:To:From:Subject:From;
	b=mpRLBTjLQBB9JIb6wiRcogzJg/d7iXBwOfackYeJHZ69GehCJk6F+WYgOpjVOiZSo
	 1jXr4/qjmhJ7VQvEL2clkBudZA1teCQP2s809FDAg1/sX/9PJmsf4FRVc/RM3z1fE/
	 t1iPA+wEtt5J8qcBukZOZwGBsTa56cV0oN5O2+KI=
Date: Mon, 03 Feb 2025 16:55:42 -0800
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,mahesh@linux.ibm.com,maddy@linux.ibm.com,hbathini@linux.ibm.com,bhe@redhat.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-remove-an-unused-argument-from-reserve_crashkernel_generic.patch added to mm-nonmm-unstable branch
Message-Id: <20250204005543.13872C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: remove an unused argument from reserve_crashkernel_generic()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-remove-an-unused-argument-from-reserve_crashkernel_generic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-remove-an-unused-argument-from-reserve_crashkernel_generic.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: crash: remove an unused argument from reserve_crashkernel_generic()
Date: Fri, 31 Jan 2025 17:08:25 +0530

cmdline argument is not used in reserve_crashkernel_generic() so remove
it.  Correspondingly, all the callers have been updated as well.

No functional change intended.

Link: https://lkml.kernel.org/r/20250131113830.925179-3-sourabhjain@linux.ibm.com
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/init.c          |    6 ++----
 arch/loongarch/kernel/setup.c |    5 ++---
 arch/riscv/mm/init.c          |    6 ++----
 arch/x86/kernel/setup.c       |    6 ++----
 include/linux/crash_reserve.h |   11 +++++------
 kernel/crash_reserve.c        |    9 ++++-----
 6 files changed, 17 insertions(+), 26 deletions(-)

--- a/arch/arm64/mm/init.c~crash-remove-an-unused-argument-from-reserve_crashkernel_generic
+++ a/arch/arm64/mm/init.c
@@ -98,21 +98,19 @@ static void __init arch_reserve_crashker
 {
 	unsigned long long low_size = 0;
 	unsigned long long crash_base, crash_size;
-	char *cmdline = boot_command_line;
 	bool high = false;
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
 		return;
 
-	ret = parse_crashkernel(cmdline, memblock_phys_mem_size(),
+	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 				&crash_size, &crash_base,
 				&low_size, &high);
 	if (ret)
 		return;
 
-	reserve_crashkernel_generic(cmdline, crash_size, crash_base,
-				    low_size, high);
+	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
 }
 
 static phys_addr_t __init max_zone_phys(phys_addr_t zone_limit)
--- a/arch/loongarch/kernel/setup.c~crash-remove-an-unused-argument-from-reserve_crashkernel_generic
+++ a/arch/loongarch/kernel/setup.c
@@ -259,18 +259,17 @@ static void __init arch_reserve_crashker
 	int ret;
 	unsigned long long low_size = 0;
 	unsigned long long crash_base, crash_size;
-	char *cmdline = boot_command_line;
 	bool high = false;
 
 	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
 		return;
 
-	ret = parse_crashkernel(cmdline, memblock_phys_mem_size(),
+	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 				&crash_size, &crash_base, &low_size, &high);
 	if (ret)
 		return;
 
-	reserve_crashkernel_generic(cmdline, crash_size, crash_base, low_size, high);
+	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
 }
 
 static void __init fdt_setup(void)
--- a/arch/riscv/mm/init.c~crash-remove-an-unused-argument-from-reserve_crashkernel_generic
+++ a/arch/riscv/mm/init.c
@@ -1392,21 +1392,19 @@ static void __init arch_reserve_crashker
 {
 	unsigned long long low_size = 0;
 	unsigned long long crash_base, crash_size;
-	char *cmdline = boot_command_line;
 	bool high = false;
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
 		return;
 
-	ret = parse_crashkernel(cmdline, memblock_phys_mem_size(),
+	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 				&crash_size, &crash_base,
 				&low_size, &high);
 	if (ret)
 		return;
 
-	reserve_crashkernel_generic(cmdline, crash_size, crash_base,
-				    low_size, high);
+	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
 }
 
 void __init paging_init(void)
--- a/arch/x86/kernel/setup.c~crash-remove-an-unused-argument-from-reserve_crashkernel_generic
+++ a/arch/x86/kernel/setup.c
@@ -472,14 +472,13 @@ static void __init memblock_x86_reserve_
 static void __init arch_reserve_crashkernel(void)
 {
 	unsigned long long crash_base, crash_size, low_size = 0;
-	char *cmdline = boot_command_line;
 	bool high = false;
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
 		return;
 
-	ret = parse_crashkernel(cmdline, memblock_phys_mem_size(),
+	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 				&crash_size, &crash_base,
 				&low_size, &high);
 	if (ret)
@@ -490,8 +489,7 @@ static void __init arch_reserve_crashker
 		return;
 	}
 
-	reserve_crashkernel_generic(cmdline, crash_size, crash_base,
-				    low_size, high);
+	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
 }
 
 static struct resource standard_io_resources[] = {
--- a/include/linux/crash_reserve.h~crash-remove-an-unused-argument-from-reserve_crashkernel_generic
+++ a/include/linux/crash_reserve.h
@@ -32,13 +32,12 @@ int __init parse_crashkernel(char *cmdli
 #define CRASH_ADDR_HIGH_MAX		memblock_end_of_DRAM()
 #endif
 
-void __init reserve_crashkernel_generic(char *cmdline,
-		unsigned long long crash_size,
-		unsigned long long crash_base,
-		unsigned long long crash_low_size,
-		bool high);
+void __init reserve_crashkernel_generic(unsigned long long crash_size,
+					unsigned long long crash_base,
+					unsigned long long crash_low_size,
+					bool high);
 #else
-static inline void __init reserve_crashkernel_generic(char *cmdline,
+static inline void __init reserve_crashkernel_generic(
 		unsigned long long crash_size,
 		unsigned long long crash_base,
 		unsigned long long crash_low_size,
--- a/kernel/crash_reserve.c~crash-remove-an-unused-argument-from-reserve_crashkernel_generic
+++ a/kernel/crash_reserve.c
@@ -375,11 +375,10 @@ static int __init reserve_crashkernel_lo
 	return 0;
 }
 
-void __init reserve_crashkernel_generic(char *cmdline,
-			     unsigned long long crash_size,
-			     unsigned long long crash_base,
-			     unsigned long long crash_low_size,
-			     bool high)
+void __init reserve_crashkernel_generic(unsigned long long crash_size,
+					unsigned long long crash_base,
+					unsigned long long crash_low_size,
+					bool high)
 {
 	unsigned long long search_end = CRASH_ADDR_LOW_MAX, search_base = 0;
 	bool fixed_base = false;
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are

kexec-initialize-elf-lowest-address-to-ulong_max.patch
crash-remove-an-unused-argument-from-reserve_crashkernel_generic.patch
crash-let-arch-decide-usable-memory-range-in-reserved-area.patch
powerpc-crash-use-generic-apis-to-locate-memory-hole-for-kdump.patch
powerpc-crash-preserve-user-specified-memory-limit.patch
powerpc-insert-system-ram-resource-to-prevent-crashkernel-conflict.patch
powerpc-crash-use-generic-crashkernel-reservation.patch

