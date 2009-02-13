From: akpm@linux-foundation.org
Subject: + ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic.patch added to -mm tree
Date: Fri, 13 Feb 2009 14:03:45 -0800
Message-ID: <200902132203.n1DM3jFn015717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753228AbZBMWDw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Feb 2009 17:03:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yjwei@cn.fujitsu.com, tytso@mit.edu


The patch titled
     ext3: use unsigned instead of int for type of blocksize in fs/ext3/namei.c
has been added to the -mm tree.  Its filename is
     ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: use unsigned instead of int for type of blocksize in fs/ext3/namei.c
From: Wei Yongjun <yjwei@cn.fujitsu.com>

Use unsigned instead of int for the parameter which carries a blocksize.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ext3/namei.c~ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic
+++ a/fs/ext3/namei.c
@@ -161,12 +161,12 @@ static struct dx_frame *dx_probe(struct 
 				 struct dx_frame *frame,
 				 int *err);
 static void dx_release (struct dx_frame *frames);
-static int dx_make_map (struct ext3_dir_entry_2 *de, int size,
+static int dx_make_map (struct ext3_dir_entry_2 *de, unsigned size,
 			struct dx_hash_info *hinfo, struct dx_map_entry map[]);
 static void dx_sort_map(struct dx_map_entry *map, unsigned count);
 static struct ext3_dir_entry_2 *dx_move_dirents (char *from, char *to,
 		struct dx_map_entry *offsets, int count);
-static struct ext3_dir_entry_2* dx_pack_dirents (char *base, int size);
+static struct ext3_dir_entry_2* dx_pack_dirents (char *base, unsigned size);
 static void dx_insert_block (struct dx_frame *frame, u32 hash, u32 block);
 static int ext3_htree_next_block(struct inode *dir, __u32 hash,
 				 struct dx_frame *frame,
@@ -708,7 +708,7 @@ errout:
  * Create map of hash values, offsets, and sizes, stored at end of block.
  * Returns number of entries mapped.
  */
-static int dx_make_map (struct ext3_dir_entry_2 *de, int size,
+static int dx_make_map (struct ext3_dir_entry_2 *de, unsigned size,
 			struct dx_hash_info *hinfo, struct dx_map_entry *map_tail)
 {
 	int count = 0;
@@ -1120,7 +1120,7 @@ dx_move_dirents(char *from, char *to, st
  * Compact each dir entry in the range to the minimal rec_len.
  * Returns pointer to last entry in range.
  */
-static struct ext3_dir_entry_2* dx_pack_dirents(char *base, int size)
+static struct ext3_dir_entry_2* dx_pack_dirents(char *base, unsigned size)
 {
 	struct ext3_dir_entry_2 *next, *to, *prev, *de = (struct ext3_dir_entry_2 *) base;
 	unsigned rec_len = 0;
_

Patches currently in -mm which might be from yjwei@cn.fujitsu.com are

linux-next.patch
fs-jffs2-mallocc-kmem_cache_alloc-memset-kmem_cache_zalloc.patch
scsi-used-kmem_cache_zalloc-instead-of-kmem_cache_alloc-memset.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic.patch

