From: akpm@linux-foundation.org
Subject: +
 zsmalloc-reorganize-struct-size_class-to-pack-4-bytes-hole.patch added to
 -mm tree
Date: Fri, 11 Dec 2015 14:34:16 -0800
Message-ID: <566b4f68.tx3YRervnUGymFWg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbbLKWeQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Dec 2015 17:34:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: reorganize struct size_class to pack 4 bytes hole
has been added to the -mm tree.  Its filename is
     zsmalloc-reorganize-struct-size_class-to-pack-4-bytes-hole.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-reorganize-struct-size_class-to-pack-4-bytes-hole.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-reorganize-struct-size_class-to-pack-4-bytes-hole.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: zsmalloc: reorganize struct size_class to pack 4 bytes hole

Reoder the pages_per_zspage field in struct size_class which can eliminate
the 4 bytes hole between it and stats field.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-reorganize-struct-size_class-to-pack-4-bytes-hole mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-reorganize-struct-size_class-to-pack-4-bytes-hole
+++ a/mm/zsmalloc.c
@@ -213,10 +213,10 @@ struct size_class {
 	int size;
 	unsigned int index;
 
-	/* Number of PAGE_SIZE sized pages to combine to form a 'zspage' */
-	int pages_per_zspage;
 	struct zs_size_stat stats;
 
+	/* Number of PAGE_SIZE sized pages to combine to form a 'zspage' */
+	int pages_per_zspage;
 	/* huge object: pages_per_zspage == 1 && maxobj_per_zspage == 1 */
 	bool huge;
 };
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

zsmalloc-reorganize-struct-size_class-to-pack-4-bytes-hole.patch

