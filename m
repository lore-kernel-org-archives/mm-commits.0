From: akpm@linux-foundation.org
Subject: + hostfs-fix-a-duplicated-global-function-name.patch added to -mm tree
Date: Tue, 18 Nov 2008 23:52:19 -0800
Message-ID: <200811190752.mAJ7qJnM025383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112AbYKSHw0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 02:52:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wangcong@zeuux.org, jdike@addtoit.com


The patch titled
     hostfs: fix a duplicated global function name
has been added to the -mm tree.  Its filename is
     hostfs-fix-a-duplicated-global-function-name.patch

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
Subject: hostfs: fix a duplicated global function name
From: WANG Cong <wangcong@zeuux.org>

fs/hostfs/hostfs_user.c defines do_readlink() as non-static, and so does
fs/xfs/linux-2.6/xfs_ioctl.c when CONFIG_XFS_DEBUG=y.  So rename
do_readlink() in hostfs to hostfs_do_readlink().

I think it's better if XFS guys will also rename their do_readlink(),
it's not necessary to use such a general name.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs.h      |    2 +-
 fs/hostfs/hostfs_kern.c |    4 ++--
 fs/hostfs/hostfs_user.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/hostfs/hostfs.h~hostfs-fix-a-duplicated-global-function-name fs/hostfs/hostfs.h
--- a/fs/hostfs/hostfs.h~hostfs-fix-a-duplicated-global-function-name
+++ a/fs/hostfs/hostfs.h
@@ -81,7 +81,7 @@ extern int do_rmdir(const char *file);
 extern int do_mknod(const char *file, int mode, unsigned int major,
 		    unsigned int minor);
 extern int link_file(const char *from, const char *to);
-extern int do_readlink(char *file, char *buf, int size);
+extern int hostfs_do_readlink(char *file, char *buf, int size);
 extern int rename_file(char *from, char *to);
 extern int do_statfs(char *root, long *bsize_out, long long *blocks_out,
 		     long long *bfree_out, long long *bavail_out,
diff -puN fs/hostfs/hostfs_kern.c~hostfs-fix-a-duplicated-global-function-name fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~hostfs-fix-a-duplicated-global-function-name
+++ a/fs/hostfs/hostfs_kern.c
@@ -168,7 +168,7 @@ static char *follow_link(char *link)
 		if (name == NULL)
 			goto out;
 
-		n = do_readlink(link, name, len);
+		n = hostfs_do_readlink(link, name, len);
 		if (n < len)
 			break;
 		len *= 2;
@@ -943,7 +943,7 @@ int hostfs_link_readpage(struct file *fi
 	name = inode_name(page->mapping->host, 0);
 	if (name == NULL)
 		return -ENOMEM;
-	err = do_readlink(name, buffer, PAGE_CACHE_SIZE);
+	err = hostfs_do_readlink(name, buffer, PAGE_CACHE_SIZE);
 	kfree(name);
 	if (err == PAGE_CACHE_SIZE)
 		err = -E2BIG;
diff -puN fs/hostfs/hostfs_user.c~hostfs-fix-a-duplicated-global-function-name fs/hostfs/hostfs_user.c
--- a/fs/hostfs/hostfs_user.c~hostfs-fix-a-duplicated-global-function-name
+++ a/fs/hostfs/hostfs_user.c
@@ -377,7 +377,7 @@ int link_file(const char *to, const char
 	return 0;
 }
 
-int do_readlink(char *file, char *buf, int size)
+int hostfs_do_readlink(char *file, char *buf, int size)
 {
 	int n;
 
_

Patches currently in -mm which might be from wangcong@zeuux.org are

hostfs-fix-a-duplicated-global-function-name.patch
scripts-improve-the-decodecode-script.patch
ipc-clean-up-ipc-shmc.patch
ipc-do-not-goto-to-the-next-line.patch

