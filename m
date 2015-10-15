From: akpm@linux-foundation.org
Subject: + zsmalloc-dont-test-shrinker_enabled-in-zs_shrinker_count.patch
 added to -mm tree
Date: Thu, 15 Oct 2015 12:50:49 -0700
Message-ID: <56200399.cH0swLyfRqYVChxk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbJOTut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 15:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: don't test shrinker_enabled in zs_shrinker_count()
has been added to the -mm tree.  Its filename is
     zsmalloc-dont-test-shrinker_enabled-in-zs_shrinker_count.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-dont-test-shrinker_enabled-in-zs_shrinker_count.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-dont-test-shrinker_enabled-in-zs_shrinker_count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: zsmalloc: don't test shrinker_enabled in zs_shrinker_count()

We don't let user to disable shrinker in zsmalloc (once it's been
enabled), so no need to check ->shrinker_enabled in zs_shrinker_count(),
at the moment at least.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-dont-test-shrinker_enabled-in-zs_shrinker_count mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-dont-test-shrinker_enabled-in-zs_shrinker_count
+++ a/mm/zsmalloc.c
@@ -1823,9 +1823,6 @@ static unsigned long zs_shrinker_count(s
 	struct zs_pool *pool = container_of(shrinker, struct zs_pool,
 			shrinker);
 
-	if (!pool->shrinker_enabled)
-		return 0;
