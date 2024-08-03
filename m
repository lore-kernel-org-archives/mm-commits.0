Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4858913E020
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722663229; cv=none; b=eO82hWzPbVFnSAZB9TtKwW4hHJqSVmm3AxsOpmGqwiRw9Zj5bSPTd6u/UDbwrrE8Ypsb/8zW0YGyVXlgoLOctFbD2KbP8ddSFhQWViPjNoEGNJcf8TxStfuXR412+GA9UPce7tdD3Z6FZ+EoCu7qla11a+fdYBo+e2Rp21xHqpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722663229; c=relaxed/simple;
	bh=IuwcAoIk/y2XEKJk2OZYzM9Odr+9jqAzmmKN6AaLPKs=;
	h=Date:To:From:Subject:Message-Id; b=nPHpGkG7lfctQ/KBD33ByPzsFyg2CKMNy+H+jAXUM0/amQUOySNNB59i2Nbv3choNIt1EKQu4NmLzX+AwtI2Btc+N2sNTQG8S2qh9SVwsC3LNFbk3jK23VZR6HznS+hKHSE/qoMSJJxjrfEofkYloaFekiICVk9FqXTfVWxMLAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2lQy4bC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2lQy4bC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152CCC116B1;
	Sat,  3 Aug 2024 05:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722663229;
	bh=IuwcAoIk/y2XEKJk2OZYzM9Odr+9jqAzmmKN6AaLPKs=;
	h=Date:To:From:Subject:From;
	b=2lQy4bC82q/h6NG1pHXG0o6RUCZbsE/6Hu6NbLRc/KA9OVAbUHfuRh9hXGln/SYej
	 Wt3+4YDmhVmzwP56rom1tDHkyPJm6+1HTK19uJo7RjQJ0atDelSsLDwO5nh4omZ6xL
	 GaQGYVac/WygFBQvWTanFQPDWrgDlR8qVgA1GYKg=
Date: Fri, 02 Aug 2024 22:33:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch added to mm-unstable branch
Message-Id: <20240803053349.152CCC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/mm/fault: convert do_secure_storage_access() from follow_page() to folio_walk
has been added to the -mm mm-unstable branch.  Its filename is
     s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: s390/mm/fault: convert do_secure_storage_access() from follow_page() to folio_walk
Date: Fri, 2 Aug 2024 17:55:22 +0200

Let's get rid of another follow_page() user and perform the conversion
under PTL: Note that this is also what follow_page_pte() ends up doing.

Unfortunately we cannot currently optimize out the additional reference,
because arch_make_folio_accessible() must be called with a raised refcount
to protect against concurrent conversion to secure.  We can just move the
arch_make_folio_accessible() under the PTL, like follow_page_pte() would.

We'll effectively drop the "writable" check implied by FOLL_WRITE:
follow_page_pte() would also not check that when calling
arch_make_folio_accessible(), so there is no good reason for doing that
here.

We'll lose the secretmem check from follow_page() as well, about which we
shouldn't really care.

Link: https://lkml.kernel.org/r/20240802155524.517137-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/fault.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/arch/s390/mm/fault.c~s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk
+++ a/arch/s390/mm/fault.c
@@ -34,6 +34,7 @@
 #include <linux/uaccess.h>
 #include <linux/hugetlb.h>
 #include <linux/kfence.h>
+#include <linux/pagewalk.h>
 #include <asm/asm-extable.h>
 #include <asm/asm-offsets.h>
 #include <asm/ptrace.h>
@@ -492,9 +493,9 @@ void do_secure_storage_access(struct pt_
 	union teid teid = { .val = regs->int_parm_long };
 	unsigned long addr = get_fault_address(regs);
 	struct vm_area_struct *vma;
+	struct folio_walk fw;
 	struct mm_struct *mm;
 	struct folio *folio;
-	struct page *page;
 	struct gmap *gmap;
 	int rc;
 
@@ -536,15 +537,18 @@ void do_secure_storage_access(struct pt_
 		vma = find_vma(mm, addr);
 		if (!vma)
 			return handle_fault_error(regs, SEGV_MAPERR);
-		page = follow_page(vma, addr, FOLL_WRITE | FOLL_GET);
-		if (IS_ERR_OR_NULL(page)) {
+		folio = folio_walk_start(&fw, vma, addr, 0);
+		if (!folio) {
 			mmap_read_unlock(mm);
 			break;
 		}
-		folio = page_folio(page);
-		if (arch_make_folio_accessible(folio))
-			send_sig(SIGSEGV, current, 0);
+		/* arch_make_folio_accessible() needs a raised refcount. */
+		folio_get(folio);
+		rc = arch_make_folio_accessible(folio);
 		folio_put(folio);
+		folio_walk_end(&fw, vma);
+		if (rc)
+			send_sig(SIGSEGV, current, 0);
 		mmap_read_unlock(mm);
 		break;
 	case KERNEL_FAULT:
_

Patches currently in -mm which might be from david@redhat.com are

mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch
mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch
mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch
mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch
mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch
mm-pagewalk-introduce-folio_walk_start-folio_walk_end.patch
mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch
mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk.patch
mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch
mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch
s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch
s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch
mm-remove-follow_page.patch
mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch

