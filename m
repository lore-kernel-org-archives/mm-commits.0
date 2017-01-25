From: akpm@linux-foundation.org
Subject: [merged] dax-fix-build-warnings-with-fs_dax-and-fs_iomap.patch
 removed from -mm tree
Date: Wed, 25 Jan 2017 14:04:22 -0800
Message-ID: <588920e6.2C1w/MdPfUrOFxx+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42002 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751939AbdAYWEn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2017 17:04:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, arnd@arndb.de, hch@lst.de, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix build warnings with FS_DAX and !FS_IOMAP
has been removed from the -mm tree.  Its filename was
     dax-fix-build-warnings-with-fs_dax-and-fs_iomap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: fix build warnings with FS_DAX and !FS_IOMAP

As reported by Arnd:

https://lkml.org/lkml/2017/1/10/756

Compiling with the following configuration:

  # CONFIG_EXT2_FS is not set
  # CONFIG_EXT4_FS is not set
  # CONFIG_XFS_FS is not set
  # CONFIG_FS_IOMAP depends on the above filesystems, as is not set
  CONFIG_FS_DAX=y

generates build warnings about unused functions in fs/dax.c:

fs/dax.c:878:12: warning: `dax_insert_mapping' defined but not used [-Wunused-function]
 static int dax_insert_mapping(struct address_space *mapping,
            ^~~~~~~~~~~~~~~~~~
fs/dax.c:572:12: warning: `copy_user_dax' defined but not used [-Wunused-function]
 static int copy_user_dax(struct block_device *bdev, sector_t sector, size_t size,
            ^~~~~~~~~~~~~
fs/dax.c:542:12: warning: `dax_load_hole' defined but not used [-Wunused-function]
 static int dax_load_hole(struct address_space *mapping, void **entry,
            ^~~~~~~~~~~~~
fs/dax.c:312:14: warning: `grab_mapping_entry' defined but not used [-Wunused-function]
 static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
              ^~~~~~~~~~~~~~~~~~

Now that the struct buffer_head based DAX fault paths and I/O path have
been removed we really depend on iomap support being present for DAX.  Make
this explicit by selecting FS_IOMAP if we compile in DAX support.

This allows us to remove conditional selections of FS_IOMAP when FS_DAX was
present for ext2 and ext4, and to remove an #ifdef in fs/dax.c.

Link: http://lkml.kernel.org/r/1484087383-29478-1-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig      |    1 +
 fs/dax.c        |    2 --
 fs/ext2/Kconfig |    1 -
 fs/ext4/Kconfig |    1 -
 4 files changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/Kconfig~dax-fix-build-warnings-with-fs_dax-and-fs_iomap fs/Kconfig
--- a/fs/Kconfig~dax-fix-build-warnings-with-fs_dax-and-fs_iomap
+++ a/fs/Kconfig
@@ -38,6 +38,7 @@ config FS_DAX
 	bool "Direct Access (DAX) support"
 	depends on MMU
 	depends on !(ARM || MIPS || SPARC)
+	select FS_IOMAP
 	help
 	  Direct Access (DAX) can be used on memory-backed block devices.
 	  If the block device supports DAX and the filesystem supports DAX,
diff -puN fs/dax.c~dax-fix-build-warnings-with-fs_dax-and-fs_iomap fs/dax.c
--- a/fs/dax.c~dax-fix-build-warnings-with-fs_dax-and-fs_iomap
+++ a/fs/dax.c
@@ -990,7 +990,6 @@ int __dax_zero_page_range(struct block_d
 }
 EXPORT_SYMBOL_GPL(__dax_zero_page_range);
 
-#ifdef CONFIG_FS_IOMAP
 static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 {
 	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
@@ -1428,4 +1427,3 @@ int dax_iomap_pmd_fault(struct vm_area_s
 }
 EXPORT_SYMBOL_GPL(dax_iomap_pmd_fault);
 #endif /* CONFIG_FS_DAX_PMD */
-#endif /* CONFIG_FS_IOMAP */
diff -puN fs/ext2/Kconfig~dax-fix-build-warnings-with-fs_dax-and-fs_iomap fs/ext2/Kconfig
--- a/fs/ext2/Kconfig~dax-fix-build-warnings-with-fs_dax-and-fs_iomap
+++ a/fs/ext2/Kconfig
@@ -1,6 +1,5 @@
 config EXT2_FS
 	tristate "Second extended fs support"
-	select FS_IOMAP if FS_DAX
 	help
 	  Ext2 is a standard Linux file system for hard disks.
 
diff -puN fs/ext4/Kconfig~dax-fix-build-warnings-with-fs_dax-and-fs_iomap fs/ext4/Kconfig
--- a/fs/ext4/Kconfig~dax-fix-build-warnings-with-fs_dax-and-fs_iomap
+++ a/fs/ext4/Kconfig
@@ -37,7 +37,6 @@ config EXT4_FS
 	select CRC16
 	select CRYPTO
 	select CRYPTO_CRC32C
-	select FS_IOMAP if FS_DAX
 	help
 	  This is the next generation of the ext3 filesystem.
 
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

tracing-add-__print_flags_u64.patch
dax-add-tracepoint-infrastructure-pmd-tracing.patch
dax-update-maintainers-entries-for-fs-dax.patch
dax-add-tracepoints-to-dax_pmd_load_hole.patch
dax-add-tracepoints-to-dax_pmd_insert_mapping.patch

