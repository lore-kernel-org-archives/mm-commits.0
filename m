From: akpm@linux-foundation.org
Subject: + eeepc-laptop-restore-acpi_generate_proc_event.patch added to -mm tree
Date: Tue, 24 Feb 2009 14:07:58 -0800
Message-ID: <200902242207.n1OM7wGo015064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543AbZBXWI6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 17:08:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: corentincj@iksaif.net, lenb@kernel.org


The patch titled
     eeepc-laptop: restore acpi_generate_proc_event()
has been added to the -mm tree.  Its filename is
     eeepc-laptop-restore-acpi_generate_proc_event.patch

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
eeepc-laptop-fix-kconfig.patch
asus-laptop-restore-acpi_generate_proc_event.patch
eeepc-laptop-restore-acpi_generate_proc_event.patch
asus-laptop-use-select-instead-of-depends-on.patch

