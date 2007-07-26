From: akpm@linux-foundation.org
Subject: + fbdev-export-fb_destroy_modelist.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:15 -0700
Message-ID: <200707261900.l6QJ0FFg015598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42828 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763168AbXGZTA2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:00:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, adaplas@gmail.com


The patch titled
     fbdev: export fb_destroy_modelist
has been added to the -mm tree.  Its filename is
     fbdev-export-fb_destroy_modelist.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: export fb_destroy_modelist
From: Michal Januszewski <spock@gentoo.org>

Make fb_destroy_modelist an exported symbol for use in the uvesafb driver.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/modedb.c~fbdev-export-fb_destroy_modelist drivers/video/modedb.c
--- a/drivers/video/modedb.c~fbdev-export-fb_destroy_modelist
+++ a/drivers/video/modedb.c
@@ -938,6 +938,7 @@ void fb_destroy_modelist(struct list_hea
 		kfree(pos);
 	}
 }
+EXPORT_SYMBOL_GPL(fb_destroy_modelist);
 
 /**
  * fb_videomode_to_modelist: convert mode array to mode list
_

Patches currently in -mm which might be from spock@gentoo.org are

fbdev-export-fb_destroy_modelist.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
uvesafb-the-driver-core.patch
uvesafb-documentation.patch
