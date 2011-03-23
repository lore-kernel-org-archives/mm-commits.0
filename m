From: akpm@linux-foundation.org
Subject: [merged] fs-use-appropriate-printk-priority-level.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:30 -0700
Message-ID: <201103232042.p2NKg670028720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755895Ab1CWUzJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msb@chromium.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: use appropriate printk priority levels
has been removed from the -mm tree.  Its filename was
     fs-use-appropriate-printk-priority-level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: use appropriate printk priority levels
From: Mandeep Singh Baines <msb@chromium.org>

printk()s without a priority level default to KERN_WARNING.  To reduce
noise at KERN_WARNING, this patch set the priority level appriopriately
for unleveled printks()s.  This should be useful to folks that look at
dmesg warnings closely.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio.c         |    2 +-
 fs/namespace.c   |    2 +-
 init/do_mounts.c |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/bio.c~fs-use-appropriate-printk-priority-level fs/bio.c
--- a/fs/bio.c~fs-use-appropriate-printk-priority-level
+++ a/fs/bio.c
@@ -111,7 +111,7 @@ static struct kmem_cache *bio_find_or_cr
 	if (!slab)
 		goto out_unlock;
 
-	printk("bio: create slab <%s> at %d\n", bslab->name, entry);
+	printk(KERN_INFO "bio: create slab <%s> at %d\n", bslab->name, entry);
 	bslab->slab = slab;
 	bslab->slab_ref = 1;
 	bslab->slab_size = sz;
diff -puN fs/namespace.c~fs-use-appropriate-printk-priority-level fs/namespace.c
--- a/fs/namespace.c~fs-use-appropriate-printk-priority-level
+++ a/fs/namespace.c
@@ -2701,7 +2701,7 @@ void __init mnt_init(void)
 	if (!mount_hashtable)
 		panic("Failed to allocate mount hash table\n");
 
-	printk("Mount-cache hash table entries: %lu\n", HASH_SIZE);
+	printk(KERN_INFO "Mount-cache hash table entries: %lu\n", HASH_SIZE);
 
 	for (u = 0; u < HASH_SIZE; u++)
 		INIT_LIST_HEAD(&mount_hashtable[u]);
diff -puN init/do_mounts.c~fs-use-appropriate-printk-priority-level init/do_mounts.c
--- a/init/do_mounts.c~fs-use-appropriate-printk-priority-level
+++ a/init/do_mounts.c
@@ -293,7 +293,8 @@ static int __init do_mount_root(char *na
 
 	sys_chdir((const char __user __force *)"/root");
 	ROOT_DEV = current->fs->pwd.mnt->mnt_sb->s_dev;
-	printk("VFS: Mounted root (%s filesystem)%s on device %u:%u.\n",
+	printk(KERN_INFO
+	       "VFS: Mounted root (%s filesystem)%s on device %u:%u.\n",
 	       current->fs->pwd.mnt->mnt_sb->s_type->name,
 	       current->fs->pwd.mnt->mnt_sb->s_flags & MS_RDONLY ?
 	       " readonly" : "", MAJOR(ROOT_DEV), MINOR(ROOT_DEV));
_

Patches currently in -mm which might be from msb@chromium.org are

origin.patch
taskstats-use-appropriate-printk-priority-level.patch

