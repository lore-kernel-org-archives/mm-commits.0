From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-s6e63m0c-fix-corruption-storing-gamma-mode.patch removed from -mm tree
Date: Fri, 16 Mar 2012 13:58:07 -0700
Message-ID: <20120316205807.5E266A0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:42769 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161197Ab2CPU6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Mar 2012 16:58:08 -0400
Received: by ggnd2 with SMTP id d2so767277ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Mar 2012 13:58:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, FlorianSchandinat@gmx.de, inki.dae@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/s6e63m0.c: fix corruption storing gamma mode
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-s6e63m0c-fix-corruption-storing-gamma-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/video/backlight/s6e63m0.c: fix corruption storing gamma mode

strict_strtoul() writes a long but ->gamma_mode only has space to store an
int, so on 64 bit systems we end up scribbling over ->gamma_table_count as
well.  I've changed it to use kstrtouint() instead.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/s6e63m0.c~drivers-video-backlight-s6e63m0c-fix-corruption-storing-gamma-mode drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~drivers-video-backlight-s6e63m0c-fix-corruption-storing-gamma-mode
+++ a/drivers/video/backlight/s6e63m0.c
@@ -690,7 +690,7 @@ static ssize_t s6e63m0_sysfs_store_gamma
 	struct backlight_device *bd = NULL;
 	int brightness, rc;
 
-	rc = strict_strtoul(buf, 0, (unsigned long *)&lcd->gamma_mode);
+	rc = kstrtouint(buf, 0, &lcd->gamma_mode);
 	if (rc < 0)
 		return rc;
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
thermal-spear13xx-checking-for-null-instead-of-is_err.patch
mm-compaction-make-compact_control-order-signed.patch
mm-compaction-make-compact_control-order-signed-fix.patch
backlight-lp855x_bl-silence-a-compiler-warning.patch
drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch
epoll-remove-unneeded-variable-in-reverse_path_check.patch

