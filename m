From: akpm@osdl.org
Subject: + struct-vfsmount-keep-mnt_count-mnt_expiry_mark-away-from-mnt_flags.patch added to -mm tree
Date: Fri, 15 Dec 2006 12:01:05 -0800
Message-ID: <200612152001.kBFK15Xj028038@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40090 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360AbWLOUBS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 15:01:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com


The patch titled
     struct vfsmount: keep mnt_count & mnt_expiry_mark away from mnt_flags
has been added to the -mm tree.  Its filename is
     struct-vfsmount-keep-mnt_count-mnt_expiry_mark-away-from-mnt_flags.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/mount.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

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

convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
get-rid-of-arch_have_xtime_lock.patch
struct-vfsmount-keep-mnt_count-mnt_expiry_mark-away-from-mnt_flags.patch
avoid-one-conditional-branch-in-touch_atime.patch

