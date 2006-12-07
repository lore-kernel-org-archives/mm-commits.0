From: akpm@osdl.org
Subject: - slab-remove-kmem_cache_t.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:19 -0800
Message-ID: <200612072258.kB7MwJnX029386@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50758 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163612AbWLGW6f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab: remove kmem_cache_t
has been removed from the -mm tree.  Its filename was
     slab-remove-kmem_cache_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: remove kmem_cache_t
From: Christoph Lameter <clameter@sgi.com>

Replace all uses of kmem_cache_t with struct kmem_cache.

The patch was generated using the following script:

#!/bin/sh

#
# Replace one string by another in all the kernel sources.
#

set -e

for file in `find * -name "*.c" -o -name "*.h"|xargs grep -l $1`; do
	quilt add $file
	sed -e "1,\$s/$1/$2/g" $file >/tmp/$$
	mv /tmp/$$ $file
	quilt refresh
done

The script was run like this

	sh replace kmem_cache_t "struct kmem_cache"

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/DMA-API.txt                   |    4 ++--
 arch/arm/mach-s3c2410/dma.c                 |    4 ++--
 arch/arm26/mm/memc.c                        |    6 +++---
 arch/frv/mm/pgalloc.c                       |    6 +++---
 arch/i386/mm/init.c                         |    4 ++--
 arch/i386/mm/pgtable.c                      |    6 +++---
 arch/ia64/ia32/ia32_support.c               |    2 +-
 arch/ia64/ia32/sys_ia32.c                   |    2 +-
 arch/powerpc/kernel/rtas_flash.c            |    4 ++--
 arch/powerpc/mm/hugetlbpage.c               |    2 +-
 arch/powerpc/mm/init_64.c                   |    6 +++---
 arch/powerpc/platforms/cell/spufs/inode.c   |    4 ++--
 arch/sh/kernel/cpu/sh4/sq.c                 |    2 +-
 arch/sh/mm/pmb.c                            |    6 +++---
 arch/sparc64/mm/init.c                      |    4 ++--
 arch/sparc64/mm/tsb.c                       |    2 +-
 block/cfq-iosched.c                         |    4 ++--
 block/ll_rw_blk.c                           |    6 +++---
 drivers/block/aoe/aoeblk.c                  |    2 +-
 drivers/ieee1394/eth1394.c                  |    2 +-
 drivers/md/dm-crypt.c                       |    2 +-
 drivers/md/dm-mpath.c                       |    2 +-
 drivers/md/dm-snap.c                        |    6 +++---
 drivers/md/dm.c                             |    4 ++--
 drivers/md/kcopyd.c                         |    2 +-
 drivers/md/raid5.c                          |    4 ++--
 drivers/message/i2o/i2o_block.h             |    2 +-
 drivers/pci/msi.c                           |    2 +-
 drivers/s390/block/dasd_devmap.c            |    2 +-
 drivers/s390/block/dasd_int.h               |    2 +-
 drivers/s390/scsi/zfcp_def.h                |    6 +++---
 drivers/scsi/aic94xx/aic94xx.h              |    4 ++--
 drivers/scsi/aic94xx/aic94xx_hwi.c          |    2 +-
 drivers/scsi/aic94xx/aic94xx_init.c         |    4 ++--
 drivers/scsi/libsas/sas_init.c              |    2 +-
 drivers/scsi/qla2xxx/qla_os.c               |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c               |    2 +-
 drivers/scsi/scsi.c                         |    2 +-
 drivers/scsi/scsi_lib.c                     |    4 ++--
 drivers/scsi/scsi_tgt_lib.c                 |    2 +-
 drivers/usb/host/hc_crisv10.c               |    6 +++---
 drivers/usb/host/uhci-hcd.c                 |    2 +-
 drivers/usb/mon/mon_text.c                  |    6 +++---
 fs/adfs/super.c                             |    4 ++--
 fs/affs/super.c                             |    4 ++--
 fs/afs/super.c                              |    6 +++---
 fs/aio.c                                    |    4 ++--
 fs/befs/linuxvfs.c                          |    4 ++--
 fs/bfs/inode.c                              |    4 ++--
 fs/bio.c                                    |    4 ++--
 fs/block_dev.c                              |    4 ++--
 fs/buffer.c                                 |    4 ++--
 fs/cifs/cifsfs.c                            |   14 +++++++-------
 fs/cifs/transport.c                         |    2 +-
 fs/coda/inode.c                             |    4 ++--
 fs/configfs/configfs_internal.h             |    2 +-
 fs/configfs/mount.c                         |    2 +-
 fs/dcache.c                                 |    6 +++---
 fs/dcookies.c                               |    2 +-
 fs/dlm/memory.c                             |    2 +-
 fs/dnotify.c                                |    2 +-
 fs/dquot.c                                  |    2 +-
 fs/ecryptfs/main.c                          |    2 +-
 fs/efs/super.c                              |    4 ++--
 fs/eventpoll.c                              |    4 ++--
 fs/ext2/super.c                             |    4 ++--
 fs/ext3/super.c                             |    4 ++--
 fs/ext4/super.c                             |    4 ++--
 fs/fat/cache.c                              |    4 ++--
 fs/fat/inode.c                              |    4 ++--
 fs/fcntl.c                                  |    2 +-
 fs/freevxfs/vxfs_inode.c                    |    2 +-
 fs/fuse/dev.c                               |    2 +-
 fs/fuse/inode.c                             |    4 ++--
 fs/gfs2/main.c                              |    4 ++--
 fs/gfs2/util.c                              |    6 +++---
 fs/gfs2/util.h                              |    6 +++---
 fs/hfs/super.c                              |    4 ++--
 fs/hfsplus/super.c                          |    4 ++--
 fs/hpfs/super.c                             |    4 ++--
 fs/hugetlbfs/inode.c                        |    4 ++--
 fs/inode.c                                  |    4 ++--
 fs/inotify_user.c                           |    4 ++--
 fs/isofs/inode.c                            |    4 ++--
 fs/jbd/journal.c                            |    6 +++---
 fs/jbd/revoke.c                             |    4 ++--
 fs/jbd2/journal.c                           |    6 +++---
 fs/jbd2/revoke.c                            |    4 ++--
 fs/jffs/inode-v23.c                         |    4 ++--
 fs/jffs/jffs_fm.c                           |    4 ++--
 fs/jffs2/malloc.c                           |   18 +++++++++---------
 fs/jffs2/super.c                            |    4 ++--
 fs/jfs/jfs_metapage.c                       |    4 ++--
 fs/jfs/super.c                              |    4 ++--
 fs/locks.c                                  |    4 ++--
 fs/mbcache.c                                |    2 +-
 fs/minix/inode.c                            |    4 ++--
 fs/namespace.c                              |    2 +-
 fs/ncpfs/inode.c                            |    4 ++--
 fs/nfs/direct.c                             |    2 +-
 fs/nfs/inode.c                              |    4 ++--
 fs/nfs/pagelist.c                           |    2 +-
 fs/nfs/read.c                               |    2 +-
 fs/nfs/write.c                              |    2 +-
 fs/nfsd/nfs4state.c                         |   10 +++++-----
 fs/ocfs2/dlm/dlmfs.c                        |    4 ++--
 fs/ocfs2/dlm/dlmmaster.c                    |    2 +-
 fs/ocfs2/extent_map.c                       |    2 +-
 fs/ocfs2/inode.h                            |    2 +-
 fs/ocfs2/super.c                            |    4 ++--
 fs/ocfs2/uptodate.c                         |    2 +-
 fs/openpromfs/inode.c                       |    4 ++--
 fs/proc/inode.c                             |    4 ++--
 fs/qnx4/inode.c                             |    4 ++--
 fs/reiserfs/super.c                         |    4 ++--
 fs/romfs/inode.c                            |    4 ++--
 fs/smbfs/inode.c                            |    4 ++--
 fs/smbfs/request.c                          |    2 +-
 fs/sysfs/mount.c                            |    2 +-
 fs/sysfs/sysfs.h                            |    2 +-
 fs/sysv/inode.c                             |    4 ++--
 fs/udf/super.c                              |    4 ++--
 fs/ufs/super.c                              |    4 ++--
 include/acpi/platform/aclinux.h             |    2 +-
 include/asm-arm26/pgalloc.h                 |    2 +-
 include/asm-i386/pgtable.h                  |   10 +++++-----
 include/asm-powerpc/pgalloc.h               |    2 +-
 include/asm-sparc64/pgalloc.h               |    2 +-
 include/linux/delayacct.h                   |    2 +-
 include/linux/i2o.h                         |    2 +-
 include/linux/jbd.h                         |    2 +-
 include/linux/jbd2.h                        |    2 +-
 include/linux/raid/raid5.h                  |    2 +-
 include/linux/rmap.h                        |    2 +-
 include/linux/skbuff.h                      |    2 +-
 include/linux/taskstats_kern.h              |    2 +-
 include/net/dst.h                           |    2 +-
 include/net/inet_hashtables.h               |    6 +++---
 include/net/neighbour.h                     |    2 +-
 include/net/netfilter/nf_conntrack_expect.h |    2 +-
 include/net/request_sock.h                  |    2 +-
 include/net/sock.h                          |    2 +-
 include/net/timewait_sock.h                 |    2 +-
 include/scsi/libsas.h                       |    4 ++--
 ipc/mqueue.c                                |    4 ++--
 kernel/delayacct.c                          |    2 +-
 kernel/fork.c                               |   16 ++++++++--------
 kernel/pid.c                                |    2 +-
 kernel/posix-timers.c                       |    2 +-
 kernel/signal.c                             |    2 +-
 kernel/taskstats.c                          |    2 +-
 kernel/user.c                               |    2 +-
 lib/idr.c                                   |    4 ++--
 lib/radix-tree.c                            |    4 ++--
 net/bridge/br_fdb.c                         |    2 +-
 net/core/flow.c                             |    2 +-
 net/core/skbuff.c                           |    8 ++++----
 net/core/sock.c                             |    2 +-
 net/dccp/ackvec.c                           |    4 ++--
 net/dccp/ccid.c                             |    6 +++---
 net/dccp/ccid.h                             |    4 ++--
 net/dccp/ccids/lib/loss_interval.h          |    2 +-
 net/dccp/ccids/lib/packet_history.h         |    4 ++--
 net/decnet/dn_table.c                       |    2 +-
 net/ipv4/fib_hash.c                         |    4 ++--
 net/ipv4/fib_trie.c                         |    2 +-
 net/ipv4/inet_hashtables.c                  |    4 ++--
 net/ipv4/inetpeer.c                         |    2 +-
 net/ipv4/ipmr.c                             |    2 +-
 net/ipv4/ipvs/ip_vs_conn.c                  |    2 +-
 net/ipv4/netfilter/ip_conntrack_core.c      |    4 ++--
 net/ipv6/ip6_fib.c                          |    2 +-
 net/ipv6/xfrm6_tunnel.c                     |    2 +-
 net/netfilter/nf_conntrack_core.c           |    6 +++---
 net/netfilter/nf_conntrack_expect.c         |    2 +-
 net/netfilter/xt_hashlimit.c                |    2 +-
 net/sctp/protocol.c                         |    4 ++--
 net/sctp/sm_make_chunk.c                    |    2 +-
 net/sctp/socket.c                           |    2 +-
 net/socket.c                                |    4 ++--
 net/sunrpc/rpc_pipe.c                       |    4 ++--
 net/sunrpc/sched.c                          |    4 ++--
 net/tipc/handler.c                          |    2 +-
 net/xfrm/xfrm_input.c                       |    2 +-
 net/xfrm/xfrm_policy.c                      |    2 +-
 security/keys/key.c                         |    2 +-
 security/selinux/avc.c                      |    2 +-
 security/selinux/hooks.c                    |    2 +-
 security/selinux/ss/avtab.c                 |    2 +-
 189 files changed, 332 insertions(+), 332 deletions(-)

diff -puN Documentation/DMA-API.txt~slab-remove-kmem_cache_t Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~slab-remove-kmem_cache_t
+++ a/Documentation/DMA-API.txt
@@ -77,7 +77,7 @@ To get this part of the dma_ API, you mu
 Many drivers need lots of small dma-coherent memory regions for DMA
 descriptors or I/O buffers.  Rather than allocating in units of a page
 or more using dma_alloc_coherent(), you can use DMA pools.  These work
-much like a kmem_cache_t, except that they use the dma-coherent allocator
+much like a struct kmem_cache, except that they use the dma-coherent allocator
 not __get_free_pages().  Also, they understand common hardware constraints
 for alignment, like queue heads needing to be aligned on N byte boundaries.
 
@@ -94,7 +94,7 @@ The pool create() routines initialize a 
 for use with a given device.  It must be called in a context which
 can sleep.
 
-The "name" is for diagnostics (like a kmem_cache_t name); dev and size
+The "name" is for diagnostics (like a struct kmem_cache name); dev and size
 are like what you'd pass to dma_alloc_coherent().  The device's hardware
 alignment requirement for this type of data is "align" (which is expressed
 in bytes, and must be a power of two).  If your device has no boundary
diff -puN arch/arm/mach-s3c2410/dma.c~slab-remove-kmem_cache_t arch/arm/mach-s3c2410/dma.c
--- a/arch/arm/mach-s3c2410/dma.c~slab-remove-kmem_cache_t
+++ a/arch/arm/mach-s3c2410/dma.c
@@ -40,7 +40,7 @@
 
 /* io map for dma */
 static void __iomem *dma_base;
-static kmem_cache_t *dma_kmem;
+static struct kmem_cache *dma_kmem;
 
 struct s3c24xx_dma_selection dma_sel;
 
@@ -1271,7 +1271,7 @@ struct sysdev_class dma_sysclass = {
 
 /* kmem cache implementation */
 
-static void s3c2410_dma_cache_ctor(void *p, kmem_cache_t *c, unsigned long f)
+static void s3c2410_dma_cache_ctor(void *p, struct kmem_cache *c, unsigned long f)
 {
 	memset(p, 0, sizeof(struct s3c2410_dma_buf));
 }
diff -puN arch/arm26/mm/memc.c~slab-remove-kmem_cache_t arch/arm26/mm/memc.c
--- a/arch/arm26/mm/memc.c~slab-remove-kmem_cache_t
+++ a/arch/arm26/mm/memc.c
@@ -24,7 +24,7 @@
 
 #define MEMC_TABLE_SIZE (256*sizeof(unsigned long))
 
-kmem_cache_t *pte_cache, *pgd_cache;
+struct kmem_cache *pte_cache, *pgd_cache;
 int page_nr;
 
 /*
@@ -162,12 +162,12 @@ void __init create_memmap_holes(struct m
 {
 }
 
-static void pte_cache_ctor(void *pte, kmem_cache_t *cache, unsigned long flags)
+static void pte_cache_ctor(void *pte, struct kmem_cache *cache, unsigned long flags)
 {
 	memzero(pte, sizeof(pte_t) * PTRS_PER_PTE);
 }
 
-static void pgd_cache_ctor(void *pgd, kmem_cache_t *cache, unsigned long flags)
+static void pgd_cache_ctor(void *pgd, struct kmem_cache *cache, unsigned long flags)
 {
 	memzero(pgd + MEMC_TABLE_SIZE, USER_PTRS_PER_PGD * sizeof(pgd_t));
 }
diff -puN arch/frv/mm/pgalloc.c~slab-remove-kmem_cache_t arch/frv/mm/pgalloc.c
--- a/arch/frv/mm/pgalloc.c~slab-remove-kmem_cache_t
+++ a/arch/frv/mm/pgalloc.c
@@ -18,7 +18,7 @@
 #include <asm/cacheflush.h>
 
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__((aligned(PAGE_SIZE)));
-kmem_cache_t *pgd_cache;
+struct kmem_cache *pgd_cache;
 
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
@@ -100,7 +100,7 @@ static inline void pgd_list_del(pgd_t *p
 		set_page_private(next, (unsigned long) pprev);
 }
 
-void pgd_ctor(void *pgd, kmem_cache_t *cache, unsigned long unused)
+void pgd_ctor(void *pgd, struct kmem_cache *cache, unsigned long unused)
 {
 	unsigned long flags;
 
@@ -120,7 +120,7 @@ void pgd_ctor(void *pgd, kmem_cache_t *c
 }
 
 /* never called when PTRS_PER_PMD > 1 */
-void pgd_dtor(void *pgd, kmem_cache_t *cache, unsigned long unused)
+void pgd_dtor(void *pgd, struct kmem_cache *cache, unsigned long unused)
 {
 	unsigned long flags; /* can be called from interrupt context */
 
diff -puN arch/i386/mm/init.c~slab-remove-kmem_cache_t arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~slab-remove-kmem_cache_t
+++ a/arch/i386/mm/init.c
@@ -699,8 +699,8 @@ int remove_memory(u64 start, u64 size)
 #endif
 #endif
 
-kmem_cache_t *pgd_cache;
-kmem_cache_t *pmd_cache;
+struct kmem_cache *pgd_cache;
+struct kmem_cache *pmd_cache;
 
 void __init pgtable_cache_init(void)
 {
diff -puN arch/i386/mm/pgtable.c~slab-remove-kmem_cache_t arch/i386/mm/pgtable.c
--- a/arch/i386/mm/pgtable.c~slab-remove-kmem_cache_t
+++ a/arch/i386/mm/pgtable.c
@@ -193,7 +193,7 @@ struct page *pte_alloc_one(struct mm_str
 	return pte;
 }
 
-void pmd_ctor(void *pmd, kmem_cache_t *cache, unsigned long flags)
+void pmd_ctor(void *pmd, struct kmem_cache *cache, unsigned long flags)
 {
 	memset(pmd, 0, PTRS_PER_PMD*sizeof(pmd_t));
 }
@@ -233,7 +233,7 @@ static inline void pgd_list_del(pgd_t *p
 		set_page_private(next, (unsigned long)pprev);
 }
 
-void pgd_ctor(void *pgd, kmem_cache_t *cache, unsigned long unused)
+void pgd_ctor(void *pgd, struct kmem_cache *cache, unsigned long unused)
 {
 	unsigned long flags;
 
@@ -253,7 +253,7 @@ void pgd_ctor(void *pgd, kmem_cache_t *c
 }
 
 /* never called when PTRS_PER_PMD > 1 */
-void pgd_dtor(void *pgd, kmem_cache_t *cache, unsigned long unused)
+void pgd_dtor(void *pgd, struct kmem_cache *cache, unsigned long unused)
 {
 	unsigned long flags; /* can be called from interrupt context */
 
diff -puN arch/ia64/ia32/ia32_support.c~slab-remove-kmem_cache_t arch/ia64/ia32/ia32_support.c
--- a/arch/ia64/ia32/ia32_support.c~slab-remove-kmem_cache_t
+++ a/arch/ia64/ia32/ia32_support.c
@@ -249,7 +249,7 @@ ia32_init (void)
 
 #if PAGE_SHIFT > IA32_PAGE_SHIFT
 	{
-		extern kmem_cache_t *partial_page_cachep;
+		extern struct kmem_cache *partial_page_cachep;
 
 		partial_page_cachep = kmem_cache_create("partial_page_cache",
 							sizeof(struct partial_page), 0, 0,
diff -puN arch/ia64/ia32/sys_ia32.c~slab-remove-kmem_cache_t arch/ia64/ia32/sys_ia32.c
--- a/arch/ia64/ia32/sys_ia32.c~slab-remove-kmem_cache_t
+++ a/arch/ia64/ia32/sys_ia32.c
@@ -254,7 +254,7 @@ mmap_subpage (struct file *file, unsigne
 }
 
 /* SLAB cache for partial_page structures */
-kmem_cache_t *partial_page_cachep;
+struct kmem_cache *partial_page_cachep;
 
 /*
  * init partial_page_list.
diff -puN arch/powerpc/kernel/rtas_flash.c~slab-remove-kmem_cache_t arch/powerpc/kernel/rtas_flash.c
--- a/arch/powerpc/kernel/rtas_flash.c~slab-remove-kmem_cache_t
+++ a/arch/powerpc/kernel/rtas_flash.c
@@ -101,7 +101,7 @@ struct flash_block_list_header { /* just
 static struct flash_block_list_header rtas_firmware_flash_list = {0, NULL};
 
 /* Use slab cache to guarantee 4k alignment */
-static kmem_cache_t *flash_block_cache = NULL;
+static struct kmem_cache *flash_block_cache = NULL;
 
 #define FLASH_BLOCK_LIST_VERSION (1UL)
 
@@ -286,7 +286,7 @@ static ssize_t rtas_flash_read(struct fi
 }
 
 /* constructor for flash_block_cache */
-void rtas_block_ctor(void *ptr, kmem_cache_t *cache, unsigned long flags)
+void rtas_block_ctor(void *ptr, struct kmem_cache *cache, unsigned long flags)
 {
 	memset(ptr, 0, RTAS_BLK_SIZE);
 }
diff -puN arch/powerpc/mm/hugetlbpage.c~slab-remove-kmem_cache_t arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~slab-remove-kmem_cache_t
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -1047,7 +1047,7 @@ repeat:
 	return err;
 }
 
-static void zero_ctor(void *addr, kmem_cache_t *cache, unsigned long flags)
+static void zero_ctor(void *addr, struct kmem_cache *cache, unsigned long flags)
 {
 	memset(addr, 0, kmem_cache_size(cache));
 }
diff -puN arch/powerpc/mm/init_64.c~slab-remove-kmem_cache_t arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~slab-remove-kmem_cache_t
+++ a/arch/powerpc/mm/init_64.c
@@ -141,7 +141,7 @@ static int __init setup_kcore(void)
 }
 module_init(setup_kcore);
 
-static void zero_ctor(void *addr, kmem_cache_t *cache, unsigned long flags)
+static void zero_ctor(void *addr, struct kmem_cache *cache, unsigned long flags)
 {
 	memset(addr, 0, kmem_cache_size(cache));
 }
@@ -166,9 +166,9 @@ static const char *pgtable_cache_name[AR
 /* Hugepages need one extra cache, initialized in hugetlbpage.c.  We
  * can't put into the tables above, because HPAGE_SHIFT is not compile
  * time constant. */
-kmem_cache_t *pgtable_cache[ARRAY_SIZE(pgtable_cache_size)+1];
+struct kmem_cache *pgtable_cache[ARRAY_SIZE(pgtable_cache_size)+1];
 #else
-kmem_cache_t *pgtable_cache[ARRAY_SIZE(pgtable_cache_size)];
+struct kmem_cache *pgtable_cache[ARRAY_SIZE(pgtable_cache_size)];
 #endif
 
 void pgtable_cache_init(void)
diff -puN arch/powerpc/platforms/cell/spufs/inode.c~slab-remove-kmem_cache_t arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~slab-remove-kmem_cache_t
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -40,7 +40,7 @@
 
 #include "spufs.h"
 
-static kmem_cache_t *spufs_inode_cache;
+static struct kmem_cache *spufs_inode_cache;
 char *isolated_loader;
 
 static struct inode *
@@ -65,7 +65,7 @@ spufs_destroy_inode(struct inode *inode)
 }
 
 static void
-spufs_init_once(void *p, kmem_cache_t * cachep, unsigned long flags)
+spufs_init_once(void *p, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct spufs_inode_info *ei = p;
 
diff -puN arch/sh/kernel/cpu/sh4/sq.c~slab-remove-kmem_cache_t arch/sh/kernel/cpu/sh4/sq.c
--- a/arch/sh/kernel/cpu/sh4/sq.c~slab-remove-kmem_cache_t
+++ a/arch/sh/kernel/cpu/sh4/sq.c
@@ -38,7 +38,7 @@ struct sq_mapping {
 
 static struct sq_mapping *sq_mapping_list;
 static DEFINE_SPINLOCK(sq_mapping_lock);
-static kmem_cache_t *sq_cache;
+static struct kmem_cache *sq_cache;
 static unsigned long *sq_bitmap;
 
 #define store_queue_barrier()			\
diff -puN arch/sh/mm/pmb.c~slab-remove-kmem_cache_t arch/sh/mm/pmb.c
--- a/arch/sh/mm/pmb.c~slab-remove-kmem_cache_t
+++ a/arch/sh/mm/pmb.c
@@ -30,7 +30,7 @@
 
 #define NR_PMB_ENTRIES	16
 
-static kmem_cache_t *pmb_cache;
+static struct kmem_cache *pmb_cache;
 static unsigned long pmb_map;
 
 static struct pmb_entry pmb_init_map[] = {
@@ -283,7 +283,7 @@ void pmb_unmap(unsigned long addr)
 	} while (pmbe);
 }
 
-static void pmb_cache_ctor(void *pmb, kmem_cache_t *cachep, unsigned long flags)
+static void pmb_cache_ctor(void *pmb, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct pmb_entry *pmbe = pmb;
 
@@ -297,7 +297,7 @@ static void pmb_cache_ctor(void *pmb, km
 	spin_unlock_irq(&pmb_list_lock);
 }
 
-static void pmb_cache_dtor(void *pmb, kmem_cache_t *cachep, unsigned long flags)
+static void pmb_cache_dtor(void *pmb, struct kmem_cache *cachep, unsigned long flags)
 {
 	spin_lock_irq(&pmb_list_lock);
 	pmb_list_del(pmb);
diff -puN arch/sparc64/mm/init.c~slab-remove-kmem_cache_t arch/sparc64/mm/init.c
--- a/arch/sparc64/mm/init.c~slab-remove-kmem_cache_t
+++ a/arch/sparc64/mm/init.c
@@ -176,9 +176,9 @@ unsigned long sparc64_kern_sec_context _
 
 int bigkernel = 0;
 
-kmem_cache_t *pgtable_cache __read_mostly;
+struct kmem_cache *pgtable_cache __read_mostly;
 
-static void zero_ctor(void *addr, kmem_cache_t *cache, unsigned long flags)
+static void zero_ctor(void *addr, struct kmem_cache *cache, unsigned long flags)
 {
 	clear_page(addr);
 }
diff -puN arch/sparc64/mm/tsb.c~slab-remove-kmem_cache_t arch/sparc64/mm/tsb.c
--- a/arch/sparc64/mm/tsb.c~slab-remove-kmem_cache_t
+++ a/arch/sparc64/mm/tsb.c
@@ -239,7 +239,7 @@ static void setup_tsb_params(struct mm_s
 	}
 }
 
-static kmem_cache_t *tsb_caches[8] __read_mostly;
+static struct kmem_cache *tsb_caches[8] __read_mostly;
 
 static const char *tsb_cache_names[8] = {
 	"tsb_8KB",
diff -puN block/cfq-iosched.c~slab-remove-kmem_cache_t block/cfq-iosched.c
--- a/block/cfq-iosched.c~slab-remove-kmem_cache_t
+++ a/block/cfq-iosched.c
@@ -43,8 +43,8 @@ static int cfq_slice_idle = HZ / 125;
 #define RQ_CIC(rq)		((struct cfq_io_context*)(rq)->elevator_private)
 #define RQ_CFQQ(rq)		((rq)->elevator_private2)
 
-static kmem_cache_t *cfq_pool;
-static kmem_cache_t *cfq_ioc_pool;
+static struct kmem_cache *cfq_pool;
+static struct kmem_cache *cfq_ioc_pool;
 
 static DEFINE_PER_CPU(unsigned long, ioc_count);
 static struct completion *ioc_gone;
diff -puN block/ll_rw_blk.c~slab-remove-kmem_cache_t block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~slab-remove-kmem_cache_t
+++ a/block/ll_rw_blk.c
@@ -44,17 +44,17 @@ static struct io_context *current_io_con
 /*
  * For the allocated request tables
  */
-static kmem_cache_t *request_cachep;
+static struct kmem_cache *request_cachep;
 
 /*
  * For queue allocation
  */
-static kmem_cache_t *requestq_cachep;
+static struct kmem_cache *requestq_cachep;
 
 /*
  * For io context allocations
  */
-static kmem_cache_t *iocontext_cachep;
+static struct kmem_cache *iocontext_cachep;
 
 /*
  * Controlling structure to kblockd
diff -puN drivers/block/aoe/aoeblk.c~slab-remove-kmem_cache_t drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~slab-remove-kmem_cache_t
+++ a/drivers/block/aoe/aoeblk.c
@@ -12,7 +12,7 @@
 #include <linux/netdevice.h>
 #include "aoe.h"
 
-static kmem_cache_t *buf_pool_cache;
+static struct kmem_cache *buf_pool_cache;
 
 static ssize_t aoedisk_show_state(struct gendisk * disk, char *page)
 {
diff -puN drivers/ieee1394/eth1394.c~slab-remove-kmem_cache_t drivers/ieee1394/eth1394.c
--- a/drivers/ieee1394/eth1394.c~slab-remove-kmem_cache_t
+++ a/drivers/ieee1394/eth1394.c
@@ -133,7 +133,7 @@ struct eth1394_node_info {
 #define ETH1394_DRIVER_NAME "eth1394"
 static const char driver_name[] = ETH1394_DRIVER_NAME;
 
-static kmem_cache_t *packet_task_cache;
+static struct kmem_cache *packet_task_cache;
 
 static struct hpsb_highlevel eth1394_highlevel;
 
diff -puN drivers/md/dm-crypt.c~slab-remove-kmem_cache_t drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~slab-remove-kmem_cache_t
+++ a/drivers/md/dm-crypt.c
@@ -101,7 +101,7 @@ struct crypt_config {
 #define MIN_POOL_PAGES 32
 #define MIN_BIO_PAGES  8
 
-static kmem_cache_t *_crypt_io_pool;
+static struct kmem_cache *_crypt_io_pool;
 
 /*
  * Different IV generation algorithms:
diff -puN drivers/md/dm-mpath.c~slab-remove-kmem_cache_t drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c~slab-remove-kmem_cache_t
+++ a/drivers/md/dm-mpath.c
@@ -101,7 +101,7 @@ typedef int (*action_fn) (struct pgpath 
 
 #define MIN_IOS 256	/* Mempool size */
 
-static kmem_cache_t *_mpio_cache;
+static struct kmem_cache *_mpio_cache;
 
 struct workqueue_struct *kmultipathd;
 static void process_queued_ios(struct work_struct *work);
diff -puN drivers/md/dm-snap.c~slab-remove-kmem_cache_t drivers/md/dm-snap.c
--- a/drivers/md/dm-snap.c~slab-remove-kmem_cache_t
+++ a/drivers/md/dm-snap.c
@@ -88,8 +88,8 @@ struct pending_exception {
  * Hash table mapping origin volumes to lists of snapshots and
  * a lock to protect it
  */
-static kmem_cache_t *exception_cache;
-static kmem_cache_t *pending_cache;
+static struct kmem_cache *exception_cache;
+static struct kmem_cache *pending_cache;
 static mempool_t *pending_pool;
 
 /*
@@ -228,7 +228,7 @@ static int init_exception_table(struct e
 	return 0;
 }
 
-static void exit_exception_table(struct exception_table *et, kmem_cache_t *mem)
+static void exit_exception_table(struct exception_table *et, struct kmem_cache *mem)
 {
 	struct list_head *slot;
 	struct exception *ex, *next;
diff -puN drivers/md/dm.c~slab-remove-kmem_cache_t drivers/md/dm.c
--- a/drivers/md/dm.c~slab-remove-kmem_cache_t
+++ a/drivers/md/dm.c
@@ -121,8 +121,8 @@ struct mapped_device {
 };
 
 #define MIN_IOS 256
-static kmem_cache_t *_io_cache;
-static kmem_cache_t *_tio_cache;
+static struct kmem_cache *_io_cache;
+static struct kmem_cache *_tio_cache;
 
 static int __init local_init(void)
 {
diff -puN drivers/md/kcopyd.c~slab-remove-kmem_cache_t drivers/md/kcopyd.c
--- a/drivers/md/kcopyd.c~slab-remove-kmem_cache_t
+++ a/drivers/md/kcopyd.c
@@ -203,7 +203,7 @@ struct kcopyd_job {
 /* FIXME: this should scale with the number of pages */
 #define MIN_JOBS 512
 
-static kmem_cache_t *_job_cache;
+static struct kmem_cache *_job_cache;
 static mempool_t *_job_pool;
 
 /*
diff -puN drivers/md/raid5.c~slab-remove-kmem_cache_t drivers/md/raid5.c
--- a/drivers/md/raid5.c~slab-remove-kmem_cache_t
+++ a/drivers/md/raid5.c
@@ -348,7 +348,7 @@ static int grow_one_stripe(raid5_conf_t 
 
 static int grow_stripes(raid5_conf_t *conf, int num)
 {
-	kmem_cache_t *sc;
+	struct kmem_cache *sc;
 	int devs = conf->raid_disks;
 
 	sprintf(conf->cache_name[0], "raid5/%s", mdname(conf->mddev));
@@ -397,7 +397,7 @@ static int resize_stripes(raid5_conf_t *
 	LIST_HEAD(newstripes);
 	struct disk_info *ndisks;
 	int err = 0;
-	kmem_cache_t *sc;
+	struct kmem_cache *sc;
 	int i;
 
 	if (newsize <= conf->pool_size)
diff -puN drivers/message/i2o/i2o_block.h~slab-remove-kmem_cache_t drivers/message/i2o/i2o_block.h
--- a/drivers/message/i2o/i2o_block.h~slab-remove-kmem_cache_t
+++ a/drivers/message/i2o/i2o_block.h
@@ -64,7 +64,7 @@
 
 /* I2O Block OSM mempool struct */
 struct i2o_block_mempool {
-	kmem_cache_t *slab;
+	struct kmem_cache *slab;
 	mempool_t *pool;
 };
 
diff -puN drivers/pci/msi.c~slab-remove-kmem_cache_t drivers/pci/msi.c
--- a/drivers/pci/msi.c~slab-remove-kmem_cache_t
+++ a/drivers/pci/msi.c
@@ -26,7 +26,7 @@
 
 static DEFINE_SPINLOCK(msi_lock);
 static struct msi_desc* msi_desc[NR_IRQS] = { [0 ... NR_IRQS-1] = NULL };
-static kmem_cache_t* msi_cachep;
+static struct kmem_cache* msi_cachep;
 
 static int pci_msi_enable = 1;
 
diff -puN drivers/s390/block/dasd_devmap.c~slab-remove-kmem_cache_t drivers/s390/block/dasd_devmap.c
--- a/drivers/s390/block/dasd_devmap.c~slab-remove-kmem_cache_t
+++ a/drivers/s390/block/dasd_devmap.c
@@ -25,7 +25,7 @@
 
 #include "dasd_int.h"
 
-kmem_cache_t *dasd_page_cache;
+struct kmem_cache *dasd_page_cache;
 EXPORT_SYMBOL_GPL(dasd_page_cache);
 
 /*
diff -puN drivers/s390/block/dasd_int.h~slab-remove-kmem_cache_t drivers/s390/block/dasd_int.h
--- a/drivers/s390/block/dasd_int.h~slab-remove-kmem_cache_t
+++ a/drivers/s390/block/dasd_int.h
@@ -474,7 +474,7 @@ extern struct dasd_profile_info_t dasd_g
 extern unsigned int dasd_profile_level;
 extern struct block_device_operations dasd_device_operations;
 
-extern kmem_cache_t *dasd_page_cache;
+extern struct kmem_cache *dasd_page_cache;
 
 struct dasd_ccw_req *
 dasd_kmalloc_request(char *, int, int, struct dasd_device *);
diff -puN drivers/s390/scsi/zfcp_def.h~slab-remove-kmem_cache_t drivers/s390/scsi/zfcp_def.h
--- a/drivers/s390/scsi/zfcp_def.h~slab-remove-kmem_cache_t
+++ a/drivers/s390/scsi/zfcp_def.h
@@ -1032,9 +1032,9 @@ struct zfcp_data {
 	wwn_t                   init_wwpn;
 	fcp_lun_t               init_fcp_lun;
 	char 			*driver_version;
-	kmem_cache_t		*fsf_req_qtcb_cache;
-	kmem_cache_t		*sr_buffer_cache;
-	kmem_cache_t		*gid_pn_cache;
+	struct kmem_cache		*fsf_req_qtcb_cache;
+	struct kmem_cache		*sr_buffer_cache;
+	struct kmem_cache		*gid_pn_cache;
 };
 
 /**
diff -puN drivers/scsi/aic94xx/aic94xx.h~slab-remove-kmem_cache_t drivers/scsi/aic94xx/aic94xx.h
--- a/drivers/scsi/aic94xx/aic94xx.h~slab-remove-kmem_cache_t
+++ a/drivers/scsi/aic94xx/aic94xx.h
@@ -56,8 +56,8 @@
 /* 2*ITNL timeout + 1 second */
 #define AIC94XX_SCB_TIMEOUT  (5*HZ)
 
-extern kmem_cache_t *asd_dma_token_cache;
-extern kmem_cache_t *asd_ascb_cache;
+extern struct kmem_cache *asd_dma_token_cache;
+extern struct kmem_cache *asd_ascb_cache;
 extern char sas_addr_str[2*SAS_ADDR_SIZE + 1];
 
 static inline void asd_stringify_sas_addr(char *p, const u8 *sas_addr)
diff -puN drivers/scsi/aic94xx/aic94xx_hwi.c~slab-remove-kmem_cache_t drivers/scsi/aic94xx/aic94xx_hwi.c
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c~slab-remove-kmem_cache_t
+++ a/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -1047,7 +1047,7 @@ irqreturn_t asd_hw_isr(int irq, void *de
 static inline struct asd_ascb *asd_ascb_alloc(struct asd_ha_struct *asd_ha,
 					      gfp_t gfp_flags)
 {
-	extern kmem_cache_t *asd_ascb_cache;
+	extern struct kmem_cache *asd_ascb_cache;
 	struct asd_seq_data *seq = &asd_ha->seq;
 	struct asd_ascb *ascb;
 	unsigned long flags;
diff -puN drivers/scsi/aic94xx/aic94xx_init.c~slab-remove-kmem_cache_t drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~slab-remove-kmem_cache_t
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -450,8 +450,8 @@ static inline void asd_destroy_ha_caches
 	asd_ha->scb_pool = NULL;
 }
 
-kmem_cache_t *asd_dma_token_cache;
-kmem_cache_t *asd_ascb_cache;
+struct kmem_cache *asd_dma_token_cache;
+struct kmem_cache *asd_ascb_cache;
 
 static int asd_create_global_caches(void)
 {
diff -puN drivers/scsi/libsas/sas_init.c~slab-remove-kmem_cache_t drivers/scsi/libsas/sas_init.c
--- a/drivers/scsi/libsas/sas_init.c~slab-remove-kmem_cache_t
+++ a/drivers/scsi/libsas/sas_init.c
@@ -36,7 +36,7 @@
 
 #include "../scsi_sas_internal.h"
 
-kmem_cache_t *sas_task_cache;
+struct kmem_cache *sas_task_cache;
 
 /*------------ SAS addr hash -----------*/
 void sas_hash_addr(u8 *hashed, const u8 *sas_addr)
diff -puN drivers/scsi/qla2xxx/qla_os.c~slab-remove-kmem_cache_t drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c~slab-remove-kmem_cache_t
+++ a/drivers/scsi/qla2xxx/qla_os.c
@@ -24,7 +24,7 @@ char qla2x00_version_str[40];
 /*
  * SRB allocation cache
  */
-static kmem_cache_t *srb_cachep;
+static struct kmem_cache *srb_cachep;
 
 /*
  * Ioctl related information.
diff -puN drivers/scsi/qla4xxx/ql4_os.c~slab-remove-kmem_cache_t drivers/scsi/qla4xxx/ql4_os.c
--- a/drivers/scsi/qla4xxx/ql4_os.c~slab-remove-kmem_cache_t
+++ a/drivers/scsi/qla4xxx/ql4_os.c
@@ -19,7 +19,7 @@ char qla4xxx_version_str[40];
 /*
  * SRB allocation cache
  */
-static kmem_cache_t *srb_cachep;
+static struct kmem_cache *srb_cachep;
 
 /*
  * Module parameter information and variables
diff -puN drivers/scsi/scsi.c~slab-remove-kmem_cache_t drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c~slab-remove-kmem_cache_t
+++ a/drivers/scsi/scsi.c
@@ -136,7 +136,7 @@ const char * scsi_device_type(unsigned t
 EXPORT_SYMBOL(scsi_device_type);
 
 struct scsi_host_cmd_pool {
-	kmem_cache_t	*slab;
+	struct kmem_cache	*slab;
 	unsigned int	users;
 	char		*name;
 	unsigned int	slab_flags;
diff -puN drivers/scsi/scsi_lib.c~slab-remove-kmem_cache_t drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~slab-remove-kmem_cache_t
+++ a/drivers/scsi/scsi_lib.c
@@ -36,7 +36,7 @@
 struct scsi_host_sg_pool {
 	size_t		size;
 	char		*name; 
-	kmem_cache_t	*slab;
+	struct kmem_cache	*slab;
 	mempool_t	*pool;
 };
 
@@ -241,7 +241,7 @@ struct scsi_io_context {
 	char sense[SCSI_SENSE_BUFFERSIZE];
 };
 
-static kmem_cache_t *scsi_io_context_cache;
+static struct kmem_cache *scsi_io_context_cache;
 
 static void scsi_end_async(struct request *req, int uptodate)
 {
diff -puN drivers/scsi/scsi_tgt_lib.c~slab-remove-kmem_cache_t drivers/scsi/scsi_tgt_lib.c
--- a/drivers/scsi/scsi_tgt_lib.c~slab-remove-kmem_cache_t
+++ a/drivers/scsi/scsi_tgt_lib.c
@@ -33,7 +33,7 @@
 #include "scsi_tgt_priv.h"
 
 static struct workqueue_struct *scsi_tgtd;
-static kmem_cache_t *scsi_tgt_cmd_cache;
+static struct kmem_cache *scsi_tgt_cmd_cache;
 
 /*
  * TODO: this struct will be killed when the block layer supports large bios
diff -puN drivers/usb/host/hc_crisv10.c~slab-remove-kmem_cache_t drivers/usb/host/hc_crisv10.c
--- a/drivers/usb/host/hc_crisv10.c~slab-remove-kmem_cache_t
+++ a/drivers/usb/host/hc_crisv10.c
@@ -275,13 +275,13 @@ static volatile USB_SB_Desc_t TxIntrSB_z
 static int zout_buffer[4] __attribute__ ((aligned (4)));
 
 /* Cache for allocating new EP and SB descriptors. */
-static kmem_cache_t *usb_desc_cache;
+static struct kmem_cache *usb_desc_cache;
 
 /* Cache for the registers allocated in the top half. */
-static kmem_cache_t *top_half_reg_cache;
+static struct kmem_cache *top_half_reg_cache;
 
 /* Cache for the data allocated in the isoc descr top half. */
-static kmem_cache_t *isoc_compl_cache;
+static struct kmem_cache *isoc_compl_cache;
 
 static struct usb_bus *etrax_usb_bus;
 
diff -puN drivers/usb/host/uhci-hcd.c~slab-remove-kmem_cache_t drivers/usb/host/uhci-hcd.c
--- a/drivers/usb/host/uhci-hcd.c~slab-remove-kmem_cache_t
+++ a/drivers/usb/host/uhci-hcd.c
@@ -81,7 +81,7 @@ MODULE_PARM_DESC(debug, "Debug level");
 static char *errbuf;
 #define ERRBUF_LEN    (32 * 1024)
 
-static kmem_cache_t *uhci_up_cachep;	/* urb_priv */
+static struct kmem_cache *uhci_up_cachep;	/* urb_priv */
 
 static void suspend_rh(struct uhci_hcd *uhci, enum uhci_rh_state new_state);
 static void wakeup_rh(struct uhci_hcd *uhci);
diff -puN drivers/usb/mon/mon_text.c~slab-remove-kmem_cache_t drivers/usb/mon/mon_text.c
--- a/drivers/usb/mon/mon_text.c~slab-remove-kmem_cache_t
+++ a/drivers/usb/mon/mon_text.c
@@ -50,7 +50,7 @@ struct mon_event_text {
 
 #define SLAB_NAME_SZ  30
 struct mon_reader_text {
-	kmem_cache_t *e_slab;
+	struct kmem_cache *e_slab;
 	int nevents;
 	struct list_head e_list;
 	struct mon_reader r;	/* In C, parent class can be placed anywhere */
@@ -63,7 +63,7 @@ struct mon_reader_text {
 	char slab_name[SLAB_NAME_SZ];
 };
 
-static void mon_text_ctor(void *, kmem_cache_t *, unsigned long);
+static void mon_text_ctor(void *, struct kmem_cache *, unsigned long);
 
 /*
  * mon_text_submit
@@ -450,7 +450,7 @@ const struct file_operations mon_fops_te
 /*
  * Slab interface: constructor.
  */
-static void mon_text_ctor(void *mem, kmem_cache_t *slab, unsigned long sflags)
+static void mon_text_ctor(void *mem, struct kmem_cache *slab, unsigned long sflags)
 {
 	/*
 	 * Nothing to initialize. No, really!
diff -puN fs/adfs/super.c~slab-remove-kmem_cache_t fs/adfs/super.c
--- a/fs/adfs/super.c~slab-remove-kmem_cache_t
+++ a/fs/adfs/super.c
@@ -212,7 +212,7 @@ static int adfs_statfs(struct dentry *de
 	return 0;
 }
 
-static kmem_cache_t *adfs_inode_cachep;
+static struct kmem_cache *adfs_inode_cachep;
 
 static struct inode *adfs_alloc_inode(struct super_block *sb)
 {
@@ -228,7 +228,7 @@ static void adfs_destroy_inode(struct in
 	kmem_cache_free(adfs_inode_cachep, ADFS_I(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct adfs_inode_info *ei = (struct adfs_inode_info *) foo;
 
diff -puN fs/affs/super.c~slab-remove-kmem_cache_t fs/affs/super.c
--- a/fs/affs/super.c~slab-remove-kmem_cache_t
+++ a/fs/affs/super.c
@@ -66,7 +66,7 @@ affs_write_super(struct super_block *sb)
 	pr_debug("AFFS: write_super() at %lu, clean=%d\n", get_seconds(), clean);
 }
 
-static kmem_cache_t * affs_inode_cachep;
+static struct kmem_cache * affs_inode_cachep;
 
 static struct inode *affs_alloc_inode(struct super_block *sb)
 {
@@ -83,7 +83,7 @@ static void affs_destroy_inode(struct in
 	kmem_cache_free(affs_inode_cachep, AFFS_I(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct affs_inode_info *ei = (struct affs_inode_info *) foo;
 
diff -puN fs/afs/super.c~slab-remove-kmem_cache_t fs/afs/super.c
--- a/fs/afs/super.c~slab-remove-kmem_cache_t
+++ a/fs/afs/super.c
@@ -35,7 +35,7 @@ struct afs_mount_params {
 	struct afs_volume	*volume;
 };
 
-static void afs_i_init_once(void *foo, kmem_cache_t *cachep,
+static void afs_i_init_once(void *foo, struct kmem_cache *cachep,
 			    unsigned long flags);
 
 static int afs_get_sb(struct file_system_type *fs_type,
@@ -65,7 +65,7 @@ static struct super_operations afs_super
 	.put_super	= afs_put_super,
 };
 
-static kmem_cache_t *afs_inode_cachep;
+static struct kmem_cache *afs_inode_cachep;
 static atomic_t afs_count_active_inodes;
 
 /*****************************************************************************/
@@ -384,7 +384,7 @@ static void afs_put_super(struct super_b
 /*
  * initialise an inode cache slab element prior to any use
  */
-static void afs_i_init_once(void *_vnode, kmem_cache_t *cachep,
+static void afs_i_init_once(void *_vnode, struct kmem_cache *cachep,
 			    unsigned long flags)
 {
 	struct afs_vnode *vnode = (struct afs_vnode *) _vnode;
diff -puN fs/aio.c~slab-remove-kmem_cache_t fs/aio.c
--- a/fs/aio.c~slab-remove-kmem_cache_t
+++ a/fs/aio.c
@@ -47,8 +47,8 @@ unsigned long aio_nr;		/* current system
 unsigned long aio_max_nr = 0x10000; /* system wide maximum number of aio requests */
 /*----end sysctl variables---*/
 
-static kmem_cache_t	*kiocb_cachep;
-static kmem_cache_t	*kioctx_cachep;
+static struct kmem_cache	*kiocb_cachep;
+static struct kmem_cache	*kioctx_cachep;
 
 static struct workqueue_struct *aio_wq;
 
diff -puN fs/befs/linuxvfs.c~slab-remove-kmem_cache_t fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~slab-remove-kmem_cache_t
+++ a/fs/befs/linuxvfs.c
@@ -61,7 +61,7 @@ static const struct super_operations bef
 };
 
 /* slab cache for befs_inode_info objects */
-static kmem_cache_t *befs_inode_cachep;
+static struct kmem_cache *befs_inode_cachep;
 
 static const struct file_operations befs_dir_operations = {
 	.read		= generic_read_dir,
@@ -289,7 +289,7 @@ befs_destroy_inode(struct inode *inode)
         kmem_cache_free(befs_inode_cachep, BEFS_I(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
         struct befs_inode_info *bi = (struct befs_inode_info *) foo;
 	
diff -puN fs/bfs/inode.c~slab-remove-kmem_cache_t fs/bfs/inode.c
--- a/fs/bfs/inode.c~slab-remove-kmem_cache_t
+++ a/fs/bfs/inode.c
@@ -228,7 +228,7 @@ static void bfs_write_super(struct super
 	unlock_kernel();
 }
 
-static kmem_cache_t * bfs_inode_cachep;
+static struct kmem_cache * bfs_inode_cachep;
 
 static struct inode *bfs_alloc_inode(struct super_block *sb)
 {
@@ -244,7 +244,7 @@ static void bfs_destroy_inode(struct ino
 	kmem_cache_free(bfs_inode_cachep, BFS_I(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct bfs_inode_info *bi = foo;
 
diff -puN fs/bio.c~slab-remove-kmem_cache_t fs/bio.c
--- a/fs/bio.c~slab-remove-kmem_cache_t
+++ a/fs/bio.c
@@ -30,7 +30,7 @@
 
 #define BIO_POOL_SIZE 256
 
-static kmem_cache_t *bio_slab __read_mostly;
+static struct kmem_cache *bio_slab __read_mostly;
 
 #define BIOVEC_NR_POOLS 6
 
@@ -44,7 +44,7 @@ mempool_t *bio_split_pool __read_mostly;
 struct biovec_slab {
 	int nr_vecs;
 	char *name; 
-	kmem_cache_t *slab;
+	struct kmem_cache *slab;
 };
 
 /*
diff -puN fs/block_dev.c~slab-remove-kmem_cache_t fs/block_dev.c
--- a/fs/block_dev.c~slab-remove-kmem_cache_t
+++ a/fs/block_dev.c
@@ -235,7 +235,7 @@ static int block_fsync(struct file *filp
  */
 
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(bdev_lock);
-static kmem_cache_t * bdev_cachep __read_mostly;
+static struct kmem_cache * bdev_cachep __read_mostly;
 
 static struct inode *bdev_alloc_inode(struct super_block *sb)
 {
@@ -253,7 +253,7 @@ static void bdev_destroy_inode(struct in
 	kmem_cache_free(bdev_cachep, bdi);
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct bdev_inode *ei = (struct bdev_inode *) foo;
 	struct block_device *bdev = &ei->bdev;
diff -puN fs/buffer.c~slab-remove-kmem_cache_t fs/buffer.c
--- a/fs/buffer.c~slab-remove-kmem_cache_t
+++ a/fs/buffer.c
@@ -2908,7 +2908,7 @@ asmlinkage long sys_bdflush(int func, lo
 /*
  * Buffer-head allocation
  */
-static kmem_cache_t *bh_cachep;
+static struct kmem_cache *bh_cachep;
 
 /*
  * Once the number of bh's in the machine exceeds this level, we start
@@ -2961,7 +2961,7 @@ void free_buffer_head(struct buffer_head
 EXPORT_SYMBOL(free_buffer_head);
 
 static void
-init_buffer_head(void *data, kmem_cache_t *cachep, unsigned long flags)
+init_buffer_head(void *data, struct kmem_cache *cachep, unsigned long flags)
 {
 	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
 			    SLAB_CTOR_CONSTRUCTOR) {
diff -puN fs/cifs/cifsfs.c~slab-remove-kmem_cache_t fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~slab-remove-kmem_cache_t
+++ a/fs/cifs/cifsfs.c
@@ -81,7 +81,7 @@ extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
 
-extern kmem_cache_t *cifs_oplock_cachep;
+extern struct kmem_cache *cifs_oplock_cachep;
 
 static int
 cifs_read_super(struct super_block *sb, void *data,
@@ -232,11 +232,11 @@ static int cifs_permission(struct inode 
 		return generic_permission(inode, mask, NULL);
 }
 
-static kmem_cache_t *cifs_inode_cachep;
-static kmem_cache_t *cifs_req_cachep;
-static kmem_cache_t *cifs_mid_cachep;
-kmem_cache_t *cifs_oplock_cachep;
-static kmem_cache_t *cifs_sm_req_cachep;
+static struct kmem_cache *cifs_inode_cachep;
+static struct kmem_cache *cifs_req_cachep;
+static struct kmem_cache *cifs_mid_cachep;
+struct kmem_cache *cifs_oplock_cachep;
+static struct kmem_cache *cifs_sm_req_cachep;
 mempool_t *cifs_sm_req_poolp;
 mempool_t *cifs_req_poolp;
 mempool_t *cifs_mid_poolp;
@@ -668,7 +668,7 @@ const struct file_operations cifs_dir_op
 };
 
 static void
-cifs_init_once(void *inode, kmem_cache_t * cachep, unsigned long flags)
+cifs_init_once(void *inode, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct cifsInodeInfo *cifsi = inode;
 
diff -puN fs/cifs/transport.c~slab-remove-kmem_cache_t fs/cifs/transport.c
--- a/fs/cifs/transport.c~slab-remove-kmem_cache_t
+++ a/fs/cifs/transport.c
@@ -34,7 +34,7 @@
 #include "cifs_debug.h"
   
 extern mempool_t *cifs_mid_poolp;
-extern kmem_cache_t *cifs_oplock_cachep;
+extern struct kmem_cache *cifs_oplock_cachep;
 
 static struct mid_q_entry *
 AllocMidQEntry(const struct smb_hdr *smb_buffer, struct cifsSesInfo *ses)
diff -puN fs/coda/inode.c~slab-remove-kmem_cache_t fs/coda/inode.c
--- a/fs/coda/inode.c~slab-remove-kmem_cache_t
+++ a/fs/coda/inode.c
@@ -38,7 +38,7 @@ static void coda_clear_inode(struct inod
 static void coda_put_super(struct super_block *);
 static int coda_statfs(struct dentry *dentry, struct kstatfs *buf);
 
-static kmem_cache_t * coda_inode_cachep;
+static struct kmem_cache * coda_inode_cachep;
 
 static struct inode *coda_alloc_inode(struct super_block *sb)
 {
@@ -58,7 +58,7 @@ static void coda_destroy_inode(struct in
 	kmem_cache_free(coda_inode_cachep, ITOC(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct coda_inode_info *ei = (struct coda_inode_info *) foo;
 
diff -puN fs/configfs/configfs_internal.h~slab-remove-kmem_cache_t fs/configfs/configfs_internal.h
--- a/fs/configfs/configfs_internal.h~slab-remove-kmem_cache_t
+++ a/fs/configfs/configfs_internal.h
@@ -49,7 +49,7 @@ struct configfs_dirent {
 #define CONFIGFS_NOT_PINNED	(CONFIGFS_ITEM_ATTR)
 
 extern struct vfsmount * configfs_mount;
-extern kmem_cache_t *configfs_dir_cachep;
+extern struct kmem_cache *configfs_dir_cachep;
 
 extern int configfs_is_root(struct config_item *item);
 
diff -puN fs/configfs/mount.c~slab-remove-kmem_cache_t fs/configfs/mount.c
--- a/fs/configfs/mount.c~slab-remove-kmem_cache_t
+++ a/fs/configfs/mount.c
@@ -38,7 +38,7 @@
 
 struct vfsmount * configfs_mount = NULL;
 struct super_block * configfs_sb = NULL;
-kmem_cache_t *configfs_dir_cachep;
+struct kmem_cache *configfs_dir_cachep;
 static int configfs_mnt_count = 0;
 
 static struct super_operations configfs_ops = {
diff -puN fs/dcache.c~slab-remove-kmem_cache_t fs/dcache.c
--- a/fs/dcache.c~slab-remove-kmem_cache_t
+++ a/fs/dcache.c
@@ -43,7 +43,7 @@ static __cacheline_aligned_in_smp DEFINE
 
 EXPORT_SYMBOL(dcache_lock);
 
-static kmem_cache_t *dentry_cache __read_mostly;
+static struct kmem_cache *dentry_cache __read_mostly;
 
 #define DNAME_INLINE_LEN (sizeof(struct dentry)-offsetof(struct dentry,d_iname))
 
@@ -2072,10 +2072,10 @@ static void __init dcache_init(unsigned 
 }
 
 /* SLAB cache for __getname() consumers */
-kmem_cache_t *names_cachep __read_mostly;
+struct kmem_cache *names_cachep __read_mostly;
 
 /* SLAB cache for file structures */
-kmem_cache_t *filp_cachep __read_mostly;
+struct kmem_cache *filp_cachep __read_mostly;
 
 EXPORT_SYMBOL(d_genocide);
 
diff -puN fs/dcookies.c~slab-remove-kmem_cache_t fs/dcookies.c
--- a/fs/dcookies.c~slab-remove-kmem_cache_t
+++ a/fs/dcookies.c
@@ -37,7 +37,7 @@ struct dcookie_struct {
 
 static LIST_HEAD(dcookie_users);
 static DEFINE_MUTEX(dcookie_mutex);
-static kmem_cache_t *dcookie_cache __read_mostly;
+static struct kmem_cache *dcookie_cache __read_mostly;
 static struct list_head *dcookie_hashtable __read_mostly;
 static size_t hash_size __read_mostly;
 
diff -puN fs/dlm/memory.c~slab-remove-kmem_cache_t fs/dlm/memory.c
--- a/fs/dlm/memory.c~slab-remove-kmem_cache_t
+++ a/fs/dlm/memory.c
@@ -15,7 +15,7 @@
 #include "config.h"
 #include "memory.h"
 
-static kmem_cache_t *lkb_cache;
+static struct kmem_cache *lkb_cache;
 
 
 int dlm_memory_init(void)
diff -puN fs/dnotify.c~slab-remove-kmem_cache_t fs/dnotify.c
--- a/fs/dnotify.c~slab-remove-kmem_cache_t
+++ a/fs/dnotify.c
@@ -23,7 +23,7 @@
 
 int dir_notify_enable __read_mostly = 1;
 
-static kmem_cache_t *dn_cache __read_mostly;
+static struct kmem_cache *dn_cache __read_mostly;
 
 static void redo_inode_mask(struct inode *inode)
 {
diff -puN fs/dquot.c~slab-remove-kmem_cache_t fs/dquot.c
--- a/fs/dquot.c~slab-remove-kmem_cache_t
+++ a/fs/dquot.c
@@ -131,7 +131,7 @@ static struct quota_format_type *quota_f
 static struct quota_module_name module_names[] = INIT_QUOTA_MODULE_NAMES;
 
 /* SLAB cache for dquot structures */
-static kmem_cache_t *dquot_cachep;
+static struct kmem_cache *dquot_cachep;
 
 int register_quota_format(struct quota_format_type *fmt)
 {
diff -puN fs/ecryptfs/main.c~slab-remove-kmem_cache_t fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~slab-remove-kmem_cache_t
+++ a/fs/ecryptfs/main.c
@@ -546,7 +546,7 @@ inode_info_init_once(void *vptr, struct 
 }
 
 static struct ecryptfs_cache_info {
-	kmem_cache_t **cache;
+	struct kmem_cache **cache;
 	const char *name;
 	size_t size;
 	void (*ctor)(void*, struct kmem_cache *, unsigned long);
diff -puN fs/efs/super.c~slab-remove-kmem_cache_t fs/efs/super.c
--- a/fs/efs/super.c~slab-remove-kmem_cache_t
+++ a/fs/efs/super.c
@@ -52,7 +52,7 @@ static struct pt_types sgi_pt_types[] = 
 };
 
 
-static kmem_cache_t * efs_inode_cachep;
+static struct kmem_cache * efs_inode_cachep;
 
 static struct inode *efs_alloc_inode(struct super_block *sb)
 {
@@ -68,7 +68,7 @@ static void efs_destroy_inode(struct ino
 	kmem_cache_free(efs_inode_cachep, INODE_INFO(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct efs_inode_info *ei = (struct efs_inode_info *) foo;
 
diff -puN fs/eventpoll.c~slab-remove-kmem_cache_t fs/eventpoll.c
--- a/fs/eventpoll.c~slab-remove-kmem_cache_t
+++ a/fs/eventpoll.c
@@ -283,10 +283,10 @@ static struct mutex epmutex;
 static struct poll_safewake psw;
 
 /* Slab cache used to allocate "struct epitem" */
-static kmem_cache_t *epi_cache __read_mostly;
+static struct kmem_cache *epi_cache __read_mostly;
 
 /* Slab cache used to allocate "struct eppoll_entry" */
-static kmem_cache_t *pwq_cache __read_mostly;
+static struct kmem_cache *pwq_cache __read_mostly;
 
 /* Virtual fs used to allocate inodes for eventpoll files */
 static struct vfsmount *eventpoll_mnt __read_mostly;
diff -puN fs/ext2/super.c~slab-remove-kmem_cache_t fs/ext2/super.c
--- a/fs/ext2/super.c~slab-remove-kmem_cache_t
+++ a/fs/ext2/super.c
@@ -135,7 +135,7 @@ static void ext2_put_super (struct super
 	return;
 }
 
-static kmem_cache_t * ext2_inode_cachep;
+static struct kmem_cache * ext2_inode_cachep;
 
 static struct inode *ext2_alloc_inode(struct super_block *sb)
 {
@@ -156,7 +156,7 @@ static void ext2_destroy_inode(struct in
 	kmem_cache_free(ext2_inode_cachep, EXT2_I(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct ext2_inode_info *ei = (struct ext2_inode_info *) foo;
 
diff -puN fs/ext3/super.c~slab-remove-kmem_cache_t fs/ext3/super.c
--- a/fs/ext3/super.c~slab-remove-kmem_cache_t
+++ a/fs/ext3/super.c
@@ -436,7 +436,7 @@ static void ext3_put_super (struct super
 	return;
 }
 
-static kmem_cache_t *ext3_inode_cachep;
+static struct kmem_cache *ext3_inode_cachep;
 
 /*
  * Called inside transaction, so use GFP_NOFS
@@ -462,7 +462,7 @@ static void ext3_destroy_inode(struct in
 	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct ext3_inode_info *ei = (struct ext3_inode_info *) foo;
 
diff -puN fs/ext4/super.c~slab-remove-kmem_cache_t fs/ext4/super.c
--- a/fs/ext4/super.c~slab-remove-kmem_cache_t
+++ a/fs/ext4/super.c
@@ -486,7 +486,7 @@ static void ext4_put_super (struct super
 	return;
 }
 
-static kmem_cache_t *ext4_inode_cachep;
+static struct kmem_cache *ext4_inode_cachep;
 
 /*
  * Called inside transaction, so use GFP_NOFS
@@ -513,7 +513,7 @@ static void ext4_destroy_inode(struct in
 	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct ext4_inode_info *ei = (struct ext4_inode_info *) foo;
 
diff -puN fs/fat/cache.c~slab-remove-kmem_cache_t fs/fat/cache.c
--- a/fs/fat/cache.c~slab-remove-kmem_cache_t
+++ a/fs/fat/cache.c
@@ -34,9 +34,9 @@ static inline int fat_max_cache(struct i
 	return FAT_MAX_CACHE;
 }
 
-static kmem_cache_t *fat_cache_cachep;
+static struct kmem_cache *fat_cache_cachep;
 
-static void init_once(void *foo, kmem_cache_t *cachep, unsigned long flags)
+static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct fat_cache *cache = (struct fat_cache *)foo;
 
diff -puN fs/fat/inode.c~slab-remove-kmem_cache_t fs/fat/inode.c
--- a/fs/fat/inode.c~slab-remove-kmem_cache_t
+++ a/fs/fat/inode.c
@@ -477,7 +477,7 @@ static void fat_put_super(struct super_b
 	kfree(sbi);
 }
 
-static kmem_cache_t *fat_inode_cachep;
+static struct kmem_cache *fat_inode_cachep;
 
 static struct inode *fat_alloc_inode(struct super_block *sb)
 {
@@ -493,7 +493,7 @@ static void fat_destroy_inode(struct ino
 	kmem_cache_free(fat_inode_cachep, MSDOS_I(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct msdos_inode_info *ei = (struct msdos_inode_info *)foo;
 
diff -puN fs/fcntl.c~slab-remove-kmem_cache_t fs/fcntl.c
--- a/fs/fcntl.c~slab-remove-kmem_cache_t
+++ a/fs/fcntl.c
@@ -553,7 +553,7 @@ int send_sigurg(struct fown_struct *fown
 }
 
 static DEFINE_RWLOCK(fasync_lock);
-static kmem_cache_t *fasync_cache __read_mostly;
+static struct kmem_cache *fasync_cache __read_mostly;
 
 /*
  * fasync_helper() is used by some character device drivers (mainly mice)
diff -puN fs/freevxfs/vxfs_inode.c~slab-remove-kmem_cache_t fs/freevxfs/vxfs_inode.c
--- a/fs/freevxfs/vxfs_inode.c~slab-remove-kmem_cache_t
+++ a/fs/freevxfs/vxfs_inode.c
@@ -46,7 +46,7 @@ extern const struct address_space_operat
 
 extern struct inode_operations vxfs_immed_symlink_iops;
 
-kmem_cache_t		*vxfs_inode_cachep;
+struct kmem_cache		*vxfs_inode_cachep;
 
 
 #ifdef DIAGNOSTIC
diff -puN fs/fuse/dev.c~slab-remove-kmem_cache_t fs/fuse/dev.c
--- a/fs/fuse/dev.c~slab-remove-kmem_cache_t
+++ a/fs/fuse/dev.c
@@ -19,7 +19,7 @@
 
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 
-static kmem_cache_t *fuse_req_cachep;
+static struct kmem_cache *fuse_req_cachep;
 
 static struct fuse_conn *fuse_get_conn(struct file *file)
 {
diff -puN fs/fuse/inode.c~slab-remove-kmem_cache_t fs/fuse/inode.c
--- a/fs/fuse/inode.c~slab-remove-kmem_cache_t
+++ a/fs/fuse/inode.c
@@ -22,7 +22,7 @@ MODULE_AUTHOR("Miklos Szeredi <miklos@sz
 MODULE_DESCRIPTION("Filesystem in Userspace");
 MODULE_LICENSE("GPL");
 
-static kmem_cache_t *fuse_inode_cachep;
+static struct kmem_cache *fuse_inode_cachep;
 struct list_head fuse_conn_list;
 DEFINE_MUTEX(fuse_mutex);
 
@@ -601,7 +601,7 @@ static struct file_system_type fuse_fs_t
 static decl_subsys(fuse, NULL, NULL);
 static decl_subsys(connections, NULL, NULL);
 
-static void fuse_inode_init_once(void *foo, kmem_cache_t *cachep,
+static void fuse_inode_init_once(void *foo, struct kmem_cache *cachep,
 				 unsigned long flags)
 {
 	struct inode * inode = foo;
diff -puN fs/gfs2/main.c~slab-remove-kmem_cache_t fs/gfs2/main.c
--- a/fs/gfs2/main.c~slab-remove-kmem_cache_t
+++ a/fs/gfs2/main.c
@@ -25,7 +25,7 @@
 #include "util.h"
 #include "glock.h"
 
-static void gfs2_init_inode_once(void *foo, kmem_cache_t *cachep, unsigned long flags)
+static void gfs2_init_inode_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct gfs2_inode *ip = foo;
 	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
@@ -37,7 +37,7 @@ static void gfs2_init_inode_once(void *f
 	}
 }
 
-static void gfs2_init_glock_once(void *foo, kmem_cache_t *cachep, unsigned long flags)
+static void gfs2_init_glock_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct gfs2_glock *gl = foo;
 	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
diff -puN fs/gfs2/util.c~slab-remove-kmem_cache_t fs/gfs2/util.c
--- a/fs/gfs2/util.c~slab-remove-kmem_cache_t
+++ a/fs/gfs2/util.c
@@ -23,9 +23,9 @@
 #include "lm.h"
 #include "util.h"
 
-kmem_cache_t *gfs2_glock_cachep __read_mostly;
-kmem_cache_t *gfs2_inode_cachep __read_mostly;
-kmem_cache_t *gfs2_bufdata_cachep __read_mostly;
+struct kmem_cache *gfs2_glock_cachep __read_mostly;
+struct kmem_cache *gfs2_inode_cachep __read_mostly;
+struct kmem_cache *gfs2_bufdata_cachep __read_mostly;
 
 void gfs2_assert_i(struct gfs2_sbd *sdp)
 {
diff -puN fs/gfs2/util.h~slab-remove-kmem_cache_t fs/gfs2/util.h
--- a/fs/gfs2/util.h~slab-remove-kmem_cache_t
+++ a/fs/gfs2/util.h
@@ -146,9 +146,9 @@ int gfs2_io_error_bh_i(struct gfs2_sbd *
 gfs2_io_error_bh_i((sdp), (bh), __FUNCTION__, __FILE__, __LINE__);
 
 
-extern kmem_cache_t *gfs2_glock_cachep;
-extern kmem_cache_t *gfs2_inode_cachep;
-extern kmem_cache_t *gfs2_bufdata_cachep;
+extern struct kmem_cache *gfs2_glock_cachep;
+extern struct kmem_cache *gfs2_inode_cachep;
+extern struct kmem_cache *gfs2_bufdata_cachep;
 
 static inline unsigned int gfs2_tune_get_i(struct gfs2_tune *gt,
 					   unsigned int *p)
diff -puN fs/hfs/super.c~slab-remove-kmem_cache_t fs/hfs/super.c
--- a/fs/hfs/super.c~slab-remove-kmem_cache_t
+++ a/fs/hfs/super.c
@@ -24,7 +24,7 @@
 #include "hfs_fs.h"
 #include "btree.h"
 
-static kmem_cache_t *hfs_inode_cachep;
+static struct kmem_cache *hfs_inode_cachep;
 
 MODULE_LICENSE("GPL");
 
@@ -430,7 +430,7 @@ static struct file_system_type hfs_fs_ty
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-static void hfs_init_once(void *p, kmem_cache_t *cachep, unsigned long flags)
+static void hfs_init_once(void *p, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct hfs_inode_info *i = p;
 
diff -puN fs/hfsplus/super.c~slab-remove-kmem_cache_t fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~slab-remove-kmem_cache_t
+++ a/fs/hfsplus/super.c
@@ -434,7 +434,7 @@ MODULE_AUTHOR("Brad Boyer");
 MODULE_DESCRIPTION("Extended Macintosh Filesystem");
 MODULE_LICENSE("GPL");
 
-static kmem_cache_t *hfsplus_inode_cachep;
+static struct kmem_cache *hfsplus_inode_cachep;
 
 static struct inode *hfsplus_alloc_inode(struct super_block *sb)
 {
@@ -467,7 +467,7 @@ static struct file_system_type hfsplus_f
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-static void hfsplus_init_once(void *p, kmem_cache_t *cachep, unsigned long flags)
+static void hfsplus_init_once(void *p, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct hfsplus_inode_info *i = p;
 
diff -puN fs/hpfs/super.c~slab-remove-kmem_cache_t fs/hpfs/super.c
--- a/fs/hpfs/super.c~slab-remove-kmem_cache_t
+++ a/fs/hpfs/super.c
@@ -160,7 +160,7 @@ static int hpfs_statfs(struct dentry *de
 	return 0;
 }
 
-static kmem_cache_t * hpfs_inode_cachep;
+static struct kmem_cache * hpfs_inode_cachep;
 
 static struct inode *hpfs_alloc_inode(struct super_block *sb)
 {
@@ -177,7 +177,7 @@ static void hpfs_destroy_inode(struct in
 	kmem_cache_free(hpfs_inode_cachep, hpfs_i(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct hpfs_inode_info *ei = (struct hpfs_inode_info *) foo;
 
diff -puN fs/hugetlbfs/inode.c~slab-remove-kmem_cache_t fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~slab-remove-kmem_cache_t
+++ a/fs/hugetlbfs/inode.c
@@ -513,7 +513,7 @@ static void hugetlbfs_inc_free_inodes(st
 }
 
 
-static kmem_cache_t *hugetlbfs_inode_cachep;
+static struct kmem_cache *hugetlbfs_inode_cachep;
 
 static struct inode *hugetlbfs_alloc_inode(struct super_block *sb)
 {
@@ -545,7 +545,7 @@ static const struct address_space_operat
 };
 
 
-static void init_once(void *foo, kmem_cache_t *cachep, unsigned long flags)
+static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct hugetlbfs_inode_info *ei = (struct hugetlbfs_inode_info *)foo;
 
diff -puN fs/inode.c~slab-remove-kmem_cache_t fs/inode.c
--- a/fs/inode.c~slab-remove-kmem_cache_t
+++ a/fs/inode.c
@@ -97,7 +97,7 @@ static DEFINE_MUTEX(iprune_mutex);
  */
 struct inodes_stat_t inodes_stat;
 
-static kmem_cache_t * inode_cachep __read_mostly;
+static struct kmem_cache * inode_cachep __read_mostly;
 
 static struct inode *alloc_inode(struct super_block *sb)
 {
@@ -209,7 +209,7 @@ void inode_init_once(struct inode *inode
 
 EXPORT_SYMBOL(inode_init_once);
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct inode * inode = (struct inode *) foo;
 
diff -puN fs/inotify_user.c~slab-remove-kmem_cache_t fs/inotify_user.c
--- a/fs/inotify_user.c~slab-remove-kmem_cache_t
+++ a/fs/inotify_user.c
@@ -34,8 +34,8 @@
 
 #include <asm/ioctls.h>
 
-static kmem_cache_t *watch_cachep __read_mostly;
-static kmem_cache_t *event_cachep __read_mostly;
+static struct kmem_cache *watch_cachep __read_mostly;
+static struct kmem_cache *event_cachep __read_mostly;
 
 static struct vfsmount *inotify_mnt __read_mostly;
 
diff -puN fs/isofs/inode.c~slab-remove-kmem_cache_t fs/isofs/inode.c
--- a/fs/isofs/inode.c~slab-remove-kmem_cache_t
+++ a/fs/isofs/inode.c
@@ -57,7 +57,7 @@ static void isofs_put_super(struct super
 static void isofs_read_inode(struct inode *);
 static int isofs_statfs (struct dentry *, struct kstatfs *);
 
-static kmem_cache_t *isofs_inode_cachep;
+static struct kmem_cache *isofs_inode_cachep;
 
 static struct inode *isofs_alloc_inode(struct super_block *sb)
 {
@@ -73,7 +73,7 @@ static void isofs_destroy_inode(struct i
 	kmem_cache_free(isofs_inode_cachep, ISOFS_I(inode));
 }
 
-static void init_once(void *foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void *foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct iso_inode_info *ei = foo;
 
diff -puN fs/jbd/journal.c~slab-remove-kmem_cache_t fs/jbd/journal.c
--- a/fs/jbd/journal.c~slab-remove-kmem_cache_t
+++ a/fs/jbd/journal.c
@@ -1630,7 +1630,7 @@ void * __jbd_kmalloc (const char *where,
 #define JBD_MAX_SLABS 5
 #define JBD_SLAB_INDEX(size)  (size >> 11)
 
-static kmem_cache_t *jbd_slab[JBD_MAX_SLABS];
+static struct kmem_cache *jbd_slab[JBD_MAX_SLABS];
 static const char *jbd_slab_names[JBD_MAX_SLABS] = {
 	"jbd_1k", "jbd_2k", "jbd_4k", NULL, "jbd_8k"
 };
@@ -1693,7 +1693,7 @@ void jbd_slab_free(void *ptr,  size_t si
 /*
  * Journal_head storage management
  */
-static kmem_cache_t *journal_head_cache;
+static struct kmem_cache *journal_head_cache;
 #ifdef CONFIG_JBD_DEBUG
 static atomic_t nr_journal_heads = ATOMIC_INIT(0);
 #endif
@@ -1996,7 +1996,7 @@ static void __exit remove_jbd_proc_entry
 
 #endif
 
-kmem_cache_t *jbd_handle_cache;
+struct kmem_cache *jbd_handle_cache;
 
 static int __init journal_init_handle_cache(void)
 {
diff -puN fs/jbd/revoke.c~slab-remove-kmem_cache_t fs/jbd/revoke.c
--- a/fs/jbd/revoke.c~slab-remove-kmem_cache_t
+++ a/fs/jbd/revoke.c
@@ -70,8 +70,8 @@
 #include <linux/init.h>
 #endif
 
-static kmem_cache_t *revoke_record_cache;
-static kmem_cache_t *revoke_table_cache;
+static struct kmem_cache *revoke_record_cache;
+static struct kmem_cache *revoke_table_cache;
 
 /* Each revoke record represents one single revoked block.  During
    journal replay, this involves recording the transaction ID of the
diff -puN fs/jbd2/journal.c~slab-remove-kmem_cache_t fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~slab-remove-kmem_cache_t
+++ a/fs/jbd2/journal.c
@@ -1641,7 +1641,7 @@ void * __jbd2_kmalloc (const char *where
 #define JBD_MAX_SLABS 5
 #define JBD_SLAB_INDEX(size)  (size >> 11)
 
-static kmem_cache_t *jbd_slab[JBD_MAX_SLABS];
+static struct kmem_cache *jbd_slab[JBD_MAX_SLABS];
 static const char *jbd_slab_names[JBD_MAX_SLABS] = {
 	"jbd2_1k", "jbd2_2k", "jbd2_4k", NULL, "jbd2_8k"
 };
@@ -1704,7 +1704,7 @@ void jbd2_slab_free(void *ptr,  size_t s
 /*
  * Journal_head storage management
  */
-static kmem_cache_t *jbd2_journal_head_cache;
+static struct kmem_cache *jbd2_journal_head_cache;
 #ifdef CONFIG_JBD_DEBUG
 static atomic_t nr_journal_heads = ATOMIC_INIT(0);
 #endif
@@ -2007,7 +2007,7 @@ static void __exit jbd2_remove_jbd_proc_
 
 #endif
 
-kmem_cache_t *jbd2_handle_cache;
+struct kmem_cache *jbd2_handle_cache;
 
 static int __init journal_init_handle_cache(void)
 {
diff -puN fs/jbd2/revoke.c~slab-remove-kmem_cache_t fs/jbd2/revoke.c
--- a/fs/jbd2/revoke.c~slab-remove-kmem_cache_t
+++ a/fs/jbd2/revoke.c
@@ -70,8 +70,8 @@
 #include <linux/init.h>
 #endif
 
-static kmem_cache_t *jbd2_revoke_record_cache;
-static kmem_cache_t *jbd2_revoke_table_cache;
+static struct kmem_cache *jbd2_revoke_record_cache;
+static struct kmem_cache *jbd2_revoke_table_cache;
 
 /* Each revoke record represents one single revoked block.  During
    journal replay, this involves recording the transaction ID of the
diff -puN fs/jffs/inode-v23.c~slab-remove-kmem_cache_t fs/jffs/inode-v23.c
--- a/fs/jffs/inode-v23.c~slab-remove-kmem_cache_t
+++ a/fs/jffs/inode-v23.c
@@ -61,8 +61,8 @@ static const struct file_operations jffs
 static struct inode_operations jffs_dir_inode_operations;
 static const struct address_space_operations jffs_address_operations;
 
-kmem_cache_t     *node_cache = NULL;
-kmem_cache_t     *fm_cache = NULL;
+struct kmem_cache     *node_cache = NULL;
+struct kmem_cache     *fm_cache = NULL;
 
 /* Called by the VFS at mount time to initialize the whole file system.  */
 static int jffs_fill_super(struct super_block *sb, void *data, int silent)
diff -puN fs/jffs/jffs_fm.c~slab-remove-kmem_cache_t fs/jffs/jffs_fm.c
--- a/fs/jffs/jffs_fm.c~slab-remove-kmem_cache_t
+++ a/fs/jffs/jffs_fm.c
@@ -29,8 +29,8 @@ static int jffs_mark_obsolete(struct jff
 static struct jffs_fm *jffs_alloc_fm(void);
 static void jffs_free_fm(struct jffs_fm *n);
 
-extern kmem_cache_t     *fm_cache;
-extern kmem_cache_t     *node_cache;
+extern struct kmem_cache     *fm_cache;
+extern struct kmem_cache     *node_cache;
 
 #if CONFIG_JFFS_FS_VERBOSE > 0
 void
diff -puN fs/jffs2/malloc.c~slab-remove-kmem_cache_t fs/jffs2/malloc.c
--- a/fs/jffs2/malloc.c~slab-remove-kmem_cache_t
+++ a/fs/jffs2/malloc.c
@@ -19,16 +19,16 @@
 
 /* These are initialised to NULL in the kernel startup code.
    If you're porting to other operating systems, beware */
-static kmem_cache_t *full_dnode_slab;
-static kmem_cache_t *raw_dirent_slab;
-static kmem_cache_t *raw_inode_slab;
-static kmem_cache_t *tmp_dnode_info_slab;
-static kmem_cache_t *raw_node_ref_slab;
-static kmem_cache_t *node_frag_slab;
-static kmem_cache_t *inode_cache_slab;
+static struct kmem_cache *full_dnode_slab;
+static struct kmem_cache *raw_dirent_slab;
+static struct kmem_cache *raw_inode_slab;
+static struct kmem_cache *tmp_dnode_info_slab;
+static struct kmem_cache *raw_node_ref_slab;
+static struct kmem_cache *node_frag_slab;
+static struct kmem_cache *inode_cache_slab;
 #ifdef CONFIG_JFFS2_FS_XATTR
-static kmem_cache_t *xattr_datum_cache;
-static kmem_cache_t *xattr_ref_cache;
+static struct kmem_cache *xattr_datum_cache;
+static struct kmem_cache *xattr_ref_cache;
 #endif
 
 int __init jffs2_create_slab_caches(void)
diff -puN fs/jffs2/super.c~slab-remove-kmem_cache_t fs/jffs2/super.c
--- a/fs/jffs2/super.c~slab-remove-kmem_cache_t
+++ a/fs/jffs2/super.c
@@ -28,7 +28,7 @@
 
 static void jffs2_put_super(struct super_block *);
 
-static kmem_cache_t *jffs2_inode_cachep;
+static struct kmem_cache *jffs2_inode_cachep;
 
 static struct inode *jffs2_alloc_inode(struct super_block *sb)
 {
@@ -44,7 +44,7 @@ static void jffs2_destroy_inode(struct i
 	kmem_cache_free(jffs2_inode_cachep, JFFS2_INODE_INFO(inode));
 }
 
-static void jffs2_i_init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void jffs2_i_init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct jffs2_inode_info *ei = (struct jffs2_inode_info *) foo;
 
diff -puN fs/jfs/jfs_metapage.c~slab-remove-kmem_cache_t fs/jfs/jfs_metapage.c
--- a/fs/jfs/jfs_metapage.c~slab-remove-kmem_cache_t
+++ a/fs/jfs/jfs_metapage.c
@@ -74,7 +74,7 @@ static inline void lock_metapage(struct 
 }
 
 #define METAPOOL_MIN_PAGES 32
-static kmem_cache_t *metapage_cache;
+static struct kmem_cache *metapage_cache;
 static mempool_t *metapage_mempool;
 
 #define MPS_PER_PAGE (PAGE_CACHE_SIZE >> L2PSIZE)
@@ -180,7 +180,7 @@ static inline void remove_metapage(struc
 
 #endif
 
-static void init_once(void *foo, kmem_cache_t *cachep, unsigned long flags)
+static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct metapage *mp = (struct metapage *)foo;
 
diff -puN fs/jfs/super.c~slab-remove-kmem_cache_t fs/jfs/super.c
--- a/fs/jfs/super.c~slab-remove-kmem_cache_t
+++ a/fs/jfs/super.c
@@ -44,7 +44,7 @@ MODULE_DESCRIPTION("The Journaled Filesy
 MODULE_AUTHOR("Steve Best/Dave Kleikamp/Barry Arndt, IBM");
 MODULE_LICENSE("GPL");
 
-static kmem_cache_t * jfs_inode_cachep;
+static struct kmem_cache * jfs_inode_cachep;
 
 static struct super_operations jfs_super_operations;
 static struct export_operations jfs_export_operations;
@@ -748,7 +748,7 @@ static struct file_system_type jfs_fs_ty
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-static void init_once(void *foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void *foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct jfs_inode_info *jfs_ip = (struct jfs_inode_info *) foo;
 
diff -puN fs/locks.c~slab-remove-kmem_cache_t fs/locks.c
--- a/fs/locks.c~slab-remove-kmem_cache_t
+++ a/fs/locks.c
@@ -142,7 +142,7 @@ int lease_break_time = 45;
 static LIST_HEAD(file_lock_list);
 static LIST_HEAD(blocked_list);
 
-static kmem_cache_t *filelock_cache __read_mostly;
+static struct kmem_cache *filelock_cache __read_mostly;
 
 /* Allocate an empty lock structure. */
 static struct file_lock *locks_alloc_lock(void)
@@ -199,7 +199,7 @@ EXPORT_SYMBOL(locks_init_lock);
  * Initialises the fields of the file lock which are invariant for
  * free file_locks.
  */
-static void init_once(void *foo, kmem_cache_t *cache, unsigned long flags)
+static void init_once(void *foo, struct kmem_cache *cache, unsigned long flags)
 {
 	struct file_lock *lock = (struct file_lock *) foo;
 
diff -puN fs/mbcache.c~slab-remove-kmem_cache_t fs/mbcache.c
--- a/fs/mbcache.c~slab-remove-kmem_cache_t
+++ a/fs/mbcache.c
@@ -85,7 +85,7 @@ struct mb_cache {
 #ifndef MB_CACHE_INDEXES_COUNT
 	int				c_indexes_count;
 #endif
-	kmem_cache_t			*c_entry_cache;
+	struct kmem_cache			*c_entry_cache;
 	struct list_head		*c_block_hash;
 	struct list_head		*c_indexes_hash[0];
 };
diff -puN fs/minix/inode.c~slab-remove-kmem_cache_t fs/minix/inode.c
--- a/fs/minix/inode.c~slab-remove-kmem_cache_t
+++ a/fs/minix/inode.c
@@ -51,7 +51,7 @@ static void minix_put_super(struct super
 	return;
 }
 
-static kmem_cache_t * minix_inode_cachep;
+static struct kmem_cache * minix_inode_cachep;
 
 static struct inode *minix_alloc_inode(struct super_block *sb)
 {
@@ -67,7 +67,7 @@ static void minix_destroy_inode(struct i
 	kmem_cache_free(minix_inode_cachep, minix_i(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct minix_inode_info *ei = (struct minix_inode_info *) foo;
 
diff -puN fs/namespace.c~slab-remove-kmem_cache_t fs/namespace.c
--- a/fs/namespace.c~slab-remove-kmem_cache_t
+++ a/fs/namespace.c
@@ -36,7 +36,7 @@ static int event;
 
 static struct list_head *mount_hashtable __read_mostly;
 static int hash_mask __read_mostly, hash_bits __read_mostly;
-static kmem_cache_t *mnt_cache __read_mostly;
+static struct kmem_cache *mnt_cache __read_mostly;
 static struct rw_semaphore namespace_sem;
 
 /* /sys/fs */
diff -puN fs/ncpfs/inode.c~slab-remove-kmem_cache_t fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~slab-remove-kmem_cache_t
+++ a/fs/ncpfs/inode.c
@@ -40,7 +40,7 @@ static void ncp_delete_inode(struct inod
 static void ncp_put_super(struct super_block *);
 static int  ncp_statfs(struct dentry *, struct kstatfs *);
 
-static kmem_cache_t * ncp_inode_cachep;
+static struct kmem_cache * ncp_inode_cachep;
 
 static struct inode *ncp_alloc_inode(struct super_block *sb)
 {
@@ -56,7 +56,7 @@ static void ncp_destroy_inode(struct ino
 	kmem_cache_free(ncp_inode_cachep, NCP_FINFO(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct ncp_inode_info *ei = (struct ncp_inode_info *) foo;
 
diff -puN fs/nfs/direct.c~slab-remove-kmem_cache_t fs/nfs/direct.c
--- a/fs/nfs/direct.c~slab-remove-kmem_cache_t
+++ a/fs/nfs/direct.c
@@ -58,7 +58,7 @@
 
 #define NFSDBG_FACILITY		NFSDBG_VFS
 
-static kmem_cache_t *nfs_direct_cachep;
+static struct kmem_cache *nfs_direct_cachep;
 
 /*
  * This represents a set of asynchronous requests that we're waiting on
diff -puN fs/nfs/inode.c~slab-remove-kmem_cache_t fs/nfs/inode.c
--- a/fs/nfs/inode.c~slab-remove-kmem_cache_t
+++ a/fs/nfs/inode.c
@@ -55,7 +55,7 @@ static int nfs_update_inode(struct inode
 
 static void nfs_zap_acl_cache(struct inode *);
 
-static kmem_cache_t * nfs_inode_cachep;
+static struct kmem_cache * nfs_inode_cachep;
 
 static inline unsigned long
 nfs_fattr_to_ino_t(struct nfs_fattr *fattr)
@@ -1111,7 +1111,7 @@ static inline void nfs4_init_once(struct
 #endif
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct nfs_inode *nfsi = (struct nfs_inode *) foo;
 
diff -puN fs/nfs/pagelist.c~slab-remove-kmem_cache_t fs/nfs/pagelist.c
--- a/fs/nfs/pagelist.c~slab-remove-kmem_cache_t
+++ a/fs/nfs/pagelist.c
@@ -20,7 +20,7 @@
 
 #define NFS_PARANOIA 1
 
-static kmem_cache_t *nfs_page_cachep;
+static struct kmem_cache *nfs_page_cachep;
 
 static inline struct nfs_page *
 nfs_page_alloc(void)
diff -puN fs/nfs/read.c~slab-remove-kmem_cache_t fs/nfs/read.c
--- a/fs/nfs/read.c~slab-remove-kmem_cache_t
+++ a/fs/nfs/read.c
@@ -38,7 +38,7 @@ static int nfs_pagein_one(struct list_he
 static const struct rpc_call_ops nfs_read_partial_ops;
 static const struct rpc_call_ops nfs_read_full_ops;
 
-static kmem_cache_t *nfs_rdata_cachep;
+static struct kmem_cache *nfs_rdata_cachep;
 static mempool_t *nfs_rdata_mempool;
 
 #define MIN_POOL_READ	(32)
diff -puN fs/nfs/write.c~slab-remove-kmem_cache_t fs/nfs/write.c
--- a/fs/nfs/write.c~slab-remove-kmem_cache_t
+++ a/fs/nfs/write.c
@@ -85,7 +85,7 @@ static const struct rpc_call_ops nfs_wri
 static const struct rpc_call_ops nfs_write_full_ops;
 static const struct rpc_call_ops nfs_commit_ops;
 
-static kmem_cache_t *nfs_wdata_cachep;
+static struct kmem_cache *nfs_wdata_cachep;
 static mempool_t *nfs_wdata_mempool;
 static mempool_t *nfs_commit_mempool;
 
diff -puN fs/nfsd/nfs4state.c~slab-remove-kmem_cache_t fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~slab-remove-kmem_cache_t
+++ a/fs/nfsd/nfs4state.c
@@ -84,10 +84,10 @@ static void nfs4_set_recdir(char *recdir
  */
 static DEFINE_MUTEX(client_mutex);
 
-static kmem_cache_t *stateowner_slab = NULL;
-static kmem_cache_t *file_slab = NULL;
-static kmem_cache_t *stateid_slab = NULL;
-static kmem_cache_t *deleg_slab = NULL;
+static struct kmem_cache *stateowner_slab = NULL;
+static struct kmem_cache *file_slab = NULL;
+static struct kmem_cache *stateid_slab = NULL;
+static struct kmem_cache *deleg_slab = NULL;
 
 void
 nfs4_lock_state(void)
@@ -1003,7 +1003,7 @@ alloc_init_file(struct inode *ino)
 }
 
 static void
-nfsd4_free_slab(kmem_cache_t **slab)
+nfsd4_free_slab(struct kmem_cache **slab)
 {
 	if (*slab == NULL)
 		return;
diff -puN fs/ocfs2/dlm/dlmfs.c~slab-remove-kmem_cache_t fs/ocfs2/dlm/dlmfs.c
--- a/fs/ocfs2/dlm/dlmfs.c~slab-remove-kmem_cache_t
+++ a/fs/ocfs2/dlm/dlmfs.c
@@ -66,7 +66,7 @@ static struct file_operations dlmfs_file
 static struct inode_operations dlmfs_dir_inode_operations;
 static struct inode_operations dlmfs_root_inode_operations;
 static struct inode_operations dlmfs_file_inode_operations;
-static kmem_cache_t *dlmfs_inode_cache;
+static struct kmem_cache *dlmfs_inode_cache;
 
 struct workqueue_struct *user_dlm_worker;
 
@@ -257,7 +257,7 @@ static ssize_t dlmfs_file_write(struct f
 }
 
 static void dlmfs_init_once(void *foo,
-			    kmem_cache_t *cachep,
+			    struct kmem_cache *cachep,
 			    unsigned long flags)
 {
 	struct dlmfs_inode_private *ip =
diff -puN fs/ocfs2/dlm/dlmmaster.c~slab-remove-kmem_cache_t fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~slab-remove-kmem_cache_t
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -221,7 +221,7 @@ EXPORT_SYMBOL_GPL(dlm_dump_all_mles);
 #endif  /*  0  */
 
 
-static kmem_cache_t *dlm_mle_cache = NULL;
+static struct kmem_cache *dlm_mle_cache = NULL;
 
 
 static void dlm_mle_release(struct kref *kref);
diff -puN fs/ocfs2/extent_map.c~slab-remove-kmem_cache_t fs/ocfs2/extent_map.c
--- a/fs/ocfs2/extent_map.c~slab-remove-kmem_cache_t
+++ a/fs/ocfs2/extent_map.c
@@ -61,7 +61,7 @@ struct ocfs2_em_insert_context {
 	struct ocfs2_extent_map_entry *right_ent;
 };
 
-static kmem_cache_t *ocfs2_em_ent_cachep = NULL;
+static struct kmem_cache *ocfs2_em_ent_cachep = NULL;
 
 
 static struct ocfs2_extent_map_entry *
diff -puN fs/ocfs2/inode.h~slab-remove-kmem_cache_t fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~slab-remove-kmem_cache_t
+++ a/fs/ocfs2/inode.h
@@ -106,7 +106,7 @@ static inline struct ocfs2_inode_info *O
 #define INODE_JOURNAL(i) (OCFS2_I(i)->ip_flags & OCFS2_INODE_JOURNAL)
 #define SET_INODE_JOURNAL(i) (OCFS2_I(i)->ip_flags |= OCFS2_INODE_JOURNAL)
 
-extern kmem_cache_t *ocfs2_inode_cache;
+extern struct kmem_cache *ocfs2_inode_cache;
 
 extern const struct address_space_operations ocfs2_aops;
 
diff -puN fs/ocfs2/super.c~slab-remove-kmem_cache_t fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~slab-remove-kmem_cache_t
+++ a/fs/ocfs2/super.c
@@ -68,7 +68,7 @@
 
 #include "buffer_head_io.h"
 
-static kmem_cache_t *ocfs2_inode_cachep = NULL;
+static struct kmem_cache *ocfs2_inode_cachep = NULL;
 
 /* OCFS2 needs to schedule several differnt types of work which
  * require cluster locking, disk I/O, recovery waits, etc. Since these
@@ -914,7 +914,7 @@ bail:
 }
 
 static void ocfs2_inode_init_once(void *data,
-				  kmem_cache_t *cachep,
+				  struct kmem_cache *cachep,
 				  unsigned long flags)
 {
 	struct ocfs2_inode_info *oi = data;
diff -puN fs/ocfs2/uptodate.c~slab-remove-kmem_cache_t fs/ocfs2/uptodate.c
--- a/fs/ocfs2/uptodate.c~slab-remove-kmem_cache_t
+++ a/fs/ocfs2/uptodate.c
@@ -69,7 +69,7 @@ struct ocfs2_meta_cache_item {
 	sector_t	c_block;
 };
 
-static kmem_cache_t *ocfs2_uptodate_cachep = NULL;
+static struct kmem_cache *ocfs2_uptodate_cachep = NULL;
 
 void ocfs2_metadata_cache_init(struct inode *inode)
 {
diff -puN fs/openpromfs/inode.c~slab-remove-kmem_cache_t fs/openpromfs/inode.c
--- a/fs/openpromfs/inode.c~slab-remove-kmem_cache_t
+++ a/fs/openpromfs/inode.c
@@ -330,7 +330,7 @@ out:
 	return 0;
 }
 
-static kmem_cache_t *op_inode_cachep;
+static struct kmem_cache *op_inode_cachep;
 
 static struct inode *openprom_alloc_inode(struct super_block *sb)
 {
@@ -415,7 +415,7 @@ static struct file_system_type openprom_
 	.kill_sb	= kill_anon_super,
 };
 
-static void op_inode_init_once(void *data, kmem_cache_t * cachep, unsigned long flags)
+static void op_inode_init_once(void *data, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct op_inode_info *oi = (struct op_inode_info *) data;
 
diff -puN fs/proc/inode.c~slab-remove-kmem_cache_t fs/proc/inode.c
--- a/fs/proc/inode.c~slab-remove-kmem_cache_t
+++ a/fs/proc/inode.c
@@ -81,7 +81,7 @@ static void proc_read_inode(struct inode
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 }
 
-static kmem_cache_t * proc_inode_cachep;
+static struct kmem_cache * proc_inode_cachep;
 
 static struct inode *proc_alloc_inode(struct super_block *sb)
 {
@@ -105,7 +105,7 @@ static void proc_destroy_inode(struct in
 	kmem_cache_free(proc_inode_cachep, PROC_I(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct proc_inode *ei = (struct proc_inode *) foo;
 
diff -puN fs/qnx4/inode.c~slab-remove-kmem_cache_t fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~slab-remove-kmem_cache_t
+++ a/fs/qnx4/inode.c
@@ -515,7 +515,7 @@ static void qnx4_read_inode(struct inode
 	brelse(bh);
 }
 
-static kmem_cache_t *qnx4_inode_cachep;
+static struct kmem_cache *qnx4_inode_cachep;
 
 static struct inode *qnx4_alloc_inode(struct super_block *sb)
 {
@@ -531,7 +531,7 @@ static void qnx4_destroy_inode(struct in
 	kmem_cache_free(qnx4_inode_cachep, qnx4_i(inode));
 }
 
-static void init_once(void *foo, kmem_cache_t * cachep,
+static void init_once(void *foo, struct kmem_cache * cachep,
 		      unsigned long flags)
 {
 	struct qnx4_inode_info *ei = (struct qnx4_inode_info *) foo;
diff -puN fs/reiserfs/super.c~slab-remove-kmem_cache_t fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~slab-remove-kmem_cache_t
+++ a/fs/reiserfs/super.c
@@ -490,7 +490,7 @@ static void reiserfs_put_super(struct su
 	return;
 }
 
-static kmem_cache_t *reiserfs_inode_cachep;
+static struct kmem_cache *reiserfs_inode_cachep;
 
 static struct inode *reiserfs_alloc_inode(struct super_block *sb)
 {
@@ -507,7 +507,7 @@ static void reiserfs_destroy_inode(struc
 	kmem_cache_free(reiserfs_inode_cachep, REISERFS_I(inode));
 }
 
-static void init_once(void *foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void *foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct reiserfs_inode_info *ei = (struct reiserfs_inode_info *)foo;
 
diff -puN fs/romfs/inode.c~slab-remove-kmem_cache_t fs/romfs/inode.c
--- a/fs/romfs/inode.c~slab-remove-kmem_cache_t
+++ a/fs/romfs/inode.c
@@ -550,7 +550,7 @@ romfs_read_inode(struct inode *i)
 	}
 }
 
-static kmem_cache_t * romfs_inode_cachep;
+static struct kmem_cache * romfs_inode_cachep;
 
 static struct inode *romfs_alloc_inode(struct super_block *sb)
 {
@@ -566,7 +566,7 @@ static void romfs_destroy_inode(struct i
 	kmem_cache_free(romfs_inode_cachep, ROMFS_I(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct romfs_inode_info *ei = (struct romfs_inode_info *) foo;
 
diff -puN fs/smbfs/inode.c~slab-remove-kmem_cache_t fs/smbfs/inode.c
--- a/fs/smbfs/inode.c~slab-remove-kmem_cache_t
+++ a/fs/smbfs/inode.c
@@ -50,7 +50,7 @@ static void smb_put_super(struct super_b
 static int  smb_statfs(struct dentry *, struct kstatfs *);
 static int  smb_show_options(struct seq_file *, struct vfsmount *);
 
-static kmem_cache_t *smb_inode_cachep;
+static struct kmem_cache *smb_inode_cachep;
 
 static struct inode *smb_alloc_inode(struct super_block *sb)
 {
@@ -66,7 +66,7 @@ static void smb_destroy_inode(struct ino
 	kmem_cache_free(smb_inode_cachep, SMB_I(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct smb_inode_info *ei = (struct smb_inode_info *) foo;
 	unsigned long flagmask = SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR;
diff -puN fs/smbfs/request.c~slab-remove-kmem_cache_t fs/smbfs/request.c
--- a/fs/smbfs/request.c~slab-remove-kmem_cache_t
+++ a/fs/smbfs/request.c
@@ -25,7 +25,7 @@
 #define ROUND_UP(x) (((x)+3) & ~3)
 
 /* cache for request structures */
-static kmem_cache_t *req_cachep;
+static struct kmem_cache *req_cachep;
 
 static int smb_request_send_req(struct smb_request *req);
 
diff -puN fs/sysfs/mount.c~slab-remove-kmem_cache_t fs/sysfs/mount.c
--- a/fs/sysfs/mount.c~slab-remove-kmem_cache_t
+++ a/fs/sysfs/mount.c
@@ -16,7 +16,7 @@
 
 struct vfsmount *sysfs_mount;
 struct super_block * sysfs_sb = NULL;
-kmem_cache_t *sysfs_dir_cachep;
+struct kmem_cache *sysfs_dir_cachep;
 
 static struct super_operations sysfs_ops = {
 	.statfs		= simple_statfs,
diff -puN fs/sysfs/sysfs.h~slab-remove-kmem_cache_t fs/sysfs/sysfs.h
--- a/fs/sysfs/sysfs.h~slab-remove-kmem_cache_t
+++ a/fs/sysfs/sysfs.h
@@ -1,6 +1,6 @@
 
 extern struct vfsmount * sysfs_mount;
-extern kmem_cache_t *sysfs_dir_cachep;
+extern struct kmem_cache *sysfs_dir_cachep;
 
 extern struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent *);
 extern int sysfs_create(struct dentry *, int mode, int (*init)(struct inode *));
diff -puN fs/sysv/inode.c~slab-remove-kmem_cache_t fs/sysv/inode.c
--- a/fs/sysv/inode.c~slab-remove-kmem_cache_t
+++ a/fs/sysv/inode.c
@@ -301,7 +301,7 @@ static void sysv_delete_inode(struct ino
 	unlock_kernel();
 }
 
-static kmem_cache_t *sysv_inode_cachep;
+static struct kmem_cache *sysv_inode_cachep;
 
 static struct inode *sysv_alloc_inode(struct super_block *sb)
 {
@@ -318,7 +318,7 @@ static void sysv_destroy_inode(struct in
 	kmem_cache_free(sysv_inode_cachep, SYSV_I(inode));
 }
 
-static void init_once(void *p, kmem_cache_t *cachep, unsigned long flags)
+static void init_once(void *p, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct sysv_inode_info *si = (struct sysv_inode_info *)p;
 
diff -puN fs/udf/super.c~slab-remove-kmem_cache_t fs/udf/super.c
--- a/fs/udf/super.c~slab-remove-kmem_cache_t
+++ a/fs/udf/super.c
@@ -107,7 +107,7 @@ static struct file_system_type udf_fstyp
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-static kmem_cache_t * udf_inode_cachep;
+static struct kmem_cache * udf_inode_cachep;
 
 static struct inode *udf_alloc_inode(struct super_block *sb)
 {
@@ -130,7 +130,7 @@ static void udf_destroy_inode(struct ino
 	kmem_cache_free(udf_inode_cachep, UDF_I(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct udf_inode_info *ei = (struct udf_inode_info *) foo;
 
diff -puN fs/ufs/super.c~slab-remove-kmem_cache_t fs/ufs/super.c
--- a/fs/ufs/super.c~slab-remove-kmem_cache_t
+++ a/fs/ufs/super.c
@@ -1204,7 +1204,7 @@ static int ufs_statfs(struct dentry *den
 	return 0;
 }
 
-static kmem_cache_t * ufs_inode_cachep;
+static struct kmem_cache * ufs_inode_cachep;
 
 static struct inode *ufs_alloc_inode(struct super_block *sb)
 {
@@ -1221,7 +1221,7 @@ static void ufs_destroy_inode(struct ino
 	kmem_cache_free(ufs_inode_cachep, UFS_I(inode));
 }
 
-static void init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct ufs_inode_info *ei = (struct ufs_inode_info *) foo;
 
diff -puN include/acpi/platform/aclinux.h~slab-remove-kmem_cache_t include/acpi/platform/aclinux.h
--- a/include/acpi/platform/aclinux.h~slab-remove-kmem_cache_t
+++ a/include/acpi/platform/aclinux.h
@@ -64,7 +64,7 @@
 /* Host-dependent types and defines */
 
 #define ACPI_MACHINE_WIDTH          BITS_PER_LONG
-#define acpi_cache_t                        kmem_cache_t
+#define acpi_cache_t                        struct kmem_cache
 #define acpi_spinlock                   spinlock_t *
 #define ACPI_EXPORT_SYMBOL(symbol)  EXPORT_SYMBOL(symbol);
 #define strtoul                     simple_strtoul
diff -puN include/asm-arm26/pgalloc.h~slab-remove-kmem_cache_t include/asm-arm26/pgalloc.h
--- a/include/asm-arm26/pgalloc.h~slab-remove-kmem_cache_t
+++ a/include/asm-arm26/pgalloc.h
@@ -15,7 +15,7 @@
 #include <asm/tlbflush.h>
 #include <linux/slab.h>
 
-extern kmem_cache_t *pte_cache;
+extern struct kmem_cache *pte_cache;
 
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addr){
 	return kmem_cache_alloc(pte_cache, GFP_KERNEL);
diff -puN include/asm-i386/pgtable.h~slab-remove-kmem_cache_t include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~slab-remove-kmem_cache_t
+++ a/include/asm-i386/pgtable.h
@@ -34,14 +34,14 @@ struct vm_area_struct;
 #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
 extern unsigned long empty_zero_page[1024];
 extern pgd_t swapper_pg_dir[1024];
-extern kmem_cache_t *pgd_cache;
-extern kmem_cache_t *pmd_cache;
+extern struct kmem_cache *pgd_cache;
+extern struct kmem_cache *pmd_cache;
 extern spinlock_t pgd_lock;
 extern struct page *pgd_list;
 
-void pmd_ctor(void *, kmem_cache_t *, unsigned long);
-void pgd_ctor(void *, kmem_cache_t *, unsigned long);
-void pgd_dtor(void *, kmem_cache_t *, unsigned long);
+void pmd_ctor(void *, struct kmem_cache *, unsigned long);
+void pgd_ctor(void *, struct kmem_cache *, unsigned long);
+void pgd_dtor(void *, struct kmem_cache *, unsigned long);
 void pgtable_cache_init(void);
 void paging_init(void);
 
diff -puN include/asm-powerpc/pgalloc.h~slab-remove-kmem_cache_t include/asm-powerpc/pgalloc.h
--- a/include/asm-powerpc/pgalloc.h~slab-remove-kmem_cache_t
+++ a/include/asm-powerpc/pgalloc.h
@@ -11,7 +11,7 @@
 #include <linux/cpumask.h>
 #include <linux/percpu.h>
 
-extern kmem_cache_t *pgtable_cache[];
+extern struct kmem_cache *pgtable_cache[];
 
 #ifdef CONFIG_PPC_64K_PAGES
 #define PTE_CACHE_NUM	0
diff -puN include/asm-sparc64/pgalloc.h~slab-remove-kmem_cache_t include/asm-sparc64/pgalloc.h
--- a/include/asm-sparc64/pgalloc.h~slab-remove-kmem_cache_t
+++ a/include/asm-sparc64/pgalloc.h
@@ -13,7 +13,7 @@
 #include <asm/page.h>
 
 /* Page table allocation/freeing. */
-extern kmem_cache_t *pgtable_cache;
+extern struct kmem_cache *pgtable_cache;
 
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
diff -puN include/linux/delayacct.h~slab-remove-kmem_cache_t include/linux/delayacct.h
--- a/include/linux/delayacct.h~slab-remove-kmem_cache_t
+++ a/include/linux/delayacct.h
@@ -30,7 +30,7 @@
 #ifdef CONFIG_TASK_DELAY_ACCT
 
 extern int delayacct_on;	/* Delay accounting turned on/off */
-extern kmem_cache_t *delayacct_cache;
+extern struct kmem_cache *delayacct_cache;
 extern void delayacct_init(void);
 extern void __delayacct_tsk_init(struct task_struct *);
 extern void __delayacct_tsk_exit(struct task_struct *);
diff -puN include/linux/i2o.h~slab-remove-kmem_cache_t include/linux/i2o.h
--- a/include/linux/i2o.h~slab-remove-kmem_cache_t
+++ a/include/linux/i2o.h
@@ -490,7 +490,7 @@ struct i2o_dma {
  */
 struct i2o_pool {
 	char *name;
-	kmem_cache_t *slab;
+	struct kmem_cache *slab;
 	mempool_t *mempool;
 };
 
diff -puN include/linux/jbd.h~slab-remove-kmem_cache_t include/linux/jbd.h
--- a/include/linux/jbd.h~slab-remove-kmem_cache_t
+++ a/include/linux/jbd.h
@@ -949,7 +949,7 @@ void journal_put_journal_head(struct jou
 /*
  * handle management
  */
-extern kmem_cache_t *jbd_handle_cache;
+extern struct kmem_cache *jbd_handle_cache;
 
 static inline handle_t *jbd_alloc_handle(gfp_t gfp_flags)
 {
diff -puN include/linux/jbd2.h~slab-remove-kmem_cache_t include/linux/jbd2.h
--- a/include/linux/jbd2.h~slab-remove-kmem_cache_t
+++ a/include/linux/jbd2.h
@@ -958,7 +958,7 @@ void jbd2_journal_put_journal_head(struc
 /*
  * handle management
  */
-extern kmem_cache_t *jbd2_handle_cache;
+extern struct kmem_cache *jbd2_handle_cache;
 
 static inline handle_t *jbd_alloc_handle(gfp_t gfp_flags)
 {
diff -puN include/linux/raid/raid5.h~slab-remove-kmem_cache_t include/linux/raid/raid5.h
--- a/include/linux/raid/raid5.h~slab-remove-kmem_cache_t
+++ a/include/linux/raid/raid5.h
@@ -235,7 +235,7 @@ struct raid5_private_data {
 	 */
 	int			active_name;
 	char			cache_name[2][20];
-	kmem_cache_t		*slab_cache; /* for allocating stripes */
+	struct kmem_cache		*slab_cache; /* for allocating stripes */
 
 	int			seq_flush, seq_write;
 	int			quiesce;
diff -puN include/linux/rmap.h~slab-remove-kmem_cache_t include/linux/rmap.h
--- a/include/linux/rmap.h~slab-remove-kmem_cache_t
+++ a/include/linux/rmap.h
@@ -30,7 +30,7 @@ struct anon_vma {
 
 #ifdef CONFIG_MMU
 
-extern kmem_cache_t *anon_vma_cachep;
+extern struct kmem_cache *anon_vma_cachep;
 
 static inline struct anon_vma *anon_vma_alloc(void)
 {
diff -puN include/linux/skbuff.h~slab-remove-kmem_cache_t include/linux/skbuff.h
--- a/include/linux/skbuff.h~slab-remove-kmem_cache_t
+++ a/include/linux/skbuff.h
@@ -345,7 +345,7 @@ static inline struct sk_buff *alloc_skb_
 	return __alloc_skb(size, priority, 1, -1);
 }
 
-extern struct sk_buff *alloc_skb_from_cache(kmem_cache_t *cp,
+extern struct sk_buff *alloc_skb_from_cache(struct kmem_cache *cp,
 					    unsigned int size,
 					    gfp_t priority);
 extern void	       kfree_skbmem(struct sk_buff *skb);
diff -puN include/linux/taskstats_kern.h~slab-remove-kmem_cache_t include/linux/taskstats_kern.h
--- a/include/linux/taskstats_kern.h~slab-remove-kmem_cache_t
+++ a/include/linux/taskstats_kern.h
@@ -12,7 +12,7 @@
 #include <net/genetlink.h>
 
 #ifdef CONFIG_TASKSTATS
-extern kmem_cache_t *taskstats_cache;
+extern struct kmem_cache *taskstats_cache;
 extern struct mutex taskstats_exit_mutex;
 
 static inline void taskstats_exit_free(struct taskstats *tidstats)
diff -puN include/net/dst.h~slab-remove-kmem_cache_t include/net/dst.h
--- a/include/net/dst.h~slab-remove-kmem_cache_t
+++ a/include/net/dst.h
@@ -98,7 +98,7 @@ struct dst_ops
 	int			entry_size;
 
 	atomic_t		entries;
-	kmem_cache_t 		*kmem_cachep;
+	struct kmem_cache 		*kmem_cachep;
 };
 
 #ifdef __KERNEL__
diff -puN include/net/inet_hashtables.h~slab-remove-kmem_cache_t include/net/inet_hashtables.h
--- a/include/net/inet_hashtables.h~slab-remove-kmem_cache_t
+++ a/include/net/inet_hashtables.h
@@ -125,7 +125,7 @@ struct inet_hashinfo {
 	rwlock_t			lhash_lock ____cacheline_aligned;
 	atomic_t			lhash_users;
 	wait_queue_head_t		lhash_wait;
-	kmem_cache_t			*bind_bucket_cachep;
+	struct kmem_cache			*bind_bucket_cachep;
 };
 
 static inline struct inet_ehash_bucket *inet_ehash_bucket(
@@ -136,10 +136,10 @@ static inline struct inet_ehash_bucket *
 }
 
 extern struct inet_bind_bucket *
-		    inet_bind_bucket_create(kmem_cache_t *cachep,
+		    inet_bind_bucket_create(struct kmem_cache *cachep,
 					    struct inet_bind_hashbucket *head,
 					    const unsigned short snum);
-extern void inet_bind_bucket_destroy(kmem_cache_t *cachep,
+extern void inet_bind_bucket_destroy(struct kmem_cache *cachep,
 				     struct inet_bind_bucket *tb);
 
 static inline int inet_bhashfn(const __u16 lport, const int bhash_size)
diff -puN include/net/neighbour.h~slab-remove-kmem_cache_t include/net/neighbour.h
--- a/include/net/neighbour.h~slab-remove-kmem_cache_t
+++ a/include/net/neighbour.h
@@ -160,7 +160,7 @@ struct neigh_table
 	atomic_t		entries;
 	rwlock_t		lock;
 	unsigned long		last_rand;
-	kmem_cache_t		*kmem_cachep;
+	struct kmem_cache		*kmem_cachep;
 	struct neigh_statistics	*stats;
 	struct neighbour	**hash_buckets;
 	unsigned int		hash_mask;
diff -puN include/net/netfilter/nf_conntrack_expect.h~slab-remove-kmem_cache_t include/net/netfilter/nf_conntrack_expect.h
--- a/include/net/netfilter/nf_conntrack_expect.h~slab-remove-kmem_cache_t
+++ a/include/net/netfilter/nf_conntrack_expect.h
@@ -7,7 +7,7 @@
 #include <net/netfilter/nf_conntrack.h>
 
 extern struct list_head nf_conntrack_expect_list;
-extern kmem_cache_t *nf_conntrack_expect_cachep;
+extern struct kmem_cache *nf_conntrack_expect_cachep;
 extern struct file_operations exp_file_ops;
 
 struct nf_conntrack_expect
diff -puN include/net/request_sock.h~slab-remove-kmem_cache_t include/net/request_sock.h
--- a/include/net/request_sock.h~slab-remove-kmem_cache_t
+++ a/include/net/request_sock.h
@@ -29,7 +29,7 @@ struct proto;
 struct request_sock_ops {
 	int		family;
 	int		obj_size;
-	kmem_cache_t	*slab;
+	struct kmem_cache	*slab;
 	int		(*rtx_syn_ack)(struct sock *sk,
 				       struct request_sock *req,
 				       struct dst_entry *dst);
diff -puN include/net/sock.h~slab-remove-kmem_cache_t include/net/sock.h
--- a/include/net/sock.h~slab-remove-kmem_cache_t
+++ a/include/net/sock.h
@@ -571,7 +571,7 @@ struct proto {
 	int			*sysctl_rmem;
 	int			max_header;
 
-	kmem_cache_t		*slab;
+	struct kmem_cache		*slab;
 	unsigned int		obj_size;
 
 	atomic_t		*orphan_count;
diff -puN include/net/timewait_sock.h~slab-remove-kmem_cache_t include/net/timewait_sock.h
--- a/include/net/timewait_sock.h~slab-remove-kmem_cache_t
+++ a/include/net/timewait_sock.h
@@ -15,7 +15,7 @@
 #include <net/sock.h>
 
 struct timewait_sock_ops {
-	kmem_cache_t	*twsk_slab;
+	struct kmem_cache	*twsk_slab;
 	unsigned int	twsk_obj_size;
 	int		(*twsk_unique)(struct sock *sk,
 				       struct sock *sktw, void *twp);
diff -puN include/scsi/libsas.h~slab-remove-kmem_cache_t include/scsi/libsas.h
--- a/include/scsi/libsas.h~slab-remove-kmem_cache_t
+++ a/include/scsi/libsas.h
@@ -557,7 +557,7 @@ struct sas_task {
 
 static inline struct sas_task *sas_alloc_task(gfp_t flags)
 {
-	extern kmem_cache_t *sas_task_cache;
+	extern struct kmem_cache *sas_task_cache;
 	struct sas_task *task = kmem_cache_alloc(sas_task_cache, flags);
 
 	if (task) {
@@ -575,7 +575,7 @@ static inline struct sas_task *sas_alloc
 static inline void sas_free_task(struct sas_task *task)
 {
 	if (task) {
-		extern kmem_cache_t *sas_task_cache;
+		extern struct kmem_cache *sas_task_cache;
 		BUG_ON(!list_empty(&task->list));
 		kmem_cache_free(sas_task_cache, task);
 	}
diff -puN ipc/mqueue.c~slab-remove-kmem_cache_t ipc/mqueue.c
--- a/ipc/mqueue.c~slab-remove-kmem_cache_t
+++ a/ipc/mqueue.c
@@ -90,7 +90,7 @@ static struct super_operations mqueue_su
 static void remove_notification(struct mqueue_inode_info *info);
 
 static spinlock_t mq_lock;
-static kmem_cache_t *mqueue_inode_cachep;
+static struct kmem_cache *mqueue_inode_cachep;
 static struct vfsmount *mqueue_mnt;
 
 static unsigned int queues_count;
@@ -211,7 +211,7 @@ static int mqueue_get_sb(struct file_sys
 	return get_sb_single(fs_type, flags, data, mqueue_fill_super, mnt);
 }
 
-static void init_once(void *foo, kmem_cache_t * cachep, unsigned long flags)
+static void init_once(void *foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct mqueue_inode_info *p = (struct mqueue_inode_info *) foo;
 
diff -puN kernel/delayacct.c~slab-remove-kmem_cache_t kernel/delayacct.c
--- a/kernel/delayacct.c~slab-remove-kmem_cache_t
+++ a/kernel/delayacct.c
@@ -20,7 +20,7 @@
 #include <linux/delayacct.h>
 
 int delayacct_on __read_mostly = 1;	/* Delay accounting turned on/off */
-kmem_cache_t *delayacct_cache;
+struct kmem_cache *delayacct_cache;
 
 static int __init delayacct_setup_disable(char *str)
 {
diff -puN kernel/fork.c~slab-remove-kmem_cache_t kernel/fork.c
--- a/kernel/fork.c~slab-remove-kmem_cache_t
+++ a/kernel/fork.c
@@ -82,26 +82,26 @@ int nr_processes(void)
 #ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
 # define alloc_task_struct()	kmem_cache_alloc(task_struct_cachep, GFP_KERNEL)
 # define free_task_struct(tsk)	kmem_cache_free(task_struct_cachep, (tsk))
-static kmem_cache_t *task_struct_cachep;
+static struct kmem_cache *task_struct_cachep;
 #endif
 
 /* SLAB cache for signal_struct structures (tsk->signal) */
-static kmem_cache_t *signal_cachep;
+static struct kmem_cache *signal_cachep;
 
 /* SLAB cache for sighand_struct structures (tsk->sighand) */
-kmem_cache_t *sighand_cachep;
+struct kmem_cache *sighand_cachep;
 
 /* SLAB cache for files_struct structures (tsk->files) */
-kmem_cache_t *files_cachep;
+struct kmem_cache *files_cachep;
 
 /* SLAB cache for fs_struct structures (tsk->fs) */
-kmem_cache_t *fs_cachep;
+struct kmem_cache *fs_cachep;
 
 /* SLAB cache for vm_area_struct structures */
-kmem_cache_t *vm_area_cachep;
+struct kmem_cache *vm_area_cachep;
 
 /* SLAB cache for mm_struct structures (tsk->mm) */
-static kmem_cache_t *mm_cachep;
+static struct kmem_cache *mm_cachep;
 
 void free_task(struct task_struct *tsk)
 {
@@ -1421,7 +1421,7 @@ long do_fork(unsigned long clone_flags,
 #define ARCH_MIN_MMSTRUCT_ALIGN 0
 #endif
 
-static void sighand_ctor(void *data, kmem_cache_t *cachep, unsigned long flags)
+static void sighand_ctor(void *data, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct sighand_struct *sighand = data;
 
diff -puN kernel/pid.c~slab-remove-kmem_cache_t kernel/pid.c
--- a/kernel/pid.c~slab-remove-kmem_cache_t
+++ a/kernel/pid.c
@@ -31,7 +31,7 @@
 #define pid_hashfn(nr) hash_long((unsigned long)nr, pidhash_shift)
 static struct hlist_head *pid_hash;
 static int pidhash_shift;
-static kmem_cache_t *pid_cachep;
+static struct kmem_cache *pid_cachep;
 
 int pid_max = PID_MAX_DEFAULT;
 
diff -puN kernel/posix-timers.c~slab-remove-kmem_cache_t kernel/posix-timers.c
--- a/kernel/posix-timers.c~slab-remove-kmem_cache_t
+++ a/kernel/posix-timers.c
@@ -70,7 +70,7 @@
 /*
  * Lets keep our timers in a slab cache :-)
  */
-static kmem_cache_t *posix_timers_cache;
+static struct kmem_cache *posix_timers_cache;
 static struct idr posix_timers_id;
 static DEFINE_SPINLOCK(idr_lock);
 
diff -puN kernel/signal.c~slab-remove-kmem_cache_t kernel/signal.c
--- a/kernel/signal.c~slab-remove-kmem_cache_t
+++ a/kernel/signal.c
@@ -33,7 +33,7 @@
  * SLAB caches for signal bits.
  */
 
-static kmem_cache_t *sigqueue_cachep;
+static struct kmem_cache *sigqueue_cachep;
 
 /*
  * In POSIX a signal is sent either to a specific thread (Linux task)
diff -puN kernel/taskstats.c~slab-remove-kmem_cache_t kernel/taskstats.c
--- a/kernel/taskstats.c~slab-remove-kmem_cache_t
+++ a/kernel/taskstats.c
@@ -34,7 +34,7 @@
 
 static DEFINE_PER_CPU(__u32, taskstats_seqnum) = { 0 };
 static int family_registered;
-kmem_cache_t *taskstats_cache;
+struct kmem_cache *taskstats_cache;
 
 static struct genl_family family = {
 	.id		= GENL_ID_GENERATE,
diff -puN kernel/user.c~slab-remove-kmem_cache_t kernel/user.c
--- a/kernel/user.c~slab-remove-kmem_cache_t
+++ a/kernel/user.c
@@ -26,7 +26,7 @@
 #define __uidhashfn(uid)	(((uid >> UIDHASH_BITS) + uid) & UIDHASH_MASK)
 #define uidhashentry(uid)	(uidhash_table + __uidhashfn((uid)))
 
-static kmem_cache_t *uid_cachep;
+static struct kmem_cache *uid_cachep;
 static struct list_head uidhash_table[UIDHASH_SZ];
 
 /*
diff -puN lib/idr.c~slab-remove-kmem_cache_t lib/idr.c
--- a/lib/idr.c~slab-remove-kmem_cache_t
+++ a/lib/idr.c
@@ -33,7 +33,7 @@
 #include <linux/string.h>
 #include <linux/idr.h>
 
-static kmem_cache_t *idr_layer_cache;
+static struct kmem_cache *idr_layer_cache;
 
 static struct idr_layer *alloc_layer(struct idr *idp)
 {
@@ -445,7 +445,7 @@ void *idr_replace(struct idr *idp, void 
 }
 EXPORT_SYMBOL(idr_replace);
 
-static void idr_cache_ctor(void * idr_layer, kmem_cache_t *idr_layer_cache,
+static void idr_cache_ctor(void * idr_layer, struct kmem_cache *idr_layer_cache,
 		unsigned long flags)
 {
 	memset(idr_layer, 0, sizeof(struct idr_layer));
diff -puN lib/radix-tree.c~slab-remove-kmem_cache_t lib/radix-tree.c
--- a/lib/radix-tree.c~slab-remove-kmem_cache_t
+++ a/lib/radix-tree.c
@@ -63,7 +63,7 @@ static unsigned long height_to_maxindex[
 /*
  * Radix tree node cache.
  */
-static kmem_cache_t *radix_tree_node_cachep;
+static struct kmem_cache *radix_tree_node_cachep;
 
 /*
  * Per-cpu pool of preloaded nodes
@@ -846,7 +846,7 @@ int radix_tree_tagged(struct radix_tree_
 EXPORT_SYMBOL(radix_tree_tagged);
 
 static void
-radix_tree_node_ctor(void *node, kmem_cache_t *cachep, unsigned long flags)
+radix_tree_node_ctor(void *node, struct kmem_cache *cachep, unsigned long flags)
 {
 	memset(node, 0, sizeof(struct radix_tree_node));
 }
diff -puN net/bridge/br_fdb.c~slab-remove-kmem_cache_t net/bridge/br_fdb.c
--- a/net/bridge/br_fdb.c~slab-remove-kmem_cache_t
+++ a/net/bridge/br_fdb.c
@@ -23,7 +23,7 @@
 #include <asm/atomic.h>
 #include "br_private.h"
 
-static kmem_cache_t *br_fdb_cache __read_mostly;
+static struct kmem_cache *br_fdb_cache __read_mostly;
 static int fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
 		      const unsigned char *addr);
 
diff -puN net/core/flow.c~slab-remove-kmem_cache_t net/core/flow.c
--- a/net/core/flow.c~slab-remove-kmem_cache_t
+++ a/net/core/flow.c
@@ -44,7 +44,7 @@ static DEFINE_PER_CPU(struct flow_cache_
 
 #define flow_table(cpu) (per_cpu(flow_tables, cpu))
 
-static kmem_cache_t *flow_cachep __read_mostly;
+static struct kmem_cache *flow_cachep __read_mostly;
 
 static int flow_lwm, flow_hwm;
 
diff -puN net/core/skbuff.c~slab-remove-kmem_cache_t net/core/skbuff.c
--- a/net/core/skbuff.c~slab-remove-kmem_cache_t
+++ a/net/core/skbuff.c
@@ -68,8 +68,8 @@
 
 #include "kmap_skb.h"
 
-static kmem_cache_t *skbuff_head_cache __read_mostly;
-static kmem_cache_t *skbuff_fclone_cache __read_mostly;
+static struct kmem_cache *skbuff_head_cache __read_mostly;
+static struct kmem_cache *skbuff_fclone_cache __read_mostly;
 
 /*
  *	Keep out-of-line to prevent kernel bloat.
@@ -144,7 +144,7 @@ EXPORT_SYMBOL(skb_truesize_bug);
 struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 			    int fclone, int node)
 {
-	kmem_cache_t *cache;
+	struct kmem_cache *cache;
 	struct skb_shared_info *shinfo;
 	struct sk_buff *skb;
 	u8 *data;
@@ -211,7 +211,7 @@ nodata:
  *	Buffers may only be allocated from interrupts using a @gfp_mask of
  *	%GFP_ATOMIC.
  */
-struct sk_buff *alloc_skb_from_cache(kmem_cache_t *cp,
+struct sk_buff *alloc_skb_from_cache(struct kmem_cache *cp,
 				     unsigned int size,
 				     gfp_t gfp_mask)
 {
diff -puN net/core/sock.c~slab-remove-kmem_cache_t net/core/sock.c
--- a/net/core/sock.c~slab-remove-kmem_cache_t
+++ a/net/core/sock.c
@@ -841,7 +841,7 @@ struct sock *sk_alloc(int family, gfp_t 
 		      struct proto *prot, int zero_it)
 {
 	struct sock *sk = NULL;
-	kmem_cache_t *slab = prot->slab;
+	struct kmem_cache *slab = prot->slab;
 
 	if (slab != NULL)
 		sk = kmem_cache_alloc(slab, priority);
diff -puN net/dccp/ackvec.c~slab-remove-kmem_cache_t net/dccp/ackvec.c
--- a/net/dccp/ackvec.c~slab-remove-kmem_cache_t
+++ a/net/dccp/ackvec.c
@@ -21,8 +21,8 @@
 
 #include <net/sock.h>
 
-static kmem_cache_t *dccp_ackvec_slab;
-static kmem_cache_t *dccp_ackvec_record_slab;
+static struct kmem_cache *dccp_ackvec_slab;
+static struct kmem_cache *dccp_ackvec_record_slab;
 
 static struct dccp_ackvec_record *dccp_ackvec_record_new(void)
 {
diff -puN net/dccp/ccid.c~slab-remove-kmem_cache_t net/dccp/ccid.c
--- a/net/dccp/ccid.c~slab-remove-kmem_cache_t
+++ a/net/dccp/ccid.c
@@ -55,9 +55,9 @@ static inline void ccids_read_unlock(voi
 #define ccids_read_unlock() do { } while(0)
 #endif
 
-static kmem_cache_t *ccid_kmem_cache_create(int obj_size, const char *fmt,...)
+static struct kmem_cache *ccid_kmem_cache_create(int obj_size, const char *fmt,...)
 {
-	kmem_cache_t *slab;
+	struct kmem_cache *slab;
 	char slab_name_fmt[32], *slab_name;
 	va_list args;
 
@@ -75,7 +75,7 @@ static kmem_cache_t *ccid_kmem_cache_cre
 	return slab;
 }
 
-static void ccid_kmem_cache_destroy(kmem_cache_t *slab)
+static void ccid_kmem_cache_destroy(struct kmem_cache *slab)
 {
 	if (slab != NULL) {
 		const char *name = kmem_cache_name(slab);
diff -puN net/dccp/ccid.h~slab-remove-kmem_cache_t net/dccp/ccid.h
--- a/net/dccp/ccid.h~slab-remove-kmem_cache_t
+++ a/net/dccp/ccid.h
@@ -27,9 +27,9 @@ struct ccid_operations {
 	unsigned char	ccid_id;
 	const char	*ccid_name;
 	struct module	*ccid_owner;
-	kmem_cache_t	*ccid_hc_rx_slab;
+	struct kmem_cache	*ccid_hc_rx_slab;
 	__u32		ccid_hc_rx_obj_size;
-	kmem_cache_t	*ccid_hc_tx_slab;
+	struct kmem_cache	*ccid_hc_tx_slab;
 	__u32		ccid_hc_tx_obj_size;
 	int		(*ccid_hc_rx_init)(struct ccid *ccid, struct sock *sk);
 	int		(*ccid_hc_tx_init)(struct ccid *ccid, struct sock *sk);
diff -puN net/dccp/ccids/lib/loss_interval.h~slab-remove-kmem_cache_t net/dccp/ccids/lib/loss_interval.h
--- a/net/dccp/ccids/lib/loss_interval.h~slab-remove-kmem_cache_t
+++ a/net/dccp/ccids/lib/loss_interval.h
@@ -20,7 +20,7 @@
 #define DCCP_LI_HIST_IVAL_F_LENGTH  8
 
 struct dccp_li_hist {
-	kmem_cache_t *dccplih_slab;
+	struct kmem_cache *dccplih_slab;
 };
 
 extern struct dccp_li_hist *dccp_li_hist_new(const char *name);
diff -puN net/dccp/ccids/lib/packet_history.h~slab-remove-kmem_cache_t net/dccp/ccids/lib/packet_history.h
--- a/net/dccp/ccids/lib/packet_history.h~slab-remove-kmem_cache_t
+++ a/net/dccp/ccids/lib/packet_history.h
@@ -68,14 +68,14 @@ struct dccp_rx_hist_entry {
 };
 
 struct dccp_tx_hist {
-	kmem_cache_t *dccptxh_slab;
+	struct kmem_cache *dccptxh_slab;
 };
 
 extern struct dccp_tx_hist *dccp_tx_hist_new(const char *name);
 extern void dccp_tx_hist_delete(struct dccp_tx_hist *hist);
 
 struct dccp_rx_hist {
-	kmem_cache_t *dccprxh_slab;
+	struct kmem_cache *dccprxh_slab;
 };
 
 extern struct dccp_rx_hist *dccp_rx_hist_new(const char *name);
diff -puN net/decnet/dn_table.c~slab-remove-kmem_cache_t net/decnet/dn_table.c
--- a/net/decnet/dn_table.c~slab-remove-kmem_cache_t
+++ a/net/decnet/dn_table.c
@@ -79,7 +79,7 @@ for( ; ((f) = *(fp)) != NULL && dn_key_e
 static struct hlist_head dn_fib_table_hash[DN_FIB_TABLE_HASHSZ];
 static DEFINE_RWLOCK(dn_fib_tables_lock);
 
-static kmem_cache_t *dn_hash_kmem __read_mostly;
+static struct kmem_cache *dn_hash_kmem __read_mostly;
 static int dn_fib_hash_zombies;
 
 static inline dn_fib_idx_t dn_hash(dn_fib_key_t key, struct dn_zone *dz)
diff -puN net/ipv4/fib_hash.c~slab-remove-kmem_cache_t net/ipv4/fib_hash.c
--- a/net/ipv4/fib_hash.c~slab-remove-kmem_cache_t
+++ a/net/ipv4/fib_hash.c
@@ -45,8 +45,8 @@
 
 #include "fib_lookup.h"
 
-static kmem_cache_t *fn_hash_kmem __read_mostly;
-static kmem_cache_t *fn_alias_kmem __read_mostly;
+static struct kmem_cache *fn_hash_kmem __read_mostly;
+static struct kmem_cache *fn_alias_kmem __read_mostly;
 
 struct fib_node {
 	struct hlist_node	fn_hash;
diff -puN net/ipv4/fib_trie.c~slab-remove-kmem_cache_t net/ipv4/fib_trie.c
--- a/net/ipv4/fib_trie.c~slab-remove-kmem_cache_t
+++ a/net/ipv4/fib_trie.c
@@ -172,7 +172,7 @@ static struct tnode *inflate(struct trie
 static struct tnode *halve(struct trie *t, struct tnode *tn);
 static void tnode_free(struct tnode *tn);
 
-static kmem_cache_t *fn_alias_kmem __read_mostly;
+static struct kmem_cache *fn_alias_kmem __read_mostly;
 static struct trie *trie_local = NULL, *trie_main = NULL;
 
 
diff -puN net/ipv4/inet_hashtables.c~slab-remove-kmem_cache_t net/ipv4/inet_hashtables.c
--- a/net/ipv4/inet_hashtables.c~slab-remove-kmem_cache_t
+++ a/net/ipv4/inet_hashtables.c
@@ -27,7 +27,7 @@
  * Allocate and initialize a new local port bind bucket.
  * The bindhash mutex for snum's hash chain must be held here.
  */
-struct inet_bind_bucket *inet_bind_bucket_create(kmem_cache_t *cachep,
+struct inet_bind_bucket *inet_bind_bucket_create(struct kmem_cache *cachep,
 						 struct inet_bind_hashbucket *head,
 						 const unsigned short snum)
 {
@@ -45,7 +45,7 @@ struct inet_bind_bucket *inet_bind_bucke
 /*
  * Caller must hold hashbucket lock for this tb with local BH disabled
  */
-void inet_bind_bucket_destroy(kmem_cache_t *cachep, struct inet_bind_bucket *tb)
+void inet_bind_bucket_destroy(struct kmem_cache *cachep, struct inet_bind_bucket *tb)
 {
 	if (hlist_empty(&tb->owners)) {
 		__hlist_del(&tb->node);
diff -puN net/ipv4/inetpeer.c~slab-remove-kmem_cache_t net/ipv4/inetpeer.c
--- a/net/ipv4/inetpeer.c~slab-remove-kmem_cache_t
+++ a/net/ipv4/inetpeer.c
@@ -73,7 +73,7 @@
 /* Exported for inet_getid inline function.  */
 DEFINE_SPINLOCK(inet_peer_idlock);
 
-static kmem_cache_t *peer_cachep __read_mostly;
+static struct kmem_cache *peer_cachep __read_mostly;
 
 #define node_height(x) x->avl_height
 static struct inet_peer peer_fake_node = {
diff -puN net/ipv4/ipmr.c~slab-remove-kmem_cache_t net/ipv4/ipmr.c
--- a/net/ipv4/ipmr.c~slab-remove-kmem_cache_t
+++ a/net/ipv4/ipmr.c
@@ -105,7 +105,7 @@ static DEFINE_SPINLOCK(mfc_unres_lock);
    In this case data path is free of exclusive locks at all.
  */
 
-static kmem_cache_t *mrt_cachep __read_mostly;
+static struct kmem_cache *mrt_cachep __read_mostly;
 
 static int ip_mr_forward(struct sk_buff *skb, struct mfc_cache *cache, int local);
 static int ipmr_cache_report(struct sk_buff *pkt, vifi_t vifi, int assert);
diff -puN net/ipv4/ipvs/ip_vs_conn.c~slab-remove-kmem_cache_t net/ipv4/ipvs/ip_vs_conn.c
--- a/net/ipv4/ipvs/ip_vs_conn.c~slab-remove-kmem_cache_t
+++ a/net/ipv4/ipvs/ip_vs_conn.c
@@ -44,7 +44,7 @@
 static struct list_head *ip_vs_conn_tab;
 
 /*  SLAB cache for IPVS connections */
-static kmem_cache_t *ip_vs_conn_cachep __read_mostly;
+static struct kmem_cache *ip_vs_conn_cachep __read_mostly;
 
 /*  counter for current IPVS connections */
 static atomic_t ip_vs_conn_count = ATOMIC_INIT(0);
diff -puN net/ipv4/netfilter/ip_conntrack_core.c~slab-remove-kmem_cache_t net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c~slab-remove-kmem_cache_t
+++ a/net/ipv4/netfilter/ip_conntrack_core.c
@@ -65,8 +65,8 @@ static LIST_HEAD(helpers);
 unsigned int ip_conntrack_htable_size __read_mostly = 0;
 int ip_conntrack_max __read_mostly;
 struct list_head *ip_conntrack_hash __read_mostly;
-static kmem_cache_t *ip_conntrack_cachep __read_mostly;
-static kmem_cache_t *ip_conntrack_expect_cachep __read_mostly;
+static struct kmem_cache *ip_conntrack_cachep __read_mostly;
+static struct kmem_cache *ip_conntrack_expect_cachep __read_mostly;
 struct ip_conntrack ip_conntrack_untracked;
 unsigned int ip_ct_log_invalid __read_mostly;
 static LIST_HEAD(unconfirmed);
diff -puN net/ipv6/ip6_fib.c~slab-remove-kmem_cache_t net/ipv6/ip6_fib.c
--- a/net/ipv6/ip6_fib.c~slab-remove-kmem_cache_t
+++ a/net/ipv6/ip6_fib.c
@@ -50,7 +50,7 @@
 
 struct rt6_statistics	rt6_stats;
 
-static kmem_cache_t * fib6_node_kmem __read_mostly;
+static struct kmem_cache * fib6_node_kmem __read_mostly;
 
 enum fib_walk_state_t
 {
diff -puN net/ipv6/xfrm6_tunnel.c~slab-remove-kmem_cache_t net/ipv6/xfrm6_tunnel.c
--- a/net/ipv6/xfrm6_tunnel.c~slab-remove-kmem_cache_t
+++ a/net/ipv6/xfrm6_tunnel.c
@@ -50,7 +50,7 @@ static u32 xfrm6_tunnel_spi;
 #define XFRM6_TUNNEL_SPI_MIN	1
 #define XFRM6_TUNNEL_SPI_MAX	0xffffffff
 
-static kmem_cache_t *xfrm6_tunnel_spi_kmem __read_mostly;
+static struct kmem_cache *xfrm6_tunnel_spi_kmem __read_mostly;
 
 #define XFRM6_TUNNEL_SPI_BYADDR_HSIZE 256
 #define XFRM6_TUNNEL_SPI_BYSPI_HSIZE 256
diff -puN net/netfilter/nf_conntrack_core.c~slab-remove-kmem_cache_t net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c~slab-remove-kmem_cache_t
+++ a/net/netfilter/nf_conntrack_core.c
@@ -108,7 +108,7 @@ static struct {
 	size_t size;
 
 	/* slab cache pointer */
-	kmem_cache_t *cachep;
+	struct kmem_cache *cachep;
 
 	/* allocated slab cache + modules which uses this slab cache */
 	int use;
@@ -147,7 +147,7 @@ int nf_conntrack_register_cache(u_int32_
 {
 	int ret = 0;
 	char *cache_name;
-	kmem_cache_t *cachep;
+	struct kmem_cache *cachep;
 
 	DEBUGP("nf_conntrack_register_cache: features=0x%x, name=%s, size=%d\n",
 	       features, name, size);
@@ -226,7 +226,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_register_
 /* FIXME: In the current, only nf_conntrack_cleanup() can call this function. */
 void nf_conntrack_unregister_cache(u_int32_t features)
 {
-	kmem_cache_t *cachep;
+	struct kmem_cache *cachep;
 	char *name;
 
 	/*
diff -puN net/netfilter/nf_conntrack_expect.c~slab-remove-kmem_cache_t net/netfilter/nf_conntrack_expect.c
--- a/net/netfilter/nf_conntrack_expect.c~slab-remove-kmem_cache_t
+++ a/net/netfilter/nf_conntrack_expect.c
@@ -29,7 +29,7 @@
 LIST_HEAD(nf_conntrack_expect_list);
 EXPORT_SYMBOL_GPL(nf_conntrack_expect_list);
 
-kmem_cache_t *nf_conntrack_expect_cachep __read_mostly;
+struct kmem_cache *nf_conntrack_expect_cachep __read_mostly;
 static unsigned int nf_conntrack_expect_next_id;
 
 /* nf_conntrack_expect helper functions */
diff -puN net/netfilter/xt_hashlimit.c~slab-remove-kmem_cache_t net/netfilter/xt_hashlimit.c
--- a/net/netfilter/xt_hashlimit.c~slab-remove-kmem_cache_t
+++ a/net/netfilter/xt_hashlimit.c
@@ -92,7 +92,7 @@ struct xt_hashlimit_htable {
 static DEFINE_SPINLOCK(hashlimit_lock);	/* protects htables list */
 static DEFINE_MUTEX(hlimit_mutex);	/* additional checkentry protection */
 static HLIST_HEAD(hashlimit_htables);
-static kmem_cache_t *hashlimit_cachep __read_mostly;
+static struct kmem_cache *hashlimit_cachep __read_mostly;
 
 static inline int dst_cmp(const struct dsthash_ent *ent, struct dsthash_dst *b)
 {
diff -puN net/sctp/protocol.c~slab-remove-kmem_cache_t net/sctp/protocol.c
--- a/net/sctp/protocol.c~slab-remove-kmem_cache_t
+++ a/net/sctp/protocol.c
@@ -79,8 +79,8 @@ static struct sctp_pf *sctp_pf_inet_spec
 static struct sctp_af *sctp_af_v4_specific;
 static struct sctp_af *sctp_af_v6_specific;
 
-kmem_cache_t *sctp_chunk_cachep __read_mostly;
-kmem_cache_t *sctp_bucket_cachep __read_mostly;
+struct kmem_cache *sctp_chunk_cachep __read_mostly;
+struct kmem_cache *sctp_bucket_cachep __read_mostly;
 
 /* Return the address of the control sock. */
 struct sock *sctp_get_ctl_sock(void)
diff -puN net/sctp/sm_make_chunk.c~slab-remove-kmem_cache_t net/sctp/sm_make_chunk.c
--- a/net/sctp/sm_make_chunk.c~slab-remove-kmem_cache_t
+++ a/net/sctp/sm_make_chunk.c
@@ -65,7 +65,7 @@
 #include <net/sctp/sctp.h>
 #include <net/sctp/sm.h>
 
-extern kmem_cache_t *sctp_chunk_cachep;
+extern struct kmem_cache *sctp_chunk_cachep;
 
 SCTP_STATIC
 struct sctp_chunk *sctp_make_chunk(const struct sctp_association *asoc,
diff -puN net/sctp/socket.c~slab-remove-kmem_cache_t net/sctp/socket.c
--- a/net/sctp/socket.c~slab-remove-kmem_cache_t
+++ a/net/sctp/socket.c
@@ -107,7 +107,7 @@ static void sctp_sock_migrate(struct soc
 			      struct sctp_association *, sctp_socket_type_t);
 static char *sctp_hmac_alg = SCTP_COOKIE_HMAC_ALG;
 
-extern kmem_cache_t *sctp_bucket_cachep;
+extern struct kmem_cache *sctp_bucket_cachep;
 
 /* Get the sndbuf space available at the time on the association.  */
 static inline int sctp_wspace(struct sctp_association *asoc)
diff -puN net/socket.c~slab-remove-kmem_cache_t net/socket.c
--- a/net/socket.c~slab-remove-kmem_cache_t
+++ a/net/socket.c
@@ -230,7 +230,7 @@ int move_addr_to_user(void *kaddr, int k
 
 #define SOCKFS_MAGIC 0x534F434B
 
-static kmem_cache_t *sock_inode_cachep __read_mostly;
+static struct kmem_cache *sock_inode_cachep __read_mostly;
 
 static struct inode *sock_alloc_inode(struct super_block *sb)
 {
@@ -257,7 +257,7 @@ static void sock_destroy_inode(struct in
 			container_of(inode, struct socket_alloc, vfs_inode));
 }
 
-static void init_once(void *foo, kmem_cache_t *cachep, unsigned long flags)
+static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct socket_alloc *ei = (struct socket_alloc *)foo;
 
diff -puN net/sunrpc/rpc_pipe.c~slab-remove-kmem_cache_t net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~slab-remove-kmem_cache_t
+++ a/net/sunrpc/rpc_pipe.c
@@ -33,7 +33,7 @@ static int rpc_mount_count;
 static struct file_system_type rpc_pipe_fs_type;
 
 
-static kmem_cache_t *rpc_inode_cachep __read_mostly;
+static struct kmem_cache *rpc_inode_cachep __read_mostly;
 
 #define RPC_UPCALL_TIMEOUT (30*HZ)
 
@@ -824,7 +824,7 @@ static struct file_system_type rpc_pipe_
 };
 
 static void
-init_once(void * foo, kmem_cache_t * cachep, unsigned long flags)
+init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct rpc_inode *rpci = (struct rpc_inode *) foo;
 
diff -puN net/sunrpc/sched.c~slab-remove-kmem_cache_t net/sunrpc/sched.c
--- a/net/sunrpc/sched.c~slab-remove-kmem_cache_t
+++ a/net/sunrpc/sched.c
@@ -34,8 +34,8 @@ static int			rpc_task_id;
 #define RPC_BUFFER_MAXSIZE	(2048)
 #define RPC_BUFFER_POOLSIZE	(8)
 #define RPC_TASK_POOLSIZE	(8)
-static kmem_cache_t	*rpc_task_slabp __read_mostly;
-static kmem_cache_t	*rpc_buffer_slabp __read_mostly;
+static struct kmem_cache	*rpc_task_slabp __read_mostly;
+static struct kmem_cache	*rpc_buffer_slabp __read_mostly;
 static mempool_t	*rpc_task_mempool __read_mostly;
 static mempool_t	*rpc_buffer_mempool __read_mostly;
 
diff -puN net/tipc/handler.c~slab-remove-kmem_cache_t net/tipc/handler.c
--- a/net/tipc/handler.c~slab-remove-kmem_cache_t
+++ a/net/tipc/handler.c
@@ -42,7 +42,7 @@ struct queue_item {
 	unsigned long data;
 };
 
-static kmem_cache_t *tipc_queue_item_cache;
+static struct kmem_cache *tipc_queue_item_cache;
 static struct list_head signal_queue_head;
 static DEFINE_SPINLOCK(qitem_lock);
 static int handler_enabled = 0;
diff -puN net/xfrm/xfrm_input.c~slab-remove-kmem_cache_t net/xfrm/xfrm_input.c
--- a/net/xfrm/xfrm_input.c~slab-remove-kmem_cache_t
+++ a/net/xfrm/xfrm_input.c
@@ -12,7 +12,7 @@
 #include <net/ip.h>
 #include <net/xfrm.h>
 
-static kmem_cache_t *secpath_cachep __read_mostly;
+static struct kmem_cache *secpath_cachep __read_mostly;
 
 void __secpath_destroy(struct sec_path *sp)
 {
diff -puN net/xfrm/xfrm_policy.c~slab-remove-kmem_cache_t net/xfrm/xfrm_policy.c
--- a/net/xfrm/xfrm_policy.c~slab-remove-kmem_cache_t
+++ a/net/xfrm/xfrm_policy.c
@@ -39,7 +39,7 @@ EXPORT_SYMBOL(xfrm_policy_count);
 static DEFINE_RWLOCK(xfrm_policy_afinfo_lock);
 static struct xfrm_policy_afinfo *xfrm_policy_afinfo[NPROTO];
 
-static kmem_cache_t *xfrm_dst_cache __read_mostly;
+static struct kmem_cache *xfrm_dst_cache __read_mostly;
 
 static struct work_struct xfrm_policy_gc_work;
 static HLIST_HEAD(xfrm_policy_gc_list);
diff -puN security/keys/key.c~slab-remove-kmem_cache_t security/keys/key.c
--- a/security/keys/key.c~slab-remove-kmem_cache_t
+++ a/security/keys/key.c
@@ -20,7 +20,7 @@
 #include <linux/err.h>
 #include "internal.h"
 
-static kmem_cache_t	*key_jar;
+static struct kmem_cache	*key_jar;
 struct rb_root		key_serial_tree; /* tree of keys indexed by serial */
 DEFINE_SPINLOCK(key_serial_lock);
 
diff -puN security/selinux/avc.c~slab-remove-kmem_cache_t security/selinux/avc.c
--- a/security/selinux/avc.c~slab-remove-kmem_cache_t
+++ a/security/selinux/avc.c
@@ -124,7 +124,7 @@ DEFINE_PER_CPU(struct avc_cache_stats, a
 
 static struct avc_cache avc_cache;
 static struct avc_callback_node *avc_callbacks;
-static kmem_cache_t *avc_node_cachep;
+static struct kmem_cache *avc_node_cachep;
 
 static inline int avc_hash(u32 ssid, u32 tsid, u16 tclass)
 {
diff -puN security/selinux/hooks.c~slab-remove-kmem_cache_t security/selinux/hooks.c
--- a/security/selinux/hooks.c~slab-remove-kmem_cache_t
+++ a/security/selinux/hooks.c
@@ -124,7 +124,7 @@ static struct security_operations *secon
 static LIST_HEAD(superblock_security_head);
 static DEFINE_SPINLOCK(sb_security_lock);
 
-static kmem_cache_t *sel_inode_cache;
+static struct kmem_cache *sel_inode_cache;
 
 /* Return security context for a given sid or just the context 
    length if the buffer is null or length is 0 */
diff -puN security/selinux/ss/avtab.c~slab-remove-kmem_cache_t security/selinux/ss/avtab.c
--- a/security/selinux/ss/avtab.c~slab-remove-kmem_cache_t
+++ a/security/selinux/ss/avtab.c
@@ -28,7 +28,7 @@
  (keyp->source_type << 9)) & \
  AVTAB_HASH_MASK)
 
-static kmem_cache_t *avtab_node_cachep;
+static struct kmem_cache *avtab_node_cachep;
 
 static struct avtab_node*
 avtab_insert_node(struct avtab *h, int hvalue,
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
ia64-resolve-name-clash-by-renaming-is_available_memory.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch

