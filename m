From: akpm@linux-foundation.org
Subject: [merged]
 mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:48:55 -0700
Message-ID: <5390c9a7.x2p5X0hC+/h/mvbk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaFETs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:48:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, n-horiguchi@ah.jp.nec.com, hughd@google.com, gorcunov@openvz.org

Subject: [merged] mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch removed from -mm tree
To: gorcunov@openvz.org,hughd@google.com,n-horiguchi@ah.jp.nec.com,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:48:55 -0700


The patch titled
     Subject: mm: softdirty: clear VM_SOFTDIRTY flag inside clear_refs_write() instead of clear_soft_dirty()
has been removed from the -mm tree.  Its filename was
     mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: mm: softdirty: clear VM_SOFTDIRTY flag inside clear_refs_write() instead of clear_soft_dirty()

clear_refs_write() is called earlier than clear_soft_dirty() and it is
more natural to clear VM_SOFTDIRTY (which belongs to VMA entry but not
PTEs) that early instead of clearing it a way deeper inside call chain.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty
+++ a/fs/proc/task_mmu.c
@@ -737,9 +737,6 @@ static inline void clear_soft_dirty(stru
 		ptent = pte_file_clear_soft_dirty(ptent);
 	}
 
-	if (vma->vm_flags & VM_SOFTDIRTY)
-		vma->vm_flags &= ~VM_SOFTDIRTY;
-
 	set_pte_at(vma->vm_mm, addr, pte, ptent);
 #endif
 }
@@ -807,8 +804,9 @@ static ssize_t clear_refs_write(struct f
 
 	if (type == CLEAR_REFS_SOFT_DIRTY) {
 		soft_dirty_cleared = true;
-		pr_warn_once("The pagemap bits 55-60 has changed their meaning! "
-				"See the linux/Documentation/vm/pagemap.txt for details.\n");
+		pr_warn_once("The pagemap bits 55-60 has changed their meaning!"
+			     " See the linux/Documentation/vm/pagemap.txt for "
+			     "details.\n");
 	}
 
 	task = get_proc_task(file_inode(file));
@@ -839,11 +837,17 @@ static ssize_t clear_refs_write(struct f
 			 *
 			 * Writing 3 to /proc/pid/clear_refs only affects file
 			 * mapped pages.
+			 *
+			 * Writing 4 to /proc/pid/clear_refs affects all pages.
 			 */
 			if (type == CLEAR_REFS_ANON && vma->vm_file)
 				continue;
 			if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
 				continue;
+			if (type == CLEAR_REFS_SOFT_DIRTY) {
+				if (vma->vm_flags & VM_SOFTDIRTY)
+					vma->vm_flags &= ~VM_SOFTDIRTY;
+			}
 			walk_page_range(vma->vm_start, vma->vm_end,
 					&clear_refs_walk);
 		}
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch

