From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-improve-readability-of-transparent_hugepage_enabled-fix.patch removed
 from -mm tree
Date: Mon, 10 Jul 2017 15:32:34 -0700
Message-ID: <59640082.WHq5L+Oym7PBLjL/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41248 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754864AbdGJWcg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:32:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mhocko@suse.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-improve-readability-of-transparent_hugepage_enabled-fix
has been removed from the -mm tree.  Its filename was
     mm-improve-readability-of-transparent_hugepage_enabled-fix.patch

This patch was dropped because it was folded into mm-improve-readability-of-transparent_hugepage_enabled.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-improve-readability-of-transparent_hugepage_enabled-fix

resolve vs mm-make-pr_set_thp_disable-immediately-active.patch

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/huge_mm.h~mm-improve-readability-of-transparent_hugepage_enabled-fix include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-improve-readability-of-transparent_hugepage_enabled-fix
+++ a/include/linux/huge_mm.h
@@ -89,7 +89,13 @@ extern unsigned long transparent_hugepag
 
 static inline bool transparent_hugepage_enabled(struct vm_area_struct *vma)
 {
-	if ((vma->vm_flags & VM_NOHUGEPAGE) || is_vma_temporary_stack(vma))
+	if (vma->vm_flags & VM_NOHUGEPAGE)
+		return false;
+
+	if (is_vma_temporary_stack(vma))
+		return false;
+
+	if (test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
 		return false;
 
 	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-improve-readability-of-transparent_hugepage_enabled.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix-fix.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix.patch
mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback-fix.patch
mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch

