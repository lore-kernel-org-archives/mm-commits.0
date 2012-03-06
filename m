From: akpm@linux-foundation.org
Subject: + backlight-lp855x_bl-silence-a-compiler-warning.patch added to -mm tree
Date: Tue, 06 Mar 2012 15:56:37 -0800
Message-ID: <20120306235637.B269BA01B8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:36367 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2CFX4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 18:56:38 -0500
Received: by ggnd2 with SMTP id d2so715761ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 15:56:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, FlorianSchandinat@gmx.de, milo.kim@ti.com


The patch titled
     Subject: drivers/video/backlight/lp855x_bl.c: silence a compiler warning
has been added to the -mm tree.  Its filename is
     backlight-lp855x_bl-silence-a-compiler-warning.patch

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
Subject: Subject: drivers/video/backlight/lp855x_bl.c: silence a compiler warning

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
thermal-spear13xx-checking-for-null-instead-of-is_err.patch
slab-introduce-kmalloc_array.patch
mm-compaction-make-compact_control-order-signed.patch
mm-compaction-make-compact_control-order-signed-fix.patch
backlight-lp855x_bl-silence-a-compiler-warning.patch
drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch
epoll-remove-unneeded-variable-in-reverse_path_check.patch

