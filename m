From: akpm@linux-foundation.org
Subject: - remove-dell-optiplex-gx240-from-the-acpi-blacklist.patch removed from -mm tree
Date: Mon, 04 Jun 2007 13:56:31 -0700
Message-ID: <200706042056.l54KuU8b018896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58305 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756320AbXFDU4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:56:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tarrqt@yahoo.com, lenb@kernel.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Remove Dell Optiplex GX240 from the ACPI blacklist
has been removed from the -mm tree.  Its filename was
     remove-dell-optiplex-gx240-from-the-acpi-blacklist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 files changed, 8 deletions(-)

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

git-acpi.patch
