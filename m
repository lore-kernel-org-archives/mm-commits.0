From: akpm@linux-foundation.org
Subject: [merged]
 zram-keep-the-exact-overcommited-value-in-mem_used_max.patch removed from
 -mm tree
Date: Mon, 09 Nov 2015 11:44:52 -0800
Message-ID: <5640f7b4.5M84MM7CFl+YB6fS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbbKITow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: keep the exact overcommited value in mem_used_max
has been removed from the -mm tree.  Its filename was
     zram-keep-the-exact-overcommited-value-in-mem_used_max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Minchan Kim <minchan@kernel.org>
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
