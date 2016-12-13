From: akpm@linux-foundation.org
Subject: [patch 075/123] mm: mark all calls into the vmalloc subsystem as
 potentially sleeping
Date: Mon, 12 Dec 2016 16:44:20 -0800
Message-ID: <584f4464.OpwznYm6MDDRdm/M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41474 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753006AbcLMAoV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:44:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de, aryabinin@virtuozzo.com, chris@chris-wilson.co.uk, hpa@zytor.com, joaodias@google.com, joelaf@google.com, jszhang@marvell.com, mingo@elte.hu, tglx@linutronix.de

From: Christoph Hellwig <hch@lst.de>
Subject: mm: mark all calls into the vmalloc subsystem as potentially sleeping

We will take a sleeping lock in later in this series, so this adds the
proper safeguards.

Link: http://lkml.kernel.org/r/1479474236-4139-9-git-send-email-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jisheng Zhang <jszhang@marvell.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: John Dias <joaodias@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-mark-all-calls-into-the-vmalloc-subsystem-as-potentially-sleeping mm/vmalloc.c
--- a/mm/vmalloc.c~mm-mark-all-calls-into-the-vmalloc-subsystem-as-potentially-sleeping
+++ a/mm/vmalloc.c
@@ -365,7 +365,7 @@ static struct vmap_area *alloc_vmap_area
 	BUG_ON(offset_in_page(size));
 	BUG_ON(!is_power_of_2(align));
 
-	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
+	might_sleep();
 
 	va = kmalloc_node(sizeof(struct vmap_area),
 			gfp_mask & GFP_RECLAIM_MASK, node);
@@ -1037,6 +1037,8 @@ void vm_unmap_aliases(void)
 	if (unlikely(!vmap_initialized))
 		return;
 
+	might_sleep();
+
 	for_each_possible_cpu(cpu) {
 		struct vmap_block_queue *vbq = &per_cpu(vmap_block_queue, cpu);
 		struct vmap_block *vb;
@@ -1080,6 +1082,7 @@ void vm_unmap_ram(const void *mem, unsig
 	unsigned long addr = (unsigned long)mem;
 	struct vmap_area *va;
 
+	might_sleep();
 	BUG_ON(!addr);
 	BUG_ON(addr < VMALLOC_START);
 	BUG_ON(addr > VMALLOC_END);
@@ -1431,6 +1434,8 @@ struct vm_struct *remove_vm_area(const v
 {
 	struct vmap_area *va;
 
+	might_sleep();
+
 	va = find_vmap_area((unsigned long)addr);
 	if (va && va->flags & VM_VM_AREA) {
 		struct vm_struct *vm = va->vm;
_
