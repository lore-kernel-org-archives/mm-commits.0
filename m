From: akpm@linux-foundation.org
Subject: + input-elantechc-make-sure-touchpad-is-really-in-absolute-mode.patch added to -mm tree
Date: Mon, 30 Mar 2009 14:54:45 -0700
Message-ID: <200903302154.n2ULskw5030856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754028AbZC3V46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 17:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@opmeer.net, dtor@mail.ru


The patch titled
     input: elantech.c make sure touchpad is really in absolute mode
has been added to the -mm tree.  Its filename is
     input-elantechc-make-sure-touchpad-is-really-in-absolute-mode.patch

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

input-elantechc-provide-a-workaround-for-jumpy-cursor-on-firmware-234.patch
input-elantechc-make-sure-touchpad-is-really-in-absolute-mode.patch

