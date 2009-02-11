From: akpm@linux-foundation.org
Subject: + m68k-count-can-reach-51-not-50.patch added to -mm tree
Date: Wed, 11 Feb 2009 14:26:45 -0800
Message-ID: <200902112226.n1BMQj4W017454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbZBKW1f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 17:27:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, geert@linux-m68k.org


The patch titled
     m68k: count can reach 51, not 50
has been added to the -mm tree.  Its filename is
     m68k-count-can-reach-51-not-50.patch

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
Subject: m68k: count can reach 51, not 50
From: Roel Kluin <roel.kluin@gmail.com>

With while (count++ < 50) { ...  } count can reach 51, not 50, so we
shouldn't give an error message on a count of 50.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/via-maciisi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/macintosh/via-maciisi.c~m68k-count-can-reach-51-not-50 drivers/macintosh/via-maciisi.c
--- a/drivers/macintosh/via-maciisi.c~m68k-count-can-reach-51-not-50
+++ a/drivers/macintosh/via-maciisi.c
@@ -288,7 +288,7 @@ static void maciisi_sync(struct adb_requ
 	}
 	/* This could be BAD... when the ADB controller doesn't respond
 	 * for this long, it's probably not coming back :-( */
-	if(count >= 50) /* Hopefully shouldn't happen */
+	if(count > 50) /* Hopefully shouldn't happen */
 		printk(KERN_ERR "maciisi_send_request: poll timed out!\n");
 }
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
rtc-t-reaches-1-tested-0.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
leds-fix-confusion.patch
paride-pgc-xs-confusion.patch
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
ufs-sector_t-cannot-be-negative.patch

