From: akpm@linux-foundation.org
Subject: - ecryptfs-fix-string-overflow-on-long-cipher-names.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:39:04 -0800
Message-ID: <200801072138.m07LcilR013496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56640 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757142AbYAGVjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:39:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: fix string overflow on long cipher names
has been removed from the -mm tree.  Its filename was
     ecryptfs-fix-string-overflow-on-long-cipher-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

hfs-handle-more-on-disk-corruptions-without-oopsing.patch
hfs-handle-more-on-disk-corruptions-without-oopsing-fix.patch
git-kbuild.patch
ext2-change-the-default-behaviour-on-error.patch
export-iov_shorten-for-ext4s-use.patch
export-iov_shorten-for-ext4s-use-fix.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
ext4-mm-ext4_store_maxbytes_for_bitmaped_files-warning-fix.patch
ext3-change-the-default-behaviour-on-error.patch
