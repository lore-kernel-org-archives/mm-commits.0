From: akpm@linux-foundation.org
Subject: + zram-clean-up-zram_meta_alloc.patch added to -mm tree
Date: Mon, 05 Jan 2015 14:48:04 -0800
Message-ID: <54ab14a4.h4Ec92w816nwdUuc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbbAEWsF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2015 17:48:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: clean up zram_meta_alloc()
has been added to the -mm tree.  Its filename is
     zram-clean-up-zram_meta_alloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-clean-up-zram_meta_alloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-clean-up-zram_meta_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: clean up zram_meta_alloc()

A trivial cleanup of zram_meta_alloc() error handling.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-clean-up-zram_meta_alloc drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-clean-up-zram_meta_alloc
+++ a/drivers/block/zram/zram_drv.c
@@ -318,31 +318,29 @@ static struct zram_meta *zram_meta_alloc
 {
 	size_t num_pages;
 	struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL);
+
 	if (!meta)
-		goto out;
+		return NULL;
 
 	num_pages = disksize >> PAGE_SHIFT;
 	meta->table = vzalloc(num_pages * sizeof(*meta->table));
 	if (!meta->table) {
 		pr_err("Error allocating zram address table\n");
-		goto free_meta;
+		goto out_error;
 	}
 
 	meta->mem_pool = zs_create_pool(GFP_NOIO | __GFP_HIGHMEM);
 	if (!meta->mem_pool) {
 		pr_err("Error creating memory pool\n");
-		goto free_table;
+		goto out_error;
 	}
 
 	return meta;
 
-free_table:
+out_error:
 	vfree(meta->table);
-free_meta:
 	kfree(meta);
-	meta = NULL;
-out:
-	return meta;
+	return NULL;
 }
 
 static void update_position(u32 *index, int *offset, struct bio_vec *bvec)
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-clean-up-zram_meta_alloc.patch

