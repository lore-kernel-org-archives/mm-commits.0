From: akpm@linux-foundation.org
Subject: + mount-options-fix-afs.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:07 -0800
Message-ID: <200801292322.m0TNM7Mq009673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52078 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755018AbYA2XXA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:23:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, dhowells@redhat.com


The patch titled
     mount options: fix afs
has been added to the -mm tree.  Its filename is
     mount-options-fix-afs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix afs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to afs.

Use generic_show_options() and save the complete option string in
afs_get_sb().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/super.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/afs/super.c~mount-options-fix-afs fs/afs/super.c
--- a/fs/afs/super.c~mount-options-fix-afs
+++ a/fs/afs/super.c
@@ -52,6 +52,7 @@ static const struct super_operations afs
 	.clear_inode	= afs_clear_inode,
 	.umount_begin	= afs_umount_begin,
 	.put_super	= afs_put_super,
+	.show_options	= generic_show_options,
 };
 
 static struct kmem_cache *afs_inode_cachep;
@@ -357,6 +358,7 @@ static int afs_get_sb(struct file_system
 	struct super_block *sb;
 	struct afs_volume *vol;
 	struct key *key;
+	char *new_opts = kstrdup(options, GFP_KERNEL);
 	int ret;
 
 	_enter(",,%s,%p", dev_name, options);
@@ -408,9 +410,11 @@ static int afs_get_sb(struct file_system
 			deactivate_super(sb);
 			goto error;
 		}
+		sb->s_options = new_opts;
 		sb->s_flags |= MS_ACTIVE;
 	} else {
 		_debug("reuse");
+		kfree(new_opts);
 		ASSERTCMP(sb->s_flags, &, MS_ACTIVE);
 	}
 
@@ -424,6 +428,7 @@ error:
 	afs_put_volume(params.volume);
 	afs_put_cell(params.cell);
 	key_put(params.key);
+	kfree(new_opts);
 	_leave(" = %d", ret);
 	return ret;
 }
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-x86.patch
fuse-fix-attribute-caching-after-create.patch
fuse-save-space-in-struct-fuse_req.patch
fuse-limit-queued-background-requests.patch
mount-options-add-documentation.patch
mount-options-add-generic_show_options.patch
mount-options-fix-adfs.patch
mount-options-fix-affs.patch
mount-options-fix-afs.patch
mount-options-fix-autofs4.patch
mount-options-fix-autofs.patch
mount-options-fix-befs.patch
mount-options-fix-capifs.patch
mount-options-fix-devpts.patch
mount-options-fix-ext2.patch
mount-options-fix-fat.patch
mount-options-fix-fuse.patch
mount-options-fix-hostfs.patch
mount-options-fix-hpfs.patch
mount-options-fix-hugetlbfs.patch
mount-options-fix-isofs.patch
mount-options-fix-ncpfs.patch
mount-options-fix-reiserfs.patch
mount-options-fix-spufs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-udf.patch
