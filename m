From: akpm@linux-foundation.org
Subject: [merged]
 documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:36:19 -0700
Message-ID: <51db14b3.yC/CIjm7i2xG0Tc9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab3GHTgU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, tony.luck@intel.com, schwidefsky@de.ibm.com, ralf@linux-mips.org, paulus@samba.org, matt.fleming@intel.com, hpa@zytor.com, holzheu@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, fenghua.yu@intel.com, ebiederm@xmission.com, dave@sr71.net, benh@kernel.crashing.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,benh@kernel.crashing.org,dave@sr71.net,ebiederm@xmission.com,fenghua.yu@intel.com,heiko.carstens@de.ibm.com,holzheu@linux.vnet.ibm.com,hpa@zytor.com,matt.fleming@intel.com,paulus@samba.org,ralf@linux-mips.org,schwidefsky@de.ibm.com,tony.luck@intel.com,vgoyal@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:19 -0700


The patch titled
     Subject: Documentation/kdump/kdump.txt: remove /dev/oldmem description
has been removed from the -mm tree.  Its filename was
     documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Documentation/kdump/kdump.txt: remove /dev/oldmem description

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |   31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff -puN Documentation/kdump/kdump.txt~documentation-kdump-kdumptxt-remove-dev-oldmem-description Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~documentation-kdump-kdumptxt-remove-dev-oldmem-description
+++ a/Documentation/kdump/kdump.txt
@@ -47,19 +47,12 @@ parameter. Optionally the size of the EL
 when using the elfcorehdr=[size[KMG]@]offset[KMG] syntax.
 
 
-With the dump-capture kernel, you can access the memory image, or "old
-memory," in two ways:
-
-- Through a /dev/oldmem device interface. A capture utility can read the
-  device file and write out the memory in raw format. This is a raw dump
-  of memory. Analysis and capture tools must be intelligent enough to
-  determine where to look for the right information.
-
-- Through /proc/vmcore. This exports the dump as an ELF-format file that
-  you can write out using file copy commands such as cp or scp. Further,
-  you can use analysis tools such as the GNU Debugger (GDB) and the Crash
-  tool to debug the dump file. This method ensures that the dump pages are
-  correctly ordered.
+With the dump-capture kernel, you can access the memory image through
+/proc/vmcore. This exports the dump as an ELF-format file that you can
+write out using file copy commands such as cp or scp. Further, you can
+use analysis tools such as the GNU Debugger (GDB) and the Crash tool to
+debug the dump file. This method ensures that the dump pages are correctly
+ordered.
 
 
 Setup and Installation
@@ -423,18 +416,6 @@ the following command:
 
    cp /proc/vmcore <dump-file>
 
-You can also access dumped memory as a /dev/oldmem device for a linear
-and raw view. To create the device, use the following command:
-
-    mknod /dev/oldmem c 1 12
-
-Use the dd command with suitable options for count, bs, and skip to
-access specific portions of the dump.
-
-To see the entire memory, use the following command:
-
-   dd if=/dev/oldmem of=oldmem.001
-
 
 Analysis
 ========
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

