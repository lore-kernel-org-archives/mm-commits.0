From: akpm@linux-foundation.org
Subject: + zram-constify-attribute_group-structures.patch added to -mm
 tree
Date: Wed, 05 Jul 2017 16:10:38 -0700
Message-ID: <595d71ee.wRYR/WGmM67l1ILo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36478 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751941AbdGEXKj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 19:10:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvind.yadav.cs@gmail.com, minchan@kernel.org, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: constify attribute_group structures.
has been added to the -mm tree.  Its filename is
     zram-constify-attribute_group-structures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-constify-attribute_group-structures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-constify-attribute_group-structures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-constify-attribute_group-structures.patch
zram-constify-attribute_group-structures.patch
kernel-ksysfs-constify-attribute_group-structures.patch

