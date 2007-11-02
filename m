From: akpm@linux-foundation.org
Subject: + ecryptfs-release-mutex-on-hash-error-path.patch added to -mm tree
Date: Fri, 02 Nov 2007 14:11:19 -0700
Message-ID: <200711022111.lA2LBJfn011083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55023 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000AbXKBVMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 17:12:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, kazuki.ohta@gmail.com


The patch titled
     eCryptfs: release mutex on hash error path
has been added to the -mm tree.  Its filename is
     ecryptfs-release-mutex-on-hash-error-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: release mutex on hash error path
From: Michael Halcrow <mhalcrow@us.ibm.com>

Release the crypt_stat hash mutex on allocation error. Check for error
conditions when doing crypto hash calls.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Reported-by: Kazuki Ohta <kazuki.ohta@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-release-mutex-on-hash-error-path fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-release-mutex-on-hash-error-path
+++ a/fs/ecryptfs/crypto.c
@@ -115,11 +115,29 @@ static int ecryptfs_calculate_md5(char *
 		}
 		crypt_stat->hash_tfm = desc.tfm;
 	}
-	crypto_hash_init(&desc);
-	crypto_hash_update(&desc, &sg, len);
-	crypto_hash_final(&desc, dst);
-	mutex_unlock(&crypt_stat->cs_hash_tfm_mutex);
+	rc = crypto_hash_init(&desc);
+	if (rc) {
+		printk(KERN_ERR
+		       "%s: Error initializing crypto hash; rc = [%d]\n",
+		       __FUNCTION__, rc);
+		goto out;
+	}
+	rc = crypto_hash_update(&desc, &sg, len);
+	if (rc) {
+		printk(KERN_ERR
+		       "%s: Error updating crypto hash; rc = [%d]\n",
+		       __FUNCTION__, rc);
+		goto out;
+	}
+	rc = crypto_hash_final(&desc, dst);
+	if (rc) {
+		printk(KERN_ERR
+		       "%s: Error finalizing crypto hash; rc = [%d]\n",
+		       __FUNCTION__, rc);
+		goto out;
+	}
 out:
+	mutex_unlock(&crypt_stat->cs_hash_tfm_mutex);
 	return rc;
 }
 
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

ecryptfs-increment-extent_offset-once-per-loop-interation.patch
ecryptfs-release-mutex-on-hash-error-path.patch
git-unionfs.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
fs-ecryptfs-possible-cleanups.patch
ecryptfs-track-header-bytes-rather-than-extents.patch
ecryptfs-set-inode-key-only-once-per-crypto-operation.patch
