From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-memory-corruption-when-storing-crypto-info-in-xattrs.patch added to -mm tree
Date: Sun, 26 Oct 2008 23:46:04 -0700
Message-ID: <200810270646.m9R6k46D027907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbYJ0GrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 02:47:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: fix memory corruption when storing crypto info in xattrs
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-memory-corruption-when-storing-crypto-info-in-xattrs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: fix memory corruption when storing crypto info in xattrs
From: Eric Sandeen <sandeen@redhat.com>

When ecryptfs allocates space to write crypto headers into, before copying
it out to file headers or to xattrs, it looks at the value of
crypt_stat->num_header_bytes_at_front to determine how much space it
needs.  This is also used as the file offset to the actual encrypted data,
so for xattr-stored crypto info, the value was zero.

So, we kzalloc'd 0 bytes, and then ran off to write to that memory. 
(Which returned as ZERO_SIZE_PTR, so we explode quickly).

The right answer is to always allocate a page to write into; the current
code won't ever write more than that (this is enforced by the
(PAGE_CACHE_SIZE - offset) length in the call to
ecryptfs_generate_key_packet_set).  To be explicit about this, we now send
in a "max" parameter, rather than magically using PAGE_CACHE_SIZE there.

Also, since the pointer we pass down the callchain eventually gets the
virt_to_page() treatment, we should be using a alloc_page variant, not
kzalloc (see also 7fcba054373d5dfc43d26e243a5c9b92069972ee)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-fix-memory-corruption-when-storing-crypto-info-in-xattrs fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-fix-memory-corruption-when-storing-crypto-info-in-xattrs
+++ a/fs/ecryptfs/crypto.c
@@ -1251,6 +1251,7 @@ struct kmem_cache *ecryptfs_header_cache
 /**
  * ecryptfs_write_headers_virt
  * @page_virt: The virtual address to write the headers to
+ * @max: The size of memory allocated at page_virt
  * @size: Set to the number of bytes written by this function
  * @crypt_stat: The cryptographic context
  * @ecryptfs_dentry: The eCryptfs dentry
@@ -1278,7 +1279,8 @@ struct kmem_cache *ecryptfs_header_cache
  *
  * Returns zero on success
  */
-static int ecryptfs_write_headers_virt(char *page_virt, size_t *size,
+static int ecryptfs_write_headers_virt(char *page_virt, size_t max,
+				       size_t *size,
 				       struct ecryptfs_crypt_stat *crypt_stat,
 				       struct dentry *ecryptfs_dentry)
 {
@@ -1296,7 +1298,7 @@ static int ecryptfs_write_headers_virt(c
 	offset += written;
 	rc = ecryptfs_generate_key_packet_set((page_virt + offset), crypt_stat,
 					      ecryptfs_dentry, &written,
-					      PAGE_CACHE_SIZE - offset);
+					      max - offset);
 	if (rc)
 		ecryptfs_printk(KERN_WARNING, "Error generating key packet "
 				"set; rc = [%d]\n", rc);
@@ -1368,14 +1370,14 @@ int ecryptfs_write_metadata(struct dentr
 		goto out;
 	}
 	/* Released in this function */
-	virt = kzalloc(crypt_stat->num_header_bytes_at_front, GFP_KERNEL);
+	virt = (char *)get_zeroed_page(GFP_KERNEL);
 	if (!virt) {
 		printk(KERN_ERR "%s: Out of memory\n", __func__);
 		rc = -ENOMEM;
 		goto out;
 	}
-	rc = ecryptfs_write_headers_virt(virt, &size, crypt_stat,
-					 ecryptfs_dentry);
+	rc = ecryptfs_write_headers_virt(virt, PAGE_CACHE_SIZE, &size,
+					 crypt_stat, ecryptfs_dentry);
 	if (unlikely(rc)) {
 		printk(KERN_ERR "%s: Error whilst writing headers; rc = [%d]\n",
 		       __func__, rc);
@@ -1393,8 +1395,7 @@ int ecryptfs_write_metadata(struct dentr
 		goto out_free;
 	}
 out_free:
-	memset(virt, 0, crypt_stat->num_header_bytes_at_front);
-	kfree(virt);
+	free_page((unsigned long)virt);
 out:
 	return rc;
 }
_

Patches currently in -mm which might be from sandeen@redhat.com are

ecryptfs-fix-memory-corruption-when-storing-crypto-info-in-xattrs.patch
linux-next.patch

