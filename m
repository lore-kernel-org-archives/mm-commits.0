From: akpm@linux-foundation.org
Subject: + mm-new-arch_remap-hook.patch added to -mm tree
Date: Thu, 23 Apr 2015 15:29:11 -0700
Message-ID: <55397237.3M4beKdiLyrZ+DGq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031118AbbDWW3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Apr 2015 18:29:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldufour@linux.vnet.ibm.com, benh@kernel.crashing.org, hughd@google.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mingo@kernel.org, mpe@ellerman.id.au, paulus@samba.org, riel@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: new arch_remap() hook
has been added to the -mm tree.  Its filename is
     mm-new-arch_remap-hook.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-new-arch_remap-hook.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-new-arch_remap-hook.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: mm: new arch_remap() hook

Some architectures would like to be triggered when a memory area is moved
through the mremap system call.

This patch introduces a new arch_remap() mm hook which is placed in the
path of mremap, and is called before the old area is unmapped (and the
arch_unmap() hook is called).

Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm-arch-hooks.h |    9 +++++++++
 mm/mremap.c                   |   17 +++++++++++------
 2 files changed, 20 insertions(+), 6 deletions(-)

diff -puN include/linux/mm-arch-hooks.h~mm-new-arch_remap-hook include/linux/mm-arch-hooks.h
--- a/include/linux/mm-arch-hooks.h~mm-new-arch_remap-hook
+++ a/include/linux/mm-arch-hooks.h
@@ -13,4 +13,13 @@
 
 #include <asm/mm-arch-hooks.h>
 
+#ifndef arch_remap
+static inline void arch_remap(struct mm_struct *mm,
+			      unsigned long old_start, unsigned long old_end,
+			      unsigned long new_start, unsigned long new_end)
+{
+}
+#define arch_remap arch_remap
+#endif
+
 #endif /* _LINUX_MM_ARCH_HOOKS_H */
diff -puN mm/mremap.c~mm-new-arch_remap-hook mm/mremap.c
--- a/mm/mremap.c~mm-new-arch_remap-hook
+++ a/mm/mremap.c
@@ -22,6 +22,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/sched/sysctl.h>
 #include <linux/uaccess.h>
+#include <linux/mm-arch-hooks.h>
 
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
@@ -286,13 +287,17 @@ static unsigned long move_vma(struct vm_
 		old_len = new_len;
 		old_addr = new_addr;
 		new_addr = -ENOMEM;
-	} else if (vma->vm_file && vma->vm_file->f_op->mremap) {
-		err = vma->vm_file->f_op->mremap(vma->vm_file, new_vma);
-		if (err < 0) {
-			move_page_tables(new_vma, new_addr, vma, old_addr,
-					 moved_len, true);
-			return err;
+	} else {
+		if (vma->vm_file && vma->vm_file->f_op->mremap) {
+			err = vma->vm_file->f_op->mremap(vma->vm_file, new_vma);
+			if (err < 0) {
+				move_page_tables(new_vma, new_addr, vma,
+						 old_addr, moved_len, true);
+				return err;
+			}
 		}
+		arch_remap(mm, old_addr, old_addr + old_len,
+			   new_addr, new_addr + new_len);
 	}
 
 	/* Conceal VM_ACCOUNT so old reservation is not undone */
_

Patches currently in -mm which might be from ldufour@linux.vnet.ibm.com are

mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch

