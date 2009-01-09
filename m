From: akpm@linux-foundation.org
Subject: - acpi-dock-terminate-eject-request-is-the-dock-is-not-present.patch removed from -mm tree
Date: Fri, 09 Jan 2009 13:25:51 -0800
Message-ID: <200901092125.n09LPpJa008961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754104AbZAIV0h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 16:26:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marvin@mydatex.cz, hmacht@suse.de, lenb@kernel.org, rui.zhang@intel.com, shaohua.li@intel.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi dock: terminate eject request is the dock is not present
has been removed from the -mm tree.  Its filename was
     acpi-dock-terminate-eject-request-is-the-dock-is-not-present.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi dock: terminate eject request is the dock is not present
From: Daniel Smolik <marvin@mydatex.cz>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=12360

nfi if it's right - I merged it so it wouldn't get lost.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: <hmacht@suse.de>
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

