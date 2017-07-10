From: akpm@linux-foundation.org
Subject: [patch 061/115] zram: constify attribute_group structures.
Date: Mon, 10 Jul 2017 15:50:15 -0700
Message-ID: <20170710225015.kIIumAKqh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43026 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754715AbdGJWuQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:50:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arvind.yadav.cs@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com, torvalds@linux-foundation.org

From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: zram: constify attribute_group structures.

attribute_groups are not supposed to change at runtime.  All functions
working with attribute_groups provided by <linux/sysfs.h> work with const
attribute_group.  So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   8293	    841	      4	   9138	   23b2	drivers/block/zram/zram_drv.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
   8357	    777	      4	   9138	   23b2	drivers/block/zram/zram_drv.o

Link: http://lkml.kernel.org/r/65680c1c4d85818f7094cbfa31c91bf28185ba1b.1499061182.git.arvind.yadav.cs@gmail.com
Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-constify-attribute_group-structures drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-constify-attribute_group-structures
+++ a/drivers/block/zram/zram_drv.c
@@ -1124,7 +1124,7 @@ static struct attribute *zram_disk_attrs
 	NULL,
 };
 
-static struct attribute_group zram_disk_attr_group = {
+static const struct attribute_group zram_disk_attr_group = {
 	.attrs = zram_disk_attrs,
 };
 
_
