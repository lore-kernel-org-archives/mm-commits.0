From: akpm@linux-foundation.org
Subject: [merged] arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch removed from -mm tree
Date: Fri, 27 Apr 2012 12:35:24 -0700
Message-ID: <20120427193524.BD637A02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:61226 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761328Ab2D0TfZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 15:35:25 -0400
Received: by yhgm50 with SMTP id m50so121339yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 12:35:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, linus.walleij@linaro.org, linux@arm.linux.org.uk, srinidhi.kasagar@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
has been removed from the -mm tree.  Its filename was
     arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Vasiliy Kulikov <segoon@openwall.com>
Subject: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file

Don't allow everybody to use a modem.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-ux500/mbox-db5500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-ux500/mbox-db5500.c~arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file arch/arm/mach-ux500/mbox-db5500.c
--- a/arch/arm/mach-ux500/mbox-db5500.c~arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file
+++ a/arch/arm/mach-ux500/mbox-db5500.c
@@ -168,7 +168,7 @@ static ssize_t mbox_read_fifo(struct dev
 	return sprintf(buf, "0x%X\n", mbox_value);
 }
 
-static DEVICE_ATTR(fifo, S_IWUGO | S_IRUGO, mbox_read_fifo, mbox_write_fifo);
+static DEVICE_ATTR(fifo, S_IWUSR | S_IRUGO, mbox_read_fifo, mbox_write_fifo);
 
 static int mbox_show(struct seq_file *s, void *data)
 {
_

Patches currently in -mm which might be from segoon@openwall.com are

origin.patch
connector-userns-replace-netlink-uses-of-cap_raised-with-capable.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

