From: akpm@linux-foundation.org
Subject: +
 mm-mark-all-calls-into-the-vmalloc-subsystem-as-potentially-sleeping.patch
 added to -mm tree
Date: Mon, 21 Nov 2016 22:11:33 -0800
Message-ID: <5833e195.4sIlDYYbE//+FOgf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57720 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbcKVGLf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 01:11:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, aryabinin@virtuozzo.com, chris@chris-wilson.co.uk, hpa@zytor.com, joaodias@google.com, joelaf@google.com, jszhang@marvell.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mark all calls into the vmalloc subsystem as potentially sleeping
has been added to the -mm tree.  Its filename is
     mm-mark-all-calls-into-the-vmalloc-subsystem-as-potentially-sleeping.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mark-all-calls-into-the-vmalloc-subsystem-as-potentially-sleeping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mark-all-calls-into-the-vmalloc-subsystem-as-potentially-sleeping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from hch@lst.de are

mm-remove-free_unmap_vmap_area_noflush.patch
mm-remove-free_unmap_vmap_area_addr.patch
mm-refactor-__purge_vmap_area_lazy.patch
mm-warn-about-vfree-from-atomic-context.patch
mm-mark-all-calls-into-the-vmalloc-subsystem-as-potentially-sleeping.patch
mm-turn-vmap_purge_lock-into-a-mutex.patch

