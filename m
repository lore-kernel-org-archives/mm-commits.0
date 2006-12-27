From: akpm@osdl.org
Subject: + page_mkclean_one-fix-call-to-set_pte_at.patch added to -mm tree
Date: Wed, 27 Dec 2006 01:06:59 -0800
Message-ID: <200612270906.kBR96xBq006381@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42401 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbWL0JHL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 04:07:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, viro@zeniv.linux.org.uk


The patch titled
     page_mkclean_one(): fix call to set_pte_at()
has been added to the -mm tree.  Its filename is
     page_mkclean_one-fix-call-to-set_pte_at.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: page_mkclean_one(): fix call to set_pte_at()
From: Al Viro <viro@ftp.linux.org.uk>

(akpm: macros are wonderful)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~page_mkclean_one-fix-call-to-set_pte_at mm/rmap.c
--- a/mm/rmap.c~page_mkclean_one-fix-call-to-set_pte_at
+++ a/mm/rmap.c
@@ -452,7 +452,7 @@ static int page_mkclean_one(struct page 
 		entry = ptep_clear_flush(vma, address, pte);
 		entry = pte_wrprotect(entry);
 		entry = pte_mkclean(entry);
-		set_pte_at(vma, address, pte, entry);
+		set_pte_at(mm, address, pte, entry);
 		lazy_mmu_prot_update(entry);
 		ret = 1;
 	}
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

page_mkclean_one-fix-call-to-set_pte_at.patch
m68k-work-around-binutils-tokenizer-change.patch
slab-leaks3-default-y.patch

