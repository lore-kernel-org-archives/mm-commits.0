From: akpm@linux-foundation.org
Subject: - ext3-issue-warning-when-bad-inode-found-via-ext3_lookup.patch removed from -mm tree
Date: Fri, 21 Dec 2007 13:56:30 -0800
Message-ID: <200712212156.lBLLuU0v001310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41353 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753254AbXLUV5I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 16:57:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ext3: issue warning when bad inode found via ext3_lookup
has been removed from the -mm tree.  Its filename was
     ext3-issue-warning-when-bad-inode-found-via-ext3_lookup.patch

This patch was dropped because it conflicts with iget-stop-ext3-from-using-iget-and-read_inode-try.patch

------------------------------------------------------
Subject: ext3: issue warning when bad inode found via ext3_lookup
From: Eric Sandeen <sandeen@redhat.com>

I have a hand-crafted bad filesystem image which has corruption:

[root@inode ~]# ls mnt/dir
file1  file2  file3  file4  file5
[root@inode ~]# ls mnt/dir/file4
ls: cannot access mnt/dir/file4: No such file or directory
[root@inode ~]# ls -l mnt/dir
ls: cannot access mnt/dir/file4: No such file or directory
total 8
drwxr-xr-x 2 root root 1024 2007-09-04 13:36 file1
drwxr-xr-x 2 root root 1024 2007-09-04 13:36 file2
drwxr-xr-x 2 root root 1024 2007-09-04 13:36 file3
d????????? ? ?    ?       ?                ? file4
drwxr-xr-x 2 root root 1024 2007-09-04 13:36 file5

e2fsck also knows it's corrupted:
Pass 2: Checking directory structure
Entry 'file4' in /dir (2049) has deleted/unused inode 13.  Clear? no

Entry 'file4' in /dir (2049) has an incorrect filetype (was 2, should be 1).
Fix? no

Pass 3: Checking directory connectivity
Unconnected directory inode 2053 (/dir/???)

BUT there are no kernel messages logged anywhere because ext3_read_inode
silently makes a bad_inode in this case, so that stale NFS filehandles
aren't noisy.  However, when we encounter such a problem after a by-name
lookup, I think a warning is appropriate, as it indicates filesystem
corruption.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ext3/namei.c~ext3-issue-warning-when-bad-inode-found-via-ext3_lookup fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-issue-warning-when-bad-inode-found-via-ext3_lookup
+++ a/fs/ext3/namei.c
@@ -1045,6 +1045,9 @@ static struct dentry *ext3_lookup(struct
 			return ERR_PTR(-EACCES);
 
 		if (is_bad_inode(inode)) {
+			ext3_warning(inode->i_sb, __FUNCTION__,
+				     "bad inode %lu in dir #%lu",
+				      inode->i_ino, dir->i_ino);
 			iput(inode);
 			return ERR_PTR(-ENOENT);
 		}
_

Patches currently in -mm which might be from sandeen@redhat.com are

ecryptfs-fix-string-overflow-on-long-cipher-names.patch
ecryptfs-fix-unlocking-in-error-paths.patch
ecryptfs-redo-dgetmntget-on-dentry_open-failure.patch
hfs-handle-more-on-disk-corruptions-without-oopsing.patch
ext2-change-the-default-behaviour-on-error.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
ext3-change-the-default-behaviour-on-error.patch
ext3-issue-warning-when-bad-inode-found-via-ext3_lookup.patch
