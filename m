From: akpm@linux-foundation.org
Subject: - struct-vfsmount-keep-mnt_count-mnt_expiry_mark-away-from-mnt_flags.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:50:27 -0800
Message-ID: <200702112250.l1BMoRvQ015858@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60058 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744AbXBKWu5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:50:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, mm-commits@vger.kernel.org


The patch titled
     struct vfsmount: keep mnt_count & mnt_expiry_mark away from mnt_flags
has been removed from the -mm tree.  Its filename was
     struct-vfsmount-keep-mnt_count-mnt_expiry_mark-away-from-mnt_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct vfsmount: keep mnt_count & mnt_expiry_mark away from mnt_flags
From: Eric Dumazet <dada1@cosmosbay.com>

I noticed cache misses in touch_atime() that can be avoided if we keep
mnt_count & mnt_expiry_mark in a different cache line than mnt_flags
(mostly read)

mnt_count & mnt_expiry_mark are modified each time a file is opened/closed
in a file system.

touch_atime() is called each time a file is read, and generally needs to
read mnt_flags.

Other fields of struct vfsmount are mostly read so I chose to move
mnt_count & mnt_expiry_mark at the end of struct vfsmount.  And adding a
comment so that nobody tries to re-arrange fields to fill the holes :)

On 64bits platforms, the new offsetof(mnt_count) is 0xC0
On 32bits platforms, it is 0x60, so I didnot add a
____cacheline_aligned_in_smp because it would have a too big impact on the
size of this object (in particular if CONFIG_X86_L1_CACHE_SHIFT=7)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mount.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN include/linux/mount.h~struct-vfsmount-keep-mnt_count-mnt_expiry_mark-away-from-mnt_flags include/linux/mount.h
--- a/include/linux/mount.h~struct-vfsmount-keep-mnt_count-mnt_expiry_mark-away-from-mnt_flags
+++ a/include/linux/mount.h
@@ -43,9 +43,8 @@ struct vfsmount {
 	struct super_block *mnt_sb;	/* pointer to superblock */
 	struct list_head mnt_mounts;	/* list of children, anchored here */
 	struct list_head mnt_child;	/* and going through their mnt_child */
-	atomic_t mnt_count;
 	int mnt_flags;
-	int mnt_expiry_mark;		/* true if marked for expiry */
+	/* 4 bytes hole on 64bits arches */
 	char *mnt_devname;		/* Name of device e.g. /dev/dsk/hda1 */
 	struct list_head mnt_list;
 	struct list_head mnt_expire;	/* link in fs-specific expiry list */
@@ -54,6 +53,13 @@ struct vfsmount {
 	struct list_head mnt_slave;	/* slave list entry */
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
+	/*
+	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
+	 * to let these frequently modified fields in a separate cache line
+	 * (so that reads of mnt_flags wont ping-pong on SMP machines)
+	 */
+	atomic_t mnt_count;
+	int mnt_expiry_mark;		/* true if marked for expiry */
 	int mnt_pinned;
 };
 
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
fs-speedup-rw_verify_area.patch
close_files-add-scheduling-point.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
