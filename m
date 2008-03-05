From: akpm@linux-foundation.org
Subject: + memstick-fix-parsing-of-assembly_date-attribute-field.patch added to -mm tree
Date: Wed, 05 Mar 2008 15:17:55 -0800
Message-ID: <200803052317.m25NHtgc026696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765227AbYCEXSx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 18:18:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oakad@yahoo.com


The patch titled
     memstick: fix parsing of "assembly_date" attribute field
has been added to the -mm tree.  Its filename is
     memstick-fix-parsing-of-assembly_date-attribute-field.patch

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
Subject: memstick: fix parsing of "assembly_date" attribute field
From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-fix-parsing-of-assembly_date-attribute-field drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-fix-parsing-of-assembly_date-attribute-field
+++ a/drivers/memstick/core/mspro_block.c
@@ -303,6 +303,20 @@ static ssize_t mspro_block_attr_show_sys
 						     dev_attr);
 	struct mspro_sys_info *x_sys = x_attr->data;
 	ssize_t rc = 0;
+	int date_tz = 0, date_tz_f = 0;
+
+	if (x_sys->assembly_date[0] > 0x80U) {
+		date_tz = (~x_sys->assembly_date[0]) + 1;
+		date_tz_f = date_tz & 3;
+		date_tz >>= 2;
+		date_tz = -date_tz;
+		date_tz_f *= 15;
+	} else if (x_sys->assembly_date[0] < 0x80U) {
+		date_tz = x_sys->assembly_date[0];
+		date_tz_f = date_tz & 3;
+		date_tz >>= 2;
+		date_tz_f *= 15;
+	}
 
 	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "class: %x\n",
 			x_sys->class);
@@ -315,8 +329,8 @@ static ssize_t mspro_block_attr_show_sys
 	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "page size: %x\n",
 			be16_to_cpu(x_sys->page_size));
 	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "assembly date: "
-			"%d %04u-%02u-%02u %02u:%02u:%02u\n",
-			x_sys->assembly_date[0],
+			"GMT%+d:%d %04u-%02u-%02u %02u:%02u:%02u\n",
+			date_tz, date_tz_f,
 			be16_to_cpu(*(unsigned short *)
 				    &x_sys->assembly_date[1]),
 			x_sys->assembly_date[3], x_sys->assembly_date[4],
_

Patches currently in -mm which might be from oakad@yahoo.com are

memstick-introduce-correct-definitions-in-the-header.patch
memstick-add-memstick_suspend-resume_host-methods.patch
memstick-make-sure-number-of-command-retries-is-exactly-as-specified.patch
memstick-drop-driver_version-numbers-as-meaningless.patch
tifm-fix-the-memorystick-host-fifo-handling-code.patch
tifm-fix-memorystick-host-initialization-code.patch
tifm-clear-interrupt-mask-bits-before-setting-them-on-adapter-init.patch
memstick-add-support-for-decoding-specfile-media-attributes.patch
memstick-fix-parsing-of-assembly_date-attribute-field.patch
memstick-try-harder-to-recover-from-unsuccessful-interface-mode-switch.patch
memstick-add-support-for-jmicron-jmb38x-memorystick-host-controller.patch

