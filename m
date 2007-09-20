From: akpm@linux-foundation.org
Subject: + ecryptfs-replace-magic-numbers.patch added to -mm tree
Date: Wed, 19 Sep 2007 22:51:43 -0700
Message-ID: <200709200551.l8K5ph2V030779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755285AbXITFv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 01:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: replace magic numbers
has been added to the -mm tree.  Its filename is
     ecryptfs-replace-magic-numbers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: replace magic numbers
From: Michael Halcrow <mhalcrow@us.ibm.com>

Replace some magic numbers with sizeof() equivalents.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-replace-magic-numbers fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-replace-magic-numbers
+++ a/fs/ecryptfs/crypto.c
@@ -1424,10 +1424,10 @@ static int parse_header_metadata(struct 
 	u32 header_extent_size;
 	u16 num_header_extents_at_front;
 
-	memcpy(&header_extent_size, virt, 4);
+	memcpy(&header_extent_size, virt, sizeof(u32));
 	header_extent_size = be32_to_cpu(header_extent_size);
-	virt += 4;
-	memcpy(&num_header_extents_at_front, virt, 2);
+	virt += sizeof(u32);
+	memcpy(&num_header_extents_at_front, virt, sizeof(u16));
 	num_header_extents_at_front = be16_to_cpu(num_header_extents_at_front);
 	crypt_stat->num_header_extents_at_front =
 		(int)num_header_extents_at_front;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
fs-remove-some-aop_truncated_page.patch
ecryptfs-add-key-list-structure-search-keyring.patch
ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch
ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions.patch
ecryptfs-fix-tag-1-parsing-code.patch
ecryptfs-fix-tag-3-parsing-code.patch
ecryptfs-fix-tag-11-parsing-code.patch
ecryptfs-fix-tag-11-writing-code.patch
ecryptfs-update-comment-and-debug-statement.patch
ecryptfs-printk-warning-fixes.patch
ecryptfs-remove-unnecessary-bug_on.patch
ecryptfs-collapse-flag-set-into-one-statement.patch
ecryptfs-grammatical-fix-destruct-to-destroy.patch
ecryptfs-comments-for-some-structs.patch
ecryptfs-kerneldoc-fixes-for-cryptoc-and-keystorec.patch
ecryptfs-remove-unnecessary-variable-initializations.patch
ecryptfs-make-needlessly-global-symbols-static.patch
ecryptfs-use-generic_file_splice_read.patch
ecryptfs-remove-header_extent_size.patch
ecryptfs-remove-assignments-in-if-statements.patch
ecryptfs-read_writec-routines.patch
ecryptfs-replace-encrypt-decrypt-and-inode-size-write.patch
ecryptfs-set-up-and-destroy-persistent-lower-file.patch
ecryptfs-update-metadata-read-write-functions.patch
ecryptfs-make-open-truncate-and-setattr-use-persistent-file.patch
ecryptfs-convert-mmap-functions-to-use-persistent-file.patch
ecryptfs-initialize-persistent-lower-file-on-inode-create.patch
ecryptfs-remove-unused-functions-and-kmem_cache.patch
ecryptfs-replace-magic-numbers.patch
