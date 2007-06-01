From: akpm@linux-foundation.org
Subject: - work-around-dell-e520-bios-reboot-bug.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:47:25 -0700
Message-ID: <200706011747.l51HlODI015123@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761370AbXFARrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.gardner@ubuntu.com, Matt_Domsch@dell.com, ak@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Work around Dell E520 BIOS reboot bug
has been removed from the -mm tree.  Its filename was
     work-around-dell-e520-bios-reboot-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Work around Dell E520 BIOS reboot bug
From: Tim Gardner <tim.gardner@ubuntu.com>

Force Dell E520 to use the BIOS to shutdown/reboot.

I have at least one report that this patch fixes shutdown/reboot
problems on the Dell E520 platform.

(Andi says: People can always set the boot option.  It hardly seems like a
critical issue needing a backport.)

Signed-off-by: Tim Gardner <tim.gardner@ubuntu.com>
Acked-by: Andi Kleen <ak@suse.de>
Acked-by: Matt Domsch <Matt_Domsch@dell.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/reboot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/i386/kernel/reboot.c~work-around-dell-e520-bios-reboot-bug arch/i386/kernel/reboot.c
--- a/arch/i386/kernel/reboot.c~work-around-dell-e520-bios-reboot-bug
+++ a/arch/i386/kernel/reboot.c
@@ -89,6 +89,14 @@ static int __init set_bios_reboot(struct
 }
 
 static struct dmi_system_id __initdata reboot_dmi_table[] = {
+	{	/* Handle problems with rebooting on Dell E520's */
+		.callback = set_bios_reboot,
+		.ident = "Dell E520",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell DM061"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 1300's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 1300",
_

Patches currently in -mm which might be from tim.gardner@ubuntu.com are

origin.patch
git-wireless.patch
