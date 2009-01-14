From: akpm@linux-foundation.org
Subject: + resume-wait-for-device-probing-to-finish.patch added to -mm tree
Date: Wed, 14 Jan 2009 15:49:14 -0800
Message-ID: <200901142349.n0ENnEIT008096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757299AbZANXt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 18:49:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, greg@kroah.com, kay.sievers@vrfy.org, lenb@kernel.org, pavel@suse.cz, rjw@sisk.pl


The patch titled
     resume: wait for device probing to finish
has been added to the -mm tree.  Its filename is
     resume-wait-for-device-probing-to-finish.patch

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
@@ -585,6 +585,12 @@ static int software_resume(void)
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
@@ -600,6 +606,11 @@ static int software_resume(void)
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
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
scripts-add-x86-register-parser-to-markup_oopspl.patch
scripts-add-x86-64-bit-support-to-the-markup_oopspl-script.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch

