From: akpm@linux-foundation.org
Subject: - acpi-set-flag-dock_undocking-when-triggered-via-sysfs.patch removed from -mm tree
Date: Tue, 18 Mar 2008 16:23:12 -0700
Message-ID: <200803182323.m2INNCtO021286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755193AbYCSTln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hmacht@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: set flag DOCK_UNDOCKING when triggered via sysfs
has been removed from the -mm tree.  Its filename was
     acpi-set-flag-dock_undocking-when-triggered-via-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: set flag DOCK_UNDOCKING when triggered via sysfs
From: Holger Macht <hmacht@suse.de>

begin_undock() is only called when triggered via a acpi notify handler
(pressing the undock button on the dock station), but complete_undock() is
always called after the eject.  So if a undock is triggered through a sysfs
write, the flag DOCK_UNDOCKING has to be set for the dock station, too. 
Otherwise this will freeze the system hard.

Signed-off-by: Holger Macht <hmacht@suse.de>
Cc: Len Brown <lenb@kernel.org>
Acked-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/dock.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/acpi/dock.c~acpi-set-flag-dock_undocking-when-triggered-via-sysfs drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-set-flag-dock_undocking-when-triggered-via-sysfs
+++ a/drivers/acpi/dock.c
@@ -710,6 +710,7 @@ static ssize_t write_undock(struct devic
 	if (!count)
 		return -EINVAL;
 
+	begin_undock(dock_station);
 	ret = handle_eject_request(dock_station, ACPI_NOTIFY_EJECT_REQUEST);
 	return ret ? ret: count;
 }
_

Patches currently in -mm which might be from hmacht@suse.de are

origin.patch
git-acpi.patch

