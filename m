From: akpm@linux-foundation.org
Subject: + fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount.patch added to -mm tree
Date: Tue, 07 Aug 2007 15:09:30 -0700
Message-ID: <200708072209.l77M9Utw007292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35976 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935474AbXHGWJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:09:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com


The patch titled
     fix a potential NULL pointer deref in XFS on failed mount.
has been added to the -mm tree.  Its filename is
     fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix a potential NULL pointer deref in XFS on failed mount.
From: Jesper Juhl <jesper.juhl@gmail.com>

The Coverity checker spotted (as bug #346) a potential problem in XFS.

The problem is that if, in xfs_mount(), this code triggers:

       ...
       if (!mp->m_logdev_targp)
               goto error0;
       ...

Then we'll end up calling xfs_unmountfs_close() with a NULL
'mp->m_logdev_targp'.
This in turn will result in a call to xfs_free_buftarg() with its 'btp'
argument == NULL. xfs_free_buftarg() dereferences 'btp' leading to
a NULL pointer dereference and crash.

I think this can happen, since the fatal call to xfs_free_buftarg()
happens when 'm_logdev_targp != m_ddev_targp' and due to a check of
'm_ddev_targp' against NULL in xfs_mount() (and subsequent return if it is
NULL) the two will never both be NULL when we hit the error0 label from
the two lines cited above.

This patch fixes the issue by checking mp->m_logdev_targp against NULL
in xfs_unmountfs_close() and doing the proper xfs_blkdev_put(logdev);
and xfs_blkdev_put(rtdev); on (!mp->m_rtdev_targp) in xfs_mount().

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_mount.c  |    2 +-
 fs/xfs/xfs_vfsops.c |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN fs/xfs/xfs_mount.c~fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount fs/xfs/xfs_mount.c
--- a/fs/xfs/xfs_mount.c~fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount
+++ a/fs/xfs/xfs_mount.c
@@ -1275,7 +1275,7 @@ xfs_unmountfs(xfs_mount_t *mp, struct cr
 void
 xfs_unmountfs_close(xfs_mount_t *mp, struct cred *cr)
 {
-	if (mp->m_logdev_targp != mp->m_ddev_targp)
+	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_free_buftarg(mp->m_logdev_targp, 1);
 	if (mp->m_rtdev_targp)
 		xfs_free_buftarg(mp->m_rtdev_targp, 1);
diff -puN fs/xfs/xfs_vfsops.c~fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount fs/xfs/xfs_vfsops.c
--- a/fs/xfs/xfs_vfsops.c~fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount
+++ a/fs/xfs/xfs_vfsops.c
@@ -482,13 +482,19 @@ xfs_mount(
 	}
 	if (rtdev) {
 		mp->m_rtdev_targp = xfs_alloc_buftarg(rtdev, 1);
-		if (!mp->m_rtdev_targp)
+		if (!mp->m_rtdev_targp) {
+			xfs_blkdev_put(logdev);
+			xfs_blkdev_put(rtdev);
 			goto error0;
+		}
 	}
 	mp->m_logdev_targp = (logdev && logdev != ddev) ?
 				xfs_alloc_buftarg(logdev, 1) : mp->m_ddev_targp;
-	if (!mp->m_logdev_targp)
+	if (!mp->m_logdev_targp) {
+		xfs_blkdev_put(logdev);
+		xfs_blkdev_put(rtdev);
 		goto error0;
+	}
 
 	/*
 	 * Setup flags based on mount(2) options and then the superblock
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-acpi.patch
git-alsa.patch
au88x0-mem-leak-fix-in-snd_vortex_create.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
git-dvb.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
git-mtd.patch
git-ubi.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
fix-several-memory-leaks-in-cr_backlight_probe-take2.patch
fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount.patch
improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
documentation-sysrq-description-of-h-slightly-inaccurate.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
