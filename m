From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:18 -0800
Message-ID: <5283e33a.RR2E3fIR8MSswrT4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3KMUiT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, rientjes@google.com, mitsuo.hayasaka.hu@hitachi.com, kosaki.motohiro@jp.fujitsu.com, iamjoonsoo.kim@lge.com, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,iamjoonsoo.kim@lge.com,kosaki.motohiro@jp.fujitsu.com,mitsuo.hayasaka.hu@hitachi.com,rientjes@google.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:18 -0800


The patch titled
     Subject: mm/vmalloc: fix show vmap_area information race with vmap_area tear down
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/vmalloc: fix show vmap_area information race with vmap_area tear down

There is a race window between vmap_area tear down and show vmap_area
information.

	A                                                B

remove_vm_area
spin_lock(&vmap_area_lock);
va->vm = NULL;
va->flags &= ~VM_VM_AREA;
spin_unlock(&vmap_area_lock);
						spin_lock(&vmap_area_lock);
						if (va->flags & (VM_LAZY_FREE | VM_LAZY_FREEZING))
							return 0;
						if (!(va->flags & VM_VM_AREA)) {
							seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
								(void *)va->va_start, (void *)va->va_end,
								va->va_end - va->va_start);
							return 0;
						}
free_unmap_vmap_area(va);
	flush_cache_vunmap
	free_unmap_vmap_area_noflush
		unmap_vmap_area
		free_vmap_area_noflush
			va->flags |= VM_LAZY_FREE

The assumption !VM_VM_AREA represents vm_map_ram allocation is introduced
by d4033afd ("mm, vmalloc: iterate vmap_area_list, instead of vmlist, in
vmallocinfo()").  However, !VM_VM_AREA also represents vmap_area is being
tear down in race window mentioned above.  This patch fix it by don't dump
any information for !VM_VM_AREA case and also remove (VM_LAZY_FREE |
VM_LAZY_FREEING) check since they are not possible for !VM_VM_AREA case.

Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down
+++ a/mm/vmalloc.c
@@ -2578,16 +2578,13 @@ static int s_show(struct seq_file *m, vo
 	struct vmap_area *va = p;
 	struct vm_struct *v;
 
-	if (va->flags & (VM_LAZY_FREE | VM_LAZY_FREEING))
+	/*
+	 * s_show can encounter race with remove_vm_area, !VM_VM_AREA on
+	 * behalf of vmap area is being tear down or vm_map_ram allocation.
+	 */
+	if (!(va->flags & VM_VM_AREA))
 		return 0;
 
-	if (!(va->flags & VM_VM_AREA)) {
-		seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
-			(void *)va->va_start, (void *)va->va_end,
-					va->va_end - va->va_start);
-		return 0;
-	}
