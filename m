From: akpm@linux-foundation.org
Subject: + mm-memory-failure-fix-race-with-compound-page-split-merge.patch added to -mm tree
Date: Thu, 21 Apr 2016 16:45:26 -0700
Message-ID: <57196616.SGn36HEAWKW6IU55%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbcDUXp1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 19:45:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: fix race with compound page split/merge
has been added to the -mm tree.  Its filename is
     mm-memory-failure-fix-race-with-compound-page-split-merge.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-fix-race-with-compound-page-split-merge.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-fix-race-with-compound-page-split-merge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm/memory-failure: fix race with compound page split/merge

Get_hwpoison_page() must recheck relation between head and tail pages.

n-horiguchi said: without this recheck, the race causes kernel to pin an
irrelevant page, and finally makes kernel crash for refcount mismatch.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-memory-failure-fix-race-with-compound-page-split-merge mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-fix-race-with-compound-page-split-merge
+++ a/mm/memory-failure.c
@@ -888,7 +888,15 @@ int get_hwpoison_page(struct page *page)
 		}
 	}
 
-	return get_page_unless_zero(head);
+	if (get_page_unless_zero(head)) {
+		if (head == compound_head(page))
+			return 1;
+
+		pr_info("MCE: %#lx cannot catch tail\n", page_to_pfn(page));
+		put_page(head);
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(get_hwpoison_page);
 
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

mm-memory-failure-fix-race-with-compound-page-split-merge.patch
mm-rmap-replace-bug_onanon_vma-degree-with-vm_warn_on.patch

