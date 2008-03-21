From: akpm@linux-foundation.org
Subject: - mm-shmem-and-tiny-shmem-fix-some-kernel-doc.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:28:59 -0700
Message-ID: <200803212028.m2LKSx7W008757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756352AbYCUU3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:29:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mm/shmem and tiny-shmem: fix some kernel-doc
has been removed from the -mm tree.  Its filename was
     mm-shmem-and-tiny-shmem-fix-some-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/shmem and tiny-shmem: fix some kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Convert tiny-shmem.c function comments to kernel-doc.  Add parameters and
convert/fix other kernel-doc in shmem.c.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c      |   25 ++++++++++---------------
 mm/tiny-shmem.c |    8 +++-----
 2 files changed, 13 insertions(+), 20 deletions(-)

diff -puN mm/shmem.c~mm-shmem-and-tiny-shmem-fix-some-kernel-doc mm/shmem.c
--- a/mm/shmem.c~mm-shmem-and-tiny-shmem-fix-some-kernel-doc
+++ a/mm/shmem.c
@@ -244,9 +244,8 @@ static void shmem_free_inode(struct supe
 	}
 }
 
-/*
+/**
  * shmem_recalc_inode - recalculate the size of an inode
- *
  * @inode: inode to recalc
  *
  * We have to calculate the free blocks since the mm can drop
@@ -270,9 +269,8 @@ static void shmem_recalc_inode(struct in
 	}
 }
 
-/*
+/**
  * shmem_swp_entry - find the swap vector position in the info structure
- *
  * @info:  info structure for the inode
  * @index: index of the page to find
  * @page:  optional page to add to the structure. Has to be preset to
@@ -374,13 +372,13 @@ static void shmem_swp_set(struct shmem_i
 	}
 }
 
-/*
+/**
  * shmem_swp_alloc - get the position of the swap entry for the page.
- *                   If it does not exist allocate the entry.
- *
  * @info:	info structure for the inode
  * @index:	index of the page to find
  * @sgp:	check and recheck i_size? skip allocation?
+ *
+ * If the entry does not exist, allocate it.
  */
 static swp_entry_t *shmem_swp_alloc(struct shmem_inode_info *info, unsigned long index, enum sgp_type sgp)
 {
@@ -440,9 +438,8 @@ static swp_entry_t *shmem_swp_alloc(stru
 	return entry;
 }
 
-/*
+/**
  * shmem_free_swp - free some swap entries in a directory
- *
  * @dir:        pointer to the directory
  * @edir:       pointer after last entry of the directory
  * @punch_lock: pointer to spinlock when needed for the holepunch case
@@ -2022,7 +2019,7 @@ static const struct inode_operations shm
 };
 
 #ifdef CONFIG_TMPFS_POSIX_ACL
-/**
+/*
  * Superblocks without xattr inode operations will get security.* xattr
  * support from the VFS "for free". As soon as we have any other xattrs
  * like ACLs, we also need to implement the security.* handlers at
@@ -2561,12 +2558,11 @@ out4:
 }
 module_init(init_tmpfs)
 
-/*
+/**
  * shmem_file_setup - get an unlinked file living in tmpfs
- *
  * @name: name for dentry (to be seen in /proc/<pid>/maps
  * @size: size to be set for the file
- *
+ * @flags: vm_flags
  */
 struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
 {
@@ -2621,9 +2617,8 @@ put_memory:
 	return ERR_PTR(error);
 }
 
-/*
+/**
  * shmem_zero_setup - setup a shared anonymous mapping
- *
  * @vma: the vma to be mmapped is prepared by do_mmap_pgoff
  */
 int shmem_zero_setup(struct vm_area_struct *vma)
diff -puN mm/tiny-shmem.c~mm-shmem-and-tiny-shmem-fix-some-kernel-doc mm/tiny-shmem.c
--- a/mm/tiny-shmem.c~mm-shmem-and-tiny-shmem-fix-some-kernel-doc
+++ a/mm/tiny-shmem.c
@@ -39,12 +39,11 @@ static int __init init_tmpfs(void)
 }
 module_init(init_tmpfs)
 
-/*
+/**
  * shmem_file_setup - get an unlinked file living in tmpfs
- *
  * @name: name for dentry (to be seen in /proc/<pid>/maps
  * @size: size to be set for the file
- *
+ * @flags: vm_flags
  */
 struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
 {
@@ -95,9 +94,8 @@ put_memory:
 	return ERR_PTR(error);
 }
 
-/*
+/**
  * shmem_zero_setup - setup a shared anonymous mapping
- *
  * @vma: the vma to be mmapped is prepared by do_mmap_pgoff
  */
 int shmem_zero_setup(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-x86.patch
rapidio-fix-docbook-references.patch
pm-remove-legacy-pm-fix.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
scsi-add-iscsi-ibft-support-fix.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
kernel-add-bit-rotation-helpers-for-16-and-8-bit.patch
profile-likely-unlikely-macros.patch

