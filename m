From: akpm@osdl.org
Subject: - swsusp-improve-handling-of-highmem-fix.patch removed from -mm tree
Date: Wed, 06 Dec 2006 19:17:21 -0800
Message-ID: <200612070317.kB73HLK3027035@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41700 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967799AbWLGDR3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 22:17:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp-improve-handling-of-highmem fix
has been removed from the -mm tree.  Its filename was
     swsusp-improve-handling-of-highmem-fix.patch

This patch was dropped because it was folded into swsusp-improve-handling-of-highmem.patch

------------------------------------------------------
Subject: swsusp-improve-handling-of-highmem fix
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Fix swsusp to use image_size as documented on systems with lots of highmem.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/swsusp.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/power/swsusp.c~swsusp-improve-handling-of-highmem-fix kernel/power/swsusp.c
--- a/kernel/power/swsusp.c~swsusp-improve-handling-of-highmem-fix
+++ a/kernel/power/swsusp.c
@@ -195,6 +195,7 @@ int swsusp_shrink_memory(void)
 		highmem_size = count_highmem_pages();
 		size = count_data_pages() + PAGES_FOR_IO;
 		tmp = size;
+		size += highmem_size;
 		for_each_zone (zone)
 			if (populated_zone(zone)) {
 				if (is_highmem(zone)) {
@@ -209,7 +210,6 @@ int swsusp_shrink_memory(void)
 		if (highmem_size < 0)
 			highmem_size = 0;
 
-		size += highmem_size;
 		tmp += highmem_size;
 		if (tmp > 0) {
 			tmp = __shrink_memory(tmp);
_

Patches currently in -mm which might be from rjw@sisk.pl are

uswsusp-add-pmops-prepareenterfinish-support-aka-platform-mode.patch
swsusp-use-partition-device-and-offset-to-identify-swap-areas.patch
swsusp-rearrange-swap-handling-code.patch
swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2.patch
swsusp-add-resume_offset-command-line-parameter-rev-2.patch
swsusp-document-support-for-swap-files-rev-2.patch
swsusp-add-ioctl-for-swap-files-support.patch
swsusp-update-userland-interface-documentation.patch
swsusp-improve-handling-of-highmem.patch
swsusp-improve-handling-of-highmem-fix.patch
swsusp-use-__gfp_wait.patch
swsusp-fix-platform-mode.patch
add-include-linux-freezerh-and-move-definitions-from.patch
add-include-linux-freezerh-and-move-definitions-from-ueagle-fix.patch
quieten-freezer-if-config_pm_debug.patch
swsusp-cleanup-whitespace-in-freezer-output.patch
swsusp-thaw-userspace-and-kernel-space-separately.patch
swsusp-support-i386-systems-with-pae-or-without-pse.patch
suspend-dont-change-cpus_allowed-for-task-initiating-the-suspend.patch
swsusp-measure-memory-shrinking-time.patch
suspend-to-disk-fails-if-gdb-is-suspended-with-a-traced-child.patch
convert-pm_sem-to-a-mutex.patch
convert-pm_sem-to-a-mutex-fix.patch
swsusp-untangle-thaw_processes.patch
swsusp-untangle-freeze_processes.patch
swsusp-fix-coding-style-in-suspendc.patch
swsusp-fix-labels.patch
pm-fix-swsusp-debug-mode-testproc.patch
support-for-freezeable-workqueues.patch
use-freezeable-workqueues-in-xfs.patch
make-8250_pnp-serial-driver-work-after.patch
make-8250_pnp-serial-driver-work-after-tidy.patch
md-change-lifetime-rules-for-md-devices.patch

