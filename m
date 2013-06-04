From: akpm@linux-foundation.org
Subject: +
 mm-vmalloc-only-call-setup_vmalloc_vm-only-in-__get_vm_area_node.patch
 added to -mm tree
Date: Tue, 04 Jun 2013 13:56:01 -0700
Message-ID: <51ae5461.hWI8mknByZ8BQyzC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab3FDU4C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jun 2013 16:56:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, iamjoonsoo.kim@lge.com, zhangyanfei@cn.fujitsu.com

Subject: + mm-vmalloc-only-call-setup_vmalloc_vm-only-in-__get_vm_area_node.patch added to -mm tree
To: zhangyanfei@cn.fujitsu.com,iamjoonsoo.kim@lge.com
From: akpm@linux-foundation.org
Date: Tue, 04 Jun 2013 13:56:01 -0700


The patch titled
     Subject: mm, vmalloc: only call setup_vmalloc_vm() only in __get_vm_area_node()
has been added to the -mm tree.  Its filename is
     mm-vmalloc-only-call-setup_vmalloc_vm-only-in-__get_vm_area_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm, vmalloc: only call setup_vmalloc_vm() only in __get_vm_area_node()

Now for insert_vmalloc_vm, it only calls the two functions:
- setup_vmalloc_vm: fill vm_struct and vmap_area instances
- clear_vm_unlist: clear VM_UNLIST bit in vm_struct->flags

So in __get_vm_area_node(), if VM_UNLIST bit unset in flags, that is the
else branch here, we don't need to clear VM_UNLIST bit for vm->flags since
this bit is obviously not set.  That is to say, we could only call
setup_vmalloc_vm instead of insert_vmalloc_vm here.  And then we could
even remove the if test here.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-only-call-setup_vmalloc_vm-only-in-__get_vm_area_node mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-only-call-setup_vmalloc_vm-only-in-__get_vm_area_node
+++ a/mm/vmalloc.c
@@ -1367,16 +1367,7 @@ static struct vm_struct *__get_vm_area_n
 		return NULL;
 	}
 
-	/*
-	 * When this function is called from __vmalloc_node_range,
-	 * we add VM_UNLIST flag to avoid accessing uninitialized
-	 * members of vm_struct such as pages and nr_pages fields.
-	 * They will be set later.
-	 */
-	if (flags & VM_UNLIST)
-		setup_vmalloc_vm(area, va, flags, caller);
-	else
-		insert_vmalloc_vm(area, va, flags, caller);
+	setup_vmalloc_vm(area, va, flags, caller);
 
 	return area;
 }
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

linux-next.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
vmcore-clean-up-read_vmcore.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmcore-treat-memory-chunks-referenced-by-pt_load-program-header-entries-in-page-size-boundary-in-vmcore_list.patch
vmalloc-make-find_vm_area-check-in-range.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-calculate-vmcore-file-size-from-buffer-size-and-total-size-of-vmcore-objects.patch
vmcore-support-mmap-on-proc-vmcore.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-vmalloc-only-call-setup_vmalloc_vm-only-in-__get_vm_area_node.patch
mm-vmalloc-call-setup_vmalloc_vm-instead-of-insert_vmalloc_vm.patch
mm-vmalloc-remove-insert_vmalloc_vm.patch
dev-oldmem-remove-the-interface.patch
dev-oldmem-remove-the-interface-fix.patch
documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch
mips-remove-savemaxmem-parameter-setup.patch
powerpc-remove-savemaxmem-parameter-setup.patch
ia64-remove-setting-for-saved_max_pfn.patch
s390-remove-setting-for-saved_max_pfn.patch

