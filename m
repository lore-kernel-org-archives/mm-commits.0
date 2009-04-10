From: akpm@linux-foundation.org
Subject: + init-initramfs-fix-warning-with-config_blk_dev_ram=n.patch added to -mm tree
Date: Fri, 10 Apr 2009 15:30:55 -0700
Message-ID: <200904102230.n3AMUtVQ024880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbZDJWcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 18:32:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@suse.de


The patch titled
     init/initramfs: fix warning with CONFIG_BLK_DEV_RAM=n
has been added to the -mm tree.  Its filename is
     init-initramfs-fix-warning-with-config_blk_dev_ram=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

init-initramfs-fix-warning-with-config_blk_dev_ram=n.patch
linux-next.patch

