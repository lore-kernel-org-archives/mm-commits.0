From: akpm@linux-foundation.org
Subject: [merged] zram-rename-struct-table-to-zram_table_entry.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:06:47 -0700
Message-ID: <53e3dc57.jr8aFq5HhxEtEd2S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:37341 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaHGUGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:48 -0400
Received: by mail-vc0-f201.google.com with SMTP id le20so611096vcb.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: rename struct `table' to `zram_table_entry'
has been removed from the -mm tree.  Its filename was
     zram-rename-struct-table-to-zram_table_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

