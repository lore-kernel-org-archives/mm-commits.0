From: akpm@linux-foundation.org
Subject: + ecryptfs-reduce-stack-usage-in-ecryptfs_generate_key_packet_set.patch added to -mm tree
Date: Wed, 14 Feb 2007 12:49:22 -0800
Message-ID: <200702142049.l1EKnMNj008680@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44925 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXBNUt2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 15:49:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: Reduce stack usage in ecryptfs_generate_key_packet_set()
has been added to the -mm tree.  Its filename is
     ecryptfs-reduce-stack-usage-in-ecryptfs_generate_key_packet_set.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: Reduce stack usage in ecryptfs_generate_key_packet_set()
From: Michael Halcrow <mhalcrow@us.ibm.com>

eCryptfs is gobbling a lot of stack in ecryptfs_generate_key_packet_set()
because it allocates a temporary memory-hungry ecryptfs_key_record struct. 
This patch introduces a new kmem_cache for that struct and converts
ecryptfs_generate_key_packet_set() to use it.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/ecryptfs_kernel.h |    1 +
 fs/ecryptfs/keystore.c        |   26 ++++++++++++++++++--------
 fs/ecryptfs/main.c            |    5 +++++
 3 files changed, 24 insertions(+), 8 deletions(-)

diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-reduce-stack-usage-in-ecryptfs_generate_key_packet_set fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-reduce-stack-usage-in-ecryptfs_generate_key_packet_set
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -467,6 +467,7 @@ extern struct kmem_cache *ecryptfs_heade
 extern struct kmem_cache *ecryptfs_header_cache_2;
 extern struct kmem_cache *ecryptfs_xattr_cache;
 extern struct kmem_cache *ecryptfs_lower_page_cache;
+extern struct kmem_cache *ecryptfs_key_record_cache;
 
 int ecryptfs_interpose(struct dentry *hidden_dentry,
 		       struct dentry *this_dentry, struct super_block *sb,
diff -puN fs/ecryptfs/keystore.c~ecryptfs-reduce-stack-usage-in-ecryptfs_generate_key_packet_set fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-reduce-stack-usage-in-ecryptfs_generate_key_packet_set
+++ a/fs/ecryptfs/keystore.c
@@ -1639,6 +1639,8 @@ out:
 	return rc;
 }
 
+struct kmem_cache *ecryptfs_key_record_cache;
+
 /**
  * ecryptfs_generate_key_packet_set
  * @dest: Virtual address from which to write the key record set
@@ -1665,50 +1667,55 @@ ecryptfs_generate_key_packet_set(char *d
 		&ecryptfs_superblock_to_private(
 			ecryptfs_dentry->d_sb)->mount_crypt_stat;
 	size_t written;
-	struct ecryptfs_key_record key_rec;
+	struct ecryptfs_key_record *key_rec;
 	int rc = 0;
 
 	(*len) = 0;
+	key_rec = kmem_cache_alloc(ecryptfs_key_record_cache, GFP_KERNEL);
+	if (!key_rec) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	if (mount_crypt_stat->global_auth_tok) {
 		auth_tok = mount_crypt_stat->global_auth_tok;
 		if (auth_tok->token_type == ECRYPTFS_PASSWORD) {
 			rc = write_tag_3_packet((dest_base + (*len)),
 						max, auth_tok,
-						crypt_stat, &key_rec,
+						crypt_stat, key_rec,
 						&written);
 			if (rc) {
 				ecryptfs_printk(KERN_WARNING, "Error "
 						"writing tag 3 packet\n");
-				goto out;
+				goto out_free;
 			}
 			(*len) += written;
 			/* Write auth tok signature packet */
 			rc = write_tag_11_packet(
 				(dest_base + (*len)),
 				(max - (*len)),
-				key_rec.sig, ECRYPTFS_SIG_SIZE, &written);
+				key_rec->sig, ECRYPTFS_SIG_SIZE, &written);
 			if (rc) {
 				ecryptfs_printk(KERN_ERR, "Error writing "
 						"auth tok signature packet\n");
-				goto out;
+				goto out_free;
 			}
 			(*len) += written;
 		} else if (auth_tok->token_type == ECRYPTFS_PRIVATE_KEY) {
 			rc = write_tag_1_packet(dest_base + (*len),
 						max, auth_tok,
 						crypt_stat,mount_crypt_stat,
-						&key_rec, &written);
+						key_rec, &written);
 			if (rc) {
 				ecryptfs_printk(KERN_WARNING, "Error "
 						"writing tag 1 packet\n");
-				goto out;
+				goto out_free;
 			}
 			(*len) += written;
 		} else {
 			ecryptfs_printk(KERN_WARNING, "Unsupported "
 					"authentication token type\n");
 			rc = -EINVAL;
-			goto out;
+			goto out_free;
 		}
 	} else
 		BUG();
@@ -1718,6 +1725,9 @@ ecryptfs_generate_key_packet_set(char *d
 		ecryptfs_printk(KERN_ERR, "Error writing boundary byte\n");
 		rc = -EIO;
 	}
+
+out_free:
+	kmem_cache_free(ecryptfs_key_record_cache, key_rec);
 out:
 	if (rc)
 		(*len) = 0;
diff -puN fs/ecryptfs/main.c~ecryptfs-reduce-stack-usage-in-ecryptfs_generate_key_packet_set fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-reduce-stack-usage-in-ecryptfs_generate_key_packet_set
+++ a/fs/ecryptfs/main.c
@@ -651,6 +651,11 @@ static struct ecryptfs_cache_info {
 		.name = "ecryptfs_lower_page_cache",
 		.size = PAGE_CACHE_SIZE,
 	},
+	{
+		.cache = &ecryptfs_key_record_cache,
+		.name = "ecryptfs_key_record_cache",
+		.size = sizeof(struct ecryptfs_key_record),
+	},
 };
 
 static void ecryptfs_free_kmem_caches(void)
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd.patch
ecryptfs-reduce-stack-usage-in-ecryptfs_generate_key_packet_set.patch
