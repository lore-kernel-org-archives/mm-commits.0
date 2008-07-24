From: akpm@linux-foundation.org
Subject: - pm-hibernation-simplify-memory-bitmap.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:25:29 -0700
Message-ID: <200807242325.m6ONPTVs010885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754360AbYGXXZh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:25:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     pm: hibernation: simplify memory bitmap
has been removed from the -mm tree.  Its filename was
     pm-hibernation-simplify-memory-bitmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: hibernation: simplify memory bitmap
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch simplifies the memory bitmap manipulations.

- remove the member size in struct bm_block

It is not necessary for struct bm_block to have the number of bit chunks that
can be calculated by using end_pfn and start_pfn.

- use find_next_bit() for memory_bm_next_pfn

No need to invent the bitmap library only for the memory bitmap.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/snapshot.c |   88 +++++++++-----------------------------
 1 file changed, 21 insertions(+), 67 deletions(-)

diff -puN kernel/power/snapshot.c~pm-hibernation-simplify-memory-bitmap kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~pm-hibernation-simplify-memory-bitmap
+++ a/kernel/power/snapshot.c
@@ -205,8 +205,7 @@ static void chain_free(struct chain_allo
  *	objects.  The main list's elements are of type struct zone_bitmap
  *	and each of them corresonds to one zone.  For each zone bitmap
  *	object there is a list of objects of type struct bm_block that
- *	represent each blocks of bit chunks in which information is
- *	stored.
+ *	represent each blocks of bitmap in which information is stored.
  *
  *	struct memory_bitmap contains a pointer to the main list of zone
  *	bitmap objects, a struct bm_position used for browsing the bitmap,
@@ -224,26 +223,27 @@ static void chain_free(struct chain_allo
  *	pfns that correspond to the start and end of the represented zone.
  *
  *	struct bm_block contains a pointer to the memory page in which
- *	information is stored (in the form of a block of bit chunks
- *	of type unsigned long each).  It also contains the pfns that
- *	correspond to the start and end of the represented memory area and
- *	the number of bit chunks in the block.
+ *	information is stored (in the form of a block of bitmap)
+ *	It also contains the pfns that correspond to the start and end of
+ *	the represented memory area.
  */
 
 #define BM_END_OF_MAP	(~0UL)
 
-#define BM_CHUNKS_PER_BLOCK	(PAGE_SIZE / sizeof(long))
-#define BM_BITS_PER_CHUNK	(sizeof(long) << 3)
 #define BM_BITS_PER_BLOCK	(PAGE_SIZE << 3)
 
 struct bm_block {
 	struct bm_block *next;		/* next element of the list */
 	unsigned long start_pfn;	/* pfn represented by the first bit */
 	unsigned long end_pfn;	/* pfn represented by the last bit plus 1 */
-	unsigned int size;	/* number of bit chunks */
-	unsigned long *data;	/* chunks of bits representing pages */
+	unsigned long *data;	/* bitmap representing pages */
 };
 
+static inline unsigned long bm_block_bits(struct bm_block *bb)
+{
+	return bb->end_pfn - bb->start_pfn;
+}
+
 struct zone_bitmap {
 	struct zone_bitmap *next;	/* next element of the list */
 	unsigned long start_pfn;	/* minimal pfn in this zone */
@@ -257,7 +257,6 @@ struct zone_bitmap {
 struct bm_position {
 	struct zone_bitmap *zone_bm;
 	struct bm_block *block;
-	int chunk;
 	int bit;
 };
 
@@ -272,12 +271,6 @@ struct memory_bitmap {
 
 /* Functions that operate on memory bitmaps */
 
-static inline void memory_bm_reset_chunk(struct memory_bitmap *bm)
-{
-	bm->cur.chunk = 0;
-	bm->cur.bit = -1;
-}
-
 static void memory_bm_position_reset(struct memory_bitmap *bm)
 {
 	struct zone_bitmap *zone_bm;
@@ -285,7 +278,7 @@ static void memory_bm_position_reset(str
 	zone_bm = bm->zone_bm_list;
 	bm->cur.zone_bm = zone_bm;
 	bm->cur.block = zone_bm->bm_blocks;
-	memory_bm_reset_chunk(bm);
+	bm->cur.bit = 0;
 }
 
 static void memory_bm_free(struct memory_bitmap *bm, int clear_nosave_free);
@@ -394,12 +387,10 @@ memory_bm_create(struct memory_bitmap *b
 			bb->start_pfn = pfn;
 			if (nr >= BM_BITS_PER_BLOCK) {
 				pfn += BM_BITS_PER_BLOCK;
-				bb->size = BM_CHUNKS_PER_BLOCK;
 				nr -= BM_BITS_PER_BLOCK;
 			} else {
 				/* This is executed only once in the loop */
 				pfn += nr;
-				bb->size = DIV_ROUND_UP(nr, BM_BITS_PER_CHUNK);
 			}
 			bb->end_pfn = pfn;
 			bb = bb->next;
@@ -478,8 +469,8 @@ static int memory_bm_find_bit(struct mem
 	}
 	zone_bm->cur_block = bb;
 	pfn -= bb->start_pfn;
-	*bit_nr = pfn % BM_BITS_PER_CHUNK;
-	*addr = bb->data + pfn / BM_BITS_PER_CHUNK;
+	*bit_nr = pfn;
+	*addr = bb->data;
 	return 0;
 }
 
@@ -528,36 +519,6 @@ static int memory_bm_test_bit(struct mem
 	return test_bit(bit, addr);
 }
 
-/* Two auxiliary functions for memory_bm_next_pfn */
-
-/* Find the first set bit in the given chunk, if there is one */
-
-static inline int next_bit_in_chunk(int bit, unsigned long *chunk_p)
-{
-	bit++;
-	while (bit < BM_BITS_PER_CHUNK) {
-		if (test_bit(bit, chunk_p))
-			return bit;
-
-		bit++;
-	}
-	return -1;
-}
-
-/* Find a chunk containing some bits set in given block of bits */
-
-static inline int next_chunk_in_block(int n, struct bm_block *bb)
-{
-	n++;
-	while (n < bb->size) {
-		if (bb->data[n])
-			return n;
-
-		n++;
-	}
-	return -1;
-}
-
 /**
  *	memory_bm_next_pfn - find the pfn that corresponds to the next set bit
  *	in the bitmap @bm.  If the pfn cannot be found, BM_END_OF_MAP is
@@ -571,40 +532,33 @@ static unsigned long memory_bm_next_pfn(
 {
 	struct zone_bitmap *zone_bm;
 	struct bm_block *bb;
-	int chunk;
 	int bit;
 
 	do {
 		bb = bm->cur.block;
 		do {
-			chunk = bm->cur.chunk;
 			bit = bm->cur.bit;
-			do {
-				bit = next_bit_in_chunk(bit, bb->data + chunk);
-				if (bit >= 0)
-					goto Return_pfn;
-
-				chunk = next_chunk_in_block(chunk, bb);
-				bit = -1;
-			} while (chunk >= 0);
+			bit = find_next_bit(bb->data, bm_block_bits(bb), bit);
+			if (bit < bm_block_bits(bb))
+				goto Return_pfn;
+
 			bb = bb->next;
 			bm->cur.block = bb;
-			memory_bm_reset_chunk(bm);
+			bm->cur.bit = 0;
 		} while (bb);
 		zone_bm = bm->cur.zone_bm->next;
 		if (zone_bm) {
 			bm->cur.zone_bm = zone_bm;
 			bm->cur.block = zone_bm->bm_blocks;
-			memory_bm_reset_chunk(bm);
+			bm->cur.bit = 0;
 		}
 	} while (zone_bm);
 	memory_bm_position_reset(bm);
 	return BM_END_OF_MAP;
 
  Return_pfn:
-	bm->cur.chunk = chunk;
-	bm->cur.bit = bit;
-	return bb->start_pfn + chunk * BM_BITS_PER_CHUNK + bit;
+	bm->cur.bit = bit + 1;
+	return bb->start_pfn + bit;
 }
 
 /**
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer-fix.patch
workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
firmware-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer-fix.patch
dcdbas-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer-fix.patch
dell_rbu-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer-fix.patch

