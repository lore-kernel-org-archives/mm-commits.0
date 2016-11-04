From: akpm@linux-foundation.org
Subject: + mm-hwpoison-fix-thp-split-handling-in-memory_failure.patch
 added to -mm tree
Date: Fri, 04 Nov 2016 12:31:15 -0700
Message-ID: <581ce203.HAXAiku6zLZvzO1d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52152 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752425AbcKDTbQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Nov 2016 15:31:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: fix thp split handling in memory_failure()
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-thp-split-handling-in-memory_failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-thp-split-handling-in-memory_failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-thp-split-handling-in-memory_failure.patch

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
Subject: mm: hwpoison: fix thp split handling in memory_failure()

When memory_failure() runs on a thp tail page after pmd is split, we
trigger the following VM_BUG_ON_PAGE():

  [  619.550520] page:ffffd7cd819b0040 count:0 mapcount:0 mapping:         (null) index:0x1
  [  619.555486] flags: 0x1fffc000400000(hwpoison)
  [  619.556408] page dumped because: VM_BUG_ON_PAGE(!page_count(p))
  [  619.558998] ------------[ cut here ]------------
  [  619.561388] kernel BUG at /src/linux-dev/mm/memory-failure.c:1132!

memory_failure() passed refcount and page lock from tail page to head
page, which is not needed because we can pass any subpage to
split_huge_page().

Fixes: 61f5d698cc97 ("mm: re-enable THP")
Link: http://lkml.kernel.org/r/1477961577-7183-1-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>	[4.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN mm/memory-failure.c~mm-hwpoison-fix-thp-split-handling-in-memory_failure mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-fix-thp-split-handling-in-memory_failure
+++ a/mm/memory-failure.c
@@ -1112,10 +1112,10 @@ int memory_failure(unsigned long pfn, in
 	}
 
 	if (!PageHuge(p) && PageTransHuge(hpage)) {
-		lock_page(hpage);
-		if (!PageAnon(hpage) || unlikely(split_huge_page(hpage))) {
-			unlock_page(hpage);
-			if (!PageAnon(hpage))
+		lock_page(p);
+		if (!PageAnon(p) || unlikely(split_huge_page(p))) {
+			unlock_page(p);
+			if (!PageAnon(p))
 				pr_err("Memory failure: %#lx: non anonymous thp\n",
 					pfn);
 			else
@@ -1126,9 +1126,7 @@ int memory_failure(unsigned long pfn, in
 			put_hwpoison_page(p);
 			return -EBUSY;
 		}
-		unlock_page(hpage);
-		get_hwpoison_page(p);
-		put_hwpoison_page(hpage);
+		unlock_page(p);
 		VM_BUG_ON_PAGE(!page_count(p), p);
 		hpage = compound_head(p);
 	}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hwpoison-fix-thp-split-handling-in-memory_failure.patch

