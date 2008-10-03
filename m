From: akpm@linux-foundation.org
Subject: + ecryptfs-convert-to-use-new-aops-update.patch added to -mm tree
Date: Thu, 02 Oct 2008 17:51:12 -0700
Message-ID: <200810030051.m930pCX7003071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753780AbYJCAvw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 20:51:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, mhalcrow@us.ibm.com, npiggin@suse.de


The patch titled
     ecryptfs-convert-to-use-new-aops update
has been added to the -mm tree.  Its filename is
     ecryptfs-convert-to-use-new-aops-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

git-cifs.patch
mm-cleanup-to-make-remove_memory-arch-neutral.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
ecryptfs-convert-to-use-new-aops.patch
ecryptfs-convert-to-use-new-aops-update.patch

