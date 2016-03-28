From: akpm@linux-foundation.org
Subject: +
 include-linux-huge_mmh-return-null-instead-of-false-for-pmd_trans_huge_lock.patch added to -mm tree
Date: Mon, 28 Mar 2016 12:57:40 -0700
Message-ID: <56f98cb4.6/yPMdVFlCnhgqN+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbcC1T5l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 15:57:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chengang@emindsoft.com.cn, gang.chen.5i5j@gmail.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/huge_mm.h: return NULL instead of false for pmd_trans_huge_lock()
has been added to the -mm tree.  Its filename is
     include-linux-huge_mmh-return-null-instead-of-false-for-pmd_trans_huge_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-huge_mmh-return-null-instead-of-false-for-pmd_trans_huge_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-huge_mmh-return-null-instead-of-false-for-pmd_trans_huge_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <chengang@emindsoft.com.cn>
Subject: include/linux/huge_mm.h: return NULL instead of false for pmd_trans_huge_lock()

The return value of pmd_trans_huge_lock() is a pointer, not a boolean
value, so use NULL instead of false as the return value.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/huge_mm.h~include-linux-huge_mmh-return-null-instead-of-false-for-pmd_trans_huge_lock include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~include-linux-huge_mmh-return-null-instead-of-false-for-pmd_trans_huge_lock
+++ a/include/linux/huge_mm.h
@@ -127,7 +127,7 @@ static inline spinlock_t *pmd_trans_huge
 	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd))
 		return __pmd_trans_huge_lock(pmd, vma);
 	else
-		return false;
+		return NULL;
 }
 static inline int hpage_nr_pages(struct page *page)
 {
_

Patches currently in -mm which might be from chengang@emindsoft.com.cn are

include-linux-huge_mmh-return-null-instead-of-false-for-pmd_trans_huge_lock.patch

