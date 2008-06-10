From: akpm@linux-foundation.org
Subject: + driver-char-generic_nvram-fix-banner.patch added to -mm tree
Date: Tue, 10 Jun 2008 16:34:59 -0700
Message-ID: <200806102334.m5ANYxO2002778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753201AbYFJXfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 19:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: phdm@macqel.be, arjan@linux.intel.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     driver/char/generic_nvram: fix banner
has been added to the -mm tree.  Its filename is
     driver-char-generic_nvram-fix-banner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: driver/char/generic_nvram: fix banner
From: Philippe De Muyter <phdm@macqel.be>

The generic nvram driver announces itself as
	'Macintosh non-volatile memory driver'
instead of 'Generic non-volatile memory driver'.  Fix that.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/generic_nvram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/generic_nvram.c~driver-char-generic_nvram-fix-banner drivers/char/generic_nvram.c
--- a/drivers/char/generic_nvram.c~driver-char-generic_nvram-fix-banner
+++ a/drivers/char/generic_nvram.c
@@ -133,7 +133,7 @@ static struct miscdevice nvram_dev = {
 
 int __init nvram_init(void)
 {
-	printk(KERN_INFO "Macintosh non-volatile memory driver v%s\n",
+	printk(KERN_INFO "Generic non-volatile memory driver v%s\n",
 		NVRAM_VERSION);
 	return misc_register(&nvram_dev);
 }
_

Patches currently in -mm which might be from phdm@macqel.be are

driver-video-cirrusfb-fix-ram-address-printk.patch
driver-video-cirrusfb-fix-ram-address-printk-fix.patch
m68knommu-init-coldfire-timer-trr-with-n-1-not-n.patch
driver-char-generic_nvram-fix-banner.patch

