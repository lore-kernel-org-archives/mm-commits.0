From: akpm@linux-foundation.org
Subject: [patch 020/115] vmalloc: show lazy-purged vma info in
 vmallocinfo
Date: Mon, 10 Jul 2017 15:48:09 -0700
Message-ID: <20170710224809.FocV52-fE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42184 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755038AbdGJWsP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:48:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guohanjun@huawei.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com, torvalds@linux-foundation.org, xieyisheng1@huawei.com, zijun_hu@htc.com

From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: vmalloc: show lazy-purged vma info in vmallocinfo

When ioremap a 67112960 bytes vm_area with the vmallocinfo:
 [..]
 0xec79b000-0xec7fa000  389120 ftl_add_mtd+0x4d0/0x754 pages=94 vmalloc
 0xec800000-0xecbe1000 4067328 kbox_proc_mem_write+0x104/0x1c4 phys=8b520000 ioremap

we get the result:
 0xf1000000-0xf5001000 67112960 devm_ioremap+0x38/0x7c phys=40000000 ioremap

For the align for ioremap must be less than '1 << IOREMAP_MAX_ORDER':
	if (flags & VM_IOREMAP)
		align = 1ul << clamp_t(int, get_count_order_long(size),
			PAGE_SHIFT, IOREMAP_MAX_ORDER);

So it makes idiot like me a litte puzzled why this was a jump the vm_area from

0xec800000-0xecbe1000 to 0xf1000000-0xf5001000, and leaving
0xed000000-0xf1000000 as a big hole.

This patch is to show all of vm_area, including vmas which are freeing but
still in the vmap_area_list, to make it more clear about why we will get
0xf1000000-0xf5001000 in the above case.  And we will get a vmallocinfo
like:

 [..]
 0xec79b000-0xec7fa000  389120 ftl_add_mtd+0x4d0/0x754 pages=94 vmalloc
 0xec800000-0xecbe1000 4067328 kbox_proc_mem_write+0x104/0x1c4 phys=8b520000 ioremap
 [..]
 0xece7c000-0xece7e000    8192 unpurged vm_area
 0xece7e000-0xece83000   20480 vm_map_ram
 0xf0099000-0xf00aa000   69632 vm_map_ram
after apply this patch.

Link: http://lkml.kernel.org/r/1496649682-20710-1-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: zijun_hu <zijun_hu@htc.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/vmalloc.c~vmalloc-show-more-detail-info-in-vmallocinfo-for-clarify mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-show-more-detail-info-in-vmallocinfo-for-clarify
+++ a/mm/vmalloc.c
@@ -325,6 +325,7 @@ EXPORT_SYMBOL(vmalloc_to_pfn);
 
 /*** Global kva allocator ***/
 
+#define VM_LAZY_FREE	0x02
 #define VM_VM_AREA	0x04
 
 static DEFINE_SPINLOCK(vmap_area_lock);
@@ -1497,6 +1498,7 @@ struct vm_struct *remove_vm_area(const v
 		spin_lock(&vmap_area_lock);
 		va->vm = NULL;
 		va->flags &= ~VM_VM_AREA;
+		va->flags |= VM_LAZY_FREE;
 		spin_unlock(&vmap_area_lock);
 
 		vmap_debug_free_range(va->va_start, va->va_end);
@@ -2704,8 +2706,14 @@ static int s_show(struct seq_file *m, vo
 	 * s_show can encounter race with remove_vm_area, !VM_VM_AREA on
 	 * behalf of vmap area is being tear down or vm_map_ram allocation.
 	 */
-	if (!(va->flags & VM_VM_AREA))
+	if (!(va->flags & VM_VM_AREA)) {
+		seq_printf(m, "0x%pK-0x%pK %7ld %s\n",
+			(void *)va->va_start, (void *)va->va_end,
+			va->va_end - va->va_start,
+			va->flags & VM_LAZY_FREE ? "unpurged vm_area" : "vm_map_ram");
+
 		return 0;
+	}
 
 	v = va->vm;
 
_
