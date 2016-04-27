From: akpm@linux-foundation.org
Subject: + memory-failure-replace-mce-with-memory-failure-fix.patch added
 to -mm tree
Date: Wed, 27 Apr 2016 13:01:12 -0700
Message-ID: <57211a88.PC0sl/CWESEj4+kA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbcD0UBS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 16:01:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slaoub@gmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-failure-replace-mce-with-memory-failure-fix
has been added to the -mm tree.  Its filename is
     memory-failure-replace-mce-with-memory-failure-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-failure-replace-mce-with-memory-failure-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-failure-replace-mce-with-memory-failure-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Yucong <slaoub@gmail.com>
Subject: memory-failure-replace-mce-with-memory-failure-fix

Signed-off-by: Chen Yucong <slaoub@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory-failure.c~memory-failure-replace-mce-with-memory-failure-fix mm/memory-failure.c
--- a/mm/memory-failure.c~memory-failure-replace-mce-with-memory-failure-fix
+++ a/mm/memory-failure.c
@@ -894,7 +894,8 @@ int get_hwpoison_page(struct page *page)
 		if (head == compound_head(page))
 			return 1;
 
-		pr_info("MCE: %#lx cannot catch tail\n", page_to_pfn(page));
+		pr_info("Memory failure: %#lx cannot catch tail\n",
+			page_to_pfn(page));
 		put_page(head);
 	}
 
_

Patches currently in -mm which might be from slaoub@gmail.com are

memory-failure-replace-mce-with-memory-failure.patch
memory-failure-replace-mce-with-memory-failure-fix.patch

