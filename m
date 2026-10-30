Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333317;
	b=JQ7yCq8etfIEnK8i7TUK2Ya41I9fXcJR79G/TduyrSVxUwTq/WZjZIlso0nsM7jTh+x9
	 eIrlMHxA8UcOLHkG13Gvd80MxEe8t9UNe4YPHltWhSFJTD+Et24bogYu7lG4l+ZJMlrSH
	 QZLPhbX57U+GQnehguiI6AmBu9OyMIhm6w8MCGGkk5FpE28uH9uPeEygKGqXMiprF5EPK
	 FdY6pIhytlTa9zuOOmwXExZv8myvsMg+x0O/67IEEoJIX+Ie7QwJKCKoQeUGsvxeZnDSz
	 HBP7k4f005OFG9acnyCE1fHWrTZxxqjUdMY1xGcbBg6szDJw9oriwC0WyqzAHUs+UVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333317;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=bIWz+QI4aSwp13drReXvsmD0+p+3+//DptvyTlL07io=;
	b=NAwlUO8lPdY6LhTiymULycVprD1nmC76wiJc8jg+UpIr0gQ6DfPp9vdtSSB1ZkbKCRQ3
	 JDHPGtIfi+hRo9tOz/qzmm44SuPHHtgYVM64rUVQ9UB6TZACjqa0tyR9Yd0McOlfByJ/5
	 KXWiUpCrwGXOut+NzGpbVl0n74kuTlDl3in4GDn2ZgU+rXokl4uHAQPujde6njXcZTQnj
	 GBR+i0OuD/hdKrj+xdbcXKte+VhoEMJgXrraQoeqgb/o8BVZmaOCRn9M9xcVkMKcOds9O
	 PUPmp9iPFe8C04rhLdEt0GBYERAtQxC4IkD8o1JMzRQe1z7RPFUbd6AKi2OViSLe1FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WQScdvaT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4640606A330
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 04:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WQScdvaT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191E91F000C1;
	Fri, 30 Oct 2026 04:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793333316;
	bh=bIWz+QI4aSwp13drReXvsmD0+p+3+//DptvyTlL07io=;
	h=Date:To:From:Subject;
	b=WQScdvaTt2WgCLKwhPgUgnLLhJkofxddzt4yJCSUnKT+iypFsdQI87Q1LcQso/CtI
	 +NNya9IKrU5EeDXmpM2bHGaOopa18GEo9dMsxm0UFpb43YVVf+6s5r7GF61daQqpI+
	 O1QhxH3SQ+um4Rqo86fk80vmMlFJcGXVIPHLpLdY=
Date: Thu, 29 Oct 2026 21:08:35 -0700
To: mm-commits@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,
	jlbec@evilplan.org,ailiop@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-replace-ocfs2-specific-inode-flags-with-generic-ones.patch added to mm-nonmm-unstable branch
Message-Id: <20261030040836.191E91F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: replace ocfs2-specific inode flags with generic ones
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-replace-ocfs2-specific-inode-flags-with-generic-ones.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-replace-ocfs2-specific-inode-flags-with-generic-ones.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Anthony Iliopoulos <ailiop@suse.com>
Subject: ocfs2: replace ocfs2-specific inode flags with generic ones
Date: Thu, 22 Oct 2026 15:04:57 +0200

The ocfs2 inode flag macros are alias definitions for the generic fs
flags. Remove these redundant macros, most of which are anyway unused,
and use the generic flags directly.

Link: https://lore.kernel.org/20261022130457.69343-3-ailiop@suse.com
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c    |   24 ++++++++++++------------
 fs/ocfs2/ioctl.c    |    8 ++++----
 fs/ocfs2/ocfs2_fs.h |   27 ---------------------------
 3 files changed, 16 insertions(+), 43 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-replace-ocfs2-specific-inode-flags-with-generic-ones
+++ a/fs/ocfs2/inode.c
@@ -107,16 +107,16 @@ void ocfs2_set_inode_flags(struct inode
 	inode->i_flags &= ~(S_IMMUTABLE |
 		S_SYNC | S_APPEND | S_NOATIME | S_DIRSYNC);
 
-	if (flags & OCFS2_IMMUTABLE_FL)
+	if (flags & FS_IMMUTABLE_FL)
 		inode->i_flags |= S_IMMUTABLE;
 
-	if (flags & OCFS2_SYNC_FL)
+	if (flags & FS_SYNC_FL)
 		inode->i_flags |= S_SYNC;
-	if (flags & OCFS2_APPEND_FL)
+	if (flags & FS_APPEND_FL)
 		inode->i_flags |= S_APPEND;
-	if (flags & OCFS2_NOATIME_FL)
+	if (flags & FS_NOATIME_FL)
 		inode->i_flags |= S_NOATIME;
-	if (flags & OCFS2_DIRSYNC_FL)
+	if (flags & FS_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
 }
 
@@ -125,18 +125,18 @@ void ocfs2_get_inode_flags(struct ocfs2_
 {
 	unsigned int flags = oi->vfs_inode.i_flags;
 
-	oi->ip_attr &= ~(OCFS2_SYNC_FL|OCFS2_APPEND_FL|
-			OCFS2_IMMUTABLE_FL|OCFS2_NOATIME_FL|OCFS2_DIRSYNC_FL);
+	oi->ip_attr &= ~(FS_SYNC_FL | FS_APPEND_FL | FS_IMMUTABLE_FL |
+			FS_NOATIME_FL | FS_DIRSYNC_FL);
 	if (flags & S_SYNC)
-		oi->ip_attr |= OCFS2_SYNC_FL;
+		oi->ip_attr |= FS_SYNC_FL;
 	if (flags & S_APPEND)
-		oi->ip_attr |= OCFS2_APPEND_FL;
+		oi->ip_attr |= FS_APPEND_FL;
 	if (flags & S_IMMUTABLE)
-		oi->ip_attr |= OCFS2_IMMUTABLE_FL;
+		oi->ip_attr |= FS_IMMUTABLE_FL;
 	if (flags & S_NOATIME)
-		oi->ip_attr |= OCFS2_NOATIME_FL;
+		oi->ip_attr |= FS_NOATIME_FL;
 	if (flags & S_DIRSYNC)
-		oi->ip_attr |= OCFS2_DIRSYNC_FL;
+		oi->ip_attr |= FS_DIRSYNC_FL;
 }
 
 struct inode *ocfs2_ilookup(struct super_block *sb, u64 blkno)
--- a/fs/ocfs2/ioctl.c~ocfs2-replace-ocfs2-specific-inode-flags-with-generic-ones
+++ a/fs/ocfs2/ioctl.c
@@ -78,7 +78,7 @@ int ocfs2_fileattr_get(struct dentry *de
 	flags = OCFS2_I(inode)->ip_attr;
 	ocfs2_inode_unlock(inode, 0);
 
-	fileattr_fill_flags(fa, flags & OCFS2_FL_VISIBLE);
+	fileattr_fill_flags(fa, flags & FS_FL_USER_VISIBLE);
 
 	return status;
 }
@@ -105,11 +105,11 @@ int ocfs2_fileattr_set(const struct mnt_
 	}
 
 	if (!S_ISDIR(inode->i_mode))
-		flags &= ~OCFS2_DIRSYNC_FL;
+		flags &= ~FS_DIRSYNC_FL;
 
 	oldflags = ocfs2_inode->ip_attr;
-	flags = flags & OCFS2_FL_MODIFIABLE;
-	flags |= oldflags & ~OCFS2_FL_MODIFIABLE;
+	flags = flags & FS_FL_USER_MODIFIABLE;
+	flags |= oldflags & ~FS_FL_USER_MODIFIABLE;
 
 	/* Check already done by VFS, but repeat with ocfs lock */
 	status = -EPERM;
--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-replace-ocfs2-specific-inode-flags-with-generic-ones
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -235,33 +235,6 @@
 #define OCFS2_INDEXED_DIR_FL	(0x0008)
 #define OCFS2_HAS_REFCOUNT_FL   (0x0010)
 
-/* Inode attributes, keep in sync with EXT2 */
-#define OCFS2_SECRM_FL			FS_SECRM_FL	/* Secure deletion */
-#define OCFS2_UNRM_FL			FS_UNRM_FL	/* Undelete */
-#define OCFS2_COMPR_FL			FS_COMPR_FL	/* Compress file */
-#define OCFS2_SYNC_FL			FS_SYNC_FL	/* Synchronous updates */
-#define OCFS2_IMMUTABLE_FL		FS_IMMUTABLE_FL	/* Immutable file */
-#define OCFS2_APPEND_FL			FS_APPEND_FL	/* writes to file may only append */
-#define OCFS2_NODUMP_FL			FS_NODUMP_FL	/* do not dump file */
-#define OCFS2_NOATIME_FL		FS_NOATIME_FL	/* do not update atime */
-/* Reserved for compression usage... */
-#define OCFS2_DIRTY_FL			FS_DIRTY_FL
-#define OCFS2_COMPRBLK_FL		FS_COMPRBLK_FL	/* One or more compressed clusters */
-#define OCFS2_NOCOMP_FL			FS_NOCOMP_FL	/* Don't compress */
-#define OCFS2_ECOMPR_FL			FS_ECOMPR_FL	/* Compression error */
-/* End compression flags --- maybe not all used */
-#define OCFS2_BTREE_FL			FS_BTREE_FL	/* btree format dir */
-#define OCFS2_INDEX_FL			FS_INDEX_FL	/* hash-indexed directory */
-#define OCFS2_IMAGIC_FL			FS_IMAGIC_FL	/* AFS directory */
-#define OCFS2_JOURNAL_DATA_FL		FS_JOURNAL_DATA_FL /* Reserved for ext3 */
-#define OCFS2_NOTAIL_FL			FS_NOTAIL_FL	/* file tail should not be merged */
-#define OCFS2_DIRSYNC_FL		FS_DIRSYNC_FL	/* dirsync behaviour (directories only) */
-#define OCFS2_TOPDIR_FL			FS_TOPDIR_FL	/* Top of directory hierarchies*/
-#define OCFS2_RESERVED_FL		FS_RESERVED_FL	/* reserved for ext2 lib */
-
-#define OCFS2_FL_VISIBLE		FS_FL_USER_VISIBLE	/* User visible flags */
-#define OCFS2_FL_MODIFIABLE		FS_FL_USER_MODIFIABLE	/* User modifiable flags */
-
 /*
  * Extent record flags (e_node.leaf.flags)
  */
_

Patches currently in -mm which might be from ailiop@suse.com are

ocfs2-replace-ocfs2-specific-falloc-ioctls-with-generic-ones.patch
ocfs2-replace-ocfs2-specific-inode-flags-with-generic-ones.patch

