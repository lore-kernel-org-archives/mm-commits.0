From: akpm@osdl.org
Subject: - ufs-rellocation-fix-fix.patch removed from -mm tree
Date: Mon, 29 Jan 2007 13:19:01 -0800
Message-ID: <200701292119.l0TLJ1sB031212@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57308 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbXA2VTI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 16:19:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     ufs: rellocation fix fix
has been removed from the -mm tree.  Its filename was
     ufs-rellocation-fix-fix.patch

This patch was dropped because it was folded into ufs-rellocation-fix.patch

------------------------------------------------------
Subject: ufs: rellocation fix fix
From: Evgeniy Dushistov <dushistov@mail.ru>

On Wed, Jan 24, 2007 at 08:21:07PM -0800, Andrew Morton wrote:
> On Mon, 22 Jan 2007 18:07:51 +0300
> Evgeniy Dushistov <dushistov@mail.ru> wrote:
>
> > -	for (i = 0; i < count; i += blk_per_page) {
> > +	for (i = 0; i < count; i = (i | mask) + 1) {
>
> This is a funny looking thing.  As far as I can tell, this is a more
> complicated way of doing the same thing as the old code did.
>
> Am I missing something?
>

No, you right, thanks, work should be done with baseblk+i, not with i.
(It is imposible to catch on my test enviroment: size of page 4096
and baseblk always point to begin of data block which size of
>=4096 and power of 2).

Here is patch for patch, it also contains typo fixing in previous
patch which lead to compilation failure if ufs debug turn on.


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ufs/balloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ufs/balloc.c~ufs-rellocation-fix-fix fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~ufs-rellocation-fix-fix
+++ a/fs/ufs/balloc.c
@@ -227,14 +227,14 @@ failed:
  * We can come here from ufs_writepage or ufs_prepare_write,
  * locked_page is argument of these functions, so we already lock it.
  */
-static void ufs_change_blocknr(struct inode *inode, unsigned int baseblk,
+static void ufs_change_blocknr(struct inode *inode, unsigned int beg,
 			       unsigned int count, unsigned int oldb,
 			       unsigned int newb, struct page *locked_page)
 {
 	const unsigned mask = (1 << (PAGE_CACHE_SHIFT - inode->i_blkbits)) - 1;
 	struct address_space * const mapping = inode->i_mapping;
 	pgoff_t index, cur_index;
-	unsigned i, pos, j;
+	unsigned end, pos, j;
 	struct page *page;
 	struct buffer_head *head, *bh;
 
@@ -246,8 +246,8 @@ static void ufs_change_blocknr(struct in
 
 	cur_index = locked_page->index;
 
-	for (i = 0; i < count; i = (i | mask) + 1) {
-		index = (baseblk+i) >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	for (end = count + beg; beg < end; beg = (beg | mask) + 1) {
+		index = beg >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
 
 		if (likely(cur_index != index)) {
 			page = ufs_get_locked_page(mapping, index);
@@ -258,7 +258,7 @@ static void ufs_change_blocknr(struct in
 
 		head = page_buffers(page);
 		bh = head;
-		pos = i & mask;
+		pos = beg & mask;
 		for (j = 0; j < pos; ++j)
 			bh = bh->b_this_page;
 		j = 0;
@@ -267,7 +267,7 @@ static void ufs_change_blocknr(struct in
 				pos = bh->b_blocknr - oldb;
 				if (pos < count) {
 					UFSD(" change from %llu to %llu\n",
-					     (unsigned long long)pos + odlb,
+					     (unsigned long long)pos + oldb,
 					     (unsigned long long)pos + newb);
 					bh->b_blocknr = newb + pos;
 					unmap_underlying_metadata(bh->b_bdev,
_

Patches currently in -mm which might be from dushistov@mail.ru are

ufs-alloc-metadata-null-page-fix.patch
ufs-truncate-negative-to-unsigned-fix.patch
ufs-rellocation-fix.patch
ufs-rellocation-fix-fix.patch
