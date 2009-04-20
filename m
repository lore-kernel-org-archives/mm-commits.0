From: akpm@linux-foundation.org
Subject: [merged] input-elantechc-make-sure-touchpad-is-really-in-absolute-mode.patch removed from -mm tree
Date: Mon, 20 Apr 2009 11:35:28 -0700
Message-ID: <200904201835.n3KIZSb5012326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754194AbZDTSiT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Apr 2009 14:38:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@opmeer.net, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: elantech.c make sure touchpad is really in absolute mode
has been removed from the -mm tree.  Its filename was
     input-elantechc-make-sure-touchpad-is-really-in-absolute-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: elantech.c make sure touchpad is really in absolute mode
From: Arjan Opmeer <arjan@opmeer.net>

There exist laptops with Elantech touchpads where switching to absolute
mode does not happen, although writing the configuration register succeeds
without error.  Reading back the register afterwards reveils that the
absolute mode bit is not set as if masked out by the touchpad firmware.

Always read back register 0x10, make sure that for hardware version 1 the
absolute mode bit is actually set and fail otherwise.  This prevents the
case where the touchpad is claimed by the Elantech driver but is
nonetheless not working.

Signed-off-by: Arjan Opmeer <arjan@opmeer.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/elantech.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff -puN drivers/input/mouse/elantech.c~input-elantechc-make-sure-touchpad-is-really-in-absolute-mode drivers/input/mouse/elantech.c
--- a/drivers/input/mouse/elantech.c~input-elantechc-make-sure-touchpad-is-really-in-absolute-mode
+++ a/drivers/input/mouse/elantech.c
@@ -375,9 +375,14 @@ static int elantech_set_absolute_mode(st
 			rc = -1;
 			break;
 		}
+	}
+
+	if (rc == 0) {
 		/*
-		 * Read back reg 0x10. The touchpad is probably initalising
-		 * and not ready until we read back the value we just wrote.
+		 * Read back reg 0x10. For hardware version 1 we must make
+		 * sure the absolute mode bit is set. For hardware version 2
+		 * the touchpad is probably initalising and not ready until
+		 * we read back the value we just wrote.
 		 */
 		do {
 			rc = elantech_read_reg(psmouse, 0x10, &val);
@@ -388,9 +393,17 @@ static int elantech_set_absolute_mode(st
 				tries);
 			msleep(ETP_READ_BACK_DELAY);
 		} while (tries > 0);
-		if (rc)
+
+		if (rc) {
 			pr_err("elantech.c: failed to read back register 0x10.\n");
-		break;
+		} else {
+			if (etd->hw_version == 1 &&
+			    val & ETP_R10_ABSOLUTE_MODE == 0) {
+				pr_err("elantech.c: touchpad refuses "
+					"to have absolute mode bit set\n");
+				rc = -1;
+			}
+		}
 	}
 
 	if (rc)
_

Patches currently in -mm which might be from arjan@opmeer.net are

linux-next.patch

