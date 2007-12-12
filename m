From: akpm@linux-foundation.org
Subject: + nfs-fix-an-oops-in-nfs-unmount.patch added to -mm tree
Date: Tue, 11 Dec 2007 19:01:52 -0800
Message-ID: <200712120301.lBC31qZx022498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38715 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbXLLDCg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 22:02:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trond.myklebust@fys.uio.no, Trond.Myklebust@netapp.com


The patch titled
     NFS: Fix an Oops in NFS unmount
has been added to the -mm tree.  Its filename is
     nfs-fix-an-oops-in-nfs-unmount.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: Fix an Oops in NFS unmount
From: Trond Myklebust <trond.myklebust@fys.uio.no>

Ensure that the dummy 'root dentry' is invisible to d_find_alias().  If
not, then it may be spliced into the tree if a parent directory from the
same filesystem gets mounted at a later time.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/getroot.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN fs/nfs/getroot.c~nfs-fix-an-oops-in-nfs-unmount fs/nfs/getroot.c
--- a/fs/nfs/getroot.c~nfs-fix-an-oops-in-nfs-unmount
+++ a/fs/nfs/getroot.c
@@ -57,6 +57,17 @@ static int nfs_superblock_set_dummy_root
 		}
 		/* Circumvent igrab(): we know the inode is not being freed */
 		atomic_inc(&inode->i_count);
+		/*
+		 * Ensure that this dentry is invisible to d_find_alias().
+		 * Otherwise, it may be spliced into the tree by
+		 * d_materialise_unique if a parent directory from the same
+		 * filesystem gets mounted at a later time.
+		 * This again causes shrink_dcache_for_umount_subtree() to
+		 * Oops, since the test for IS_ROOT() will fail.
+		 */
+		spin_lock(&dcache_lock);
+		list_del_init(&sb->s_root->d_alias);
+		spin_unlock(&dcache_lock);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from trond.myklebust@fys.uio.no are

knfsd-change-mailing-list-for-nfsd-in-maintainers.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
git-nfsd.patch
nfs-fix-nfs-mountpoint-crossing.patch
nfs-fix-an-oops-in-nfs-unmount.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
add-lock_page_killable.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-nfs4-fix.patch
