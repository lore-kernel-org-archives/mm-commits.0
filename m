From: akpm@linux-foundation.org
Subject: + slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch added to -mm tree
Date: Tue, 24 Jul 2007 15:09:01 -0700
Message-ID: <200707242209.l6OM911n003416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33787 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756157AbXGXWJN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 18:09:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     slab-api-remove-useless-ctor-parameter-and-reorder-parameters fix
has been added to the -mm tree.  Its filename is
     slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slab-api-remove-useless-ctor-parameter-and-reorder-parameters fix
From: Christoph Lameter <clameter@sgi.com>

There are more ctors that are called *init_once*

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/inode.c |    2 +-
 fs/adfs/super.c                           |    2 +-
 fs/affs/super.c                           |    2 +-
 fs/afs/super.c                            |    6 ++----
 fs/befs/linuxvfs.c                        |    2 +-
 fs/bfs/inode.c                            |    2 +-
 fs/coda/inode.c                           |    2 +-
 fs/ecryptfs/main.c                        |    2 +-
 fs/efs/super.c                            |    2 +-
 fs/ext4/super.c                           |    2 +-
 fs/fat/cache.c                            |    2 +-
 fs/fat/inode.c                            |    2 +-
 fs/gfs2/main.c                            |    4 ++--
 fs/hfs/super.c                            |    2 +-
 fs/hfsplus/super.c                        |    2 +-
 fs/hpfs/super.c                           |    2 +-
 fs/hugetlbfs/inode.c                      |    2 +-
 fs/jffs2/super.c                          |    2 +-
 fs/jfs/jfs_metapage.c                     |    2 +-
 fs/jfs/super.c                            |    2 +-
 fs/minix/inode.c                          |    2 +-
 fs/ncpfs/inode.c                          |    2 +-
 fs/ntfs/super.c                           |    3 +--
 fs/ocfs2/dlm/dlmfs.c                      |    5 ++---
 fs/ocfs2/super.c                          |    4 +---
 fs/openpromfs/inode.c                     |    2 +-
 fs/qnx4/inode.c                           |    3 +--
 fs/romfs/inode.c                          |    2 +-
 fs/smbfs/inode.c                          |    2 +-
 fs/sysv/inode.c                           |    2 +-
 fs/ufs/super.c                            |    2 +-
 net/sunrpc/rpc_pipe.c                     |    2 +-
 32 files changed, 35 insertions(+), 42 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -67,7 +67,7 @@ spufs_destroy_inode(struct inode *inode)
 }
 
 static void
-spufs_init_once(void *p, struct kmem_cache * cachep, unsigned long flags)
+spufs_init_once(struct kmem_cache *cachep, void *p)
 {
 	struct spufs_inode_info *ei = p;
 
diff -puN fs/adfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/adfs/super.c
--- a/fs/adfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/adfs/super.c
@@ -228,7 +228,7 @@ static void adfs_destroy_inode(struct in
 	kmem_cache_free(adfs_inode_cachep, ADFS_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct adfs_inode_info *ei = (struct adfs_inode_info *) foo;
 
diff -puN fs/affs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/affs/super.c
--- a/fs/affs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/affs/super.c
@@ -84,7 +84,7 @@ static void affs_destroy_inode(struct in
 	kmem_cache_free(affs_inode_cachep, AFFS_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct affs_inode_info *ei = (struct affs_inode_info *) foo;
 
diff -puN fs/afs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/afs/super.c
--- a/fs/afs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/afs/super.c
@@ -27,8 +27,7 @@
 
 #define AFS_FS_MAGIC 0x6B414653 /* 'kAFS' */
 
-static void afs_i_init_once(void *foo, struct kmem_cache *cachep,
-			    unsigned long flags);
+static void afs_i_init_once(struct kmem_cache *cachep, void *foo);
 static int afs_get_sb(struct file_system_type *fs_type,
 		      int flags, const char *dev_name,
 		      void *data, struct vfsmount *mnt);
@@ -446,8 +445,7 @@ static void afs_put_super(struct super_b
 /*
  * initialise an inode cache slab element prior to any use
  */
-static void afs_i_init_once(void *_vnode, struct kmem_cache *cachep,
-			    unsigned long flags)
+static void afs_i_init_once(struct kmem_cache *cachep, void *_vnode)
 {
 	struct afs_vnode *vnode = _vnode;
 
diff -puN fs/befs/linuxvfs.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/befs/linuxvfs.c
@@ -289,7 +289,7 @@ befs_destroy_inode(struct inode *inode)
         kmem_cache_free(befs_inode_cachep, BEFS_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
         struct befs_inode_info *bi = (struct befs_inode_info *) foo;
 
diff -puN fs/bfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/bfs/inode.c
--- a/fs/bfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/bfs/inode.c
@@ -244,7 +244,7 @@ static void bfs_destroy_inode(struct ino
 	kmem_cache_free(bfs_inode_cachep, BFS_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct bfs_inode_info *bi = foo;
 
diff -puN fs/coda/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/coda/inode.c
--- a/fs/coda/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/coda/inode.c
@@ -58,7 +58,7 @@ static void coda_destroy_inode(struct in
 	kmem_cache_free(coda_inode_cachep, ITOC(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct coda_inode_info *ei = (struct coda_inode_info *) foo;
 
diff -puN fs/ecryptfs/main.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/ecryptfs/main.c
@@ -541,7 +541,7 @@ static struct file_system_type ecryptfs_
  * Initializes the ecryptfs_inode_info_cache when it is created
  */
 static void
-inode_info_init_once(void *vptr, struct kmem_cache *cachep, unsigned long flags)
+inode_info_init_once(struct kmem_cache *cachep, void *vptr)
 {
 	struct ecryptfs_inode_info *ei = (struct ecryptfs_inode_info *)vptr;
 
diff -puN fs/efs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/efs/super.c
--- a/fs/efs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/efs/super.c
@@ -69,7 +69,7 @@ static void efs_destroy_inode(struct ino
 	kmem_cache_free(efs_inode_cachep, INODE_INFO(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct efs_inode_info *ei = (struct efs_inode_info *) foo;
 
diff -puN fs/ext4/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/ext4/super.c
--- a/fs/ext4/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/ext4/super.c
@@ -532,7 +532,7 @@ static void ext4_destroy_inode(struct in
 	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct ext4_inode_info *ei = (struct ext4_inode_info *) foo;
 
diff -puN fs/fat/cache.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/fat/cache.c
--- a/fs/fat/cache.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/fat/cache.c
@@ -36,7 +36,7 @@ static inline int fat_max_cache(struct i
 
 static struct kmem_cache *fat_cache_cachep;
 
-static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct fat_cache *cache = (struct fat_cache *)foo;
 
diff -puN fs/fat/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/fat/inode.c
--- a/fs/fat/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/fat/inode.c
@@ -501,7 +501,7 @@ static void fat_destroy_inode(struct ino
 	kmem_cache_free(fat_inode_cachep, MSDOS_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct msdos_inode_info *ei = (struct msdos_inode_info *)foo;
 
diff -puN fs/gfs2/main.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/gfs2/main.c
--- a/fs/gfs2/main.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/gfs2/main.c
@@ -24,7 +24,7 @@
 #include "util.h"
 #include "glock.h"
 
-static void gfs2_init_inode_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void gfs2_init_inode_once(struct kmem_cache *cachep, void *foo)
 {
 	struct gfs2_inode *ip = foo;
 
@@ -34,7 +34,7 @@ static void gfs2_init_inode_once(void *f
 	memset(ip->i_cache, 0, sizeof(ip->i_cache));
 }
 
-static void gfs2_init_glock_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void gfs2_init_glock_once(struct kmem_cache *cachep, void *foo)
 {
 	struct gfs2_glock *gl = foo;
 
diff -puN fs/hfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/hfs/super.c
--- a/fs/hfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/hfs/super.c
@@ -430,7 +430,7 @@ static struct file_system_type hfs_fs_ty
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-static void hfs_init_once(void *p, struct kmem_cache *cachep, unsigned long flags)
+static void hfs_init_once(struct kmem_cache *cachep, void *p)
 {
 	struct hfs_inode_info *i = p;
 
diff -puN fs/hfsplus/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/hfsplus/super.c
@@ -466,7 +466,7 @@ static struct file_system_type hfsplus_f
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-static void hfsplus_init_once(void *p, struct kmem_cache *cachep, unsigned long flags)
+static void hfsplus_init_once(struct kmem_cache *cachep, void *p)
 {
 	struct hfsplus_inode_info *i = p;
 
diff -puN fs/hpfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/hpfs/super.c
--- a/fs/hpfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/hpfs/super.c
@@ -173,7 +173,7 @@ static void hpfs_destroy_inode(struct in
 	kmem_cache_free(hpfs_inode_cachep, hpfs_i(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct hpfs_inode_info *ei = (struct hpfs_inode_info *) foo;
 
diff -puN fs/hugetlbfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/hugetlbfs/inode.c
@@ -688,7 +688,7 @@ static const struct address_space_operat
 };
 
 
-static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct hugetlbfs_inode_info *ei = (struct hugetlbfs_inode_info *)foo;
 
diff -puN fs/jffs2/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/jffs2/super.c
--- a/fs/jffs2/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/jffs2/super.c
@@ -43,7 +43,7 @@ static void jffs2_destroy_inode(struct i
 	kmem_cache_free(jffs2_inode_cachep, JFFS2_INODE_INFO(inode));
 }
 
-static void jffs2_i_init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void jffs2_i_init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct jffs2_inode_info *ei = (struct jffs2_inode_info *) foo;
 
diff -puN fs/jfs/jfs_metapage.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/jfs/jfs_metapage.c
--- a/fs/jfs/jfs_metapage.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/jfs/jfs_metapage.c
@@ -180,7 +180,7 @@ static inline void remove_metapage(struc
 
 #endif
 
-static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct metapage *mp = (struct metapage *)foo;
 
diff -puN fs/jfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/jfs/super.c
--- a/fs/jfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/jfs/super.c
@@ -750,7 +750,7 @@ static struct file_system_type jfs_fs_ty
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-static void init_once(void *foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct jfs_inode_info *jfs_ip = (struct jfs_inode_info *) foo;
 
diff -puN fs/minix/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/minix/inode.c
--- a/fs/minix/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/minix/inode.c
@@ -69,7 +69,7 @@ static void minix_destroy_inode(struct i
 	kmem_cache_free(minix_inode_cachep, minix_i(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct minix_inode_info *ei = (struct minix_inode_info *) foo;
 
diff -puN fs/ncpfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/ncpfs/inode.c
@@ -56,7 +56,7 @@ static void ncp_destroy_inode(struct ino
 	kmem_cache_free(ncp_inode_cachep, NCP_FINFO(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct ncp_inode_info *ei = (struct ncp_inode_info *) foo;
 
diff -puN fs/ntfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/ntfs/super.c
--- a/fs/ntfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/ntfs/super.c
@@ -3080,8 +3080,7 @@ struct kmem_cache *ntfs_inode_cache;
 struct kmem_cache *ntfs_big_inode_cache;
 
 /* Init once constructor for the inode slab cache. */
-static void ntfs_big_inode_init_once(void *foo, struct kmem_cache *cachep,
-		unsigned long flags)
+static void ntfs_big_inode_init_once(struct kmem_cache *cachep, void *foo)
 {
 	ntfs_inode *ni = (ntfs_inode *)foo;
 
diff -puN fs/ocfs2/dlm/dlmfs.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/ocfs2/dlm/dlmfs.c
--- a/fs/ocfs2/dlm/dlmfs.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/ocfs2/dlm/dlmfs.c
@@ -255,9 +255,8 @@ static ssize_t dlmfs_file_write(struct f
 	return writelen;
 }
 
-static void dlmfs_init_once(void *foo,
-			    struct kmem_cache *cachep,
-			    unsigned long flags)
+static void dlmfs_init_once(struct kmem_cache *cachep,
+			    void *foo)
 {
 	struct dlmfs_inode_private *ip =
 		(struct dlmfs_inode_private *) foo;
diff -puN fs/ocfs2/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/ocfs2/super.c
@@ -958,9 +958,7 @@ bail:
 	return status;
 }
 
-static void ocfs2_inode_init_once(void *data,
-				  struct kmem_cache *cachep,
-				  unsigned long flags)
+static void ocfs2_inode_init_once(struct kmem_cache *cachep, void *data)
 {
 	struct ocfs2_inode_info *oi = data;
 
diff -puN fs/openpromfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/openpromfs/inode.c
--- a/fs/openpromfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/openpromfs/inode.c
@@ -415,7 +415,7 @@ static struct file_system_type openprom_
 	.kill_sb	= kill_anon_super,
 };
 
-static void op_inode_init_once(void *data, struct kmem_cache * cachep, unsigned long flags)
+static void op_inode_init_once(struct kmem_cache * cachep, void *data)
 {
 	struct op_inode_info *oi = (struct op_inode_info *) data;
 
diff -puN fs/qnx4/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/qnx4/inode.c
@@ -536,8 +536,7 @@ static void qnx4_destroy_inode(struct in
 	kmem_cache_free(qnx4_inode_cachep, qnx4_i(inode));
 }
 
-static void init_once(void *foo, struct kmem_cache * cachep,
-		      unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct qnx4_inode_info *ei = (struct qnx4_inode_info *) foo;
 
diff -puN fs/romfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/romfs/inode.c
--- a/fs/romfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/romfs/inode.c
@@ -566,7 +566,7 @@ static void romfs_destroy_inode(struct i
 	kmem_cache_free(romfs_inode_cachep, ROMFS_I(inode));
 }
 
-static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct romfs_inode_info *ei = foo;
 
diff -puN fs/smbfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/smbfs/inode.c
--- a/fs/smbfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/smbfs/inode.c
@@ -67,7 +67,7 @@ static void smb_destroy_inode(struct ino
 	kmem_cache_free(smb_inode_cachep, SMB_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct smb_inode_info *ei = (struct smb_inode_info *) foo;
 
diff -puN fs/sysv/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/sysv/inode.c
--- a/fs/sysv/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/sysv/inode.c
@@ -318,7 +318,7 @@ static void sysv_destroy_inode(struct in
 	kmem_cache_free(sysv_inode_cachep, SYSV_I(inode));
 }
 
-static void init_once(void *p, struct kmem_cache *cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *p)
 {
 	struct sysv_inode_info *si = (struct sysv_inode_info *)p;
 
diff -puN fs/ufs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix fs/ufs/super.c
--- a/fs/ufs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/fs/ufs/super.c
@@ -1234,7 +1234,7 @@ static void ufs_destroy_inode(struct ino
 	kmem_cache_free(ufs_inode_cachep, UFS_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct ufs_inode_info *ei = (struct ufs_inode_info *) foo;
 
diff -puN net/sunrpc/rpc_pipe.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix
+++ a/net/sunrpc/rpc_pipe.c
@@ -842,7 +842,7 @@ static struct file_system_type rpc_pipe_
 };
 
 static void
-init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct rpc_inode *rpci = (struct rpc_inode *) foo;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch
slab-maintainer-credits-update.patch
slab-correctly-handle-__gfp_zero.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
page-owner-tracking-leak-detector.patch
