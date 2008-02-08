From: akpm@linux-foundation.org
Subject: - cramfs-update-documentation.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:02:14 -0800
Message-ID: <200802082001.m18K1twN009740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40404 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932860AbYBHUKW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:10:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lists-receive@programmierforen.de, andi@programmierforen.de, mm-commits@vger.kernel.org


The patch titled
     cramfs: update documentation
has been removed from the -mm tree.  Its filename was
     cramfs-update-documentation.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cramfs: update documentation
From: Andi Drebes <lists-receive@programmierforen.de>

Update the cramfs documentation according to the changes in PATCH 1/2.

The changes were tested on the following types of machines: An i386 compatible
box (little endian) UltraSparc IIi (big endian)

Signed-off-by: Andi Drebes <andi@programmierforen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/README |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN fs/cramfs/README~cramfs-update-documentation fs/cramfs/README
--- a/fs/cramfs/README~cramfs-update-documentation
+++ a/fs/cramfs/README
@@ -6,8 +6,11 @@ a bit looser, e.g. it doesn't care if th
 swapped around (though it does care that directory entries (inodes) in
 a given directory are contiguous, as this is used by readdir).
 
-All data is currently in host-endian format; neither mkcramfs nor the
-kernel ever do swabbing.  (See section `Block Size' below.)
+All data is now in little endian format. Before, it was in host endian
+format. In order to make filesystem images more shareable between machines
+with a different byte order, cramfs' specification ("this README file")
+was updated. There will be no support for big endian filesystems in the
+future.
 
 <filesystem>:
 	<superblock>
@@ -108,18 +111,6 @@ kernels, not even necessarily kernels of
 PAGE_CACHE_SIZE is subject to change between kernel versions
 (currently possible with arm and ia64).
 
-The remaining options try to make cramfs more sharable.
-
-One part of that is addressing endianness.  The two options here are
-`always use little-endian' (like ext2fs) or `writer chooses
-endianness; kernel adapts at runtime'.  Little-endian wins because of
-code simplicity and little CPU overhead even on big-endian machines.
-
-The cost of swabbing is changing the code to use the le32_to_cpu
-etc. macros as used by ext2fs.  We don't need to swab the compressed
-data, only the superblock, inodes and block pointers.
-
-
 The other part of making cramfs more sharable is choosing a block
 size.  The options are:
 
_

Patches currently in -mm which might be from lists-receive@programmierforen.de are

cramfs-update-documentation.patch
