From: akpm@linux-foundation.org
Subject: + toshiba_acpi-rename-add_device-and-remove_device-to-create_toshiba_proc_entries-and-remove_toshiba_proc_entries.patch added to -mm tree
Date: Thu, 08 Jul 2010 14:39:01 -0700
Message-ID: <201007082139.o68Ld1te030591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238Ab0GHVjx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 17:39:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, mjg@redhat.com, nm127@freemail.hu


The patch titled
     toshiba_acpi: rename add_device() and remove_device() to create_to=
shiba_proc_entries() and remove_toshiba_proc_entries()
has been added to the -mm tree.  Its filename is
     toshiba_acpi-rename-add_device-and-remove_device-to-create_toshiba=
_proc_entries-and-remove_toshiba_proc_entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: toshiba_acpi: rename add_device() and remove_device() to creat=
e_toshiba_proc_entries() and remove_toshiba_proc_entries()
=46rom: Axel Lin <axel.lin@gmail.com>

To improve readability rename add_device() to
create_toshiba_proc_entries() and rename remove_device() to
remove_toshiba_proc_entries().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: M=E1rton N=E9meth <nm127@freemail.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/toshiba_acpi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/platform/x86/toshiba_acpi.c~toshiba_acpi-rename-add_d=
evice-and-remove_device-to-create_toshiba_proc_entries-and-remove_toshi=
ba_proc_entries drivers/platform/x86/toshiba_acpi.c
--- a/drivers/platform/x86/toshiba_acpi.c~toshiba_acpi-rename-add_devic=
e-and-remove_device-to-create_toshiba_proc_entries-and-remove_toshiba_p=
roc_entries
+++ a/drivers/platform/x86/toshiba_acpi.c
@@ -720,7 +720,7 @@ static const struct file_operations vers
=20
 #define PROC_TOSHIBA		"toshiba"
=20
-static void __init add_device(void)
+static void __init create_toshiba_proc_entries(void)
 {
 	proc_create("lcd", S_IRUGO | S_IWUSR, toshiba_proc_dir, &lcd_proc_fop=
s);
 	proc_create("video", S_IRUGO | S_IWUSR, toshiba_proc_dir, &video_proc=
_fops);
@@ -729,7 +729,7 @@ static void __init add_device(void)
 	proc_create("version", S_IRUGO, toshiba_proc_dir, &version_proc_fops)=
;
 }
=20
-static void remove_device(void)
+static void remove_toshiba_proc_entries(void)
 {
 	remove_proc_entry("lcd", toshiba_proc_dir);
 	remove_proc_entry("video", toshiba_proc_dir);
@@ -903,7 +903,7 @@ static void toshiba_acpi_exit(void)
 	if (toshiba_backlight_device)
 		backlight_device_unregister(toshiba_backlight_device);
=20
-	remove_device();
+	remove_toshiba_proc_entries();
=20
 	if (toshiba_proc_dir)
 		remove_proc_entry(PROC_TOSHIBA, acpi_root_dir);
@@ -965,7 +965,7 @@ static int __init toshiba_acpi_init(void
 		toshiba_acpi_exit();
 		return -ENODEV;
 	} else {
-		add_device();
+		create_toshiba_proc_entries();
 	}
=20
 	props.max_brightness =3D HCI_LCD_BRIGHTNESS_LEVELS - 1;
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
hp-wmi-return-enodev-if-bios-does-not-export-any-supported-hp-wmi-guid.=
patch
fujitsu-laptop-remove-unnecessary-input_free_device-calls.patch
compal-laptop-fujitsu-laptop-msi-laptop-make-dmi_check_cb-to-return-1-i=
nstead-of-0.patch
asus_acpi-fix-a-memory-leak-in-asus_hotk_get_info.patch
asus_acpi-fix-coding-style-to-improve-readability.patch
acerhdf-make-needlessly-global-symbols-static.patch
classmate-laptop-make-needlessly-global-symbols-static.patch
fujitsu-laptop-make-needlessly-global-symbols-static.patch
msi-laptop-make-struct-rfkill_ops-const.patch
asus-laptop-fix-incorrect-return-value-for-write_acpi_int_ret-if-handle=
-is-null.patch
asus-laptop-return-proper-error-for-store_ledd-if-write_acpi_int-fail.p=
atch
acerhdf-fix-resource-reclaim-in-error-path.patch
toshiba_acpi-make-remove_device-and-add_device-void.patch
toshiba_acpi-rename-add_device-and-remove_device-to-create_toshiba_proc=
_entries-and-remove_toshiba_proc_entries.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to=
-0444.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
