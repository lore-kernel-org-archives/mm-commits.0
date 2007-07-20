From: akpm@linux-foundation.org
Subject: + cr_backlight_probe-allocates-too-little-storage-for-struct-cr_panel.patch added to -mm tree
Date: Thu, 19 Jul 2007 23:25:08 -0700
Message-ID: <200707200625.l6K6P8De011371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59152 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753710AbXGTGZm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 02:25:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, alanh@tungstengraphics.com, stable@kernel.org, thomas@tungstengraphics.com


The patch titled
     cr_backlight_probe() allocates too little storage for struct cr_panel
has been added to the -mm tree.  Its filename is
     cr_backlight_probe-allocates-too-little-storage-for-struct-cr_panel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
cr_backlight_probe-allocates-too-little-storage-for-struct-cr_panel.patch
fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak.patch
git-gfs2-nmw.patch
git-mtd.patch
git-xfs.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
