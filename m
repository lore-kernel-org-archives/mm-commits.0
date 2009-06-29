From: akpm@linux-foundation.org
Subject: + hostfs-set-maximum-filesize-in-superblock-for-proper-lfs-support.patch added to -mm tree
Date: Mon, 29 Jun 2009 15:33:16 -0700
Message-ID: <200906292233.n5TMXGqD012461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbZF2WdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 18:33:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wolfgang@illmeyer.com, jdike@addtoit.com


The patch titled
     hostfs: set maximum filesize in superblock for proper LFS support
has been added to the -mm tree.  Its filename is
     hostfs-set-maximum-filesize-in-superblock-for-proper-lfs-support.patch

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
Subject: hostfs: set maximum filesize in superblock for proper LFS support
From: Wolfgang Illmeyer <wolfgang@illmeyer.com>

Maximum file size for hostfs mounts defaults to 2GB, so bigger files cannot be
read/written through hostfs. This patch initializes the maximum file size to
MAX_LFS_SIZE.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13531

Signed-off-by: Wolfgang Illmeyer <wolfgang@illmeyer.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_kern.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/hostfs/hostfs_kern.c~hostfs-set-maximum-filesize-in-superblock-for-proper-lfs-support fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~hostfs-set-maximum-filesize-in-superblock-for-proper-lfs-support
+++ a/fs/hostfs/hostfs_kern.c
@@ -972,6 +972,7 @@ static int hostfs_fill_sb_common(struct 
 	sb->s_blocksize_bits = 10;
 	sb->s_magic = HOSTFS_SUPER_MAGIC;
 	sb->s_op = &hostfs_sbops;
+	sb->s_maxbytes = MAX_LFS_FILESIZE;
 
 	/* NULL is printed as <NULL> by sprintf: avoid that. */
 	if (req_root == NULL)
_

Patches currently in -mm which might be from wolfgang@illmeyer.com are

hostfs-set-maximum-filesize-in-superblock-for-proper-lfs-support.patch

