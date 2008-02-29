From: akpm@linux-foundation.org
Subject: + acpi-make-real-parent-for-acpi-button-input-devices.patch added to -mm tree
Date: Thu, 28 Feb 2008 17:27:30 -0800
Message-ID: <200802290127.m1T1RUWs031305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:32844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753945AbYB2B3e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 20:29:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arvidjaar@mail.ru, dtor@mail.ru, lenb@kernel.org


The patch titled
     acpi: make real parent for ACPI button input devices
has been added to the -mm tree.  Its filename is
     acpi-make-real-parent-for-acpi-button-input-devices.patch

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
Subject: acpi: make real parent for ACPI button input devices
From: Andrey Borzenkov <arvidjaar@mail.ru>

Make sure input device for ACPI button gets proper place in device tree.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Len Brown <lenb@kernel.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/button.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/acpi/button.c~acpi-make-real-parent-for-acpi-button-input-devices drivers/acpi/button.c
--- a/drivers/acpi/button.c~acpi-make-real-parent-for-acpi-button-input-devices
+++ a/drivers/acpi/button.c
@@ -449,6 +449,7 @@ static int acpi_button_add(struct acpi_d
 	input->phys = button->phys;
 	input->id.bustype = BUS_HOST;
 	input->id.product = button->type;
+	input->dev.parent = &device->dev;
 
 	switch (button->type) {
 	case ACPI_BUTTON_TYPE_POWER:
_

Patches currently in -mm which might be from arvidjaar@mail.ru are

acpi-add-acpi-aliases-to-toshiba_acpi-module.patch
acpi-make-real-parent-for-acpi-button-input-devices.patch
e100-do-suspend-shutdown-like-e1000.patch

