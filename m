From: akpm@linux-foundation.org
Subject: + mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch added to -mm tree
Date: Wed, 17 Dec 2014 13:13:24 -0800
Message-ID: <5491f1f4.IQQC+NsdfJTKLyvb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaLQVN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 16:13:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, koct9i@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-prevent-endless-growth-of-anon_vma-hierarchy-fix
has been added to the -mm tree.  Its filename is
     mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-prevent-endless-growth-of-anon_vma-hierarchy-fix

fix typo, per Rik

Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/rmap.c~mm-prevent-endless-growth-of-anon_vma-hierarchy-fix mm/rmap.c
--- a/mm/rmap.c~mm-prevent-endless-growth-of-anon_vma-hierarchy-fix
+++ a/mm/rmap.c
@@ -244,9 +244,10 @@ static inline void unlock_anon_vma_root(
  * If dst->anon_vma is NULL this function tries to find and reuse existing
  * anon_vma which has no vmas and only one child anon_vma. This prevents
  * degradation of anon_vma hierarchy to endless linear chain in case of
- * constantly forking task. In other hand anon_vma with more than one child
- * isn't reused even if was no alive vma, thus rmap walker has a good chance
- * to avoid scanning whole hieraryhy when it searches where page is mapped.
+ * constantly forking task. On the other hand, an anon_vma with more than one
+ * child isn't reused even if there was no alive vma, thus rmap walker has a
+ * good chance of avoiding scanning the whole hierarchy when it searches where
+ * page is mapped.
  */
 int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
mailmap-update-akpm-osdlorg.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
tools-testing-selftests-makefile-alphasort-the-targets-list.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

