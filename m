From: akpm@linux-foundation.org
Subject: [merged] init-initramfs-fix-warning-with-config_blk_dev_ram=n.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:48:33 -0700
Message-ID: <200904141948.n3EJmXIL019088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753420AbZDNTug (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:50:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: knikanth@suse.de, mm-commits@vger.kernel.org


The patch titled
     init/initramfs: fix warning with CONFIG_BLK_DEV_RAM=n
has been removed from the -mm tree.  Its filename was
     init-initramfs-fix-warning-with-config_blk_dev_ram=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init/initramfs: fix warning with CONFIG_BLK_DEV_RAM=n
From: Nikanth Karthikesan <knikanth@suse.de>

init/initramfs.c:520: warning: 'clean_rootfs' defined but not used

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN init/initramfs.c~init-initramfs-fix-warning-with-config_blk_dev_ram=n init/initramfs.c
--- a/init/initramfs.c~init-initramfs-fix-warning-with-config_blk_dev_ram=n
+++ a/init/initramfs.c
@@ -515,6 +515,7 @@ skip:
 	initrd_end = 0;
 }
 
+#ifdef CONFIG_BLK_DEV_RAM
 #define BUF_SIZE 1024
 static void __init clean_rootfs(void)
 {
@@ -561,6 +562,7 @@ static void __init clean_rootfs(void)
 	sys_close(fd);
 	kfree(buf);
 }
+#endif
 
 static int __init populate_rootfs(void)
 {
_

Patches currently in -mm which might be from knikanth@suse.de are

origin.patch
linux-next.patch

