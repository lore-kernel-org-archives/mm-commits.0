From: akpm@linux-foundation.org
Subject: [merged] ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:46 -0700
Message-ID: <200904061933.n36JXkIu011270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507AbZDFTfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:35:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yjwei@cn.fujitsu.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext3: use unsigned instead of int for type of blocksize in fs/ext3/namei.c
has been removed from the -mm tree.  Its filename was
     ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: use unsigned instead of int for type of blocksize in fs/ext3/namei.c
From: Wei Yongjun <yjwei@cn.fujitsu.com>

Use unsigned instead of int for the parameter which carries a blocksize.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN fs/ext3/namei.c~ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic
+++ a/fs/ext3/namei.c
@@ -161,12 +161,12 @@ static struct dx_frame *dx_probe(struct 
 				 struct dx_frame *frame,
 				 int *err);
 static void dx_release (struct dx_frame *frames);
-static int dx_make_map (struct ext3_dir_entry_2 *de, int size,
+static int dx_make_map(struct ext3_dir_entry_2 *de, unsigned blocksize,
 			struct dx_hash_info *hinfo, struct dx_map_entry map[]);
 static void dx_sort_map(struct dx_map_entry *map, unsigned count);
 static struct ext3_dir_entry_2 *dx_move_dirents (char *from, char *to,
 		struct dx_map_entry *offsets, int count);
-static struct ext3_dir_entry_2* dx_pack_dirents (char *base, int size);
+static struct ext3_dir_entry_2 *dx_pack_dirents(char *base, unsigned blocksize);
 static void dx_insert_block (struct dx_frame *frame, u32 hash, u32 block);
 static int ext3_htree_next_block(struct inode *dir, __u32 hash,
 				 struct dx_frame *frame,
@@ -708,14 +708,14 @@ errout:
  * Create map of hash values, offsets, and sizes, stored at end of block.
  * Returns number of entries mapped.
  */
-static int dx_make_map (struct ext3_dir_entry_2 *de, int size,
-			struct dx_hash_info *hinfo, struct dx_map_entry *map_tail)
+static int dx_make_map(struct ext3_dir_entry_2 *de, unsigned blocksize,
+		struct dx_hash_info *hinfo, struct dx_map_entry *map_tail)
 {
 	int count = 0;
 	char *base = (char *) de;
 	struct dx_hash_info h = *hinfo;
 
-	while ((char *) de < base + size)
+	while ((char *) de < base + blocksize)
 	{
 		if (de->name_len && de->inode) {
 			ext3fs_dirhash(de->name, de->name_len, &h);
@@ -1120,13 +1120,14 @@ dx_move_dirents(char *from, char *to, st
  * Compact each dir entry in the range to the minimal rec_len.
  * Returns pointer to last entry in range.
  */
-static struct ext3_dir_entry_2* dx_pack_dirents(char *base, int size)
+static struct ext3_dir_entry_2 *dx_pack_dirents(char *base, unsigned blocksize)
 {
-	struct ext3_dir_entry_2 *next, *to, *prev, *de = (struct ext3_dir_entry_2 *) base;
+	struct ext3_dir_entry_2 *next, *to, *prev;
+	struct ext3_dir_entry_2 *de = (struct ext3_dir_entry_2 *)base;
 	unsigned rec_len = 0;
 
 	prev = to = de;
-	while ((char*)de < base + size) {
+	while ((char *)de < base + blocksize) {
 		next = ext3_next_entry(de);
 		if (de->inode && de->name_len) {
 			rec_len = EXT3_DIR_REC_LEN(de->name_len);
_

Patches currently in -mm which might be from yjwei@cn.fujitsu.com are

origin.patch
linux-next.patch

