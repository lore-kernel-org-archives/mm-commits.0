From: akpm@linux-foundation.org
Subject: + acpi-dock-terminate-eject-request-is-the-dock-is-not-present.patch added to -mm tree
Date: Mon, 05 Jan 2009 15:57:54 -0800
Message-ID: <200901052357.n05NvsKU002139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504AbZAEX6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 18:58:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marvin@mydatex.cz, lenb@kernel.org, rui.zhang@intel.com, stable@kernel.org


The patch titled
     acpi dock: terminate eject request is the dock is not present
has been added to the -mm tree.  Its filename is
     acpi-dock-terminate-eject-request-is-the-dock-is-not-present.patch

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
Subject: acpi dock: terminate eject request is the dock is not present
From: Daniel Smolik <marvin@mydatex.cz>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=12360

nfi if it's right - I merged it so it wouldn't get lost.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: <stable@kernel.org>		[2.6.26.x, 2.6.27.x, 2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/dock.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/acpi/dock.c~acpi-dock-terminate-eject-request-is-the-dock-is-not-present drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-dock-terminate-eject-request-is-the-dock-is-not-present
+++ a/drivers/acpi/dock.c
@@ -668,6 +668,9 @@ EXPORT_SYMBOL_GPL(unregister_hotplug_doc
  */
 static int handle_eject_request(struct dock_station *ds, u32 event)
 {
+	if (!dock_present(ds))
+		return -ENODEV;
+
 	if (dock_in_progress(ds))
 		return -EBUSY;
 
_

Patches currently in -mm which might be from marvin@mydatex.cz are

acpi-dock-terminate-eject-request-is-the-dock-is-not-present.patch

