From: akpm@linux-foundation.org
Subject: + zram-keep-the-exact-overcommited-value-in-mem_used_max.patch
 added to -mm tree
Date: Thu, 24 Sep 2015 13:59:05 -0700
Message-ID: <56046419.vBxElAV6v4J9SpIf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbbIXU7G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Sep 2015 16:59:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: keep the exact overcommited value in mem_used_max
has been added to the -mm tree.  Its filename is
     zram-keep-the-exact-overcommited-value-in-mem_used_max.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-keep-the-exact-overcommited-value-in-mem_used_max.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-keep-the-exact-overcommited-value-in-mem_used_max.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey SENOZHATSKY <sergey.senozhatsky@gmail.com>
Subject: zram: keep the exact overcommited value in mem_used_max

`mem_used_max' is designed to store the max amount of memory zram consumed
to store the data.  However, it does not represent the actual
'overcommited' (max) value.  The existing code goes to -ENOMEM
overcommited case before it updates `->stats.max_used_pages', which hides
the reason we went to -ENOMEM in the first place -- we actually used more
memory than `->limit_pages':

        alloced_pages = zs_get_total_pages(meta->mem_pool);
        if (zram->limit_pages && alloced_pages > zram->limit_pages) {
                zs_free(meta->mem_pool, handle);
                ret = -ENOMEM;
                goto out;
        }

        update_used_max(zram, alloced_pages);

Which is misleading.  User will see -ENOMEM, check `->limit_pages', check
`->stats.max_used_pages', which will keep the value BEFORE zram passed
`->limit_pages', and see:
	`->stats.max_used_pages' < `->limit_pages'

Move update_used_max() before we do `->limit_pages' check, so that
user will see:
	`->stats.max_used_pages' > `->limit_pages'
should the overcommit and -ENOMEM happen.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-keep-the-exact-overcommited-value-in-mem_used_max drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-keep-the-exact-overcommited-value-in-mem_used_max
+++ a/drivers/block/zram/zram_drv.c
@@ -726,14 +726,14 @@ static int zram_bvec_write(struct zram *
 	}
 
 	alloced_pages = zs_get_total_pages(meta->mem_pool);
+	update_used_max(zram, alloced_pages);
+
 	if (zram->limit_pages && alloced_pages > zram->limit_pages) {
 		zs_free(meta->mem_pool, handle);
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	update_used_max(zram, alloced_pages);
