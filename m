From: akpm@linux-foundation.org
Subject: + zram-rename-struct-table-to-zram_table_entry.patch added to -mm tree
Date: Tue, 24 Jun 2014 13:29:37 -0700
Message-ID: <53a9dfb1.LnxvKtXj4Ek/dJBX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFXU3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 16:29:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: rename struct `table' to `zram_table_entry'
has been added to the -mm tree.  Its filename is
     zram-rename-struct-table-to-zram_table_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-rename-struct-table-to-zram_table_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-rename-struct-table-to-zram_table_entry.patch

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
Subject: zram: rename struct `table' to `zram_table_entry'

Andrew Morton has recently noted that `struct table' actually represents
table entry and, thus, should be renamed.  Rename to `zram_table_entry'.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Weijie Yang <weijie.yang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.h~zram-rename-struct-table-to-zram_table_entry drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-rename-struct-table-to-zram_table_entry
+++ a/drivers/block/zram/zram_drv.h
@@ -62,7 +62,7 @@ enum zram_pageflags {
 /*-- Data structures */
 
 /* Allocated for each disk page */
-struct table {
+struct zram_table_entry {
 	unsigned long handle;
 	u16 size;	/* object size (excluding header) */
 	u8 flags;
@@ -82,7 +82,7 @@ struct zram_stats {
 
 struct zram_meta {
 	rwlock_t tb_lock;	/* protect table */
-	struct table *table;
+	struct zram_table_entry *table;
 	struct zs_pool *mem_pool;
 };
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-rename-struct-table-to-zram_table_entry.patch
zram-remove-unused-sector_size-define.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch

