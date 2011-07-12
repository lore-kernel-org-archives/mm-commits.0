From: akpm@linux-foundation.org
Subject: [merged] drivers-platform-x86-dell-laptopc-revert-dell-laptop-toggle-the-unsupported-hardware-killswitch.patch removed from -mm tree
Date: Tue, 12 Jul 2011 13:00:53 -0700
Message-ID: <201107122000.p6CK0NHq032580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754845Ab1GLUAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jul 2011 16:00:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kengyu@canonical.com, abogani@texware.it, mjg@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/platform/x86/dell-laptop.c: revert "dell-laptop: Toggle the unsupported hardware killswitch"
has been removed from the -mm tree.  Its filename was
     drivers-platform-x86-dell-laptopc-revert-dell-laptop-toggle-the-unsupported-hardware-killswitch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/platform/x86/dell-laptop.c: revert "dell-laptop: Toggle the unsupported hardware killswitch"
From: Keng-Yu Lin <kengyu@canonical.com>

This reverts my commit a3d77411e8b2ad ("dell-laptop: Toggle the
unsupported hardware killswitch").

It caused a mess in the wireless rfkill status on some models.  It is
probably a bad idea to toggle the rfkill for all dell models without the
respect to the claim that it is hardware-controlled.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
Cc: Alessio Igor Bogani <abogani@texware.it>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: <stable@kernel.org>		[2.6.38+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/dell-laptop.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff -puN drivers/platform/x86/dell-laptop.c~drivers-platform-x86-dell-laptopc-revert-dell-laptop-toggle-the-unsupported-hardware-killswitch drivers/platform/x86/dell-laptop.c
--- a/drivers/platform/x86/dell-laptop.c~drivers-platform-x86-dell-laptopc-revert-dell-laptop-toggle-the-unsupported-hardware-killswitch
+++ a/drivers/platform/x86/dell-laptop.c
@@ -292,12 +292,9 @@ static int dell_rfkill_set(void *data, b
 	dell_send_request(buffer, 17, 11);
 
 	/* If the hardware switch controls this radio, and the hardware
-	   switch is disabled, don't allow changing the software state.
-	   If the hardware switch is reported as not supported, always
-	   fire the SMI to toggle the killswitch. */
+	   switch is disabled, don't allow changing the software state */
 	if ((hwswitch_state & BIT(hwswitch_bit)) &&
-	    !(buffer->output[1] & BIT(16)) &&
-	    (buffer->output[1] & BIT(0))) {
+	    !(buffer->output[1] & BIT(16))) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -403,23 +400,6 @@ static const struct file_operations dell
 
 static void dell_update_rfkill(struct work_struct *ignored)
 {
-	int status;
-
-	get_buffer();
-	dell_send_request(buffer, 17, 11);
-	status = buffer->output[1];
-	release_buffer();
-
-	/* if hardware rfkill is not supported, set it explicitly */
-	if (!(status & BIT(0))) {
-		if (wifi_rfkill)
-			dell_rfkill_set((void *)1, !((status & BIT(17)) >> 17));
-		if (bluetooth_rfkill)
-			dell_rfkill_set((void *)2, !((status & BIT(18)) >> 18));
-		if (wwan_rfkill)
-			dell_rfkill_set((void *)3, !((status & BIT(19)) >> 19));
-	}
