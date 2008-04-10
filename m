From: akpm@linux-foundation.org
Subject: - nfs-nommu-fix-bug-executing-fdpic-elf-on-nfs-mount-triggers-bug-at-mm-nommuc-862-do_mmap_private.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:01:49 -0700
Message-ID: <200804102001.m3AK1n1T015005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757547AbYDJUMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:12:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cooloney@kernel.org, bfields@fieldses.org, dhowells@redhat.com, trond.myklebust@fys.uio.no, vapier.adi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     nfs/nommu: fix bug: executing FDPIC ELF on NFS mount triggers BUG() at mm/nommu.c:862:/do_mmap_private()
has been removed from the -mm tree.  Its filename was
     nfs-nommu-fix-bug-executing-fdpic-elf-on-nfs-mount-triggers-bug-at-mm-nommuc-862-do_mmap_private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfs/nommu: fix bug: executing FDPIC ELF on NFS mount triggers BUG() at mm/nommu.c:862:/do_mmap_private()
From: Bryan Wu <cooloney@kernel.org>

NFS needs a NOMMU version mmap function to support uClinux on NOMMU machine
http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_id=141&tracker_item_id=3992

Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/file.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/nfs/file.c~nfs-nommu-fix-bug-executing-fdpic-elf-on-nfs-mount-triggers-bug-at-mm-nommuc-862-do_mmap_private fs/nfs/file.c
--- a/fs/nfs/file.c~nfs-nommu-fix-bug-executing-fdpic-elf-on-nfs-mount-triggers-bug-at-mm-nommuc-862-do_mmap_private
+++ a/fs/nfs/file.c
@@ -64,7 +64,11 @@ const struct file_operations nfs_file_op
 	.write		= do_sync_write,
 	.aio_read	= nfs_file_read,
 	.aio_write	= nfs_file_write,
+#ifdef CONFIG_MMU
 	.mmap		= nfs_file_mmap,
+#else
+	.mmap		= generic_file_mmap,
+#endif
 	.open		= nfs_file_open,
 	.flush		= nfs_file_flush,
 	.release	= nfs_file_release,
_

Patches currently in -mm which might be from cooloney@kernel.org are

origin.patch
git-watchdog.patch
smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch

