From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd.patch removed
 from -mm tree
Date: Fri, 11 Sep 2015 11:13:55 -0700
Message-ID: <55f319e3.1X04WAS8eXYr4Fey%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbbIKSN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com, hpa@zytor.com, luto@amacapital.net, minchan@kernel.org, mingo@elte.hu, oleg@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use vma_is_anonymous() in create_huge_pmd() and wp_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: use vma_is_anonymous() in create_huge_pmd() and wp_huge_pmd()

Let's use helper rather than direct check of vma->vm_ops to distinguish
anonymous VMA.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd mm/memory.c
--- a/mm/memory.c~mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd
+++ a/mm/memory.c
@@ -3233,7 +3233,7 @@ out:
 static int create_huge_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pmd_t *pmd, unsigned int flags)
 {
-	if (!vma->vm_ops)
+	if (vma_is_anonymous(vma))
 		return do_huge_pmd_anonymous_page(mm, vma, address, pmd, flags);
 	if (vma->vm_ops->pmd_fault)
 		return vma->vm_ops->pmd_fault(vma, address, pmd, flags);
@@ -3244,7 +3244,7 @@ static int wp_huge_pmd(struct mm_struct
 			unsigned long address, pmd_t *pmd, pmd_t orig_pmd,
 			unsigned int flags)
 {
-	if (!vma->vm_ops)
+	if (vma_is_anonymous(vma))
 		return do_huge_pmd_wp_page(mm, vma, address, pmd, orig_pmd);
 	if (vma->vm_ops->pmd_fault)
 		return vma->vm_ops->pmd_fault(vma, address, pmd, flags);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

