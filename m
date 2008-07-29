From: akpm@linux-foundation.org
Subject: - ecryptfs-use-page_alloc-not-kmalloc-to-get-a-page-of-memory.patch removed from -mm tree
Date: Tue, 29 Jul 2008 13:30:12 -0700
Message-ID: <200807292030.m6TKUCKA019800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700AbYG2Ub2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 16:31:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, mhalcrow@us.ibm.com, riel@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: use page_alloc not kmalloc to get a page of memory
has been removed from the -mm tree.  Its filename was
     ecryptfs-use-page_alloc-not-kmalloc-to-get-a-page-of-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: use page_alloc not kmalloc to get a page of memory
From: Eric Sandeen <sandeen@redhat.com>

With SLUB debugging turned on in 2.6.26, I was getting memory corruption
when testing eCryptfs.  The root cause turned out to be that eCryptfs was
doing kmalloc(PAGE_CACHE_SIZE); virt_to_page() and treating that as a nice
page-aligned chunk of memory.  But at least with SLUB debugging on, this
is not always true, and the page we get from virt_to_page does not
necessarily match the PAGE_CACHE_SIZE worth of memory we got from kmalloc.

My simple testcase was 2 loops doing "rm -f fileX; cp /tmp/fileX ." for 2
different multi-megabyte files.  With this change I no longer see the
corruption.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-use-page_alloc-not-kmalloc-to-get-a-page-of-memory fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-use-page_alloc-not-kmalloc-to-get-a-page-of-memory
+++ a/fs/ecryptfs/crypto.c
@@ -475,8 +475,8 @@ int ecryptfs_encrypt_page(struct page *p
 {
 	struct inode *ecryptfs_inode;
 	struct ecryptfs_crypt_stat *crypt_stat;
-	char *enc_extent_virt = NULL;
-	struct page *enc_extent_page;
+	char *enc_extent_virt;
+	struct page *enc_extent_page = NULL;
 	loff_t extent_offset;
 	int rc = 0;
 
@@ -492,14 +492,14 @@ int ecryptfs_encrypt_page(struct page *p
 			       page->index);
 		goto out;
 	}
-	enc_extent_virt = kmalloc(PAGE_CACHE_SIZE, GFP_USER);
-	if (!enc_extent_virt) {
+	enc_extent_page = alloc_page(GFP_USER);
+	if (!enc_extent_page) {
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR, "Error allocating memory for "
 				"encrypted extent\n");
 		goto out;
 	}
-	enc_extent_page = virt_to_page(enc_extent_virt);
+	enc_extent_virt = kmap(enc_extent_page);
 	for (extent_offset = 0;
 	     extent_offset < (PAGE_CACHE_SIZE / crypt_stat->extent_size);
 	     extent_offset++) {
@@ -527,7 +527,10 @@ int ecryptfs_encrypt_page(struct page *p
 		}
 	}
 out:
-	kfree(enc_extent_virt);
+	if (enc_extent_page) {
+		kunmap(enc_extent_page);
+		__free_page(enc_extent_page);
+	}
 	return rc;
 }
 
@@ -609,8 +612,8 @@ int ecryptfs_decrypt_page(struct page *p
 {
 	struct inode *ecryptfs_inode;
 	struct ecryptfs_crypt_stat *crypt_stat;
-	char *enc_extent_virt = NULL;
-	struct page *enc_extent_page;
+	char *enc_extent_virt;
+	struct page *enc_extent_page = NULL;
 	unsigned long extent_offset;
 	int rc = 0;
 
@@ -627,14 +630,14 @@ int ecryptfs_decrypt_page(struct page *p
 			       page->index);
 		goto out;
 	}
-	enc_extent_virt = kmalloc(PAGE_CACHE_SIZE, GFP_USER);
-	if (!enc_extent_virt) {
+	enc_extent_page = alloc_page(GFP_USER);
+	if (!enc_extent_page) {
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR, "Error allocating memory for "
 				"encrypted extent\n");
 		goto out;
 	}
-	enc_extent_page = virt_to_page(enc_extent_virt);
+	enc_extent_virt = kmap(enc_extent_page);
 	for (extent_offset = 0;
 	     extent_offset < (PAGE_CACHE_SIZE / crypt_stat->extent_size);
 	     extent_offset++) {
@@ -662,7 +665,10 @@ int ecryptfs_decrypt_page(struct page *p
 		}
 	}
 out:
-	kfree(enc_extent_virt);
+	if (enc_extent_page) {
+		kunmap(enc_extent_page);
+		__free_page(enc_extent_page);
+	}
 	return rc;
 }
 
_

Patches currently in -mm which might be from sandeen@redhat.com are

linux-next.patch

