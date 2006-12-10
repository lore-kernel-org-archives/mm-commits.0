From: akpm@osdl.org
Subject: + xfs-remove-useless-wmb-memory-barrier.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:40:15 -0800
Message-ID: <200612101940.kBAJeFF8001136@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54322 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762368AbWLJTk2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:40:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, dgc@sgi.com


The patch titled
     xfs: remove useless wmb() memory barrier
has been added to the -mm tree.  Its filename is
     xfs-remove-useless-wmb-memory-barrier.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xfs: remove useless wmb() memory barrier
From: Ralf Baechle <ralf@linux-mips.org>

wake_up's implementation does an implicit memory barrier and I think that's
the only sane semantics as the caller shouldn't have to worry.  So this
write memory barrier is useless.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/xfs/linux-2.6/xfs_super.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/xfs/linux-2.6/xfs_super.c~xfs-remove-useless-wmb-memory-barrier fs/xfs/linux-2.6/xfs_super.c
--- a/fs/xfs/linux-2.6/xfs_super.c~xfs-remove-useless-wmb-memory-barrier
+++ a/fs/xfs/linux-2.6/xfs_super.c
@@ -553,7 +553,6 @@ vfs_sync_worker(
 		error = bhv_vfs_sync(vfsp, SYNC_FSDATA | SYNC_BDFLUSH | \
 					SYNC_ATTR | SYNC_REFCACHE, NULL);
 	vfsp->vfs_sync_seq++;
-	wmb();
 	wake_up(&vfsp->vfs_wait_single_sync_task);
 }
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
sysctl-remove-unused-context-param.patch
dont-build-some-broken-isdn-drivers-on-big-endian-mips.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
git-net.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pci-legacy-resource-fix.patch
pci-legacy-resource-fix-tidy.patch
xfs-remove-useless-wmb-memory-barrier.patch
tty-remove-useless-memory-barrier.patch
getting-rid-of-all-casts-of-kalloc-calls.patch

