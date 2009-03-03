From: akpm@linux-foundation.org
Subject: [merged] asus-laptop-restore-acpi_generate_proc_event.patch removed from -mm tree
Date: Tue, 03 Mar 2009 11:42:50 -0800
Message-ID: <200903031942.n23Jgo93029445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753738AbZCCTnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 14:43:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corentincj@iksaif.net, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     asus-laptop: restore acpi_generate_proc_event()
has been removed from the -mm tree.  Its filename was
     asus-laptop-restore-acpi_generate_proc_event.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asus-laptop: restore acpi_generate_proc_event()
From: Corentin Chary <corentincj@iksaif.net>

Restore acpi_generate_proc_event() for backward compatibility with old
acpi scripts.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/asus-laptop.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/platform/x86/asus-laptop.c~asus-laptop-restore-acpi_generate_proc_event drivers/platform/x86/asus-laptop.c
--- a/drivers/platform/x86/asus-laptop.c~asus-laptop-restore-acpi_generate_proc_event
+++ a/drivers/platform/x86/asus-laptop.c
@@ -815,6 +815,7 @@ static int asus_setkeycode(struct input_
 static void asus_hotk_notify(acpi_handle handle, u32 event, void *data)
 {
 	static struct key_entry *key;
+	u16 count;
 
 	/* TODO Find a better way to handle events count. */
 	if (!hotk)
@@ -832,9 +833,11 @@ static void asus_hotk_notify(acpi_handle
 		lcd_blank(FB_BLANK_POWERDOWN);
 	}
 
+	count = hotk->event_count[event % 128]++;
+	acpi_bus_generate_proc_event(hotk->device, event, count);
 	acpi_bus_generate_netlink_event(hotk->device->pnp.device_class,
 					dev_name(&hotk->device->dev), event,
-					hotk->event_count[event % 128]++);
+					count);
 
 	if (hotk->inputdev) {
 		key = asus_get_entry_by_scancode(event);
_

Patches currently in -mm which might be from corentincj@iksaif.net are

linux-next.patch

