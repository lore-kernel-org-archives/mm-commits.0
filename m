From: akpm@linux-foundation.org
Subject: + vmalloc-make-find_vm_area-check-in-range.patch added to -mm
 tree
Date: Thu, 23 May 2013 15:25:04 -0700
Message-ID: <519e9740.gn9b9sQ78juDxKwL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759761Ab3EWWZP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 18:25:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vgoyal@redhat.com, lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp, kosaki.motohiro@jp.fujitsu.com, d.hatayama@jp.fujitsu.com

Subject: + vmalloc-make-find_vm_area-check-in-range.patch added to -mm tree
To: d.hatayama@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,kumagai-atsushi@mxc.nes.nec.co.jp,lisa.mitchell@hp.com,vgoyal@redhat.com,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 15:25:04 -0700


The patch titled
     Subject: vmalloc: make find_vm_area check in range
has been added to the -mm tree.  Its filename is
     vmalloc-make-find_vm_area-check-in-range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmalloc: make find_vm_area check in range

Currently, __find_vmap_area searches for the kernel VM area starting at a
given address.  This patch changes this behavior so that it searches for
the kernel VM area to which the address belongs.  This change is needed by
remap_vmalloc_range_partial to be introduced in later patch that receives
any position of kernel VM area as target address.

This patch changes the condition (addr > va->va_start) to the equivalent
(addr >= va->va_end) by taking advantage of the fact that each kernel VM
area is non-overlapping.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: Lisa Mitchell <lisa.mitchell@hp.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~vmalloc-make-find_vm_area-check-in-range mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-make-find_vm_area-check-in-range
+++ a/mm/vmalloc.c
@@ -292,7 +292,7 @@ static struct vmap_area *__find_vmap_are
 		va = rb_entry(n, struct vmap_area, rb_node);
 		if (addr < va->va_start)
 			n = n->rb_left;
-		else if (addr > va->va_start)
+		else if (addr >= va->va_end)
 			n = n->rb_right;
 		else
 			return va;
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

include-linux-mmh-add-page_aligned-helper.patch
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

