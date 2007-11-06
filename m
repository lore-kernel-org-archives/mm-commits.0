From: akpm@linux-foundation.org
Subject: - ecryptfs-release-mutex-on-hash-error-path.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:52:38 -0800
Message-ID: <200711060552.lA65qcww007341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53030 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753775AbXKFFxO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:53:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, kazuki.ohta@gmail.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: release mutex on hash error path
has been removed from the -mm tree.  Its filename was
     ecryptfs-release-mutex-on-hash-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
ecryptfs-cast-page-index-to-loff_t-instead-of-off_t.patch
git-unionfs.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
fs-ecryptfs-possible-cleanups.patch
ecryptfs-track-header-bytes-rather-than-extents.patch
ecryptfs-set-inode-key-only-once-per-crypto-operation.patch
d_path-make-d_path-use-a-struct-path.patch
