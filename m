From: akpm@linux-foundation.org
Subject: - ecryptfs-string-copy-cleanup.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:28:55 -0700
Message-ID: <200807242328.m6ONSt3N011319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066AbYGXX3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: string copy cleanup
has been removed from the -mm tree.  Its filename was
     ecryptfs-string-copy-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: string copy cleanup
From: Miklos Szeredi <mszeredi@suse.cz>

Clean up overcomplicated string copy, which also gets rid of this
bogus warning:

fs/ecryptfs/main.c: In function 'ecryptfs_parse_options':
include/asm/arch/string_32.h:75: warning: array subscript is above array bounds

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/main.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN fs/ecryptfs/main.c~ecryptfs-string-copy-cleanup fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-string-copy-cleanup
+++ a/fs/ecryptfs/main.c
@@ -301,7 +301,6 @@ static int ecryptfs_parse_options(struct
 	char *cipher_name_dst;
 	char *cipher_name_src;
 	char *cipher_key_bytes_src;
-	int cipher_name_len;
 
 	if (!options) {
 		rc = -EINVAL;
@@ -382,17 +381,12 @@ static int ecryptfs_parse_options(struct
 		goto out;
 	}
 	if (!cipher_name_set) {
-		cipher_name_len = strlen(ECRYPTFS_DEFAULT_CIPHER);
-		if (unlikely(cipher_name_len
-			     >= ECRYPTFS_MAX_CIPHER_NAME_SIZE)) {
-			rc = -EINVAL;
-			BUG();
-			goto out;
-		}
-		memcpy(mount_crypt_stat->global_default_cipher_name,
-		       ECRYPTFS_DEFAULT_CIPHER, cipher_name_len);
-		mount_crypt_stat->global_default_cipher_name[cipher_name_len]
-		    = '\0';
+		int cipher_name_len = strlen(ECRYPTFS_DEFAULT_CIPHER);
+
+		BUG_ON(cipher_name_len >= ECRYPTFS_MAX_CIPHER_NAME_SIZE);
+
+		strcpy(mount_crypt_stat->global_default_cipher_name,
+		       ECRYPTFS_DEFAULT_CIPHER);
 	}
 	if (!cipher_key_bytes_set) {
 		mount_crypt_stat->global_default_cipher_key_size = 0;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
linux-next.patch
git-unprivileged-mounts.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

