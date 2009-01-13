From: akpm@linux-foundation.org
Subject: + drivers-net-irda-irda-usbc-fix-buffer-overflow.patch added to -mm tree
Date: Tue, 13 Jan 2009 13:30:45 -0800
Message-ID: <200901132130.n0DLUjhI014094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753018AbZAMVbo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 16:31:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josevteg@gmail.com, davem@davemloft.net, linville@tuxdriver.com, samuel@sortiz.org, stable@kernel.org


The patch titled
     drivers/net/irda/irda-usb.c: fix buffer overflow
has been added to the -mm tree.  Its filename is
     drivers-net-irda-irda-usbc-fix-buffer-overflow.patch

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
Subject: drivers/net/irda/irda-usb.c: fix buffer overflow
From: Jos-Vicente Gilabert <josevteg@gmail.com>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=12397

We're doing an sprintf of an 11-char string into an 11-char buffer. 
Whoops.  It breaks firmware uploading.

Reported-by: Jos-Vicente Gilabert <josevteg@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/irda-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/irda/irda-usb.c~drivers-net-irda-irda-usbc-fix-buffer-overflow drivers/net/irda/irda-usb.c
--- a/drivers/net/irda/irda-usb.c~drivers-net-irda-irda-usbc-fix-buffer-overflow
+++ a/drivers/net/irda/irda-usb.c
@@ -1073,7 +1073,7 @@ static int stir421x_patch_device(struct 
 {
 	unsigned int i;
 	int ret;
-	char stir421x_fw_name[11];
+	char stir421x_fw_name[12];
 	const struct firmware *fw;
 	const unsigned char *fw_version_ptr; /* pointer to version string */
 	unsigned long fw_version = 0;
_

Patches currently in -mm which might be from josevteg@gmail.com are

drivers-net-irda-irda-usbc-fix-buffer-overflow.patch

