From: akpm@linux-foundation.org
Subject: [merged] ramfs-ignore-unknown-mount-options.patch removed from -mm tree
Date: Tue, 16 Jun 2009 11:27:56 -0700
Message-ID: <200906161827.n5GIRuPX028372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759461AbZFPS3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 14:29:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, mpm@selenic.com, stable@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     ramfs: ignore unknown mount options
has been removed from the -mm tree.  Its filename was
     ramfs-ignore-unknown-mount-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ramfs: ignore unknown mount options
From: Mike Frysinger <vapier@gentoo.org>

On systems where CONFIG_SHMEM is disabled, mounting tmpfs filesystems can
fail when tmpfs options are used.  This is because tmpfs creates a small
wrapper around ramfs which rejects unknown options, and ramfs itself only
supports a tiny subset of what tmpfs supports.  This makes it pretty hard
to use the same userspace systems across different configuration systems. 
As such, ramfs should ignore the tmpfs options when tmpfs is merely a
wrapper around ramfs.

This used to work before commit c3b1b1cbf0 as previously, ramfs would
ignore all options.  But now, we get: ramfs: bad mount option: size=10M
mount: mounting mdev on /dev failed: Invalid argument

Another option might be to restore the previous behavior, where ramfs
simply ignored all unknown mount options ...  which is what Hugh prefers.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Matt Mackall <mpm@selenic.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: <stable@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/inode.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/ramfs/inode.c~ramfs-ignore-unknown-mount-options fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~ramfs-ignore-unknown-mount-options
+++ a/fs/ramfs/inode.c
@@ -202,9 +202,12 @@ static int ramfs_parse_options(char *dat
 				return -EINVAL;
 			opts->mode = option & S_IALLUGO;
 			break;
-		default:
-			printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
-			return -EINVAL;
+		/*
+		 * We might like to report bad mount options here;
+		 * but traditionally ramfs has ignored all mount options,
+		 * and as it is used as a !CONFIG_SHMEM simple substitute
+		 * for tmpfs, better continue to ignore other mount options.
+		 */
 		}
 	}
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-hvc-add-missing-__devexit_p.patch
kmap_types-make-most-arches-use-generic-header-file.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
fbdev-blackfin-has-__raw-i-o-accessors-so-use-them-in-fbh.patch
fbdev-bfin-t350mcqb-fb-drop-unused-local-variables.patch
fbdev-bfin-drop-unnecessary-calls-to-memset.patch
fbdev-bfin-fix-__devinitexit-markings.patch
fbdev-bf54x-lq043fb-use-kzalloc-over-kmalloc-memset.patch
istallion-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch

