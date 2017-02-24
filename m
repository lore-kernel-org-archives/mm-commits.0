From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix.patch removed
 from -mm tree
Date: Fri, 24 Feb 2017 14:36:41 -0800
Message-ID: <58b0b579.Rj9KgNR1VRdLon/q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33816 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbdBXWgn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:36:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix.patch

This patch was dropped because it was folded into userfaultfd-non-cooperative-add-event-for-memory-unmaps.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix

This breaks compilation on nommu configs.
mm/nommu.c:1201:15: error: conflicting types for 'do_mmap'
 unsigned long do_mmap(struct file *file,
               ^
In file included from mm/nommu.c:19:0:
./include/linux/mm.h:2089:22: note: previous declaration of 'do_mmap' was here
 extern unsigned long do_mmap(struct file *file, unsigned long addr,
                      ^
mm/nommu.c:1580:5: error: conflicting types for 'do_munmap'
 int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
     ^
In file included from mm/nommu.c:19:0:
./include/linux/mm.h:2093:12: note: previous declaration of 'do_munmap' was here
 extern int do_munmap(struct mm_struct *, unsigned long, size_t,
            ^
make[1]: *** [mm/nommu.o] Error 1

CONFIG_USERFAULTFD depends on CONFIG_MMU so I guess we are OK to just ignore the
argument.

Link: http://lkml.kernel.org/r/20170202091503.GA22823@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/nommu.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix mm/nommu.c
--- a/mm/nommu.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix
+++ a/mm/nommu.c
@@ -1205,7 +1205,8 @@ unsigned long do_mmap(struct file *file,
 			unsigned long flags,
 			vm_flags_t vm_flags,
 			unsigned long pgoff,
-			unsigned long *populate)
+			unsigned long *populate,
+			struct list_head *uf_unused)
 {
 	struct vm_area_struct *vma;
 	struct vm_region *region;
@@ -1577,7 +1578,7 @@ static int shrink_vma(struct mm_struct *
  * - under NOMMU conditions the chunk to be unmapped must be backed by a single
  *   VMA, though it need not cover the whole VMA
  */
-int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
+int do_munmap(struct mm_struct *mm, unsigned long start, size_t len, struct list_head *uf)
 {
 	struct vm_area_struct *vma;
 	unsigned long end;
@@ -1643,7 +1644,7 @@ int vm_munmap(unsigned long addr, size_t
 	int ret;
 
 	down_write(&mm->mmap_sem);
-	ret = do_munmap(mm, addr, len);
+	ret = do_munmap(mm, addr, len, NULL);
 	up_write(&mm->mmap_sem);
 	return ret;
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-page_alloc-do-not-depend-on-cpu-hotplug-locks-inside-the-allocator.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps.patch
vmalloc-back-of-when-the-current-is-killed.patch

