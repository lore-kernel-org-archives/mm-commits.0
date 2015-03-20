From: akpm@linux-foundation.org
Subject: + mm-zsmallocc-fix-comment-for-get_pages_per_zspage.patch added
 to -mm tree
Date: Fri, 20 Mar 2015 14:53:39 -0700
Message-ID: <550c96e3.C1A2Kjpw7jstALbW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbbCTVxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 17:53:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghao.xie@samsung.com, minchan@kernel.org, yinghao.xie@sumsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: fix comment for get_pages_per_zspage
has been added to the -mm tree.  Its filename is
     mm-zsmallocc-fix-comment-for-get_pages_per_zspage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmallocc-fix-comment-for-get_pages_per_zspage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmallocc-fix-comment-for-get_pages_per_zspage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yinghao Xie <yinghao.xie@samsung.com>
Subject: mm/zsmalloc.c: fix comment for get_pages_per_zspage

Signed-off-by: Yinghao Xie <yinghao.xie@sumsung.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~mm-zsmallocc-fix-comment-for-get_pages_per_zspage mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmallocc-fix-comment-for-get_pages_per_zspage
+++ a/mm/zsmalloc.c
@@ -731,7 +731,8 @@ out:
  * to form a zspage for each size class. This is important
  * to reduce wastage due to unusable space left at end of
  * each zspage which is given as:
- *	wastage = Zp - Zp % size_class
+ *     wastage = Zp % class_size
+ *     usage = Zp - wastage
  * where Zp = zspage size = k * PAGE_SIZE where k = 1, 2, ...
  *
  * For example, for size class of 3/8 * PAGE_SIZE, we should
_

Patches currently in -mm which might be from yinghao.xie@samsung.com are

mm-zsmallocc-fix-comment-for-get_pages_per_zspage.patch

