From: akpm@linux-foundation.org
Subject: + proc-move-struct-pde_opener-to-kmem-cache.patch added to -mm
 tree
Date: Fri, 16 Feb 2018 15:07:33 -0800
Message-ID: <5a876435.SR5AXcn1sC4zgoZI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45520 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751053AbeBPXHe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 18:07:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, keescook@chromium.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: move "struct pde_opener" to kmem cache
has been added to the -mm tree.  Its filename is
     proc-move-struct-pde_opener-to-kmem-cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-move-struct-pde_opener-to-kmem-cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-move-struct-pde_opener-to-kmem-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: move "struct pde_opener" to kmem cache

"struct pde_opener" is fixed size and we can have more granular approach
to debugging.

For those who don't know, per cache SLUB poisoning and red zoning
don't work if there is at least one object allocated which is hopeless
in case of kmalloc-64 but not in case of standalone cache.
Although systemd opens 2 files from the get go, so it is hopeless after
all.

Link: http://lkml.kernel.org/r/20180214082306.GB17157@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c    |   12 ++++++++----
 fs/proc/internal.h |    2 +-
 fs/proc/root.c     |    2 +-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff -puN fs/proc/inode.c~proc-move-struct-pde_opener-to-kmem-cache fs/proc/inode.c
--- a/fs/proc/inode.c~proc-move-struct-pde_opener-to-kmem-cache
+++ a/fs/proc/inode.c
@@ -54,6 +54,7 @@ static void proc_evict_inode(struct inod
 }
 
 static struct kmem_cache *proc_inode_cachep __ro_after_init;
+static struct kmem_cache *pde_opener_cache __ro_after_init;
 
 static struct inode *proc_alloc_inode(struct super_block *sb)
 {
@@ -92,7 +93,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-void __init proc_init_inodecache(void)
+void __init proc_init_kmemcache(void)
 {
 	proc_inode_cachep = kmem_cache_create("proc_inode_cache",
 					     sizeof(struct proc_inode),
@@ -100,6 +101,9 @@ void __init proc_init_inodecache(void)
 						SLAB_MEM_SPREAD|SLAB_ACCOUNT|
 						SLAB_PANIC),
 					     init_once);
+	pde_opener_cache =
+		kmem_cache_create("pde_opener", sizeof(struct pde_opener), 0,
+				  SLAB_PANIC, NULL);
 }
 
 static int proc_show_options(struct seq_file *seq, struct dentry *root)
@@ -172,7 +176,7 @@ static void close_pdeo(struct proc_dir_e
 		spin_unlock(&pde->pde_unload_lock);
 		if (unlikely(c))
 			complete(c);
-		kfree(pdeo);
+		kmem_cache_free(pde_opener_cache, pdeo);
 	}
 }
 
@@ -347,7 +351,7 @@ static int proc_reg_open(struct inode *i
 
 	release = pde->proc_fops->release;
 	if (release) {
-		pdeo = kmalloc(sizeof(struct pde_opener), GFP_KERNEL);
+		pdeo = kmem_cache_alloc(pde_opener_cache, GFP_KERNEL);
 		if (!pdeo) {
 			rv = -ENOMEM;
 			goto out_unuse;
@@ -368,7 +372,7 @@ static int proc_reg_open(struct inode *i
 			list_add(&pdeo->lh, &pde->pde_openers);
 			spin_unlock(&pde->pde_unload_lock);
 		} else
-			kfree(pdeo);
+			kmem_cache_free(pde_opener_cache, pdeo);
 	}
 
 out_unuse:
diff -puN fs/proc/internal.h~proc-move-struct-pde_opener-to-kmem-cache fs/proc/internal.h
--- a/fs/proc/internal.h~proc-move-struct-pde_opener-to-kmem-cache
+++ a/fs/proc/internal.h
@@ -182,7 +182,7 @@ extern const struct inode_operations pro
 
 extern const struct inode_operations proc_pid_link_inode_operations;
 
-extern void proc_init_inodecache(void);
+void proc_init_kmemcache(void);
 void set_proc_pid_nlink(void);
 extern struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
 extern int proc_fill_super(struct super_block *, void *data, int flags);
diff -puN fs/proc/root.c~proc-move-struct-pde_opener-to-kmem-cache fs/proc/root.c
--- a/fs/proc/root.c~proc-move-struct-pde_opener-to-kmem-cache
+++ a/fs/proc/root.c
@@ -125,7 +125,7 @@ void __init proc_root_init(void)
 {
 	int err;
 
-	proc_init_inodecache();
+	proc_init_kmemcache();
 	set_proc_pid_nlink();
 	err = register_filesystem(&proc_fs_type);
 	if (err)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-do-less-stuff-under-pde_unload_lock.patch
proc-move-proc-sysvipc-creation-to-where-it-belongs.patch
proc-faster-open-close-of-files-without-release-hook.patch
proc-randomize-struct-pde_opener.patch
proc-move-struct-pde_opener-to-kmem-cache.patch
proc-account-struct-pde_opener.patch
seq_file-delete-small-value-optimization.patch

