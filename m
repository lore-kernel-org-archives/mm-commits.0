From: akpm@linux-foundation.org
Subject: +
 mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages.patch
 added to -mm tree
Date: Thu, 15 Jun 2017 16:10:39 -0700
Message-ID: <594313ef.//DDrPuGEF7PLdcf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47068 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbdFOXKk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 19:10:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: correct the comment when reclaimed pages exceed the scanned pages
has been added to the -mm tree.  Its filename is
     mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhongjiang <zhongjiang@huawei.com>
Subject: mm: correct the comment when reclaimed pages exceed the scanned pages

e1587a494540 ("mm: vmpressure: fix sending wrong events on underflow")
declare that reclaimed pages exceed the scanned pages due to the thp
reclaim.  it is incorrect because THP will be spilt to normal page and
loop again.  which will result in the scanned pages increment.

Link: http://lkml.kernel.org/r/1496824266-25235-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhongjiang <zhongjiang@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmpressure.c~mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages mm/vmpressure.c
--- a/mm/vmpressure.c~mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages
+++ a/mm/vmpressure.c
@@ -116,8 +116,9 @@ static enum vmpressure_levels vmpressure
 
 	/*
 	 * reclaimed can be greater than scanned in cases
-	 * like THP, where the scanned is 1 and reclaimed
-	 * could be 512
+	 * like reclaimed slab pages, shrink_node just add
+	 * reclaimed page without a related increment to
+	 * scanned pages.
 	 */
 	if (reclaimed >= scanned)
 		goto out;
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch
signal-avoid-undefined-behaviour-in-kill_something_info.patch
exit-avoid-undefined-behaviour-when-call-wait4.patch

