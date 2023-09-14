Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F5AEEAA65
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 18:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241400AbjINSvh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 14:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242186AbjINSvU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 14:51:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FF02103
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 11:47:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F300FC433C9;
        Thu, 14 Sep 2023 18:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694717229;
        bh=2NzCjdBIrwqPiGalpQB8iCJgUiHSdKiYijADJQxj/QU=;
        h=Date:To:From:Subject:From;
        b=PC/GjJhzdnMq954Z2S5HEQ5OW5VRbiq1InMDcU89X4W9yAu9scENgVDQ1qlktYod+
         emLolTf4my6hplPB/E1wke5v2mab4brOTotw71oaUjjcThy2yTKiQRj3rLnlsIzW+D
         OeqcS5qoH/kFEYFtLMdMHuQLfbp6l55apS6yAoJk=
Date:   Thu, 14 Sep 2023 11:47:08 -0700
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        chenjiahao16@huawei.com, catalin.marinas@arm.com, bhe@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_core-change-the-prototype-of-function-parse_crashkernel.patch added to mm-nonmm-unstable branch
Message-Id: <20230914184708.F300FC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: crash_core: change the prototype of function parse_crashkernel()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_core-change-the-prototype-of-function-parse_crashkernel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_core-change-the-prototype-of-function-parse_crashkernel.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: crash_core: change the prototype of function parse_crashkernel()
Date: Thu, 14 Sep 2023 11:31:35 +0800

Add two parameters 'low_size' and 'high' to function parse_crashkernel(),
later crashkernel=,high|low parsing will be added.  Make adjustments in
all call sites of parse_crashkernel() in arch.

Link: https://lkml.kernel.org/r/20230914033142.676708-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Jiahao <chenjiahao16@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/setup.c              |    3 ++-
 arch/arm64/mm/init.c                 |    2 +-
 arch/ia64/kernel/setup.c             |    2 +-
 arch/loongarch/kernel/setup.c        |    4 +++-
 arch/mips/kernel/setup.c             |    3 ++-
 arch/powerpc/kernel/fadump.c         |    2 +-
 arch/powerpc/kexec/core.c            |    2 +-
 arch/powerpc/mm/nohash/kaslr_booke.c |    2 +-
 arch/riscv/mm/init.c                 |    2 +-
 arch/s390/kernel/setup.c             |    4 ++--
 arch/sh/kernel/machine_kexec.c       |    2 +-
 arch/x86/kernel/setup.c              |    3 ++-
 include/linux/crash_core.h           |    3 ++-
 kernel/crash_core.c                  |   15 ++++++++++++---
 14 files changed, 32 insertions(+), 17 deletions(-)

--- a/arch/arm64/mm/init.c~crash_core-change-the-prototype-of-function-parse_crashkernel
+++ a/arch/arm64/mm/init.c
@@ -142,7 +142,7 @@ static void __init reserve_crashkernel(v
 
 	/* crashkernel=X[@offset] */
 	ret = parse_crashkernel(cmdline, memblock_phys_mem_size(),
-				&crash_size, &crash_base);
+				&crash_size, &crash_base, NULL, NULL);
 	if (ret == -ENOENT) {
 		ret = parse_crashkernel_high(cmdline, 0, &crash_size, &crash_base);
 		if (ret || !crash_size)
--- a/arch/arm/kernel/setup.c~crash_core-change-the-prototype-of-function-parse_crashkernel
+++ a/arch/arm/kernel/setup.c
@@ -1010,7 +1010,8 @@ static void __init reserve_crashkernel(v
 
 	total_mem = get_total_mem();
 	ret = parse_crashkernel(boot_command_line, total_mem,
-				&crash_size, &crash_base);
+				&crash_size, &crash_base,
+				NULL, NULL);
 	/* invalid value specified or crashkernel=0 */
 	if (ret || !crash_size)
 		return;
--- a/arch/ia64/kernel/setup.c~crash_core-change-the-prototype-of-function-parse_crashkernel
+++ a/arch/ia64/kernel/setup.c
@@ -277,7 +277,7 @@ static void __init setup_crashkernel(uns
 	int ret;
 
 	ret = parse_crashkernel(boot_command_line, total,
-			&size, &base);
+			&size, &base, NULL, NULL);
 	if (ret == 0 && size > 0) {
 		if (!base) {
 			sort_regions(rsvd_region, *n);
--- a/arch/loongarch/kernel/setup.c~crash_core-change-the-prototype-of-function-parse_crashkernel
+++ a/arch/loongarch/kernel/setup.c
@@ -267,7 +267,9 @@ static void __init arch_parse_crashkerne
 	unsigned long long crash_base, crash_size;
 
 	total_mem = memblock_phys_mem_size();
-	ret = parse_crashkernel(boot_command_line, total_mem, &crash_size, &crash_base);
+	ret = parse_crashkernel(boot_command_line, total_mem,
+				&crash_size, &crash_base,
+				NULL, NULL);
 	if (ret < 0 || crash_size <= 0)
 		return;
 
--- a/arch/mips/kernel/setup.c~crash_core-change-the-prototype-of-function-parse_crashkernel
+++ a/arch/mips/kernel/setup.c
@@ -460,7 +460,8 @@ static void __init mips_parse_crashkerne
 
 	total_mem = memblock_phys_mem_size();
 	ret = parse_crashkernel(boot_command_line, total_mem,
-				&crash_size, &crash_base);
+				&crash_size, &crash_base,
+				NULL, NULL);
 	if (ret != 0 || crash_size <= 0)
 		return;
 
--- a/arch/powerpc/kernel/fadump.c~crash_core-change-the-prototype-of-function-parse_crashkernel
+++ a/arch/powerpc/kernel/fadump.c
@@ -313,7 +313,7 @@ static __init u64 fadump_calculate_reser
 	 * memory at a predefined offset.
 	 */
 	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
-				&size, &base);
+				&size, &base, NULL, NULL);
 	if (ret == 0 && size > 0) {
 		unsigned long max_size;
 
--- a/arch/powerpc/kexec/core.c~crash_core-change-the-prototype-of-function-parse_crashkernel
+++ a/arch/powerpc/kexec/core.c
@@ -109,7 +109,7 @@ void __init reserve_crashkernel(void)
 	total_mem_sz = memory_limit ? memory_limit : memblock_phys_mem_size();
 	/* use common parsing */
 	ret = parse_crashkernel(boot_command_line, total_mem_sz,
-			&crash_size, &crash_base);
+			&crash_size, &crash_base, NULL, NULL);
 	if (ret == 0 && crash_size > 0) {
 		crashk_res.start = crash_base;
 		crashk_res.end = crash_base + crash_size - 1;
--- a/arch/powerpc/mm/nohash/kaslr_booke.c~crash_core-change-the-prototype-of-function-parse_crashkernel
+++ a/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -178,7 +178,7 @@ static void __init get_crash_kernel(void
 	int ret;
 
 	ret = parse_crashkernel(boot_command_line, size, &crash_size,
-				&crash_base);
+				&crash_base, NULL, NULL);
 	if (ret != 0 || crash_size == 0)
 		return;
 	if (crash_base == 0)
--- a/arch/riscv/mm/init.c~crash_core-change-the-prototype-of-function-parse_crashkernel
+++ a/arch/riscv/mm/init.c
@@ -1388,7 +1388,7 @@ static void __init reserve_crashkernel(v
 	}
 
 	ret = parse_crashkernel(cmdline, memblock_phys_mem_size(),
-				&crash_size, &crash_base);
+				&crash_size, &crash_base, NULL, NULL);
 	if (ret == -ENOENT) {
 		/* Fallback to crashkernel=X,[high,low] */
 		ret = parse_crashkernel_high(cmdline, 0, &crash_size, &crash_base);
--- a/arch/s390/kernel/setup.c~crash_core-change-the-prototype-of-function-parse_crashkernel
+++ a/arch/s390/kernel/setup.c
@@ -625,8 +625,8 @@ static void __init reserve_crashkernel(v
 	phys_addr_t low, high;
 	int rc;
 
-	rc = parse_crashkernel(boot_command_line, ident_map_size, &crash_size,
-			       &crash_base);
+	rc = parse_crashkernel(boot_command_line, ident_map_size,
+			       &crash_size, &crash_base, NULL, NULL);
 
 	crash_base = ALIGN(crash_base, KEXEC_CRASH_MEM_ALIGN);
 	crash_size = ALIGN(crash_size, KEXEC_CRASH_MEM_ALIGN);
--- a/arch/sh/kernel/machine_kexec.c~crash_core-change-the-prototype-of-function-parse_crashkernel
+++ a/arch/sh/kernel/machine_kexec.c
@@ -154,7 +154,7 @@ void __init reserve_crashkernel(void)
 	int ret;
 
 	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
-			&crash_size, &crash_base);
+			&crash_size, &crash_base, NULL, NULL);
 	if (ret == 0 && crash_size > 0) {
 		crashk_res.start = crash_base;
 		crashk_res.end = crash_base + crash_size - 1;
--- a/arch/x86/kernel/setup.c~crash_core-change-the-prototype-of-function-parse_crashkernel
+++ a/arch/x86/kernel/setup.c
@@ -557,7 +557,8 @@ static void __init reserve_crashkernel(v
 	total_mem = memblock_phys_mem_size();
 
 	/* crashkernel=XM */
-	ret = parse_crashkernel(boot_command_line, total_mem, &crash_size, &crash_base);
+	ret = parse_crashkernel(boot_command_line, total_mem,
+				&crash_size, &crash_base, NULL, NULL);
 	if (ret != 0 || crash_size <= 0) {
 		/* crashkernel=X,high */
 		ret = parse_crashkernel_high(boot_command_line, total_mem,
--- a/include/linux/crash_core.h~crash_core-change-the-prototype-of-function-parse_crashkernel
+++ a/include/linux/crash_core.h
@@ -80,7 +80,8 @@ Elf_Word *append_elf_note(Elf_Word *buf,
 void final_note(Elf_Word *buf);
 
 int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
-		unsigned long long *crash_size, unsigned long long *crash_base);
+		unsigned long long *crash_size, unsigned long long *crash_base,
+		unsigned long long *low_size, bool *high);
 int parse_crashkernel_high(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
 int parse_crashkernel_low(char *cmdline, unsigned long long system_ram,
--- a/kernel/crash_core.c~crash_core-change-the-prototype-of-function-parse_crashkernel
+++ a/kernel/crash_core.c
@@ -287,10 +287,19 @@ static int __init __parse_crashkernel(ch
 int __init parse_crashkernel(char *cmdline,
 			     unsigned long long system_ram,
 			     unsigned long long *crash_size,
-			     unsigned long long *crash_base)
+			     unsigned long long *crash_base,
+			     unsigned long long *low_size,
+			     bool *high)
 {
-	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
-				NULL);
+	int ret;
+
+	/* crashkernel=X[@offset] */
+	ret = __parse_crashkernel(cmdline, system_ram, crash_size,
+				crash_base, NULL);
+	if (!high)
+		return ret;
+
+	return 0;
 }
 
 int __init parse_crashkernel_high(char *cmdline,
_

Patches currently in -mm which might be from bhe@redhat.com are

crash_corec-remove-unnecessary-parameter-of-function.patch
crash_core-change-the-prototype-of-function-parse_crashkernel.patch
crash_core-change-parse_crashkernel-to-support-crashkernel=highlow-parsing.patch
crash_core-add-generic-function-to-do-reservation.patch
crash_core-move-crashk_res-definition-into-crash_corec.patch
x86-kdump-use-generic-interface-to-simplify-crashkernel-reservation-code.patch
arm64-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch
riscv-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch
crash_corec-remove-unneeded-functions.patch

