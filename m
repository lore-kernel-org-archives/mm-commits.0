From: akpm@linux-foundation.org
Subject: + kexec-introduce-bootmem_exclusive-fix.patch added to -mm tree
Date: Sun, 21 Oct 2007 15:31:59 -0700
Message-ID: <200710212238.l9LMcSpS030702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51004 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872AbXJUWie (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 18:38:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bwalle@suse.de


The patch titled
     kexec-introduce-bootmem_exclusive-fix
has been added to the -mm tree.  Its filename is
     kexec-introduce-bootmem_exclusive-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kexec-introduce-bootmem_exclusive-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/mpparse_32.c~kexec-introduce-bootmem_exclusive-fix arch/x86/kernel/mpparse_32.c
diff -puN arch/x86/kernel/setup_32.c~kexec-introduce-bootmem_exclusive-fix arch/x86/kernel/setup_32.c
diff -puN arch/x86/kernel/setup_64.c~kexec-introduce-bootmem_exclusive-fix arch/x86/kernel/setup_64.c
diff -puN include/linux/bootmem.h~kexec-introduce-bootmem_exclusive-fix include/linux/bootmem.h
diff -puN mm/bootmem.c~kexec-introduce-bootmem_exclusive-fix mm/bootmem.c
diff -puN arch/x86/mm/init_64.c~kexec-introduce-bootmem_exclusive-fix arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~kexec-introduce-bootmem_exclusive-fix
+++ a/arch/x86/mm/init_64.c
@@ -652,7 +652,7 @@ void __init reserve_bootmem_generic(unsi
 #ifdef CONFIG_NUMA
   	reserve_bootmem_node(NODE_DATA(nid), phys, len);
 #else       		
-	reserve_bootmem(phys, len);    
+	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
 #endif
 	if (phys+len <= MAX_DMA_PFN*PAGE_SIZE) {
 		dma_reserve += len / PAGE_SIZE;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic.patch
capabilities-clean-up-file-capability-reading.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
kexec-add-bss-to-resource-tree.patch
kexec-introduce-bootmem_exclusive.patch
kexec-introduce-bootmem_exclusive-fix.patch
