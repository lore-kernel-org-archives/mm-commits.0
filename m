From: akpm@linux-foundation.org
Subject: +
 mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch added to -mm tree
Date: Wed, 18 Sep 2013 13:40:10 -0700
Message-ID: <523a0faa.t1Ruh0GhITDnvpuR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab3IRUkL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 16:40:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, iamjoonsoo.kim@lge.com, liwanp@linux.vnet.ibm.com

Subject: + mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,iamjoonsoo.kim@lge.com,kosaki.motohiro@jp.fujitsu.com,rientjes@google.com,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 13:40:10 -0700


The patch titled
     Subject: mm/vmalloc: fix show vmap_area information race with vmap_area tear down
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
by commit: d4033afd ("mm, vmalloc: iterate vmap_area_list, instead of
vmlist, in vmallocinfo()").  However, !VM_VM_AREA also represents vmap_area
is being tear down in race window mentioned above.

This patch fixes it by not dumping any information for !VM_VM_AREA case
and also remove (VM_LAZY_FREE | VM_LAZY_FREEING) check since they are not
possible for !VM_VM_AREA case.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down
+++ a/mm/vmalloc.c
@@ -2583,16 +2583,13 @@ static int s_show(struct seq_file *m, vo
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
