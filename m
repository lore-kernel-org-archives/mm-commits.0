Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333313;
	b=e4APp2LxT9TpcGRBItoZMQDGjlXpvsEi/DPwhWYZ9EHDY1bCo2rX0feFdVvnBWVrqwaE
	 12Do106aZa1D3EFGkO4DP5pS/ERBREcC83SR8bh/oIsEHqERcw6gF9yZ7ljS9xFSMrg1m
	 gNWIS2r4lipbtbJrmKdXr5gBhh7jA44/t/LlRexBaao/CzSpBnYmootQHrZxpm10vXcjA
	 dQ/VLmLstKNAhTXjHJg7JS4Yi6DJFdnHF/iSEN65RcXboz6ptLVAiR4Xn+X+89iVIvw61
	 btNstS7P6pCV9kGrh3X3brWinTrWl6HUwHZjx2tRi3oXAcONJfggACnGrna3U31OZlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333313;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6k4OHNhHNLNxyIH8WEWEmlMRH/7d9L1ogtJAPQBlZVI=;
	b=NK0peOkmv/HkS44qXn8vn0ffG1UDk9OR+YOkaSebQBjfwJaaKcoVHzIbAQCGkOdMC1kE
	 aC0tr9PKVS1oJs9mVqv8zrlFmAWbZQaYEoOK9v+TSBsb/udTAtnh91xQwGVGRApJBWxVM
	 VJTgsE9T5EFoWtLSQKlAtLNQDpyOnexNHZe0CwG69LoeqpJRe1f6hAAS6RMB7Eelqrndd
	 d+8Ophx8TCf1DLCZChJ38CDNUUiuEjWWVLHfYPVWUO25z0ChUUq9KwurUbYFyhAZf7Iaj
	 NLxKH5I3qg0kco9WzuoROhcdugl32sBgANeNWuStn7h7BPrev5EYpMmmBZu/sNSfPgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DPaUhuTG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCE2606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 04:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DPaUhuTG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5271F000C1;
	Fri, 30 Oct 2026 04:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793333312;
	bh=6k4OHNhHNLNxyIH8WEWEmlMRH/7d9L1ogtJAPQBlZVI=;
	h=Date:To:From:Subject;
	b=DPaUhuTGGDt4q9ndwbAF+teGwnIb+L6k2sP3Mq9p4K3EDv1lv4GCAHkkcFC2RF8CK
	 tZgwFNQU6Bwu9duDHkxxIz6rJSfv7M6xZULdPu0vYXzEjzNnFKFt516BQuu18PHeTt
	 MdZWP9dWEykSFK5napvTothTYyGF2XxaNLCqG4pg=
Date: Thu, 29 Oct 2026 21:08:32 -0700
To: mm-commits@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,
	jlbec@evilplan.org,ailiop@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-replace-ocfs2-specific-falloc-ioctls-with-generic-ones.patch added to mm-nonmm-unstable branch
Message-Id: <20261030040832.AE5271F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: replace ocfs2-specific falloc ioctls with generic ones
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-replace-ocfs2-specific-falloc-ioctls-with-generic-ones.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-replace-ocfs2-specific-falloc-ioctls-with-generic-ones.patch

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
Subject: ocfs2: replace ocfs2-specific falloc ioctls with generic ones
Date: Thu, 22 Oct 2026 15:04:56 +0200

Patch series "ocfs2: clean up falloc and inode flag definitions", v2.

This short series cleans up and replaces redundant ocfs2-specific falloc
ioctl and inode flag definitions in favor of generic ones.


This patch (of 2):

Replace custom ocfs2 space reservation structures and ioctl definitions
with the generic file space allocation interfaces.

Those were originally copied from xfs in commit b25801038da5 ("ocfs2:
Support xfs style space reservation ioctls") for compatibility reasons,
which were eventually lifted to vfs and made generic. As such there is
no reason to carry around the redundant definitions any longer, they can
be dropped at this point.

Link: https://lore.kernel.org/20261022130457.69343-1-ailiop@suse.com
Link: https://lore.kernel.org/20261022130457.69343-2-ailiop@suse.com
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/file.c        |   26 +++++++++++++-------------
 fs/ocfs2/file.h        |    4 +++-
 fs/ocfs2/ioctl.c       |   19 ++++++++++---------
 fs/ocfs2/ocfs2_ioctl.h |   26 --------------------------
 4 files changed, 26 insertions(+), 49 deletions(-)

--- a/fs/ocfs2/file.c~ocfs2-replace-ocfs2-specific-falloc-ioctls-with-generic-ones
+++ a/fs/ocfs2/file.c
@@ -1969,7 +1969,7 @@ out:
  */
 static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 				     loff_t f_pos, unsigned int cmd,
-				     struct ocfs2_space_resv *sr,
+				     struct space_resv *sr,
 				     int change_size)
 {
 	int ret;
@@ -2033,8 +2033,8 @@ static int __ocfs2_change_file_space(str
 	}
 	size = sr->l_start + sr->l_len;
 
-	if (cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64 ||
-	    cmd == OCFS2_IOC_UNRESVSP || cmd == OCFS2_IOC_UNRESVSP64) {
+	if (cmd == FS_IOC_RESVSP || cmd == FS_IOC_RESVSP64 ||
+	    cmd == FS_IOC_UNRESVSP || cmd == FS_IOC_UNRESVSP64) {
 		if (sr->l_len <= 0) {
 			ret = -EINVAL;
 			goto out_inode_unlock;
@@ -2051,8 +2051,8 @@ static int __ocfs2_change_file_space(str
 
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 	switch (cmd) {
-	case OCFS2_IOC_RESVSP:
-	case OCFS2_IOC_RESVSP64:
+	case FS_IOC_RESVSP:
+	case FS_IOC_RESVSP64:
 		/*
 		 * This takes unsigned offsets, but the signed ones we
 		 * pass have been checked against overflow above.
@@ -2060,8 +2060,8 @@ static int __ocfs2_change_file_space(str
 		ret = ocfs2_allocate_unwritten_extents(inode, sr->l_start,
 						       sr->l_len);
 		break;
-	case OCFS2_IOC_UNRESVSP:
-	case OCFS2_IOC_UNRESVSP64:
+	case FS_IOC_UNRESVSP:
+	case FS_IOC_UNRESVSP64:
 		ret = ocfs2_remove_inode_range(inode, di_bh, sr->l_start,
 					       sr->l_len);
 		break;
@@ -2115,16 +2115,16 @@ out:
 }
 
 int ocfs2_change_file_space(struct file *file, unsigned int cmd,
-			    struct ocfs2_space_resv *sr)
+			    struct space_resv *sr)
 {
 	struct inode *inode = file_inode(file);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int ret;
 
-	if ((cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) &&
+	if ((cmd == FS_IOC_RESVSP || cmd == FS_IOC_RESVSP64) &&
 	    !ocfs2_writes_unwritten_extents(osb))
 		return -ENOTTY;
-	else if ((cmd == OCFS2_IOC_UNRESVSP || cmd == OCFS2_IOC_UNRESVSP64) &&
+	else if ((cmd == FS_IOC_UNRESVSP || cmd == FS_IOC_UNRESVSP64) &&
 		 !ocfs2_sparse_alloc(osb))
 		return -ENOTTY;
 
@@ -2147,9 +2147,9 @@ static long ocfs2_fallocate(struct file
 {
 	struct inode *inode = file_inode(file);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_space_resv sr;
+	struct space_resv sr;
 	int change_size = 1;
-	int cmd = OCFS2_IOC_RESVSP64;
+	int cmd = FS_IOC_RESVSP64;
 	int ret = 0;
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
@@ -2166,7 +2166,7 @@ static long ocfs2_fallocate(struct file
 	}
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
-		cmd = OCFS2_IOC_UNRESVSP64;
+		cmd = FS_IOC_UNRESVSP64;
 
 	sr.l_whence = 0;
 	sr.l_start = (s64)offset;
--- a/fs/ocfs2/file.h~ocfs2-replace-ocfs2-specific-falloc-ioctls-with-generic-ones
+++ a/fs/ocfs2/file.h
@@ -10,6 +10,8 @@
 #ifndef OCFS2_FILE_H
 #define OCFS2_FILE_H
 
+#include <linux/falloc.h>
+
 extern const struct file_operations ocfs2_fops;
 extern const struct file_operations ocfs2_dops;
 extern const struct file_operations ocfs2_fops_no_plocks;
@@ -64,7 +66,7 @@ int ocfs2_update_inode_atime(struct inod
 			     struct buffer_head *bh);
 
 int ocfs2_change_file_space(struct file *file, unsigned int cmd,
-			    struct ocfs2_space_resv *sr);
+			    struct space_resv *sr);
 
 int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
 				   size_t count);
--- a/fs/ocfs2/ioctl.c~ocfs2-replace-ocfs2-specific-falloc-ioctls-with-generic-ones
+++ a/fs/ocfs2/ioctl.c
@@ -11,6 +11,7 @@
 #include <linux/blkdev.h>
 #include <linux/compat.h>
 #include <linux/fileattr.h>
+#include <linux/falloc.h>
 
 #include <cluster/masklog.h>
 
@@ -857,12 +858,12 @@ long ocfs2_ioctl(struct file *filp, unsi
 	int status;
 
 	switch (cmd) {
-	case OCFS2_IOC_RESVSP:
-	case OCFS2_IOC_RESVSP64:
-	case OCFS2_IOC_UNRESVSP:
-	case OCFS2_IOC_UNRESVSP64:
+	case FS_IOC_RESVSP:
+	case FS_IOC_RESVSP64:
+	case FS_IOC_UNRESVSP:
+	case FS_IOC_UNRESVSP64:
 	{
-		struct ocfs2_space_resv sr;
+		struct space_resv sr;
 
 		if (copy_from_user(&sr, (int __user *) arg, sizeof(sr)))
 			return -EFAULT;
@@ -971,10 +972,10 @@ long ocfs2_compat_ioctl(struct file *fil
 	void __user *argp = (void __user *)arg;
 
 	switch (cmd) {
-	case OCFS2_IOC_RESVSP:
-	case OCFS2_IOC_RESVSP64:
-	case OCFS2_IOC_UNRESVSP:
-	case OCFS2_IOC_UNRESVSP64:
+	case FS_IOC_RESVSP:
+	case FS_IOC_RESVSP64:
+	case FS_IOC_UNRESVSP:
+	case FS_IOC_UNRESVSP64:
 	case OCFS2_IOC_GROUP_EXTEND:
 	case OCFS2_IOC_GROUP_ADD:
 	case OCFS2_IOC_GROUP_ADD64:
--- a/fs/ocfs2/ocfs2_ioctl.h~ocfs2-replace-ocfs2-specific-falloc-ioctls-with-generic-ones
+++ a/fs/ocfs2/ocfs2_ioctl.h
@@ -10,32 +10,6 @@
 #ifndef OCFS2_IOCTL_H
 #define OCFS2_IOCTL_H
 
-/*
- * Space reservation / allocation / free ioctls and argument structure
- * are designed to be compatible with XFS.
- *
- * ALLOCSP* and FREESP* are not and will never be supported, but are
- * included here for completeness.
- */
-struct ocfs2_space_resv {
-	__s16		l_type;
-	__s16		l_whence;
-	__s64		l_start;
-	__s64		l_len;		/* len == 0 means until end of file */
-	__s32		l_sysid;
-	__u32		l_pid;
-	__s32		l_pad[4];	/* reserve area			    */
-};
-
-#define OCFS2_IOC_ALLOCSP		_IOW ('X', 10, struct ocfs2_space_resv)
-#define OCFS2_IOC_FREESP		_IOW ('X', 11, struct ocfs2_space_resv)
-#define OCFS2_IOC_RESVSP		_IOW ('X', 40, struct ocfs2_space_resv)
-#define OCFS2_IOC_UNRESVSP	_IOW ('X', 41, struct ocfs2_space_resv)
-#define OCFS2_IOC_ALLOCSP64	_IOW ('X', 36, struct ocfs2_space_resv)
-#define OCFS2_IOC_FREESP64	_IOW ('X', 37, struct ocfs2_space_resv)
-#define OCFS2_IOC_RESVSP64	_IOW ('X', 42, struct ocfs2_space_resv)
-#define OCFS2_IOC_UNRESVSP64	_IOW ('X', 43, struct ocfs2_space_resv)
-
 /* Used to pass group descriptor data when online resize is done */
 struct ocfs2_new_group_input {
 	__u64 group;		/* Group descriptor's blkno. */
_

Patches currently in -mm which might be from ailiop@suse.com are

ocfs2-replace-ocfs2-specific-falloc-ioctls-with-generic-ones.patch
ocfs2-replace-ocfs2-specific-inode-flags-with-generic-ones.patch

