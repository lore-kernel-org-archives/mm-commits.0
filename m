From: akpm@linux-foundation.org
Subject: + input-touchpad-not-detected-on-asus-g1s.patch added to -mm tree
Date: Wed, 29 Jul 2009 15:53:31 -0700
Message-ID: <200907292253.n6TMrWPw001974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbZG2Wxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 18:53:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geekypenguin@gmail.com, dtor@mail.ru


The patch titled
     input: touchpad not detected on Asus G1S
has been added to the -mm tree.  Its filename is
     input-touchpad-not-detected-on-asus-g1s.patch

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
Subject: input: touchpad not detected on Asus G1S
From: "Jory A. Pratt" <geekypenguin@gmail.com>

The synaptic touchpad on the Asus G1S is not properly detected when
rebooting machine or on cold boot from time to time.  Adding the Asus G1S
to the noloop exception table resolves the issue, as it allows the AUX IRQ
to be rasied.

# dmidecode 2.10
SMBIOS 2.4 present.

Handle 0x0001, DMI type 1, 27 bytes
System Information
     Manufacturer: ASUSTeK Computer Inc.
     Product Name: G1S
     Version: 1.0
     Serial Number: NF1G7900340285
     UUID: 242481DC-61E7-7EFB-2480-001D606B6A5E
     Wake-up Type: Power Switch
     SKU Number:
     Family:

Signed-off-by: Jory A. Pratt <geekypenguin@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042-x86ia64io.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/input/serio/i8042-x86ia64io.h~input-touchpad-not-detected-on-asus-g1s drivers/input/serio/i8042-x86ia64io.h
--- a/drivers/input/serio/i8042-x86ia64io.h~input-touchpad-not-detected-on-asus-g1s
+++ a/drivers/input/serio/i8042-x86ia64io.h
@@ -78,6 +78,14 @@ static struct dmi_system_id __initdata i
 		},
 	},
 	{
+		.ident = "ASUS G1S",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "G1S"),
+			DMI_MATCH(DMI_BOARD_VERSION, "1.0"),
+		},
+	},
+	{
 		/* AUX LOOP command does not raise AUX IRQ */
 		.ident = "ASUS P65UP5",
 		.matches = {
_

Patches currently in -mm which might be from geekypenguin@gmail.com are

input-touchpad-not-detected-on-asus-g1s.patch

