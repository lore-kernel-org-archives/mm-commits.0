From: akpm@linux-foundation.org
Subject: - make-mm-memoryc-print_bad_pte-static.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:18:16 -0700
Message-ID: <200807262118.m6QLIGqn020076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758034AbYGZVS0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:18:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     make mm/memory.c:print_bad_pte() static
has been removed from the -mm tree.  Its filename was
     make-mm-memoryc-print_bad_pte-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make mm/memory.c:print_bad_pte() static
From: Adrian Bunk <bunk@kernel.org>

This patch makes the needlessly global print_bad_pte() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/memory.c        |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~make-mm-memoryc-print_bad_pte-static include/linux/mm.h
--- a/include/linux/mm.h~make-mm-memoryc-print_bad_pte-static
+++ a/include/linux/mm.h
@@ -810,7 +810,6 @@ extern int access_process_vm(struct task
 
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm, unsigned long start,
 		int len, int write, int force, struct page **pages, struct vm_area_struct **vmas);
-void print_bad_pte(struct vm_area_struct *, pte_t, unsigned long);
 
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned long offset);
diff -puN mm/memory.c~make-mm-memoryc-print_bad_pte-static mm/memory.c
--- a/mm/memory.c~make-mm-memoryc-print_bad_pte-static
+++ a/mm/memory.c
@@ -374,7 +374,8 @@ static inline void add_mm_rss(struct mm_
  *
  * The calling function must still handle the error.
  */
-void print_bad_pte(struct vm_area_struct *vma, pte_t pte, unsigned long vaddr)
+static void print_bad_pte(struct vm_area_struct *vma, pte_t pte,
+			  unsigned long vaddr)
 {
 	printk(KERN_ERR "Bad pte = %08llx, process = %s, "
 			"vm_flags = %lx, vaddr = %lx\n",
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

