From: akpm@linux-foundation.org
Subject: [merged] resume-wait-for-device-probing-to-finish.patch removed from -mm tree
Date: Fri, 20 Feb 2009 11:21:44 -0800
Message-ID: <200902201921.n1KJLi6j026498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753298AbZBTTWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Feb 2009 14:22:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, greg@kroah.com, kay.sievers@vrfy.org, lenb@kernel.org, pavel@suse.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     resume: wait for device probing to finish
has been removed from the -mm tree.  Its filename was
     resume-wait-for-device-probing-to-finish.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: resume: wait for device probing to finish
From: Arjan van de Ven <arjan@linux.intel.com>

The resume code does not currently wait for device probing to finish. 
Even without async function calls this is dicey and not correct, but with
async function calls during the boot sequence this is going to get hit
more...

This patch adds the synchronization using the newly introduced helper.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN kernel/power/disk.c~resume-wait-for-device-probing-to-finish kernel/power/disk.c
--- a/kernel/power/disk.c~resume-wait-for-device-probing-to-finish
+++ a/kernel/power/disk.c
@@ -595,6 +595,12 @@ static int software_resume(void)
 	unsigned int flags;
 
 	/*
+	 * If the user said "noresume".. bail out early.
+	 */
+	if (noresume)
+		return 0;
+
+	/*
 	 * name_to_dev_t() below takes a sysfs buffer mutex when sysfs
 	 * is configured into the kernel. Since the regular hibernate
 	 * trigger path is via sysfs which takes a buffer mutex before
@@ -610,6 +616,11 @@ static int software_resume(void)
 			mutex_unlock(&pm_mutex);
 			return -ENOENT;
 		}
+		/*
+		 * Some device discovery might still be in progress; we need
+		 * to wait for this to finish.
+		 */
+		wait_for_device_probe();
 		swsusp_resume_device = name_to_dev_t(resume_file);
 		pr_debug("PM: Resume from partition %s\n", resume_file);
 	} else {
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
input-introduce-a-tougher-i8042reset.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch

