From: akpm@linux-foundation.org
Subject: + hpfs-dont-bother-with-the-i_version-counter-or-f_version.patch
 added to -mm tree
Date: Thu, 07 Dec 2017 15:39:55 -0800
Message-ID: <5a29d14b.Zp6Lkt5LAKoxZ7Bk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57248 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbdLGXj4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2017 18:39:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, andreas.dilger@intel.com, anton@tuxera.com, jsimmons@infradead.org, mikulas@artax.karlin.mff.cuni.cz, oleg.drokin@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hpfs: don't bother with the i_version counter or f_version
has been added to the -mm tree.  Its filename is
     hpfs-dont-bother-with-the-i_version-counter-or-f_version.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hpfs-dont-bother-with-the-i_version-counter-or-f_version.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hpfs-dont-bother-with-the-i_version-counter-or-f_version.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: hpfs: don't bother with the i_version counter or f_version

HPFS does not set SB_I_VERSION and does not use the i_version counter
internally.

Link: http://lkml.kernel.org/r/20171207113206.31544-4-jlayton@kernel.org
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/dir.c   |    1 -
 fs/hpfs/dnode.c |    2 --
 fs/hpfs/super.c |    1 -
 3 files changed, 4 deletions(-)

diff -puN fs/hpfs/dir.c~hpfs-dont-bother-with-the-i_version-counter-or-f_version fs/hpfs/dir.c
--- a/fs/hpfs/dir.c~hpfs-dont-bother-with-the-i_version-counter-or-f_version
+++ a/fs/hpfs/dir.c
@@ -150,7 +150,6 @@ static int hpfs_readdir(struct file *fil
 			if (unlikely(ret < 0))
 				goto out;
 			ctx->pos = ((loff_t) hpfs_de_as_down_as_possible(inode->i_sb, hpfs_inode->i_dno) << 4) + 1;
-			file->f_version = inode->i_version;
 		}
 		next_pos = ctx->pos;
 		if (!(de = map_pos_dirent(inode, &next_pos, &qbh))) {
diff -puN fs/hpfs/dnode.c~hpfs-dont-bother-with-the-i_version-counter-or-f_version fs/hpfs/dnode.c
--- a/fs/hpfs/dnode.c~hpfs-dont-bother-with-the-i_version-counter-or-f_version
+++ a/fs/hpfs/dnode.c
@@ -419,7 +419,6 @@ int hpfs_add_dirent(struct inode *i,
 		c = 1;
 		goto ret;
 	}	
-	i->i_version++;
 	c = hpfs_add_to_dnode(i, dno, name, namelen, new_de, 0);
 	ret:
 	return c;
@@ -726,7 +725,6 @@ int hpfs_remove_dirent(struct inode *i,
 			return 2;
 		}
 	}
-	i->i_version++;
 	for_all_poss(i, hpfs_pos_del, (t = get_pos(dnode, de)) + 1, 1);
 	hpfs_delete_de(i->i_sb, dnode, de);
 	hpfs_mark_4buffers_dirty(qbh);
diff -puN fs/hpfs/super.c~hpfs-dont-bother-with-the-i_version-counter-or-f_version fs/hpfs/super.c
--- a/fs/hpfs/super.c~hpfs-dont-bother-with-the-i_version-counter-or-f_version
+++ a/fs/hpfs/super.c
@@ -235,7 +235,6 @@ static struct inode *hpfs_alloc_inode(st
 	ei = kmem_cache_alloc(hpfs_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
-	ei->vfs_inode.i_version = 1;
 	return &ei->vfs_inode;
 }
 
_

Patches currently in -mm which might be from jlayton@redhat.com are

ntfs-remove-i_version-handling.patch
hpfs-dont-bother-with-the-i_version-counter-or-f_version.patch
lustre-dont-set-f_version-in-ll_readdir.patch

