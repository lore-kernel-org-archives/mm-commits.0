From: akpm@linux-foundation.org
Subject: + ecryptfs-remove-unnecessary-page-decrypt-call.patch added to -mm tree
Date: Thu, 29 May 2008 16:36:51 -0700
Message-ID: <200805292336.m4TNap2S028632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755084AbYE2XiF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 19:38:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, sandeen@redhat.com, shaggy@austin.ibm.com


The patch titled
     eCryptfs: remove unnecessary page decrypt call
has been added to the -mm tree.  Its filename is
     ecryptfs-remove-unnecessary-page-decrypt-call.patch

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

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
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

ecryptfs-remove-unnecessary-page-decrypt-call.patch
git-unionfs.patch
ecryptfs-privileged-kthread-for-lower-file-opens.patch
notify_change-callers-must-hold-i_mutex.patch

