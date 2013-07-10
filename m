From: akpm@linux-foundation.org
Subject: + firmware-dmi_scan-drop-oom-messages.patch added to -mm tree
Date: Wed, 10 Jul 2013 14:34:44 -0700
Message-ID: <51ddd374.pNkMVHAV7OnG+D+q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab3GJVep (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jul 2013 17:34:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, jdelvare@suse.de

Subject: + firmware-dmi_scan-drop-oom-messages.patch added to -mm tree
To: jdelvare@suse.de,joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 10 Jul 2013 14:34:44 -0700


The patch titled
     Subject: firmware/dmi_scan: drop OOM messages
has been added to the -mm tree.  Its filename is
     firmware-dmi_scan-drop-oom-messages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/firmware-dmi_scan-drop-oom-messages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/firmware-dmi_scan-drop-oom-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: firmware/dmi_scan: drop OOM messages

As reported by Joe Perches: OOM messages generally aren't useful. 
dmi_alloc is either a trivial front-end to kzalloc, and kzalloc already
does a dump_stack() when OOM, or for x86, dmi_alloc uses extend_brk which
BUGs when unsuccessful.

So we can remove all 6 such log messages in the dmi_scan driver, to shrink
the binary size (by 528 bytes on x86_64.)

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~firmware-dmi_scan-drop-oom-messages drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~firmware-dmi_scan-drop-oom-messages
+++ a/drivers/firmware/dmi_scan.c
@@ -62,8 +62,6 @@ static const char * __init dmi_string(co
 	str = dmi_alloc(len);
 	if (str != NULL)
 		strcpy(str, bp);
-	else
-		pr_err("dmi_string: cannot allocate %Zu bytes.\n", len);
 
 	return str;
 }
@@ -219,10 +217,8 @@ static void __init dmi_save_one_device(i
 		return;
 
 	dev = dmi_alloc(sizeof(*dev) + strlen(name) + 1);
-	if (!dev) {
-		pr_err("dmi_save_one_device: out of memory.\n");
+	if (!dev)
 		return;
-	}
 
 	dev->type = type;
 	strcpy((char *)(dev + 1), name);
@@ -258,10 +254,8 @@ static void __init dmi_save_oem_strings_
 			continue;
 
 		dev = dmi_alloc(sizeof(*dev));
-		if (!dev) {
-			pr_err("dmi_save_oem_strings_devices: out of memory.\n");
+		if (!dev)
 			break;
-		}
 
 		dev->type = DMI_DEV_TYPE_OEM_STRING;
 		dev->name = devname;
@@ -277,18 +271,14 @@ static void __init dmi_save_ipmi_device(
 	void *data;
 
 	data = dmi_alloc(dm->length);
-	if (data == NULL) {
-		pr_err("dmi_save_ipmi_device: out of memory.\n");
+	if (data == NULL)
 		return;
-	}
 
 	memcpy(data, dm, dm->length);
 
 	dev = dmi_alloc(sizeof(*dev));
-	if (!dev) {
-		pr_err("dmi_save_ipmi_device: out of memory.\n");
+	if (!dev)
 		return;
-	}
 
 	dev->type = DMI_DEV_TYPE_IPMI;
 	dev->name = "IPMI controller";
@@ -303,10 +293,9 @@ static void __init dmi_save_dev_onboard(
 	struct dmi_dev_onboard *onboard_dev;
 
 	onboard_dev = dmi_alloc(sizeof(*onboard_dev) + strlen(name) + 1);
-	if (!onboard_dev) {
-		pr_err("dmi_save_dev_onboard: out of memory.\n");
+	if (!onboard_dev)
 		return;
-	}
+
 	onboard_dev->instance = instance;
 	onboard_dev->segment = segment;
 	onboard_dev->bus = bus;
_

Patches currently in -mm which might be from jdelvare@suse.de are

origin.patch
linux-next.patch
dmi_scan-add-comments-on-dmi_present-and-the-loop-in-dmi_scan_machine.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch

