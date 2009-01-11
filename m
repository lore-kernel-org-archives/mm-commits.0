From: akpm@linux-foundation.org
Subject: - serio_raw-add-support-for-translated-serio_i8042xl-ports.patch removed from -mm tree
Date: Sun, 11 Jan 2009 00:02:28 -0800
Message-ID: <200901110802.n0B82Snx006989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbZAKIC7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Jan 2009 03:02:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: niels.devos@wincor-nixdorf.com, dmitry.torokhov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     serio_raw: add support for translated (SERIO_I8042XL) ports
has been removed from the -mm tree.  Its filename was
     serio_raw-add-support-for-translated-serio_i8042xl-ports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -378,6 +378,12 @@ static struct serio_device_id serio_raw_
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

origin.patch
serio_raw-add-support-for-translated-serio_i8042xl-ports.patch

