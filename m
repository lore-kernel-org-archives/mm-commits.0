From: akpm@linux-foundation.org
Subject: - acpi-make-real-parent-for-acpi-button-input-devices.patch removed from -mm tree
Date: Thu, 13 Mar 2008 11:59:20 -0700
Message-ID: <200803131859.m2DIxKY0027946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753971AbYCMTDi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:03:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvidjaar@mail.ru, dtor@mail.ru, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: make real parent for ACPI button input devices
has been removed from the -mm tree.  Its filename was
     acpi-make-real-parent-for-acpi-button-input-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-acpi.patch

