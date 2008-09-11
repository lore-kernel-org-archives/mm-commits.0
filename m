From: akpm@linux-foundation.org
Subject: + acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type.patch added to -mm tree
Date: Wed, 10 Sep 2008 17:31:13 -0700
Message-ID: <200809110031.m8B0VDja002276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbYIKAcA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 20:32:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, hare@suse.de, lenb@kernel.org


The patch titled
     acpi: catch calls of acpi_driver_data on pointer of wrong type
has been added to the -mm tree.  Its filename is
     acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: catch calls of acpi_driver_data on pointer of wrong type
From: Pavel Machek <pavel@suse.cz>

Catch attempts to use of acpi_driver_data on pointers of wrong type.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/acpi/acpi_bus.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/acpi/acpi_bus.h~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type include/acpi/acpi_bus.h
--- a/include/acpi/acpi_bus.h~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type
+++ a/include/acpi/acpi_bus.h
@@ -300,7 +300,7 @@ struct acpi_device {
 	enum acpi_bus_removal_type removal_type;	/* indicate for different removal type */
 };
 
-#define acpi_driver_data(d)	((d)->driver_data)
+#define acpi_driver_data(d)	((void) (d == (struct acpi_device *) 0), d)->driver_data
 #define to_acpi_device(d)	container_of(d, struct acpi_device, dev)
 #define to_acpi_driver(d)	container_of(d, struct acpi_driver, drv)
 
_

Patches currently in -mm which might be from pavel@suse.cz are

linux-next.patch
acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type.patch
acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch

