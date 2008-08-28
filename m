From: akpm@linux-foundation.org
Subject: + initramfs-fix-compilation-warning.patch added to -mm tree
Date: Wed, 27 Aug 2008 20:43:38 -0700
Message-ID: <200808280343.m7S3hcbu005613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753660AbYH1Doy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 23:44:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: h-shimamoto@ct.jp.nec.com, arjan@infradead.org, mingo@elte.hu, shaohua.li@intel.com


The patch titled
     initramfs: fix compilation warning
has been added to the -mm tree.  Its filename is
     initramfs-fix-compilation-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: initramfs: fix compilation warning
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

  CC      init/initramfs.o
init/initramfs.c:517: warning: 'clean_rootfs' defined but not used

clean_rootfs is not used when CONFIG_BLK_DEV_RAM disabled.

(akpm: fixes "fastboot: remove duplicate unpack_to_rootfs()")

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN init/initramfs.c~initramfs-fix-compilation-warning init/initramfs.c
--- a/init/initramfs.c~initramfs-fix-compilation-warning
+++ a/init/initramfs.c
@@ -512,6 +512,7 @@ skip:
 	initrd_end = 0;
 }
 
+#ifdef CONFIG_BLK_DEV_RAM
 #define BUF_SIZE 1024
 static void __init clean_rootfs(void)
 {
@@ -558,6 +559,7 @@ static void __init clean_rootfs(void)
 	sys_close(fd);
 	kfree(buf);
 }
+#endif
 
 static int __init populate_rootfs(void)
 {
_

Patches currently in -mm which might be from h-shimamoto@ct.jp.nec.com are

linux-next.patch
net-fix-compilation-ng-when-config_module.patch
initramfs-fix-compilation-warning.patch
rcu-spinlocks-take-an-unsigned-long-flags.patch
unevictable-lru-page-statistics.patch

