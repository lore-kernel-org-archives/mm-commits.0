From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-s6e63m0c-fix-corruption-storing-gamma-mode.patch added to -mm tree
Date: Tue, 06 Mar 2012 15:57:35 -0800
Message-ID: <20120306235735.5A7B3A01B8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:35633 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670Ab2CFX5g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 18:57:36 -0500
Received: by ggnd2 with SMTP id d2so715847ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 15:57:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, FlorianSchandinat@gmx.de, inki.dae@samsung.com


The patch titled
     Subject: drivers/video/backlight/s6e63m0.c: fix corruption storing gamma mode
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-s6e63m0c-fix-corruption-storing-gamma-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/video/backlight/s6e63m0.c: fix corruption storing gamma mode

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
drivers-video-backlight-s6e63m0c-fix-corruption-storing-gamma-mode.patch
thermal-spear13xx-checking-for-null-instead-of-is_err.patch
slab-introduce-kmalloc_array.patch
mm-compaction-make-compact_control-order-signed.patch
mm-compaction-make-compact_control-order-signed-fix.patch
backlight-lp855x_bl-silence-a-compiler-warning.patch
drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch
epoll-remove-unneeded-variable-in-reverse_path_check.patch

