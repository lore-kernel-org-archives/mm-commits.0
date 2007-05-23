From: akpm@linux-foundation.org
Subject: + remove-dell-optiplex-gx240-from-the-acpi-blacklist.patch added to -mm tree
Date: Wed, 23 May 2007 10:39:52 -0700
Message-ID: <200705231739.l4NHdpkf028257@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756433AbXEWRlJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 13:41:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tarrqt@yahoo.com, lenb@kernel.org


The patch titled
     Remove Dell Optiplex GX240 from the ACPI blacklist
has been added to the -mm tree.  Its filename is
     remove-dell-optiplex-gx240-from-the-acpi-blacklist.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove Dell Optiplex GX240 from the ACPI blacklist
From: Tear <tarrqt@yahoo.com>

I have a Dell Optiplex GX240 and when I boot Linux, ACPI gets set up by only
acpi=ht.  dmesg shows the following line:

   DELL GX240 detected: force use of acpi=ht

Everything seemed to be fine.  However, I discovered that everything is not
fine.  The USB controller works so slowly that copying a few (uncached) 1
megabyte large photos from a USB-enabled digital camera takes many minutes
instead of a couple of seconds.

I am using Linux 2.6.21.1 on a Debian 4.0 ("Etch") system.

I thought that this might be related to ACPI.  So I tried to boot with _only_
"acpi=force" appended to the kernel command line.  Voila, the USB controller
started to work at full speed and copying photos from my digital camera took
only seconds.

I tested the system with "acpi=force" and could not find anything which did
not work.  So, can we please remove Dell Optiplex GX240 from the blacklist in

..../arch/i386/kernel/acpi/boot.c

?  The attached patch does just that: It removes Dell Optiplex GX240 from the
ACPI blacklist.

I thought that this might be related to interrupts and APIC as well.  (Note
that this is APIC, not ACPI.) I tried booting with _only_ "noapic" and
"nolapic" appended to the command line.  Again, the USB controller started to
work at full speed.

Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/boot.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN arch/i386/kernel/acpi/boot.c~remove-dell-optiplex-gx240-from-the-acpi-blacklist arch/i386/kernel/acpi/boot.c
--- a/arch/i386/kernel/acpi/boot.c~remove-dell-optiplex-gx240-from-the-acpi-blacklist
+++ a/arch/i386/kernel/acpi/boot.c
@@ -971,14 +971,6 @@ static struct dmi_system_id __initdata a
 	 },
 	{
 	 .callback = force_acpi_ht,
-	 .ident = "DELL GX240",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "Dell Computer Corporation"),
-		     DMI_MATCH(DMI_BOARD_NAME, "OptiPlex GX240"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
 	 .ident = "HP VISUALIZE NT Workstation",
 	 .matches = {
 		     DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
_

Patches currently in -mm which might be from tarrqt@yahoo.com are

remove-dell-optiplex-gx240-from-the-acpi-blacklist.patch
