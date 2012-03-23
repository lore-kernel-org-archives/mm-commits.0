From: akpm@linux-foundation.org
Subject: [folded] backlight-lp855x_bl-silence-a-compiler-warning.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:34:57 -0700
Message-ID: <20120323213457.85BEEA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:48759 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755466Ab2CWVe7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Mar 2012 17:34:59 -0400
Received: by laai8 with SMTP id i8so188072laa.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:34:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, FlorianSchandinat@gmx.de, milo.kim@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/lp855x_bl.c: silence a compiler warning
has been removed from the -mm tree.  Its filename was
     backlight-lp855x_bl-silence-a-compiler-warning.patch

This patch was dropped because it was folded into backlight-new-backlight-driver-for-lp855x-devices.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/video/backlight/lp855x_bl.c: silence a compiler warning

Gcc 4.6.2 complains that "end" can be used without being initialized:

drivers/video/backlight/lp855x_bl.c: In function `lp855x_init_registers':
drivers/video/backlight/lp855x_bl.c:78:32: warning: `end' may be used uninitialized in this function [-Wuninitialized]
drivers/video/backlight/lp855x_bl.c:67:12: note: `end' was declared here

I've modified the function to return invalid if we don't recognize the
id string.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x_bl-silence-a-compiler-warning drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x_bl-silence-a-compiler-warning
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -73,6 +73,8 @@ static int lp855x_is_valid_rom_area(stru
 	} else if (strstr(id, "lp8556")) {
 		start = EPROM_START;
 		end = EPROM_END;
+	} else {
+		return 0;
 	}
 
 	return (addr >= start && addr <= end) ? 1 : 0;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
backlight-new-backlight-driver-for-lp855x-devices.patch
drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch
epoll-remove-unneeded-variable-in-reverse_path_check.patch

