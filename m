From: akpm@linux-foundation.org
Subject: + thp-avoid-dumping-huge-zero-page.patch added to -mm tree
Date: Mon, 14 Jan 2013 15:11:17 -0800
Message-ID: <20130114231117.96BA2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:40280 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab3ANXLS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 18:11:18 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so560972qch.2
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 15:11:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, walken@google.com


The patch titled
     Subject: thp: avoid dumping huge zero page
has been added to the -mm tree.  Its filename is
     thp-avoid-dumping-huge-zero-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1251,6 +1251,10 @@ struct page *follow_trans_huge_pmd(struc
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

include-asm-generic-pgtableh-fix-mips-build.patch
thp-avoid-dumping-huge-zero-page.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
mm-huge_memory-use-new-hashtable-implementation.patch

