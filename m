From: akpm@linux-foundation.org
Subject: - ecryptfs-remove-unnecessary-page-decrypt-call.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:18 -0700
Message-ID: <200806081947.m58JlIfr017408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902AbYFHTsW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:48:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, sandeen@redhat.com, shaggy@austin.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: remove unnecessary page decrypt call
has been removed from the -mm tree.  Its filename was
     ecryptfs-remove-unnecessary-page-decrypt-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: remove unnecessary page decrypt call
From: Michael Halcrow <mhalcrow@us.ibm.com>

The page decrypt calls in ecryptfs_write() are both pointless and buggy. 
Pointless because ecryptfs_get_locked_page() has already brought the page
up to date, and buggy because prior mmap writes will just be blown away by
the decrypt call.

This patch also removes the declaration of a now-nonexistent function
ecryptfs_write_zeros().

Thanks to Eric Sandeen and David Kleikamp for helping to track this
down.

Eric said:

   fsx w/ mmap dies quickly ( < 100 ops) without this, and survives
   nicely (to millions of ops+) with it in place.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/ecryptfs_kernel.h |    2 --
 fs/ecryptfs/read_write.c      |   22 ----------------------
 2 files changed, 24 deletions(-)

diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-remove-unnecessary-page-decrypt-call fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-remove-unnecessary-page-decrypt-call
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -660,8 +660,6 @@ int ecryptfs_get_tfm_and_mutex_for_ciphe
 int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 				      struct ecryptfs_auth_tok **auth_tok,
 				      char *sig);
-int ecryptfs_write_zeros(struct file *file, pgoff_t index, int start,
-			 int num_zeros);
 int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
 			 loff_t offset, size_t size);
 int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
diff -puN fs/ecryptfs/read_write.c~ecryptfs-remove-unnecessary-page-decrypt-call fs/ecryptfs/read_write.c
--- a/fs/ecryptfs/read_write.c~ecryptfs-remove-unnecessary-page-decrypt-call
+++ a/fs/ecryptfs/read_write.c
@@ -157,20 +157,6 @@ int ecryptfs_write(struct file *ecryptfs
 			       ecryptfs_page_idx, rc);
 			goto out;
 		}
-		if (start_offset_in_page) {
-			/* Read in the page from the lower
-			 * into the eCryptfs inode page cache,
-			 * decrypting */
-			rc = ecryptfs_decrypt_page(ecryptfs_page);
-			if (rc) {
-				printk(KERN_ERR "%s: Error decrypting "
-				       "page; rc = [%d]\n",
-				       __func__, rc);
-				ClearPageUptodate(ecryptfs_page);
-				page_cache_release(ecryptfs_page);
-				goto out;
-			}
-		}
 		ecryptfs_page_virt = kmap_atomic(ecryptfs_page, KM_USER0);
 
 		/*
@@ -349,14 +335,6 @@ int ecryptfs_read(char *data, loff_t off
 			       ecryptfs_page_idx, rc);
 			goto out;
 		}
-		rc = ecryptfs_decrypt_page(ecryptfs_page);
-		if (rc) {
-			printk(KERN_ERR "%s: Error decrypting "
-			       "page; rc = [%d]\n", __func__, rc);
-			ClearPageUptodate(ecryptfs_page);
-			page_cache_release(ecryptfs_page);
-			goto out;
-		}
 		ecryptfs_page_virt = kmap_atomic(ecryptfs_page, KM_USER0);
 		memcpy((data + data_offset),
 		       ((char *)ecryptfs_page_virt + start_offset_in_page),
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-privileged-kthread-for-lower-file-opens.patch
notify_change-callers-must-hold-i_mutex.patch

