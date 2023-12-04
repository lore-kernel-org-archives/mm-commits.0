Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C14AC4167B
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjLDTks (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbjLDTkq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:40:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E2DCA
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:40:52 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F88BC433C9;
        Mon,  4 Dec 2023 19:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701718852;
        bh=6g52mWFeeJHZUDvL9fqfqRLHrmnxqHCEwQgW4fYgd5E=;
        h=Date:To:From:Subject:From;
        b=v/0w0j9MCfbkNYnLDx9pDdUS6Y9KmyBfxcZdECK3gHyPkyj0uF3XyClah/hvGoZJJ
         BkpUEU0zxmuzZv1ekCcI9kBJcb3qRjAetb1mZ/uyjAdmhbvgUiQX5+3lsht7Hi0y9X
         oJkgCkv5GGQJ13IM3APXG/H4unzvf1G1iGuV6SiM=
Date:   Mon, 04 Dec 2023 11:40:51 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rdunlap@infradead.org, ignat@cloudflare.com,
        agordeev@linux.ibm.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-1.patch added to mm-hotfixes-unstable branch
Message-Id: <20231204194052.4F88BC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv, crash: don't export some symbols when CONFIG_MMU=n
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-1.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: riscv, crash: don't export some symbols when CONFIG_MMU=n
Date: Mon, 4 Dec 2023 10:19:36 +0800

When dropping select of KEXEC and dependency on ARCH_SUPPORTS_KEXEC
from CRASH_DUMP, compiling error is reported when below config items are
set:
-----------------------
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_CRASH_DUMP=y
......
-----------------------

-------------------------------------------------------------------------------------------------
arch/riscv/kernel/crash_core.c:8:27: error: 'VA_BITS' undeclared (first use in this function)
 8 |         VMCOREINFO_NUMBER(VA_BITS);
   |                           ^~~~~~~
include/linux/crash_core.h:78:64: note: in definition of macro 'VMCOREINFO_NUMBER'
78 |         vmcoreinfo_append_str("NUMBER(%s)=%ld\n", #name, (long)name)
   |                                                                ^~~~

arch/riscv/kernel/crash_core.c:14:64: error: 'VMEMMAP_START' undeclared (first use in this function)
14 |         vmcoreinfo_append_str("NUMBER(VMEMMAP_START)=0x%lx\n", VMEMMAP_START);
   |                                                                ^~~~~~~~~~~~~
arch/riscv/kernel/crash_core.c:15:62: error: 'VMEMMAP_END' undeclared (first use in this function); did you mean 'MEMREMAP_ENC'?
15 |         vmcoreinfo_append_str("NUMBER(VMEMMAP_END)=0x%lx\n", VMEMMAP_END);
   |                                                              ^~~~~~~~~~~
   |                                                              MEMREMAP_ENC
arch/riscv/kernel/crash_core.c:17:64: error: 'MODULES_VADDR' undeclared (first use in this function)
17 |         vmcoreinfo_append_str("NUMBER(MODULES_VADDR)=0x%lx\n", MODULES_VADDR);
   |                                                                ^~~~~~~~~~~~~
arch/riscv/kernel/crash_core.c:18:62: error: 'MODULES_END' undeclared (first use in this function)
18 |         vmcoreinfo_append_str("NUMBER(MODULES_END)=0x%lx\n", MODULES_END);
-------------------------------------------------------------------------------------------------

Currently, riscv's ARCH_SUPPORTS_KEXEC has dependency on MMU. Before
dropping ARCH_SUPPORTS_KEXEC, disabling CONFIG_MMU will unset
CONFIG_CRASH_DUMP, CONFIG_KEXEC_CORE, CONFIG_CRASH_CORE. Hence
crash_core related codes won't be compiled.

---------------------
arch/riscv/Kconfig:
config ARCH_SUPPORTS_KEXEC
        def_bool MMU
---------------------

After dropping ARCH_SUPPORTS_KEXEC, CONFIG_CRASH_DUMP, CONFIG_KEXEC_CORE,
CONFIG_CRASH_CORE can be set independently of CONFIG_MMU. However, there
are several macro definitions, such as VA_BITS, VMEMMAP_START, VMEMMAP_END,
MODULES_VADDR, MODULES_END are only available when CONFIG_MMU=y. Then
compiling errors are triggered.

Here, add CONFIG_MMU ifdeffery in arch_crash_save_vmcoreinfo() to export
those symbols when CONFIG_MMU is enabled.

Link: https://lkml.kernel.org/r/ZW03ODUKGGhP1ZGU@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/kernel/crash_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/riscv/kernel/crash_core.c~kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-1
+++ a/arch/riscv/kernel/crash_core.c
@@ -5,18 +5,20 @@
 
 void arch_crash_save_vmcoreinfo(void)
 {
-	VMCOREINFO_NUMBER(VA_BITS);
 	VMCOREINFO_NUMBER(phys_ram_base);
 
 	vmcoreinfo_append_str("NUMBER(PAGE_OFFSET)=0x%lx\n", PAGE_OFFSET);
 	vmcoreinfo_append_str("NUMBER(VMALLOC_START)=0x%lx\n", VMALLOC_START);
 	vmcoreinfo_append_str("NUMBER(VMALLOC_END)=0x%lx\n", VMALLOC_END);
+#ifdef CONFIG_MMU
+	VMCOREINFO_NUMBER(VA_BITS);
 	vmcoreinfo_append_str("NUMBER(VMEMMAP_START)=0x%lx\n", VMEMMAP_START);
 	vmcoreinfo_append_str("NUMBER(VMEMMAP_END)=0x%lx\n", VMEMMAP_END);
 #ifdef CONFIG_64BIT
 	vmcoreinfo_append_str("NUMBER(MODULES_VADDR)=0x%lx\n", MODULES_VADDR);
 	vmcoreinfo_append_str("NUMBER(MODULES_END)=0x%lx\n", MODULES_END);
 #endif
+#endif
 	vmcoreinfo_append_str("NUMBER(KERNEL_LINK_ADDR)=0x%lx\n", KERNEL_LINK_ADDR);
 	vmcoreinfo_append_str("NUMBER(va_kernel_pa_offset)=0x%lx\n",
 						kernel_map.va_kernel_pa_offset);
_

Patches currently in -mm which might be from bhe@redhat.com are

drivers-base-cpu-crash-data-showing-should-depends-on-kexec_core.patch
kernel-kconfigkexec-drop-select-of-kexec-for-crash_dump.patch
kexec_core-change-dependency-of-object-files.patch
kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-1.patch
kexec-drop-dependency-on-arch_supports_kexec-from-crash_dump-fix-2.patch
resource-add-walk_system_ram_res_rev.patch
kexec_file-load-kernel-at-top-of-system-ram-if-required.patch
kexec_file-add-kexec_file-flag-to-control-debug-printing.patch
kexec_file-print-out-debugging-message-if-required.patch
kexec_file-x86-print-out-debugging-message-if-required.patch
kexec_file-arm64-print-out-debugging-message-if-required.patch
kexec_file-ricv-print-out-debugging-message-if-required.patch
kexec_file-power-print-out-debugging-message-if-required.patch
kexec_file-parisc-print-out-debugging-message-if-required.patch
riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch

