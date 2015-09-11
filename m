From: akpm@linux-foundation.org
Subject: [merged] mm-make-sure-all-file-vmas-have-vm_ops-set.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:13:52 -0700
Message-ID: <55f319e0.nYVohq16s7/4ts6w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbbIKSNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com, hpa@zytor.com, luto@amacapital.net, minchan@kernel.org, mingo@elte.hu, oleg@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make sure all file VMAs have ->vm_ops set
has been removed from the -mm tree.  Its filename was
     mm-make-sure-all-file-vmas-have-vm_ops-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: make sure all file VMAs have ->vm_ops set

We rely on vma->vm_ops == NULL to detect anonymous VMA: see
vma_is_anonymous(), but some drivers doesn't set ->vm_ops.

As a result we can end up with anonymous page in private file mapping. 
That should not lead to serious misbehaviour, but nevertheless is wrong.

Let's fix by setting up dummy ->vm_ops for file mmapping if f_op->mmap()
didn't set its own.

The patch also adds sanity check into __vma_link_rb(). It will help
catch broken VMAs which inserted directly into mm_struct via
insert_vm_struct().

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

 mm/mmap.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/mmap.c~mm-make-sure-all-file-vmas-have-vm_ops-set mm/mmap.c
--- a/mm/mmap.c~mm-make-sure-all-file-vmas-have-vm_ops-set
+++ a/mm/mmap.c
@@ -612,6 +612,8 @@ static unsigned long count_vma_pages_ran
 void __vma_link_rb(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct rb_node **rb_link, struct rb_node *rb_parent)
 {
+	WARN_ONCE(vma->vm_file && !vma->vm_ops, "missing vma->vm_ops");
+
 	/* Update tracking information for the gap following the new vma. */
 	if (vma->vm_next)
 		vma_gap_update(vma->vm_next);
@@ -1636,6 +1638,12 @@ unsigned long mmap_region(struct file *f
 		 */
 		WARN_ON_ONCE(addr != vma->vm_start);
 
+		/* All file mapping must have ->vm_ops set */
+		if (!vma->vm_ops) {
+			static const struct vm_operations_struct dummy_ops = {};
+			vma->vm_ops = &dummy_ops;
+		}
+
 		addr = vma->vm_start;
 		vm_flags = vma->vm_flags;
 	} else if (vm_flags & VM_SHARED) {
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

