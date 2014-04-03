From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch removed from -mm
 tree
Date: Thu, 03 Apr 2014 14:08:30 -0700
Message-ID: <533dcdce.wXjCT92iRg9XnxT6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbaDCVIb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:08:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, matthew.r.wilcox@intel.com, dave.hansen@linux.intel.com, ak@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: [folded-merged] mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,ak@linux.intel.com,dave.hansen@linux.intel.com,matthew.r.wilcox@intel.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:08:30 -0700


The patch titled
     Subject: mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix
has been removed from the -mm tree.  Its filename was
     mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch

This patch was dropped because it was folded into mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix

I forgot to set VM_FAULT_LOCKED bit in do_page_mkwrite() return code, if
we lock the page in do_page_mkwrite(). It triggers deadlock, if
->page_mkwrite doesn't take page lock on its own.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory.c~mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix mm/memory.c
--- a/mm/memory.c~mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix
+++ a/mm/memory.c
@@ -2612,6 +2612,7 @@ static int do_page_mkwrite(struct vm_are
 			unlock_page(page);
 			return 0; /* retry */
 		}
+		ret |= VM_FAULT_LOCKED;
 	} else
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 	return ret;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-setup-pte.patch
mm-thp-drop-do_huge_pmd_wp_zero_page_fallback.patch

