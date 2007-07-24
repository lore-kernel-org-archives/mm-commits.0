From: akpm@linux-foundation.org
Subject: + cciss-fix-memory-leak.patch added to -mm tree
Date: Mon, 23 Jul 2007 17:26:33 -0700
Message-ID: <200707240026.l6O0QXE2019642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59156 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbXGXA0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 20:26:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, mike.miller@hp.com


The patch titled
     cciss: fix memory leak
has been added to the -mm tree.  Its filename is
     cciss-fix-memory-leak.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cciss: fix memory leak
From: Jesper Juhl <jesper.juhl@gmail.com>

There's a memory leak in the cciss driver.

in alloc_cciss_hba() we may leak sizeof(ctlr_info_t) bytes if a
call to alloc_disk(1 << NWD_SHIFT) fails.
This patch should fix the issue.

Spotted by the Coverity checker.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-fix-memory-leak drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-memory-leak
+++ a/drivers/block/cciss.c
@@ -3227,12 +3227,15 @@ static int alloc_cciss_hba(void)
 	for (i = 0; i < MAX_CTLR; i++) {
 		if (!hba[i]) {
 			ctlr_info_t *p;
+
 			p = kzalloc(sizeof(ctlr_info_t), GFP_KERNEL);
 			if (!p)
 				goto Enomem;
 			p->gendisk[0] = alloc_disk(1 << NWD_SHIFT);
-			if (!p->gendisk[0])
+			if (!p->gendisk[0]) {
+				kfree(p);
 				goto Enomem;
+			}
 			hba[i] = p;
 			return i;
 		}
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

clean-up-duplicate-includes-in-sound-core.patch
clean-up-duplicate-includes-in-sound-ppc.patch
clean-up-duplicate-includes-in-sound-soc.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
fix-use-after-free--double-free-bug-in-ati_create_gatt_pages--ati_free_gatt_pages.patch
clean-up-duplicate-includes-in-drivers-media.patch
clean-up-duplicate-includes-in-include-media.patch
clean-up-duplicate-includes-in-drivers-hwmon.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-fs-gfs2.patch
hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch
clean-up-duplicate-includes-in-drivers-input.patch
git-kbuild.patch
git-mtd.patch
clean-up-duplicate-includes-in-drivers-mtd.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-bridge.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-netfilter.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-selinux.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-drivers-usb.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
cciss-fix-memory-leak.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
