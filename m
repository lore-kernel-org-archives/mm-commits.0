From: akpm@linux-foundation.org
Subject: [merged] s390-remove-setting-for-saved_max_pfn.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:36:27 -0700
Message-ID: <51db14bb.N5iLlsDHFsqJLKqG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3GHTg2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, tony.luck@intel.com, schwidefsky@de.ibm.com, ralf@linux-mips.org, paulus@samba.org, matt.fleming@intel.com, hpa@zytor.com, holzheu@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, fenghua.yu@intel.com, ebiederm@xmission.com, dave@sr71.net, benh@kernel.crashing.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] s390-remove-setting-for-saved_max_pfn.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,benh@kernel.crashing.org,dave@sr71.net,ebiederm@xmission.com,fenghua.yu@intel.com,heiko.carstens@de.ibm.com,holzheu@linux.vnet.ibm.com,hpa@zytor.com,matt.fleming@intel.com,paulus@samba.org,ralf@linux-mips.org,schwidefsky@de.ibm.com,tony.luck@intel.com,vgoyal@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:27 -0700


The patch titled
     Subject: s390: remove setting for saved_max_pfn
has been removed from the -mm tree.  Its filename was
     s390-remove-setting-for-saved_max_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: s390: remove setting for saved_max_pfn

The only user of saved_max_pfn in s390 is read_oldmem interface but we
have removed that interface, so saved_max_pfn is now unneeded in s390, and
we needn't set it anymore.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/setup.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/s390/kernel/setup.c~s390-remove-setting-for-saved_max_pfn arch/s390/kernel/setup.c
--- a/arch/s390/kernel/setup.c~s390-remove-setting-for-saved_max_pfn
+++ a/arch/s390/kernel/setup.c
@@ -719,10 +719,6 @@ static void reserve_oldmem(void)
 	}
 	create_mem_hole(memory_chunk, OLDMEM_BASE, OLDMEM_SIZE);
 	create_mem_hole(memory_chunk, OLDMEM_SIZE, real_size - OLDMEM_SIZE);
-	if (OLDMEM_BASE + OLDMEM_SIZE == real_size)
-		saved_max_pfn = PFN_DOWN(OLDMEM_BASE) - 1;
-	else
-		saved_max_pfn = PFN_DOWN(real_size) - 1;
 #endif
 }
 
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

