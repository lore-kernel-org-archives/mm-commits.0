From: akpm@linux-foundation.org
Subject: + firmware-dmi_scan-constify-strings.patch added to -mm tree
Date: Wed, 10 Jul 2013 14:34:43 -0700
Message-ID: <51ddd373.qqvGJY3DDfmA3FB1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab3GJVeo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jul 2013 17:34:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, jdelvare@suse.de

Subject: + firmware-dmi_scan-constify-strings.patch added to -mm tree
To: jdelvare@suse.de,joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 10 Jul 2013 14:34:43 -0700


The patch titled
     Subject: firmware/dmi_scan: constify strings
has been added to the -mm tree.  Its filename is
     firmware-dmi_scan-constify-strings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/firmware-dmi_scan-constify-strings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/firmware-dmi_scan-constify-strings.patch

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
Subject: firmware/dmi_scan: constify strings

Add const to all DMI string pointers where this is possible.  This fixes a
checkpatch warning.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~firmware-dmi_scan-constify-strings drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~firmware-dmi_scan-constify-strings
+++ a/drivers/firmware/dmi_scan.c
@@ -14,7 +14,7 @@
  * of and an antecedent to, SMBIOS, which stands for System
  * Management BIOS.  See further: http://www.dmtf.org/standards
  */
-static char dmi_empty_string[] = "        ";
+static const char dmi_empty_string[] = "        ";
 
 static u16 __initdata dmi_ver;
 /*
@@ -49,7 +49,7 @@ static const char * __init dmi_string_no
 	return "";
 }
 
-static char * __init dmi_string(const struct dmi_header *dm, u8 s)
+static const char * __init dmi_string(const struct dmi_header *dm, u8 s)
 {
 	const char *bp = dmi_string_nosave(dm, s);
 	char *str;
@@ -133,7 +133,7 @@ static int __init dmi_checksum(const u8
 	return sum == 0;
 }
 
-static char *dmi_ident[DMI_STRING_MAX];
+static const char *dmi_ident[DMI_STRING_MAX];
 static LIST_HEAD(dmi_devices);
 int dmi_available;
 
@@ -144,7 +144,7 @@ static void __init dmi_save_ident(const
 		int string)
 {
 	const char *d = (const char *) dm;
-	char *p;
+	const char *p;
 
 	if (dmi_ident[slot])
 		return;
@@ -252,7 +252,7 @@ static void __init dmi_save_oem_strings_
 	struct dmi_device *dev;
 
 	for (i = 1; i <= count; i++) {
-		char *devname = dmi_string(dm, i);
+		const char *devname = dmi_string(dm, i);
 
 		if (devname == dmi_empty_string)
 			continue;
_

Patches currently in -mm which might be from jdelvare@suse.de are

origin.patch
linux-next.patch
dmi_scan-add-comments-on-dmi_present-and-the-loop-in-dmi_scan_machine.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch

