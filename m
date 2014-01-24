From: akpm@linux-foundation.org
Subject: [merged] mm-ignore-vm_softdirty-on-vma-merging.patch removed from -mm tree
Date: Fri, 24 Jan 2014 10:59:51 -0800
Message-ID: <52e2b827.zzBLr/uGJ0xLwU8x%akpm__48681.3335017816$1390590006$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, stable@vger.kernel.org, mgorman@suse.de, gorcunov@openvz.org, gnome@rvzt.net, gorcunov@gmail.com

Subject: [merged] mm-ignore-vm_softdirty-on-vma-merging.patch removed from -mm tree
To: gorcunov@gmail.com,gnome@rvzt.net,gorcunov@openvz.org,mgorman@suse.de,stable@vger.kernel.org,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:51 -0800


The patch titled
     Subject: mm: ignore VM_SOFTDIRTY on VMA merging
has been removed from the -mm tree.  Its filename was
     mm-ignore-vm_softdirty-on-vma-merging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: mm: ignore VM_SOFTDIRTY on VMA merging

The VM_SOFTDIRTY bit affects vma merge routine: if two VMAs has all bits
in vm_flags matched except dirty bit the kernel can't longer merge them
and this forces the kernel to generate new VMAs instead.

It finally may lead to the situation when userspace application reaches
vm.max_map_count limit and get crashed in worse case

 | (gimp:11768): GLib-ERROR **: gmem.c:110: failed to allocate 4096 bytes
 |
 | (file-tiff-load:12038): LibGimpBase-WARNING **: file-tiff-load: gimp_wire_read(): error
 | xinit: connection to X server lost
 |
 | waiting for X server to shut down
 | /usr/lib64/gimp/2.0/plug-ins/file-tiff-load terminated: Hangup
 | /usr/lib64/gimp/2.0/plug-ins/script-fu terminated: Hangup
 | /usr/lib64/gimp/2.0/plug-ins/script-fu terminated: Hangup

https://bugzilla.kernel.org/show_bug.cgi?id=67651
https://bugzilla.gnome.org/show_bug.cgi?id=719619#c0

Initial problem came from missed VM_SOFTDIRTY in do_brk() routine but even
if we would set up VM_SOFTDIRTY here, there is still a way to prevent VMAs
from merging: one can call

 | echo 4 > /proc/$PID/clear_refs

and clear all VM_SOFTDIRTY over all VMAs presented in memory map, then new
do_brk() will try to extend old VMA and finds that dirty bit doesn't match
thus new VMA will be generated.

As discussed with Pavel, the right approach should be to ignore
VM_SOFTDIRTY bit when we're trying to merge VMAs and if merge successed we
mark extended VMA with dirty bit where needed.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reported-by: Bastian Hougaard <gnome@rvzt.net>
Reported-by: Mel Gorman <mgorman@suse.de>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mm-ignore-vm_softdirty-on-vma-merging mm/mmap.c
--- a/mm/mmap.c~mm-ignore-vm_softdirty-on-vma-merging
+++ a/mm/mmap.c
@@ -894,7 +894,15 @@ again:			remove_next = 1 + (end > next->
 static inline int is_mergeable_vma(struct vm_area_struct *vma,
 			struct file *file, unsigned long vm_flags)
 {
-	if (vma->vm_flags ^ vm_flags)
+	/*
+	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
+	 * match the flags but dirty bit -- the caller should mark
+	 * merged VMA as dirty. If dirty bit won't be excluded from
+	 * comparison, we increase pressue on the memory system forcing
+	 * the kernel to generate new VMAs when old one could be
+	 * extended instead.
+	 */
+	if ((vma->vm_flags ^ vm_flags) & ~VM_SOFTDIRTY)
 		return 0;
 	if (vma->vm_file != file)
 		return 0;
@@ -1083,7 +1091,7 @@ static int anon_vma_compatible(struct vm
 	return a->vm_end == b->vm_start &&
 		mpol_equal(vma_policy(a), vma_policy(b)) &&
 		a->vm_file == b->vm_file &&
-		!((a->vm_flags ^ b->vm_flags) & ~(VM_READ|VM_WRITE|VM_EXEC)) &&
+		!((a->vm_flags ^ b->vm_flags) & ~(VM_READ|VM_WRITE|VM_EXEC|VM_SOFTDIRTY)) &&
 		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
 }
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch

