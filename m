From: akpm@linux-foundation.org
Subject: [merged] zram-constify-attribute_group-structures.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:25:16 -0700
Message-ID: <20170711192516.KGHVFOORq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48146 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933785AbdGKTZR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:25:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvind.yadav.cs@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com


The patch titled
     Subject: zram: constify attribute_group structures.
has been removed from the -mm tree.  Its filename was
     zram-constify-attribute_group-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from arvind.yadav.cs@gmail.com are


