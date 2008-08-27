From: akpm@linux-foundation.org
Subject: + serio_raw-add-support-for-translated-serio_i8042xl-ports.patch added to -mm tree
Date: Wed, 27 Aug 2008 16:49:28 -0700
Message-ID: <200808272349.m7RNnSx7029355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754457AbYH0Xtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 19:49:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: niels.devos@wincor-nixdorf.com, dmitry.torokhov@gmail.com


The patch titled
     serio_raw: add support for translated (SERIO_I8042XL) ports
has been added to the -mm tree.  Its filename is
     serio_raw-add-support-for-translated-serio_i8042xl-ports.patch

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
Subject: serio_raw: add support for translated (SERIO_I8042XL) ports
From: "Niels de Vos" <niels.devos@wincor-nixdorf.com>

serio_raw only binds to non-translated devices. Enable serio_raw to
bind to normal (translated) keyboards which can have non-standard
extensions (like POS Keyboards). With this it is possible to send
commands to the device over /dev/serio_raw<n>.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/serio_raw.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/input/serio/serio_raw.c~serio_raw-add-support-for-translated-serio_i8042xl-ports drivers/input/serio/serio_raw.c
--- a/drivers/input/serio/serio_raw.c~serio_raw-add-support-for-translated-serio_i8042xl-ports
+++ a/drivers/input/serio/serio_raw.c
@@ -373,6 +373,12 @@ static struct serio_device_id serio_raw_
 		.id	= SERIO_ANY,
 		.extra	= SERIO_ANY,
 	},
+	{
+		.type   = SERIO_8042_XL,
+		.proto  = SERIO_ANY,
+		.id     = SERIO_ANY,
+		.extra  = SERIO_ANY,
+	},
 	{ 0 }
 };
 
_

Patches currently in -mm which might be from niels.devos@wincor-nixdorf.com are

serio_raw-add-support-for-translated-serio_i8042xl-ports.patch

