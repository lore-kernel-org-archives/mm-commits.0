From: akpm@linux-foundation.org
Subject: - cr_backlight_probe-allocates-too-little-storage-for-struct-cr_panel.patch removed from -mm tree
Date: Fri, 20 Jul 2007 12:42:01 -0700
Message-ID: <200707201942.l6KJg1t4013053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39239 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763586AbXGTTmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:42:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, alanh@tungstengraphics.com, stable@kernel.org, thomas@tungstengraphics.com, mm-commits@vger.kernel.org


The patch titled
     cr_backlight_probe() allocates too little storage for struct cr_panel
has been removed from the -mm tree.  Its filename was
     cr_backlight_probe-allocates-too-little-storage-for-struct-cr_panel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cr_backlight_probe() allocates too little storage for struct cr_panel
From: Jesper Juhl <jesper.juhl@gmail.com>

The Coverity checker noticed that we allocate too little storage for
"struct cr_panel *crp" in cr_backlight_probe().

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Thomas Hellstrom <thomas@tungstengraphics.com>
Cc: Alan Hourihane <alanh@tungstengraphics.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/cr_bllcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/cr_bllcd.c~cr_backlight_probe-allocates-too-little-storage-for-struct-cr_panel drivers/video/backlight/cr_bllcd.c
--- a/drivers/video/backlight/cr_bllcd.c~cr_backlight_probe-allocates-too-little-storage-for-struct-cr_panel
+++ a/drivers/video/backlight/cr_bllcd.c
@@ -174,7 +174,7 @@ static int cr_backlight_probe(struct pla
 	struct cr_panel *crp;
 	u8 dev_en;
 
-	crp = kzalloc(sizeof(crp), GFP_KERNEL);
+	crp = kzalloc(sizeof(*crp), GFP_KERNEL);
 	if (crp == NULL)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
memory-leak-in-tpm_ascii_bios_measurements_open-fix.patch
fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-gfs2-nmw.patch
git-mtd.patch
git-xfs.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
