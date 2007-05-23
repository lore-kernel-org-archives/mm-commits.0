From: akpm@linux-foundation.org
Subject: + work-around-dell-e520-bios-reboot-bug.patch added to -mm tree
Date: Wed, 23 May 2007 14:03:38 -0700
Message-ID: <200705232103.l4NL3clo031994@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755849AbXEWVDo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 17:03:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tim.gardner@ubuntu.com, ak@suse.de


The patch titled
     Work around Dell E520 BIOS reboot bug
has been added to the -mm tree.  Its filename is
     work-around-dell-e520-bios-reboot-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Work around Dell E520 BIOS reboot bug
From: Tim Gardner <tim.gardner@ubuntu.com>

Force Dell E520 to use the BIOS to shutdown/reboot.

I have at least one report that this patch fixes shutdown/reboot
problems on the Dell E520 platform.

Signed-off-by: Tim Gardner <tim.gardner@ubuntu.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+)

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

git-wireless.patch
work-around-dell-e520-bios-reboot-bug.patch
