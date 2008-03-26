From: akpm@linux-foundation.org
Subject: + usb-serial-fix-regression-in-visor-palm-os-module-for-kernels-=-2624.patch added to -mm tree
Date: Tue, 25 Mar 2008 23:41:46 -0700
Message-ID: <200803260641.m2Q6fkfp001715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbYCZGlz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 02:41:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: brad+debian@swatter.net, brad+kernel@swatter.net


The patch titled
     usb-serial: fix regression in Visor/Palm OS module for kernels >= 2.6.24
has been added to the -mm tree.  Its filename is
     usb-serial-fix-regression-in-visor-palm-os-module-for-kernels-=-2624.patch

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
Subject: usb-serial: fix regression in Visor/Palm OS module for kernels >= 2.6.24
From: Brad Sawatzky <brad+debian@swatter.net>

Fixes a bug/inconsistency revealed by the additional sanity checking in
   commit 063a2da8f01806906f7d7b1a1424b9afddebc443
introduced in the original 2.6.24 branch.

The Handspring Visor / PalmOS 4 device structure defines .num_bulk_out=2
but the usb-serial probe returns num_bulk_out=3, triggering the check in
the above commit and forcing a bail out when the device (a Garmin iQue in
my case) attempts to connect.  The patch bumps the expected number of
endpoints to 3.

I suppose it's possible that the kernel is identifying 3 bulk endpoints
when there should only be 2 and there is some issue with the lower level
endpoint probe?

FWIW, this patch will probably solve the following kernel bug report for
Treo users (identical symptoms, different model PalmOS units):
  <http://bugzilla.kernel.org/show_bug.cgi?id=10118>

Signed-off-by: Brad Sawatzky <brad+kernel@swatter.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/visor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/visor.c~usb-serial-fix-regression-in-visor-palm-os-module-for-kernels-=-2624 drivers/usb/serial/visor.c
--- a/drivers/usb/serial/visor.c~usb-serial-fix-regression-in-visor-palm-os-module-for-kernels-=-2624
+++ a/drivers/usb/serial/visor.c
@@ -191,7 +191,7 @@ static struct usb_serial_driver handspri
 	.id_table =		id_table,
 	.num_interrupt_in =	NUM_DONT_CARE,
 	.num_bulk_in =		2,
-	.num_bulk_out =		2,
+	.num_bulk_out =		3,
 	.num_ports =		2,
 	.open =			visor_open,
 	.close =		visor_close,
_

Patches currently in -mm which might be from brad+debian@swatter.net are

usb-serial-fix-regression-in-visor-palm-os-module-for-kernels-=-2624.patch

