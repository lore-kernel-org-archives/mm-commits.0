From: akpm@linux-foundation.org
Subject: + fix-oops-in-toshiba_acpi-error-return-path.patch added to -mm tree
Date: Mon, 05 Nov 2007 16:15:03 -0800
Message-ID: <200711060015.lA60F3Vb027026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755028AbXKFAPz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 19:15:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arvidjaar@mail.ru, rpurdie@rpsys.net, toshiba_acpi@memebeam.org


The patch titled
     Fix Oops in toshiba_acpi error return path
has been added to the -mm tree.  Its filename is
     fix-oops-in-toshiba_acpi-error-return-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix Oops in toshiba_acpi error return path
From: Andrey Borzenkov <arvidjaar@mail.ru>

When backlight_device_register() fails, return after undo initialization, do
not try to use pointer that just was reset to NULL

This fixes this oops:

[ 1595.177672]  [<c010480a>] show_trace_log_lvl+0x1a/0x30
[ 1595.177706]  [<c01052a2>] show_trace+0x12/0x20
[ 1595.177718]  [<c0105305>] dump_stack+0x15/0x20
[ 1595.177728]  [<c01c9375>] kobject_shadow_add+0x125/0x1c0
[ 1595.177754]  [<c01c941a>] kobject_add+0xa/0x10
[ 1595.177764]  [<c0239a37>] device_add+0x97/0x5d0
[ 1595.177776]  [<c0239f82>] device_register+0x12/0x20
[ 1595.177786]  [<dfd912df>] backlight_device_register+0x9f/0x110 [backlight]
[ 1595.177814]  [<df861117>] toshiba_acpi_init+0x117/0x15e [toshiba_acpi]
[ 1595.177834]  [<c013e28d>] sys_init_module+0xfd/0x14e0
[ 1595.177871]  [<c0104112>] sysenter_past_esp+0x5f/0x99
[ 1595.177883]  =======================
[ 1595.177890] Could not register toshiba backlight device
[ 1595.177985] BUG: unable to handle kernel NULL pointer dereference at 
virtual address 00000004
...
[ 1595.394097] EIP:    0060:[<df861143>]    Not tainted VLI
[ 1595.394101] EFLAGS: 00010282   (2.6.23-rc9-1avb #24)
[ 1595.480081] EIP is at toshiba_acpi_init+0x143/0x15e [toshiba_acpi]

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: John Belmonte <toshiba_acpi@memebeam.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/toshiba_acpi.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/acpi/toshiba_acpi.c~fix-oops-in-toshiba_acpi-error-return-path drivers/acpi/toshiba_acpi.c
--- a/drivers/acpi/toshiba_acpi.c~fix-oops-in-toshiba_acpi-error-return-path
+++ a/drivers/acpi/toshiba_acpi.c
@@ -591,9 +591,12 @@ static int __init toshiba_acpi_init(void
 						NULL,
 						&toshiba_backlight_data);
         if (IS_ERR(toshiba_backlight_device)) {
+		int ret = PTR_ERR(toshiba_backlight_device);
+
 		printk(KERN_ERR "Could not register toshiba backlight device\n");
 		toshiba_backlight_device = NULL;
 		toshiba_acpi_exit();
+		return ret;
 	}
         toshiba_backlight_device->props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
 
_

Patches currently in -mm which might be from arvidjaar@mail.ru are

origin.patch
make-proc-acpi-ac_adapter-dependent-on-acpi_procfs.patch
acpi-ac-update-ac-state-on-resume.patch
fix-oops-in-toshiba_acpi-error-return-path.patch
