From: akpm@linux-foundation.org
Subject: [wrecked] dell_laptop-when-the-hardware-switch-is-disabled-dont-actually-allow-changing-the-softblock-status.patch removed from -mm tree
Date: Mon, 01 Mar 2010 11:31:52 -0800
Message-ID: <201003011931.o21JVq8a027986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118Ab0CATdI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Mar 2010 14:33:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Mario_Limonciello@Dell.com, lenb@kernel.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dell_laptop: when the "hardware" switch is disabled, don't actually allow changing the softblock status.
has been removed from the -mm tree.  Its filename was
     dell_laptop-when-the-hardware-switch-is-disabled-dont-actually-allow-changing-the-softblock-status.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dell_laptop: when the "hardware" switch is disabled, don't actually allow changing the softblock status.
From: Mario Limonciello <Mario_Limonciello@Dell.com>

The "hardware" switch is tied directly to a BIOS interface that will
connect and disconnect the hardware from the bus.

If you use the software interface to request the BIOS to make these
changes, the HW switch will be in an inconsistent state and LEDs may not
reflect the state of the HW.

Signed-off-by: Mario Limonciello <Mario_Limonciello@Dell.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/dell-laptop.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/platform/x86/dell-laptop.c~dell_laptop-when-the-hardware-switch-is-disabled-dont-actually-allow-changing-the-softblock-status drivers/platform/x86/dell-laptop.c
--- a/drivers/platform/x86/dell-laptop.c~dell_laptop-when-the-hardware-switch-is-disabled-dont-actually-allow-changing-the-softblock-status
+++ a/drivers/platform/x86/dell-laptop.c
@@ -189,6 +189,10 @@ static int dell_rfkill_set(void *data, b
 	unsigned long radio = (unsigned long)data;
 
 	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
+	dell_send_request(&buffer, 17, 11);
+	if (!(buffer.output[1] & BIT(16)))
+		return -EINVAL;
+
 	buffer.input[0] = (1 | (radio<<8) | (disable << 16));
 	dell_send_request(&buffer, 17, 11);
 
_

Patches currently in -mm which might be from Mario_Limonciello@Dell.com are

origin.patch
dell_laptop-when-the-hardware-switch-is-disabled-dont-actually-allow-changing-the-softblock-status.patch

