Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE5A5589B
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247752; cv=none; b=MG9zIVm6VlkO1gkXzut6guVibFhlqa6WJ1wKHs26hbV0UZommeuLoAWoyB8IfVui6IVdDNFlMoEE8OrJMJ3uwLmYc3z8iPjnei/cSIaoSfrBY+5lOulX6/xN4qZVDVJ5ZPSx07VhkBySMvKmnTvC1XGu1GFxstGnDCPyD7+hCnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247752; c=relaxed/simple;
	bh=9QgGmpmn8Sfu8wSFhaW9PiubnAc2fJjMfj7DUeCLKRg=;
	h=Date:To:From:Subject:Message-Id; b=puI1I0EcLr8fc/qbt/LW1KlGGNKqjxvzTNaYO90ci6sdgKhvhMalYmw4D4MPORvvkfQ5njfwlrLJUV1T1Zivd/52JeaX/2tXj23lmt8284vrbee4mjkTRPjJp/fU3S0e0IDY17LJEXzunTnXugw8Q8YJquas+B3zrPsSB37dgxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JWwokIL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JWwokIL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4717DC4CEC2;
	Mon,  2 Sep 2024 03:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247752;
	bh=9QgGmpmn8Sfu8wSFhaW9PiubnAc2fJjMfj7DUeCLKRg=;
	h=Date:To:From:Subject:From;
	b=JWwokIL9jjeXRgo2HWQV3IhwTHjY1hYhWc/tLjaUMNmHYiN3kfRZpFW+XcgaPIF3U
	 Bx+Cm5cp/FS6DO/LLqAogqcTo3aWXYhQKvJ3a7KeQ5R08o5oleQn8PZelwETNp3lI9
	 IvTfwQxq5eJPrcGMuXqaKwaNXQSr8rzOSnmR5hU8=
Date: Sun, 01 Sep 2024 20:29:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,svens@linux.ibm.com,ryan.roberts@arm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch removed from -mm tree
Message-Id: <20240902032912.4717DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/mm/fault: convert do_secure_storage_access() from follow_page() to folio_walk
has been removed from the -mm tree.  Its filename was
     s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
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

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

