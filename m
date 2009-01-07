From: akpm@linux-foundation.org
Subject: - romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:24:07 -0800
Message-ID: <200901072324.n07NO7iU007403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754799AbZAGXYk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:24:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch

This patch was dropped because it was folded into romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#32: FILE: fs/romfs/inode.c:530:
+        ret = romfs_strnlen(i, ino+ROMFH_SIZE, ROMFS_MAXFN);$

ERROR: code indent should use tabs where possible
#33: FILE: fs/romfs/inode.c:531:
+        if (ret >= 0)$

ERROR: code indent should use tabs where possible
#34: FILE: fs/romfs/inode.c:532:
+                ino = ((ROMFH_SIZE+ret+1+ROMFH_PAD)&ROMFH_MASK);$

total: 3 errors, 0 warnings, 20 lines checked

./patches/romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: roel kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/romfs/inode.c~romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes fs/romfs/inode.c
--- a/fs/romfs/inode.c~romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes
+++ a/fs/romfs/inode.c
@@ -527,11 +527,11 @@ romfs_iget(struct super_block *sb, unsig
 	i->i_uid = i->i_gid = 0;
 
         /* Precalculate the data offset */
-        ret = romfs_strnlen(i, ino+ROMFH_SIZE, ROMFS_MAXFN);
-        if (ret >= 0)
-                ino = ((ROMFH_SIZE+ret+1+ROMFH_PAD)&ROMFH_MASK);
-        else
-                ino = 0;
+	ret = romfs_strnlen(i, ino + ROMFH_SIZE, ROMFS_MAXFN);
+	if (ret >= 0)
+		ino = (ROMFH_SIZE + ret + 1 + ROMFH_PAD) & ROMFH_MASK;
+	else
+		ino = 0;
 
         ROMFS_I(i)->i_metasize = ino;
         ROMFS_I(i)->i_dataoffset = ino+(i->i_ino&ROMFH_MASK);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
w1-allow-master-io-commands.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
kmemleak-add-the-base-support-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

