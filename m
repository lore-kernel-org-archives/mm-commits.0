Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6E2140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189493; cv=none; b=Oix1S06jf6REWgQPoc6L9Lf3HzRjWD+qkQrJAem/rsjAb/PbWqowDxXoAUDOEtrSM93i1i/RSmdAM0b4M3MGzTVDTiyE2SUEfkSVBbglx/9pL1TqS1wFIP9Wu7yHek4YDsM3JkwrMSEYFSR/nt3ENQIAVnfWm+WK5zZi7bV+Fy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189493; c=relaxed/simple;
	bh=5k/Q8vIuyL55neDFH2Du+cAwmNFtj07eP6yDYWBvPjw=;
	h=Date:To:From:Subject:Message-Id; b=SE+YQtOLqszerA/YiFUfl7fe62iDrShI1viQiATtAHlYWoK4ZOZO4S2PBeTieVE3ec8qCBOZWbn9x1EoMB3q6Y4ZiM48/kIuG3Tl7MUr3FwQqSh0waCOXAWem4PFRHKMbI9/WkJ8WwaQcc3JhhqrQ2NMbNd5zu9luotm5EWZVC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=abkpPFF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="abkpPFF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E37C4CEEC;
	Mon, 17 Mar 2025 05:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189493;
	bh=5k/Q8vIuyL55neDFH2Du+cAwmNFtj07eP6yDYWBvPjw=;
	h=Date:To:From:Subject:From;
	b=abkpPFF9ak3KUtHlGZMi8GLSFboDfMRu6/IkAbadAXI6PLehxtYJC66U291XCQu0+
	 Ytfjn9IHqkWJTY7yNnK2ngwoXpKxJrZj3UEilPRHxW62PgIepA98fbcgNHU8zorfzg
	 Al+F1KJi+n9hnZ2nvVF45MrjOTMzubVV8nu6v0Y8=
Date: Sun, 16 Mar 2025 22:31:32 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,mahesh@linux.ibm.com,maddy@linux.ibm.com,hbathini@linux.ibm.com,bhe@redhat.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash-remove-an-unused-argument-from-reserve_crashkernel_generic.patch removed from -mm tree
Message-Id: <20250317053133.47E37C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: remove an unused argument from reserve_crashkernel_generic()
has been removed from the -mm tree.  Its filename was
     crash-remove-an-unused-argument-from-reserve_crashkernel_generic.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1396,21 +1396,19 @@ static void __init arch_reserve_crashker
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


