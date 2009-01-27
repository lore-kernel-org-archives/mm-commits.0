From: akpm@linux-foundation.org
Subject: + acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read.patch added to -mm tree
Date: Tue, 27 Jan 2009 13:05:16 -0800
Message-ID: <200901272105.n0RL5HVm017707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756111AbZA0VGF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 16:06:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hmacht@suse.de, Li@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org, marvin@mydatex.cz, rui.zhang@intel.com, shaohua.li@intel.com, stable@kernel.org


The patch titled
     acpi: dock: don't evaluate _STA on every show_docked sysfs read
has been added to the -mm tree.  Its filename is
     acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read.patch

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
Subject: acpi: dock: don't evaluate _STA on every show_docked sysfs read
From: Holger Macht <hmacht@suse.de>

Some devices trigger a DEVICE_CHECK on every evalutation of _STA.  This
can also be seen in commit 8b59560a3baf2e7c24e0fb92ea5d09eca92805db (ACPI:
dock: avoid check _STA method).  If an undock is processed, the dock
driver sends a uevent and userspace might read the show_docked property in
sysfs.  This causes an evaluation of _STA of the particular device which
causes the dock driver to immediately dock again.

In any case, evaluation of _STA (show_docked) does not necessarily mean
that we are docked, so check with the internal device structure.

http://bugzilla.kernel.org/show_bug.cgi?id=12360

Signed-off-by: Holger Macht <hmacht@suse.de>
Reported-by: Daniel Smolik <marvin@mydatex.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: <Li@suse.de>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/dock.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/dock.c~acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read
+++ a/drivers/acpi/dock.c
@@ -855,10 +855,14 @@ fdd_out:
 static ssize_t show_docked(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
+	struct acpi_device *tmp;
+
 	struct dock_station *dock_station = *((struct dock_station **)
 		dev->platform_data);
-	return snprintf(buf, PAGE_SIZE, "%d\n", dock_present(dock_station));
 
+	if (ACPI_SUCCESS(acpi_bus_get_device(dock_station->handle, &tmp)))
+		return snprintf(buf, PAGE_SIZE, "1\n");
+	return snprintf(buf, PAGE_SIZE, "0\n");
 }
 static DEVICE_ATTR(docked, S_IRUGO, show_docked, NULL);
 
_

Patches currently in -mm which might be from hmacht@suse.de are

acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read.patch
acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read-simplification.patch

