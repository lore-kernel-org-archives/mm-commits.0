From: akpm@linux-foundation.org
Subject: [merged] eeepc-laptop-restore-acpi_generate_proc_event.patch removed from -mm tree
Date: Tue, 03 Mar 2009 11:42:52 -0800
Message-ID: <200903031942.n23JgqbN029448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754024AbZCCTnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 14:43:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corentincj@iksaif.net, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     eeepc-laptop: restore acpi_generate_proc_event()
has been removed from the -mm tree.  Its filename was
     eeepc-laptop-restore-acpi_generate_proc_event.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eeepc-laptop: restore acpi_generate_proc_event()
From: Corentin Chary <corentincj@iksaif.net>

Restore acpi_generate_proc_event() for backward compatibility with old
acpi scripts.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/eeepc-laptop.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/platform/x86/eeepc-laptop.c~eeepc-laptop-restore-acpi_generate_proc_event drivers/platform/x86/eeepc-laptop.c
--- a/drivers/platform/x86/eeepc-laptop.c~eeepc-laptop-restore-acpi_generate_proc_event
+++ a/drivers/platform/x86/eeepc-laptop.c
@@ -557,13 +557,17 @@ static void eeepc_rfkill_notify(acpi_han
 static void eeepc_hotk_notify(acpi_handle handle, u32 event, void *data)
 {
 	static struct key_entry *key;
+	u16 count;
+
 	if (!ehotk)
 		return;
 	if (event >= NOTIFY_BRN_MIN && event <= NOTIFY_BRN_MAX)
 		notify_brn();
+	count = ehotk->event_count[event % 128]++;
+	acpi_bus_generate_proc_event(ehotk->device, event, count);
 	acpi_bus_generate_netlink_event(ehotk->device->pnp.device_class,
 					dev_name(&ehotk->device->dev), event,
-					ehotk->event_count[event % 128]++);
+					count);
 	if (ehotk->inputdev) {
 		key = eepc_get_entry_by_scancode(event);
 		if (key) {
_

Patches currently in -mm which might be from corentincj@iksaif.net are

linux-next.patch

