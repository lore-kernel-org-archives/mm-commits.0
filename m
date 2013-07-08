From: akpm@linux-foundation.org
Subject: [merged] powerpc-remove-savemaxmem-parameter-setup.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:36:23 -0700
Message-ID: <51db14b7.n5QMcGATFY94yn3z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3GHTgY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, tony.luck@intel.com, schwidefsky@de.ibm.com, ralf@linux-mips.org, paulus@samba.org, matt.fleming@intel.com, hpa@zytor.com, holzheu@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, fenghua.yu@intel.com, ebiederm@xmission.com, dave@sr71.net, benh@kernel.crashing.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] powerpc-remove-savemaxmem-parameter-setup.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,benh@kernel.crashing.org,dave@sr71.net,ebiederm@xmission.com,fenghua.yu@intel.com,heiko.carstens@de.ibm.com,holzheu@linux.vnet.ibm.com,hpa@zytor.com,matt.fleming@intel.com,paulus@samba.org,ralf@linux-mips.org,schwidefsky@de.ibm.com,tony.luck@intel.com,vgoyal@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:23 -0700


The patch titled
     Subject: powerpc: Remove savemaxmem parameter setup
has been removed from the -mm tree.  Its filename was
     powerpc-remove-savemaxmem-parameter-setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: powerpc: Remove savemaxmem parameter setup

saved_max_pfn is used to know the amount of memory that the previous
kernel used.  And for powerpc, we set saved_max_pfn by passing the kernel
commandline parameter "savemaxmem=".

The only user of saved_max_pfn in powerpc is read_oldmem interface.  Since
we have removed read_oldmem, we don't need this parameter anymore.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/crash_dump.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN arch/powerpc/kernel/crash_dump.c~powerpc-remove-savemaxmem-parameter-setup arch/powerpc/kernel/crash_dump.c
--- a/arch/powerpc/kernel/crash_dump.c~powerpc-remove-savemaxmem-parameter-setup
+++ a/arch/powerpc/kernel/crash_dump.c
@@ -69,16 +69,6 @@ void __init setup_kdump_trampoline(void)
 }
 #endif /* CONFIG_NONSTATIC_KERNEL */
 
-static int __init parse_savemaxmem(char *p)
-{
-	if (p)
-		saved_max_pfn = (memparse(p, &p) >> PAGE_SHIFT) - 1;
-
-	return 1;
-}
-__setup("savemaxmem=", parse_savemaxmem);
-
-
 static size_t copy_oldmem_vaddr(void *vaddr, char *buf, size_t csize,
                                unsigned long offset, int userbuf)
 {
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
linux-next.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch
mm-vmallocc-unbreak-__vunmap.patch
mm-vmallocc-remove-dead-code-in-vb_alloc.patch
mm-vmallocc-remove-unused-purge_fragmented_blocks_thiscpu.patch
mm-vmallocc-remove-alloc_map-from-vmap_block.patch
mm-vmallocc-emit-the-failure-message-before-return.patch
mm-vmallocc-rename-vm_unlist-to-vm_uninitialized.patch
mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
include-linux-gfph-fix-the-comment-for-gfp_zone_table.patch
mm-remove-zone_type-argument-of-build_zonelists_node.patch
mm-remove-unused-functions-is_normal_idx-normal-dma32-dma.patch
mm-remove-unlikely-from-the-current_order-test.patch
mm-remove-unused-__put_page.patch
mm-sparsec-put-clear_hwpoisoned_pages-within-config_memory_hotremove.patch
mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd.patch
mm-vmallocc-fix-an-overflow-bug-in-alloc_vmap_area.patch

