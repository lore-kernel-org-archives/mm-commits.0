Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7894BEEAA66
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 18:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241578AbjINSvi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 14:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242197AbjINSvV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 14:51:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C0A58D5
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 11:47:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A5CC433C8;
        Thu, 14 Sep 2023 18:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694717232;
        bh=AmYHeZzJPn61Eqy2gxfV+8lvz69S1qSJTs/2LEBJaBs=;
        h=Date:To:From:Subject:From;
        b=k+7vKrsdCciBBT9VgjQJlovqeuN3saUlIsKG4g978xLu0L1EUUd1VPrf0H3PO94B6
         KxT2Mx+ung7AXxliiD5Wc/meKgJ+349ZA30W/nVq6MVfFx/Tu9i2oPvMt5OjNrpLJy
         IMqBQQQ7YWqjA+qFMDmcCkp1epSp4KBKbkIuz/1c=
Date:   Thu, 14 Sep 2023 11:47:12 -0700
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        chenjiahao16@huawei.com, catalin.marinas@arm.com, bhe@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_core-add-generic-function-to-do-reservation.patch added to mm-nonmm-unstable branch
Message-Id: <20230914184712.93A5CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: crash_core: add generic function to do reservation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_core-add-generic-function-to-do-reservation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_core-add-generic-function-to-do-reservation.patch

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
Subject: crash_core: add generic function to do reservation
Date: Thu, 14 Sep 2023 11:31:37 +0800

In architecture like x86_64, arm64 and riscv, they have vast virtual
address space and usually have huge physical memory RAM.  Their
crashkernel reservation doesn't have to be limited under 4G RAM, but can
be extended to the whole physical memory via crashkernel=,high support.

Now add function reserve_crashkernel_generic() to reserve crashkernel
memory if users specify any case of kernel pamameters, like
crashkernel=xM[@offset] or crashkernel=,high|low.

This is preparation to simplify code of crashkernel=,high support in
architecutures.

Link: https://lkml.kernel.org/r/20230914033142.676708-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Jiahao <chenjiahao16@huawei.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_core.h |   28 +++++++++
 kernel/crash_core.c        |  107 ++++++++++++++++++++++++++++++++++-
 2 files changed, 134 insertions(+), 1 deletion(-)

--- a/include/linux/crash_core.h~crash_core-add-generic-function-to-do-reservation
+++ a/include/linux/crash_core.h
@@ -93,6 +93,34 @@ int parse_crashkernel_high(char *cmdline
 int parse_crashkernel_low(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
 
+#ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
+#ifndef DEFAULT_CRASH_KERNEL_LOW_SIZE
+#define DEFAULT_CRASH_KERNEL_LOW_SIZE	(128UL << 20)
+#endif
+#ifndef CRASH_ALIGN
+#define CRASH_ALIGN			SZ_2M
+#endif
+#ifndef CRASH_ADDR_LOW_MAX
+#define CRASH_ADDR_LOW_MAX		SZ_4G
+#endif
+#ifndef CRASH_ADDR_HIGH_MAX
+#define CRASH_ADDR_HIGH_MAX		memblock_end_of_DRAM()
+#endif
+
+void __init reserve_crashkernel_generic(char *cmdline,
+		unsigned long long crash_size,
+		unsigned long long crash_base,
+		unsigned long long crash_low_size,
+		bool high);
+#else
+static inline void __init reserve_crashkernel_generic(char *cmdline,
+		unsigned long long crash_size,
+		unsigned long long crash_base,
+		unsigned long long crash_low_size,
+		bool high)
+{}
+#endif
+
 /* Alignment required for elf header segment */
 #define ELF_CORE_HEADER_ALIGN   4096
 
--- a/kernel/crash_core.c~crash_core-add-generic-function-to-do-reservation
+++ a/kernel/crash_core.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/buildid.h>
-#include <linux/crash_core.h>
 #include <linux/init.h>
 #include <linux/utsname.h>
 #include <linux/vmalloc.h>
@@ -13,6 +12,9 @@
 #include <linux/kexec.h>
 #include <linux/memory.h>
 #include <linux/cpuhotplug.h>
+#include <linux/memblock.h>
+#include <linux/kexec.h>
+#include <linux/kmemleak.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -360,6 +362,109 @@ static int __init parse_crashkernel_dumm
 }
 early_param("crashkernel", parse_crashkernel_dummy);
 
+#ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
+static int __init reserve_crashkernel_low(unsigned long long low_size)
+{
+#ifdef CONFIG_64BIT
+	unsigned long long low_base;
+
+	low_base = memblock_phys_alloc_range(low_size, CRASH_ALIGN, 0, CRASH_ADDR_LOW_MAX);
+	if (!low_base) {
+		pr_err("cannot allocate crashkernel low memory (size:0x%llx).\n", low_size);
+		return -ENOMEM;
+	}
+
+	pr_info("crashkernel low memory reserved: 0x%08llx - 0x%08llx (%lld MB)\n",
+		low_base, low_base + low_size, low_size >> 20);
+
+	crashk_low_res.start = low_base;
+	crashk_low_res.end   = low_base + low_size - 1;
+	insert_resource(&iomem_resource, &crashk_low_res);
+#endif
+	return 0;
+}
+
+void __init reserve_crashkernel_generic(char *cmdline,
+			     unsigned long long crash_size,
+			     unsigned long long crash_base,
+			     unsigned long long crash_low_size,
+			     bool high)
+{
+	unsigned long long search_end = CRASH_ADDR_LOW_MAX, search_base = 0;
+	bool fixed_base = false;
+
+	/* User specifies base address explicitly. */
+	if (crash_base) {
+		fixed_base = true;
+		search_base = crash_base;
+		search_end = crash_base + crash_size;
+	} else if (high) {
+		search_base = CRASH_ADDR_LOW_MAX;
+		search_end = CRASH_ADDR_HIGH_MAX;
+	}
+
+retry:
+	crash_base = memblock_phys_alloc_range(crash_size, CRASH_ALIGN,
+					       search_base, search_end);
+	if (!crash_base) {
+		/*
+		 * For crashkernel=size[KMG]@offset[KMG], print out failure
+		 * message if can't reserve the specified region.
+		 */
+		if (fixed_base) {
+			pr_warn("crashkernel reservation failed - memory is in use.\n");
+			return;
+		}
+
+		/*
+		 * For crashkernel=size[KMG], if the first attempt was for
+		 * low memory, fall back to high memory, the minimum required
+		 * low memory will be reserved later.
+		 */
+		if (!high && search_end == CRASH_ADDR_LOW_MAX) {
+			search_end = CRASH_ADDR_HIGH_MAX;
+			search_base = CRASH_ADDR_LOW_MAX;
+			crash_low_size = DEFAULT_CRASH_KERNEL_LOW_SIZE;
+			goto retry;
+		}
+
+		/*
+		 * For crashkernel=size[KMG],high, if the first attempt was
+		 * for high memory, fall back to low memory.
+		 */
+		if (high && search_end == CRASH_ADDR_HIGH_MAX) {
+			search_end = CRASH_ADDR_LOW_MAX;
+			search_base = 0;
+			goto retry;
+		}
+		pr_warn("cannot allocate crashkernel (size:0x%llx)\n",
+			crash_size);
+		return;
+	}
+
+	if ((crash_base > CRASH_ADDR_LOW_MAX) &&
+	     crash_low_size && reserve_crashkernel_low(crash_low_size)) {
+		memblock_phys_free(crash_base, crash_size);
+		return;
+	}
+
+	pr_info("crashkernel reserved: 0x%016llx - 0x%016llx (%lld MB)\n",
+		crash_base, crash_base + crash_size, crash_size >> 20);
+
+	/*
+	 * The crashkernel memory will be removed from the kernel linear
+	 * map. Inform kmemleak so that it won't try to access it.
+	 */
+	kmemleak_ignore_phys(crash_base);
+	if (crashk_low_res.end)
+		kmemleak_ignore_phys(crashk_low_res.start);
+
+	crashk_res.start = crash_base;
+	crashk_res.end = crash_base + crash_size - 1;
+	insert_resource(&iomem_resource, &crashk_res);
+}
+#endif
+
 int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
 			  void **addr, unsigned long *sz)
 {
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

