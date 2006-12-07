From: akpm@osdl.org
Subject: - swsusp-add-resume_offset-command-line-parameter-rev-2.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:09 -0800
Message-ID: <200612072259.kB7Mx9kB029460@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50957 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163661AbWLGW7e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: add resume_offset command line parameter
has been removed from the -mm tree.  Its filename was
     swsusp-add-resume_offset-command-line-parameter-rev-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: add resume_offset command line parameter
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Add the kernel command line parameter "resume_offset=" allowing us to specify
the offset, in <PAGE_SIZE> units, from the beginning of the partition pointed
to by the "resume=" parameter at which the swap header is located.

This offset can be determined, for example, by an application using the FIBMAP
ioctl to obtain the swap header's block number for given file.

[akpm@osdl.org: we don't know what type sector_t is]
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/disk.c  |   15 +++++++++++++++
 kernel/power/power.h |    1 +
 kernel/power/swap.c  |   15 ++++++++++-----
 3 files changed, 26 insertions(+), 5 deletions(-)

diff -puN kernel/power/disk.c~swsusp-add-resume_offset-command-line-parameter-rev-2 kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-add-resume_offset-command-line-parameter-rev-2
+++ a/kernel/power/disk.c
@@ -27,6 +27,7 @@
 static int noresume = 0;
 char resume_file[256] = CONFIG_PM_STD_PARTITION;
 dev_t swsusp_resume_device;
+sector_t swsusp_resume_block;
 
 /**
  *	power_down - Shut machine down for hibernate.
@@ -423,6 +424,19 @@ static int __init resume_setup(char *str
 	return 1;
 }
 
+static int __init resume_offset_setup(char *str)
+{
+	unsigned long long offset;
+
+	if (noresume)
+		return 1;
+
+	if (sscanf(str, "%llu", &offset) == 1)
+		swsusp_resume_block = offset;
+
+	return 1;
+}
+
 static int __init noresume_setup(char *str)
 {
 	noresume = 1;
@@ -430,4 +444,5 @@ static int __init noresume_setup(char *s
 }
 
 __setup("noresume", noresume_setup);
+__setup("resume_offset=", resume_offset_setup);
 __setup("resume=", resume_setup);
diff -puN kernel/power/power.h~swsusp-add-resume_offset-command-line-parameter-rev-2 kernel/power/power.h
--- a/kernel/power/power.h~swsusp-add-resume_offset-command-line-parameter-rev-2
+++ a/kernel/power/power.h
@@ -42,6 +42,7 @@ extern const void __nosave_begin, __nosa
 extern unsigned long image_size;
 extern int in_suspend;
 extern dev_t swsusp_resume_device;
+extern sector_t swsusp_resume_block;
 
 extern asmlinkage int swsusp_arch_suspend(void);
 extern asmlinkage int swsusp_arch_resume(void);
diff -puN kernel/power/swap.c~swsusp-add-resume_offset-command-line-parameter-rev-2 kernel/power/swap.c
--- a/kernel/power/swap.c~swsusp-add-resume_offset-command-line-parameter-rev-2
+++ a/kernel/power/swap.c
@@ -161,13 +161,14 @@ static int mark_swapfiles(sector_t start
 {
 	int error;
 
-	bio_read_page(0, &swsusp_header, NULL);
+	bio_read_page(swsusp_resume_block, &swsusp_header, NULL);
 	if (!memcmp("SWAP-SPACE",swsusp_header.sig, 10) ||
 	    !memcmp("SWAPSPACE2",swsusp_header.sig, 10)) {
 		memcpy(swsusp_header.orig_sig,swsusp_header.sig, 10);
 		memcpy(swsusp_header.sig,SWSUSP_SIG, 10);
 		swsusp_header.image = start;
-		error = bio_write_page(0, &swsusp_header, NULL);
+		error = bio_write_page(swsusp_resume_block,
+					&swsusp_header, NULL);
 	} else {
 		printk(KERN_ERR "swsusp: Swap header not found!\n");
 		error = -ENODEV;
@@ -184,7 +185,7 @@ static int swsusp_swap_check(void) /* Th
 {
 	int res;
 
-	res = swap_type_of(swsusp_resume_device, 0);
+	res = swap_type_of(swsusp_resume_device, swsusp_resume_block);
 	if (res < 0)
 		return res;
 
@@ -610,12 +611,16 @@ int swsusp_check(void)
 	if (!IS_ERR(resume_bdev)) {
 		set_blocksize(resume_bdev, PAGE_SIZE);
 		memset(&swsusp_header, 0, sizeof(swsusp_header));
-		if ((error = bio_read_page(0, &swsusp_header, NULL)))
+		error = bio_read_page(swsusp_resume_block,
+					&swsusp_header, NULL);
+		if (error)
 			return error;
+
 		if (!memcmp(SWSUSP_SIG, swsusp_header.sig, 10)) {
 			memcpy(swsusp_header.sig, swsusp_header.orig_sig, 10);
 			/* Reset swap signature now */
-			error = bio_write_page(0, &swsusp_header, NULL);
+			error = bio_write_page(swsusp_resume_block,
+						&swsusp_header, NULL);
 		} else {
 			return -EINVAL;
 		}
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch

