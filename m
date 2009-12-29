From: akpm@linux-foundation.org
Subject: [merged] emi62-fix-crash-when-trying-to-load-emi-62-firmware.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:31:46 -0800
Message-ID: <200912292131.nBTLVkHg008512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbZL2Vcg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:32:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clemens@ladisch.de, David.Woodhouse@intel.com, greg@kroah.com, retroeffective@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     emi62: fix crash when trying to load EMI 6|2 firmware
has been removed from the -mm tree.  Its filename was
     emi62-fix-crash-when-trying-to-load-emi-62-firmware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: emi62: fix crash when trying to load EMI 6|2 firmware
From: Clemens Ladisch <clemens@ladisch.de>

While converting emi62 to use request_firmware(), the driver was also
changed to use the ihex helper functions.  However, this broke the loading
of the FPGA firmware because the code tries to access the addr field of
the EOF record which works with a plain array that has an empty last
record but not with the ihex helper functions where the end of the data is
signaled with a NULL record pointer, resulting in:

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<f80d248c>] emi62_load_firmware+0x33c/0x740 [emi62]

This can be fixed by changing the loop condition to test the return value
of ihex_next_binrec() directly (like in emi26.c).

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-and-tested-by: Der Mickster <retroeffective@gmail.com>
Acked-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/emi62.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/misc/emi62.c~emi62-fix-crash-when-trying-to-load-emi-62-firmware drivers/usb/misc/emi62.c
--- a/drivers/usb/misc/emi62.c~emi62-fix-crash-when-trying-to-load-emi-62-firmware
+++ a/drivers/usb/misc/emi62.c
@@ -167,7 +167,7 @@ static int emi62_load_firmware (struct u
 			err("%s - error loading firmware: error = %d", __func__, err);
 			goto wraperr;
 		}
-	} while (i > 0);
+	} while (rec);
 
 	/* Assert reset (stop the CPU in the EMI) */
 	err = emi62_set_reset(dev,1);
_

Patches currently in -mm which might be from clemens@ladisch.de are

linux-next.patch

