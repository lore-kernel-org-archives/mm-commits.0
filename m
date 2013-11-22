From: akpm@linux-foundation.org
Subject: + include-linux-hugetlbh-make-isolate_huge_page-an-inline.patch
 added to -mm tree
Date: Thu, 21 Nov 2013 16:32:45 -0800
Message-ID: <528ea62d.hYu9ycAmBkoMP5Hv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab3KVAcq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Nov 2013 19:32:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, bp@alien8.de, n-horiguchi@ah.jp.nec.com

Subject: + include-linux-hugetlbh-make-isolate_huge_page-an-inline.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,bp@alien8.de,rientjes@google.com
From: akpm@linux-foundation.org
Date: Thu, 21 Nov 2013 16:32:45 -0800


The patch titled
     Subject: include/linux/hugetlb.h: make isolate_huge_page() an inline
has been added to the -mm tree.  Its filename is
     include-linux-hugetlbh-make-isolate_huge_page-an-inline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-hugetlbh-make-isolate_huge_page-an-inline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-hugetlbh-make-isolate_huge_page-an-inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: include/linux/hugetlb.h: make isolate_huge_page() an inline

With CONFIG_HUGETLBFS=n:

mm/migrate.c: In function `do_move_page_to_node_array':
include/linux/hugetlb.h:140:33: warning: statement with no effect [-Wunused-value]
 #define isolate_huge_page(p, l) false
                                 ^
mm/migrate.c:1170:4: note: in expansion of macro `isolate_huge_page'
    isolate_huge_page(page, &pagelist);


Reported-by: Borislav Petkov <bp@alien8.de>
Tested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~include-linux-hugetlbh-make-isolate_huge_page-an-inline include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~include-linux-hugetlbh-make-isolate_huge_page-an-inline
+++ a/include/linux/hugetlb.h
@@ -142,7 +142,10 @@ static inline int dequeue_hwpoisoned_hug
 	return 0;
 }
 
-#define isolate_huge_page(p, l) false
+static inline bool isolate_huge_page(struct page *page, struct list_head *list)
+{
+	return false;
+}
 #define putback_active_hugepage(p)	do {} while (0)
 #define is_hugepage_active(x)	false
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch
mm-place-page-pmd_huge_pte-to-right-union.patch
include-linux-hugetlbh-make-isolate_huge_page-an-inline.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch

