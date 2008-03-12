From: akpm@linux-foundation.org
Subject: + acpi-set-flag-dock_undocking-when-triggered-via-sysfs.patch added to -mm tree
Date: Tue, 11 Mar 2008 22:35:26 -0700
Message-ID: <200803120535.m2C5ZQwe012261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752842AbYCLFgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 01:36:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hmacht@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org, stable@kernel.org


The patch titled
     acpi: set flag DOCK_UNDOCKING when triggered via sysfs
has been added to the -mm tree.  Its filename is
     acpi-set-flag-dock_undocking-when-triggered-via-sysfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: <stable@kernel.org>
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

git-acpi.patch
acpi-set-flag-dock_undocking-when-triggered-via-sysfs.patch

