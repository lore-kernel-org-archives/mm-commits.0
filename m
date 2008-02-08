From: akpm@linux-foundation.org
Subject: - mount-options-fix-afs.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:36 -0800
Message-ID: <200802082019.m18KJHtM011035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49478 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935538AbYBHUif (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:38:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mount options: fix afs
has been removed from the -mm tree.  Its filename was
     mount-options-fix-afs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
vfs-create-proc-pid-mountinfo.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
