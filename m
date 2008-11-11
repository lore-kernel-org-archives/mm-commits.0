From: akpm@linux-foundation.org
Subject: + physmap-make-map_info-customizable.patch added to -mm tree
Date: Tue, 11 Nov 2008 15:16:42 -0800
Message-ID: <200811112316.mABNGgfp008924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526AbYKKXRS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Nov 2008 18:17:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp


The patch titled
     physmap: make map_info customizable
has been added to the -mm tree.  Its filename is
     physmap-make-map_info-customizable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: physmap: make map_info customizable
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Add a hook to physmap_flash_data for map_info initialization.  This makes
platform code can customize map operations.

Background: I wrote this patch to support RBTX4939 board, which requires
custom map->{read,write,copy_from} function.  I think extending the
physmap driver is better than adding a new map driver.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/physmap.c  |    5 ++++-
 include/linux/mtd/physmap.h |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/maps/physmap.c~physmap-make-map_info-customizable drivers/mtd/maps/physmap.c
--- a/drivers/mtd/maps/physmap.c~physmap-make-map_info-customizable
+++ a/drivers/mtd/maps/physmap.c
@@ -136,7 +136,10 @@ static int physmap_flash_probe(struct pl
 			goto err_out;
 		}
 
-		simple_map_init(&info->map[i]);
+		if (physmap_data->map_init)
+			(*physmap_data->map_init)(&info->map[i]);
+		else
+			simple_map_init(&info->map[i]);
 
 		probe_type = rom_probe_types;
 		for (; info->mtd[i] == NULL && *probe_type != NULL; probe_type++)
diff -puN include/linux/mtd/physmap.h~physmap-make-map_info-customizable include/linux/mtd/physmap.h
--- a/include/linux/mtd/physmap.h~physmap-make-map_info-customizable
+++ a/include/linux/mtd/physmap.h
@@ -25,6 +25,7 @@ struct physmap_flash_data {
 	void			(*set_vpp)(struct map_info *, int);
 	unsigned int		nr_parts;
 	struct mtd_partition	*parts;
+	void			(*map_init)(struct map_info *map);
 };
 
 /*
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

linux-next.patch
physmap-make-map_info-customizable.patch
physmap-fix-memory-leak-on-physmap_flash_remove-by-using-devres.patch

