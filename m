From: akpm@linux-foundation.org
Subject: + block-remove-unrelated-header-files-and-export-symbol.patch
 added to -mm tree
Date: Tue, 05 Nov 2013 14:43:34 -0800
Message-ID: <52797496.6SC8fVjRaZUYz/ne%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab3KEWnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 17:43:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shmulik.ladkani@gmail.com, kzak@redhat.com, ezequiel.garcia@free-electrons.com, dwmw2@infradead.org, dedekind1@gmail.com, computersforpeace@gmail.com, axboe@kernel.dk, albert.wanglin@hisilicon.com, caizhiyong@huawei.com

Subject: + block-remove-unrelated-header-files-and-export-symbol.patch added to -mm tree
To: caizhiyong@huawei.com,albert.wanglin@hisilicon.com,axboe@kernel.dk,computersforpeace@gmail.com,dedekind1@gmail.com,dwmw2@infradead.org,ezequiel.garcia@free-electrons.com,kzak@redhat.com,shmulik.ladkani@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 14:43:34 -0800


The patch titled
     Subject: block: remove unrelated header files and export symbol
has been added to the -mm tree.  Its filename is
     block-remove-unrelated-header-files-and-export-symbol.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-remove-unrelated-header-files-and-export-symbol.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-remove-unrelated-header-files-and-export-symbol.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: CaiZhiyong <caizhiyong@huawei.com>
Subject: block: remove unrelated header files and export symbol

Fix up the following items:

 - remove unrelated header files.
 - export interface function.
 - modify function cmdline_parts_parse return value, this will make
   it more friendly for the caller.

Signed-off-by: CaiZhiyong <caizhiyong@huawei.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: Brian Norris <computersforpeace@gmail.com>
Cc: "Wanglin (Albert)" <albert.wanglin@hisilicon.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Karel Zak <kzak@redhat.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cmdline-parser.c         |   18 +++++++++++-------
 include/linux/cmdline-parser.h |    8 ++++----
 2 files changed, 15 insertions(+), 11 deletions(-)

diff -puN block/cmdline-parser.c~block-remove-unrelated-header-files-and-export-symbol block/cmdline-parser.c
--- a/block/cmdline-parser.c~block-remove-unrelated-header-files-and-export-symbol
+++ a/block/cmdline-parser.c
@@ -4,8 +4,7 @@
  * Written by Cai Zhiyong <caizhiyong@huawei.com>
  *
  */
-#include <linux/buffer_head.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/cmdline-parser.h>
 
 static int parse_subpart(struct cmdline_subpart **subpart, char *partdef)
@@ -159,6 +158,7 @@ void cmdline_parts_free(struct cmdline_p
 		*parts = next_parts;
 	}
 }
+EXPORT_SYMBOL(cmdline_parts_free);
 
 int cmdline_parts_parse(struct cmdline_parts **parts, const char *cmdline)
 {
@@ -206,6 +206,7 @@ fail:
 	cmdline_parts_free(parts);
 	goto done;
 }
+EXPORT_SYMBOL(cmdline_parts_parse);
 
 struct cmdline_parts *cmdline_parts_find(struct cmdline_parts *parts,
 					 const char *bdev)
@@ -214,17 +215,17 @@ struct cmdline_parts *cmdline_parts_find
 		parts = parts->next_parts;
 	return parts;
 }
+EXPORT_SYMBOL(cmdline_parts_find);
 
 /*
  *  add_part()
  *    0 success.
  *    1 can not add so many partitions.
  */
-void cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
-		       int slot,
-		       int (*add_part)(int, struct cmdline_subpart *, void *),
-		       void *param)
-
+int cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
+		      int slot,
+		      int (*add_part)(int, struct cmdline_subpart *, void *),
+		      void *param)
 {
 	sector_t from = 0;
 	struct cmdline_subpart *subpart;
@@ -247,4 +248,7 @@ void cmdline_parts_set(struct cmdline_pa
 		if (add_part(slot, subpart, param))
 			break;
 	}
+
+	return slot;
 }
+EXPORT_SYMBOL(cmdline_parts_set);
diff -puN include/linux/cmdline-parser.h~block-remove-unrelated-header-files-and-export-symbol include/linux/cmdline-parser.h
--- a/include/linux/cmdline-parser.h~block-remove-unrelated-header-files-and-export-symbol
+++ a/include/linux/cmdline-parser.h
@@ -35,9 +35,9 @@ int cmdline_parts_parse(struct cmdline_p
 struct cmdline_parts *cmdline_parts_find(struct cmdline_parts *parts,
 					 const char *bdev);
 
-void cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
-		       int slot,
-		       int (*add_part)(int, struct cmdline_subpart *, void *),
-		       void *param);
+int cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
+		      int slot,
+		      int (*add_part)(int, struct cmdline_subpart *, void *),
+		      void *param);
 
 #endif /* CMDLINEPARSEH */
_

Patches currently in -mm which might be from caizhiyong@huawei.com are

block-remove-unrelated-header-files-and-export-symbol.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib.patch

