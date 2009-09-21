From: akpm@linux-foundation.org
Subject: [folded] lis3-add-power-management-functions-fix.patch removed from -mm tree
Date: Mon, 21 Sep 2009 14:41:52 -0700
Message-ID: <200909212141.n8LLfqrQ011954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752065AbZIUVmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 17:42:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, daniel@caiaq.de, eric.piel@tremplin-utc.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     hwmon: fix lis3-spi for CONFIG_PM=n
has been removed from the -mm tree.  Its filename was
     lis3-add-power-management-functions-fix.patch

This patch was dropped because it was folded into lis3-add-power-management-functions.patch

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
mm-make-swap-token-dummies-static-inlines.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
flex_array-add-missing-kerneldoc-annotations.patch
lis3-add-power-management-functions.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
kcore-register-vmemmap-range-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
docs-fix-various-documentation-paths-in-header-files.patch
reiser4-export-remove_from_page_cache-fix.patch

