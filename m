From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-string-overflow-on-long-cipher-names.patch added to -mm tree
Date: Tue, 18 Dec 2007 12:24:15 -0800
Message-ID: <200712182024.lBIKOFLO020099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34389 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297AbXLRUZZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 15:25:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: fix string overflow on long cipher names
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-string-overflow-on-long-cipher-names.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ecryptfs: fix string overflow on long cipher names
From: Eric Sandeen <sandeen@redhat.com>

Passing a cipher name > 32 chars on mount results in an overflow when the
cipher name is printed, because the last character in the struct
ecryptfs_key_tfm's cipher_name string was never zeroed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-fix-string-overflow-on-long-cipher-names fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-fix-string-overflow-on-long-cipher-names
+++ a/fs/ecryptfs/crypto.c
@@ -1847,6 +1847,7 @@ ecryptfs_add_new_key_tfm(struct ecryptfs
 	mutex_init(&tmp_tfm->key_tfm_mutex);
 	strncpy(tmp_tfm->cipher_name, cipher_name,
 		ECRYPTFS_MAX_CIPHER_NAME_SIZE);
+	tmp_tfm->cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE] = '\0';
 	tmp_tfm->key_size = key_size;
 	rc = ecryptfs_process_key_cipher(&tmp_tfm->key_tfm,
 					 tmp_tfm->cipher_name,
_

Patches currently in -mm which might be from sandeen@redhat.com are

ecryptfs-initialize-new-auth_tokens-before-teardown.patch
ecryptfs-set-s_blocksize-from-lower-fs-in-sb.patch
ecryptfs-fix-fsx-data-corruption-problems.patch
ecryptfs-fix-string-overflow-on-long-cipher-names.patch
ext2-change-the-default-behaviour-on-error.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ext4-fix-mb_debug-format-warnings.patch
ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines.patch
ext4-fix-oops-with-jbd-stats-through-procfs-and-external.patch
ext4-fix-up-ext4fs_debug-builds.patch
ext3-change-the-default-behaviour-on-error.patch
