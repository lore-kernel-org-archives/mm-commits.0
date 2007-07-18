From: akpm@linux-foundation.org
Subject: + vmalloc_32-should-use-gfp_kernel.patch added to -mm tree
Date: Wed, 18 Jul 2007 13:11:25 -0700
Message-ID: <200707182011.l6IKBPus026679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024AbXGRULo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 16:11:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, airlied@linux.ie, ak@suse.de


The patch titled
     vmalloc_32 should use GFP_KERNEL
has been added to the -mm tree.  Its filename is
     vmalloc_32-should-use-gfp_kernel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vmalloc_32 should use GFP_KERNEL
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

I've noticed lots of failures of vmalloc_32 on machines where it
shouldn't have failed unless it was doing an atomic operation.

Looking closely, I noticed that:

#if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
#define GFP_VMALLOC32 GFP_DMA32
#elif defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA)
#define GFP_VMALLOC32 GFP_DMA
#else
#define GFP_VMALLOC32 GFP_KERNEL
#endif

Which seems to be incorrect, it should always -or- in the DMA flags
on top of GFP_KERNEL, thus this patch.

This fixes frequent errors launchin X with the nouveau DRM for example.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~vmalloc_32-should-use-gfp_kernel mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc_32-should-use-gfp_kernel
+++ a/mm/vmalloc.c
@@ -583,9 +583,9 @@ void *vmalloc_exec(unsigned long size)
 }
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
-#define GFP_VMALLOC32 GFP_DMA32
+#define GFP_VMALLOC32 GFP_DMA32 | GFP_KERNEL
 #elif defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA)
-#define GFP_VMALLOC32 GFP_DMA
+#define GFP_VMALLOC32 GFP_DMA | GFP_KERNEL
 #else
 #define GFP_VMALLOC32 GFP_KERNEL
 #endif
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
i386-put-allocated-elf-notes-in-read-only-data-segment.patch
powerpc-put-allocated-elf-notes-in-read-only-data-segment.patch
add-sys-kernel-notes.patch
add-sys-kernel-notes-fix.patch
use-build-id-ld-option.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
vmalloc_32-should-use-gfp_kernel.patch
powerpc-tlb_32c-build-fix.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
git-libata-all.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
print-utsname-on-oops-on-all-architectures.patch
print-utsname-on-oops-on-all-architectures-fix.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
