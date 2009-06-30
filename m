From: akpm@linux-foundation.org
Subject: + lis3-add-power-management-functions-fix.patch added to -mm tree
Date: Tue, 30 Jun 2009 15:02:04 -0700
Message-ID: <200906302202.n5UM24ru026389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759530AbZF3WCY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 18:02:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, daniel@caiaq.de, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     hwmon: fix lis3-spi for CONFIG_PM=n
has been added to the -mm tree.  Its filename is
     lis3-add-power-management-functions-fix.patch

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
Subject: hwmon: fix lis3-spi for CONFIG_PM=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error when CONFIG_PM=n:

The suspend & resume function names are incorrect for the PM=n case.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d_spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/lis3lv02d_spi.c~lis3-add-power-management-functions-fix drivers/hwmon/lis3lv02d_spi.c
--- a/drivers/hwmon/lis3lv02d_spi.c~lis3-add-power-management-functions-fix
+++ a/drivers/hwmon/lis3lv02d_spi.c
@@ -109,8 +109,8 @@ static int lis3lv02d_spi_resume(struct s
 }
 
 #else
-#define lis3_spi_suspend	NULL
-#define lis3_spi_resume		NULL
+#define lis3lv02d_spi_suspend	NULL
+#define lis3lv02d_spi_resume	NULL
 #endif
 
 static struct spi_driver lis302dl_spi_driver = {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-doc-move-ignoring-kmemcheck.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
lis3-add-power-management-functions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch

