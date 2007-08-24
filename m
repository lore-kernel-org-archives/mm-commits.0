From: akpm@linux-foundation.org
Subject: - zorro-make-sysfs-config-attribute-read-only.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:18 -0700
Message-ID: <200708242056.l7OKuImI014029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43071 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762528AbXHXVIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     zorro: Make sysfs config attribute read-only
has been removed from the -mm tree.  Its filename was
     zorro-make-sysfs-config-attribute-read-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
move-preempt_notifiers-into-an-always-included-kconfig.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
