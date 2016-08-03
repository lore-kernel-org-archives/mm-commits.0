From: akpm@linux-foundation.org
Subject: [merged]
 fbdev-bfin_adv7393fb-move-driver_name-before-its-first-use.patch removed
 from -mm tree
Date: Wed, 03 Aug 2016 11:12:08 -0700
Message-ID: <57a233f8.dD6jAVzFlty9hABA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbcHCSN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, fengguang.wu@intel.com, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fbdev/bfin_adv7393fb: move DRIVER_NAME before its first use
has been removed from the -mm tree.  Its filename was
     fbdev-bfin_adv7393fb-move-driver_name-before-its-first-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: fbdev/bfin_adv7393fb: move DRIVER_NAME before its first use

Move the DRIVER_NAME macro definition before the first usage site and
fix build error.

Link: http://lkml.kernel.org/r/20160801163937.GA28119@nazgul.tnic
Signed-off-by: Borislav Petkov <bp@suse.de>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/bfin_adv7393fb.c |    2 ++
 drivers/video/fbdev/bfin_adv7393fb.h |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/fbdev/bfin_adv7393fb.c~fbdev-bfin_adv7393fb-move-driver_name-before-its-first-use drivers/video/fbdev/bfin_adv7393fb.c
--- a/drivers/video/fbdev/bfin_adv7393fb.c~fbdev-bfin_adv7393fb-move-driver_name-before-its-first-use
+++ a/drivers/video/fbdev/bfin_adv7393fb.c
@@ -10,6 +10,8 @@
  * TODO: Code Cleanup
  */
 
+#define DRIVER_NAME "bfin-adv7393"
+
 #define pr_fmt(fmt) DRIVER_NAME ": " fmt
 
 #include <linux/module.h>
diff -puN drivers/video/fbdev/bfin_adv7393fb.h~fbdev-bfin_adv7393fb-move-driver_name-before-its-first-use drivers/video/fbdev/bfin_adv7393fb.h
--- a/drivers/video/fbdev/bfin_adv7393fb.h~fbdev-bfin_adv7393fb-move-driver_name-before-its-first-use
+++ a/drivers/video/fbdev/bfin_adv7393fb.h
@@ -59,8 +59,6 @@ enum {
 	BLANK_OFF,
 };
 
-#define DRIVER_NAME "bfin-adv7393"
