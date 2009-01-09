From: akpm@linux-foundation.org
Subject: - physmap-make-map_info-customizable.patch removed from -mm tree
Date: Fri, 09 Jan 2009 12:51:17 -0800
Message-ID: <200901092051.n09KpHdV011874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493AbZAIUvX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 15:51:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, mm-commits@vger.kernel.org


The patch titled
     physmap: make map_info customizable
has been removed from the -mm tree.  Its filename was
     physmap-make-map_info-customizable.patch

This patch was dropped because it was nacked

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
@@ -132,7 +132,10 @@ static int physmap_flash_probe(struct pl
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
@@ -26,6 +26,7 @@ struct physmap_flash_data {
 	unsigned int		nr_parts;
 	unsigned int		pfow_base;
 	struct mtd_partition	*parts;
+	void			(*map_init)(struct map_info *map);
 };
 
 /*
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
linux-next.patch
physmap-make-map_info-customizable.patch
atmel_serial-might-lose-modem-status-change.patch

