From: akpm@linux-foundation.org
Subject: + hwpoison-soft-offlining-for-non-lru-movable-page-v4.patch added to -mm tree
Date: Wed, 25 Jan 2017 15:26:08 -0800
Message-ID: <58893410.21X9DduMGmwYHTo2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50750 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752510AbdAYX0Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2017 18:26:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison-soft-offlining-for-non-lru-movable-page-v4
has been added to the -mm tree.  Its filename is
     hwpoison-soft-offlining-for-non-lru-movable-page-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hwpoison-soft-offlining-for-non-lru-movable-page-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hwpoison-soft-offlining-for-non-lru-movable-page-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: hwpoison-soft-offlining-for-non-lru-movable-page-v4

Link: http://lkml.kernel.org/r/1485356738-4831-3-git-send-email-ysxie@foxmail.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~hwpoison-soft-offlining-for-non-lru-movable-page-v4 mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-soft-offlining-for-non-lru-movable-page-v4
+++ a/mm/memory-failure.c
@@ -1652,8 +1652,8 @@ static int __soft_offline_page(struct pa
 	 */
 	if (PageLRU(page))
 		ret = isolate_lru_page(page);
-	else
-		ret = !isolate_movable_page(page, ISOLATE_UNEVICTABLE);
+	else if (!isolate_movable_page(page, ISOLATE_UNEVICTABLE))
+		ret = -EBUSY;
 	/*
 	 * Drop page reference which is came from get_any_page()
 	 * successful isolate_lru_page() already took another one.
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are

hwpoison-soft-offlining-for-non-lru-movable-page.patch
hwpoison-soft-offlining-for-non-lru-movable-page-v4.patch

