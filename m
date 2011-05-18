From: akpm@linux-foundation.org
Subject: + drivers-firmware-dmi_scanc-make-dmi_name_in_vendors-more-focused.patch added to -mm tree
Date: Wed, 18 May 2011 14:23:07 -0700
Message-ID: <201105182123.p4ILN7f1024504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755145Ab1ERVYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 17:24:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, andi@firstfloor.org, jbarnes@virtuousgeek.org


The patch titled
     drivers/firmware/dmi_scan.c: make dmi_name_in_vendors more focused
has been added to the -mm tree.  Its filename is
     drivers-firmware-dmi_scanc-make-dmi_name_in_vendors-more-focused.patch

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
Subject: drivers/firmware/dmi_scan.c: make dmi_name_in_vendors more focused
From: Jean Delvare <khali@linux-fr.org>

The current implementation of dmi_name_in_vendors() is an invitation to
lazy coding and false positives [1].  Searching for a string in 8 know
what you're looking for, so you should know where to look.  strstr isn't
fast, especially when it fails, so we should avoid calling it when it just
can't succeed.

Looking at the current users of the function, it seems clear to me that
they are looking for a system or board vendor name, so let's limit
dmi_name_in_vendors to these two DMI fields.  This much better matches the
function name, BTW.

[1] We currently have code looking for short names in DMI data, such
as "IBM", "ASUS" or "Acer". I let you guess what will happen the day
other vendors ship products named, for example, "SCHREIBMEISTER",
"PEGASUS" or "Acerola".

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-make-dmi_name_in_vendors-more-focused drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-make-dmi_name_in_vendors-more-focused
+++ a/drivers/firmware/dmi_scan.c
@@ -585,14 +585,12 @@ int dmi_name_in_serial(const char *str)
 }
 
 /**
- *	dmi_name_in_vendors - Check if string is anywhere in the DMI vendor information.
+ *	dmi_name_in_vendors - Check if string is in the DMI system or board vendor name
  *	@str: 	Case sensitive Name
  */
 int dmi_name_in_vendors(const char *str)
 {
-	static int fields[] = { DMI_BIOS_VENDOR, DMI_BIOS_VERSION, DMI_SYS_VENDOR,
-				DMI_PRODUCT_NAME, DMI_PRODUCT_VERSION, DMI_BOARD_VENDOR,
-				DMI_BOARD_NAME, DMI_BOARD_VERSION, DMI_NONE };
+	static int fields[] = { DMI_SYS_VENDOR, DMI_BOARD_VENDOR, DMI_NONE };
 	int i;
 	for (i = 0; fields[i] != DMI_NONE; i++) {
 		int f = fields[i];
_

Patches currently in -mm which might be from khali@linux-fr.org are

linux-next.patch
pci-dont-use-dmi_name_in_vendors-in-quirk.patch
drivers-firmware-dmi_scanc-make-dmi_name_in_vendors-more-focused.patch

