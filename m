From: akpm@linux-foundation.org
Subject: [merged] thp-avoid-dumping-huge-zero-page.patch removed from -mm tree
Date: Tue, 05 Feb 2013 12:20:12 -0800
Message-ID: <20130205202012.93CCB31C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:34545 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab3BEUUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 15:20:13 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so65011vcd.3
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 12:20:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: avoid dumping huge zero page
has been removed from the -mm tree.  Its filename was
     thp-avoid-dumping-huge-zero-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: avoid dumping huge zero page

No reason to preserve the huge zero page in core dumps.

Reported-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/huge_memory.c~thp-avoid-dumping-huge-zero-page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-avoid-dumping-huge-zero-page
+++ a/mm/huge_memory.c
@@ -1257,6 +1257,10 @@ struct page *follow_trans_huge_pmd(struc
 	if (flags & FOLL_WRITE && !pmd_write(*pmd))
 		goto out;
 
+	/* Avoid dumping huge zero page */
+	if ((flags & FOLL_DUMP) && is_huge_zero_pmd(*pmd))
+		return ERR_PTR(-EFAULT);
+
 	page = pmd_page(*pmd);
 	VM_BUG_ON(!PageHead(page));
 	if (flags & FOLL_TOUCH) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
linux-next.patch
mm-huge_memory-use-new-hashtable-implementation.patch
mm-remove-unused-memclear_highpage_flush.patch

