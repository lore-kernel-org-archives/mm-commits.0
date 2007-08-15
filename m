From: akpm@linux-foundation.org
Subject: + zorro-make-sysfs-config-attribute-read-only.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:18:26 -0700
Message-ID: <200708152118.l7FLIQKm015490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758139AbXHOVUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:20:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org


The patch titled
     zorro: Make sysfs config attribute read-only
has been added to the -mm tree.  Its filename is
     zorro-make-sysfs-config-attribute-read-only.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: zorro: Make sysfs config attribute read-only
From: Geert Uytterhoeven <geert@linux-m68k.org>

zorro: Make the sysfs `config' attribute read-only, as you cannot write to it
(there's no .write function neither).

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/zorro/zorro-sysfs.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/zorro/zorro-sysfs.c~zorro-make-sysfs-config-attribute-read-only drivers/zorro/zorro-sysfs.c
--- a/drivers/zorro/zorro-sysfs.c~zorro-make-sysfs-config-attribute-read-only
+++ a/drivers/zorro/zorro-sysfs.c
@@ -78,7 +78,7 @@ static ssize_t zorro_read_config(struct 
 static struct bin_attribute zorro_config_attr = {
 	.attr =	{
 		.name = "config",
-		.mode = S_IRUGO | S_IWUSR,
+		.mode = S_IRUGO,
 	},
 	.size = sizeof(struct ConfigDev),
 	.read = zorro_read_config,
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-asm-pageh-needs-linux-compilerh.patch
m68k-kill-superfluous-extern.patch
m68k-remove-unnecessary-m68k_memoffset-export-and-init.patch
remove-dead-code-in-via-pmu68k.patch
m68k-use-_ac-instead-of-ifdef-__assembly__.patch
m68k-enable-arbitary-speed-tty-support.patch
m68k-dont-include-rodata-into-text-segment.patch
m68k-fix-a-few-hickups-in-drivers-scsi-kconfig.patch
zorro-make-sysfs-config-attribute-read-only.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
