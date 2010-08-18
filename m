From: akpm@linux-foundation.org
Subject: + cciss-disable-doorbell-reset-on-reset_devices.patch added to -mm tree
Date: Wed, 18 Aug 2010 15:50:59 -0700
Message-ID: <201008182250.o7IMoxVL016550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208Ab0HRWvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 18:51:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, axboe@kernel.dk, brace@beardog.cce.hp.com, mikem@beardog.cce.hp.com


The patch titled
     cciss: disable doorbell reset on reset_devices
has been added to the -mm tree.  Its filename is
     cciss-disable-doorbell-reset-on-reset_devices.patch

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
Subject: cciss: disable doorbell reset on reset_devices
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

The doorbell reset initially appears to work correctly, the controller
resets, comes up, some i/o can even be done, but on at least some Smart
Arrays in some servers, it eventually causes a subsequent controller
lockup due to some kind of PCIe error, and kdump can end up leaving the
root filesystem in an unbootable state.  For this reason, until the
problem is fixed, or at least isolated to certain hardware enough to be
avoided, the doorbell reset should not be used at all.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Cc: <brace@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/block/cciss.c~cciss-disable-doorbell-reset-on-reset_devices drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-disable-doorbell-reset-on-reset_devices
+++ a/drivers/block/cciss.c
@@ -4519,6 +4519,12 @@ static __devinit int cciss_kdump_hard_re
 	misc_fw_support = readl(&cfgtable->misc_fw_support);
 	use_doorbell = misc_fw_support & MISC_FW_DOORBELL_RESET;
 
+	/* The doorbell reset seems to cause lockups on some Smart
+	 * Arrays (e.g. P410, P410i, maybe others).  Until this is
+	 * fixed or at least isolated, avoid the doorbell reset.
+	 */
+	use_doorbell = 0;
+
 	rc = cciss_controller_hard_reset(pdev, vaddr, use_doorbell);
 	if (rc)
 		goto unmap_cfgtable;
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

cciss-disable-doorbell-reset-on-reset_devices.patch

