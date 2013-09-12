From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:07 -0700
Message-ID: <523219c3.H/+wAN7sHUHkYLiS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab3ILTpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rientjes@google.com, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, jkosina@suse.cz, isimatu.yasuaki@jp.fujitsu.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, fengguang.wu@intel.com, dave.hansen@linux.intel.com, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,dave.hansen@linux.intel.com,fengguang.wu@intel.com,hannes@cmpxchg.org,iamjoonsoo.kim@lge.com,isimatu.yasuaki@jp.fujitsu.com,jkosina@suse.cz,kosaki.motohiro@jp.fujitsu.com,riel@redhat.com,rientjes@google.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:07 -0700


The patch titled
     Subject: mm/vmalloc: use wrapper function get_vm_area_size to caculate size of vm area
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/vmalloc: use wrapper function get_vm_area_size to caculate size of vm area

Use wrapper function get_vm_area_size to calculate size of vm area.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area
+++ a/mm/vmalloc.c
@@ -1258,7 +1258,7 @@ void unmap_kernel_range(unsigned long ad
 int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page ***pages)
 {
 	unsigned long addr = (unsigned long)area->addr;
-	unsigned long end = addr + area->size - PAGE_SIZE;
+	unsigned long end = addr + get_vm_area_size(area);
 	int err;
 
 	err = vmap_page_range(addr, end, prot, *pages);
@@ -1553,7 +1553,7 @@ static void *__vmalloc_area_node(struct
 	unsigned int nr_pages, array_size, i;
 	gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
 
-	nr_pages = (area->size - PAGE_SIZE) >> PAGE_SHIFT;
+	nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
 
 	area->nr_pages = nr_pages;
@@ -1985,7 +1985,7 @@ long vread(char *buf, char *addr, unsign
 
 		vm = va->vm;
 		vaddr = (char *) vm->addr;
-		if (addr >= vaddr + vm->size - PAGE_SIZE)
+		if (addr >= vaddr + get_vm_area_size(vm))
 			continue;
 		while (addr < vaddr) {
 			if (count == 0)
@@ -1995,7 +1995,7 @@ long vread(char *buf, char *addr, unsign
 			addr++;
 			count--;
 		}
-		n = vaddr + vm->size - PAGE_SIZE - addr;
+		n = vaddr + get_vm_area_size(vm) - addr;
 		if (n > count)
 			n = count;
 		if (!(vm->flags & VM_IOREMAP))
@@ -2067,7 +2067,7 @@ long vwrite(char *buf, char *addr, unsig
 
 		vm = va->vm;
 		vaddr = (char *) vm->addr;
-		if (addr >= vaddr + vm->size - PAGE_SIZE)
+		if (addr >= vaddr + get_vm_area_size(vm))
 			continue;
 		while (addr < vaddr) {
 			if (count == 0)
@@ -2076,7 +2076,7 @@ long vwrite(char *buf, char *addr, unsig
 			addr++;
 			count--;
 		}
-		n = vaddr + vm->size - PAGE_SIZE - addr;
+		n = vaddr + get_vm_area_size(vm) - addr;
 		if (n > count)
 			n = count;
 		if (!(vm->flags & VM_IOREMAP)) {
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

