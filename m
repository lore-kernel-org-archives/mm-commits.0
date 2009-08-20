From: akpm@linux-foundation.org
Subject: + dell_laptop-when-the-hardware-switch-is-disabled-dont-actually-allow-changing-the-softblock-status.patch added to -mm tree
Date: Thu, 20 Aug 2009 14:52:55 -0700
Message-ID: <200908202152.n7KLqt3m029602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751817AbZHTVxx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 17:53:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Mario_Limonciello@Dell.com


The patch titled
     dell_laptop: when the "hardware" switch is disabled, don't actually allow changing the softblock status.
has been added to the -mm tree.  Its filename is
     dell_laptop-when-the-hardware-switch-is-disabled-dont-actually-allow-changing-the-softblock-status.patch

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
Subject: dell_laptop: when the "hardware" switch is disabled, don't actually allow changing the softblock status.
From: Mario Limonciello <Mario_Limonciello@Dell.com>

The "hardware" switch is tied directly to a BIOS interface that will
connect and disconnect the hardware from the bus.

If you use the software interface to request the BIOS to make these
changes, the HW switch will be in an inconsistent state and LEDs may not
reflect the state of the HW.

Signed-off-by: Mario Limonciello <Mario_Limonciello@Dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/dell-laptop.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/platform/x86/dell-laptop.c~dell_laptop-when-the-hardware-switch-is-disabled-dont-actually-allow-changing-the-softblock-status drivers/platform/x86/dell-laptop.c
--- a/drivers/platform/x86/dell-laptop.c~dell_laptop-when-the-hardware-switch-is-disabled-dont-actually-allow-changing-the-softblock-status
+++ a/drivers/platform/x86/dell-laptop.c
@@ -181,6 +181,10 @@ static int dell_rfkill_set(void *data, b
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

dell_laptop-when-the-hardware-switch-is-disabled-dont-actually-allow-changing-the-softblock-status.patch

