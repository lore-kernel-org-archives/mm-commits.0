From: akpm@linux-foundation.org
Subject: - ecryptfs-convert-to-use-new-aops-update.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:45:52 -0700
Message-ID: <200810152345.m9FNjqaC023087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753201AbYJOXqM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:46:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, mhalcrow@us.ibm.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     ecryptfs-convert-to-use-new-aops update
has been removed from the -mm tree.  Its filename was
     ecryptfs-convert-to-use-new-aops-update.patch

This patch was dropped because it was folded into ecryptfs-convert-to-use-new-aops.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs-convert-to-use-new-aops update
From: Badari Pulavarty <pbadari@us.ibm.com>

By mistake, I sent out the version without updated comments.
Arguments to write_begin/write_ends needs comment update.

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/mmap.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN fs/ecryptfs/mmap.c~ecryptfs-convert-to-use-new-aops-update fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-convert-to-use-new-aops-update
+++ a/fs/ecryptfs/mmap.c
@@ -268,8 +268,11 @@ out:
  * ecryptfs_write_begin
  * @file: The eCryptfs file
  * @mapping: The eCryptfs object
- * @from: The start byte from which we will write
- * @to: The end byte to which we will write
+ * @pos: The file offset at which to start writing
+ * @len: Length of the write
+ * @flags: Various flags
+ * @pagep: Pointer to return the page
+ * @fsdata: Pointer to return fs data (unused)
  *
  * This function must zero any hole we create
  *
@@ -456,8 +459,11 @@ int ecryptfs_write_inode_size_to_metadat
  * ecryptfs_write_end
  * @file: The eCryptfs file object
  * @mapping: The eCryptfs object
- * @pos, len: Ignored (we rotate the page IV on each write)
+ * @pos: The file position
+ * @len: The length of the data (unused)
+ * @copied: The amount of data copied
  * @page: The eCryptfs page
+ * @fsdata: The fsdata (unused)
  *
  * This is where we encrypt the data and pass the encrypted data to
  * the lower filesystem.  In OpenPGP-compatible mode, we operate on
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

origin.patch
ecryptfs-convert-to-use-new-aops.patch
ecryptfs-convert-to-use-new-aops-update.patch

