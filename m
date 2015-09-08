From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:04:14 -0700
Message-ID: <55ef231e.imhHFrIsWp601Np/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbbIHSE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: prevent khugepaged to merge if userfaultfd is armed
has been removed from the -mm tree.  Its filename was
     userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: prevent khugepaged to merge if userfaultfd is armed

If userfaultfd is armed on a certain vma we can't "fill" the holes with
zeroes or we'll break the userland on demand paging.  The holes if the
userfault is armed, are really missing information (not zeroes) that the
userland has to load from network or elsewhere.

The same issue happens for wrprotected ptes that we can't just convert
into a single writable pmd_trans_huge.

We could however in theory still merge across zeropages if only
VM_UFFD_MISSING is set (so if VM_UFFD_WP is not set)...  that could be
slightly improved but it'd be much more complex code for a tiny corner
case.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: zhang.zhanghailiang@huawei.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed mm/huge_memory.c
--- a/mm/huge_memory.c~userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed
+++ a/mm/huge_memory.c
@@ -2158,7 +2158,8 @@ static int __collapse_huge_page_isolate(
 	     _pte++, address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
-			if (++none_or_zero <= khugepaged_max_ptes_none)
+			if (!userfaultfd_armed(vma) &&
+			    ++none_or_zero <= khugepaged_max_ptes_none)
 				continue;
 			else
 				goto out;
@@ -2611,7 +2612,8 @@ static int khugepaged_scan_pmd(struct mm
 	     _pte++, _address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
-			if (++none_or_zero <= khugepaged_max_ptes_none)
+			if (!userfaultfd_armed(vma) &&
+			    ++none_or_zero <= khugepaged_max_ptes_none)
 				continue;
 			else
 				goto out_unmap;
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

