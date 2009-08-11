From: akpm@linux-foundation.org
Subject: + vfs-change-sb-s_maxbytes-to-a-loff_t.patch added to -mm tree
Date: Mon, 10 Aug 2009 21:45:18 -0700
Message-ID: <200908110445.n7B4jIuj010592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbZHKLzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 07:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, hannes@cmpxchg.org, hch@lst.de, msb@google.com, rlove@google.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: change sb->s_maxbytes to a loff_t
has been added to the -mm tree.  Its filename is
     vfs-change-sb-s_maxbytes-to-a-loff_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: change sb->s_maxbytes to a loff_t
From: Jeff Layton <jlayton@redhat.com>

sb->s_maxbytes is supposed to indicate the maximum size of a file that can
exist on the filesystem.  It's declared as an unsigned long long.

Even if a filesystem has no inherent limit that prevents it from using
every bit in that unsigned long long, it's still problematic to set it to
anything larger than MAX_LFS_FILESIZE.  There are places in the kernel
that cast s_maxbytes to a signed value.  If it's set too large then this
cast makes it a negative number and generally breaks the comparison.

Change s_maxbytes to be loff_t instead.  That should help eliminate the
temptation to set it too large by making it a signed value.

Also, add a warning for couple of releases to help catch filesystems that
set s_maxbytes too large.  Eventually we can either convert this to a
BUG() or just remove it and in the hope that no one will get it wrong now
that it's a signed value.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Robert Love <rlove@google.com>
Cc: Mandeep Singh Baines <msb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c         |   10 ++++++++++
 include/linux/fs.h |    2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN fs/super.c~vfs-change-sb-s_maxbytes-to-a-loff_t fs/super.c
--- a/fs/super.c~vfs-change-sb-s_maxbytes-to-a-loff_t
+++ a/fs/super.c
@@ -887,6 +887,16 @@ vfs_kern_mount(struct file_system_type *
  	if (error)
  		goto out_sb;
 
+	/*
+	 * filesystems should never set s_maxbytes larger than MAX_LFS_FILESIZE
+	 * but s_maxbytes was an unsigned long long for many releases. Throw
+	 * this warning for a little while to try and catch filesystems that
+	 * violate this rule. This warning should be either removed or
+	 * converted to a BUG() in 2.6.34.
+	 */
+	WARN((mnt->mnt_sb->s_maxbytes < 0), "WARNING: %s set sb->s_maxbytes to "
+		"negative value (%lld)\n", type->name, mnt->mnt_sb->s_maxbytes);
+
 	mnt->mnt_mountpoint = mnt->mnt_root;
 	mnt->mnt_parent = mnt;
 	up_write(&mnt->mnt_sb->s_umount);
diff -puN include/linux/fs.h~vfs-change-sb-s_maxbytes-to-a-loff_t include/linux/fs.h
--- a/include/linux/fs.h~vfs-change-sb-s_maxbytes-to-a-loff_t
+++ a/include/linux/fs.h
@@ -1317,7 +1317,7 @@ struct super_block {
 	unsigned long		s_blocksize;
 	unsigned char		s_blocksize_bits;
 	unsigned char		s_dirt;
-	unsigned long long	s_maxbytes;	/* Max file size */
+	loff_t			s_maxbytes;	/* Max file size */
 	struct file_system_type	*s_type;
 	const struct super_operations	*s_op;
 	struct dquot_operations	*dq_op;
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
vfs-make-get_sb_pseudo-set-s_maxbytes-to-value-that-can-be-cast-to-signed.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch

