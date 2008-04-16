From: akpm@linux-foundation.org
Subject: - usb-serial-fix-regression-in-visor-palm-os-module-for-kernels-=-2624.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:45:49 -0700
Message-ID: <200804162245.m3GMjnC1010723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbYDPWqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 18:46:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brad+debian@swatter.net, brad+kernel@swatter.net, mm-commits@vger.kernel.org


The patch titled
     usb-serial: fix regression in Visor/Palm OS module for kernels >= 2.6.24
has been removed from the -mm tree.  Its filename was
     usb-serial-fix-regression-in-visor-palm-os-module-for-kernels-=-2624.patch

This patch was dropped because this code got deleted in Greg's tree. Hopefully the bug got fixed too?

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
@@ -221,7 +221,7 @@ static struct usb_serial_driver clie_5_d
 	.id_table =		clie_id_5_table,
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

