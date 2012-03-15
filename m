From: akpm@linux-foundation.org
Subject: + radix-tree-introduce-bit-optimized-iterator.patch added to -mm tree
Date: Wed, 14 Mar 2012 17:44:28 -0700
Message-ID: <20120315004428.71E14A0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:48051 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031349Ab2COAob (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Mar 2012 20:44:31 -0400
Received: by yenq2 with SMTP id q2so405879yen.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Mar 2012 17:44:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hch@lst.de, hughd@google.com, torvalds@linux-foundation.org


The patch titled
     Subject: radix-tree: introduce bit-optimized iterator
has been added to the -mm tree.  Its filename is
     radix-tree-introduce-bit-optimized-iterator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: radix-tree: introduce bit-optimized iterator

A series of radix tree cleanups, and usage of them in the core pagecache
code.

Micro-benchmark:

lookup 14 slots (typical page-vector size)
in radix-tree there earch <step> slot filled and tagged
before/after - nsec per full scan through tree

* Intel Sandy Bridge i7-2620M 4Mb L3
New code always faster

* AMD Athlon 6000+ 2x1Mb L2, without L3
New code generally faster,
Minor degradation (marked with "*") for huge sparse trees

* i386 on Sandy Bridge
New code faster for common cases: tagged and dense trees.
Some degradations for non-tagged lookup on sparse trees.

Ideally, there might help __ffs() analog for searching first non-zero
long element in array, gcc sometimes cannot optimize this loop corretly.

Numbers:

CPU: Intel Sandy Bridge i7-2620M 4Mb L3

radix-tree with 1024 slots:

tagged lookup

step  1      before  7156        after  3613
step  2      before  5399        after  2696
step  3      before  4779        after  1928
step  4      before  4456        after  1429
step  5      before  4292        after  1213
step  6      before  4183        after  1052
step  7      before  4157        after  951
step  8      before  4016        after  812
step  9      before  3952        after  851
step  10     before  3937        after  732
step  11     before  4023        after  709
step  12     before  3872        after  657
step  13     before  3892        after  633
step  14     before  3720        after  591
step  15     before  3879        after  578
step  16     before  3561        after  513

normal lookup

step  1      before  4266       after  3301
step  2      before  2695       after  2129
step  3      before  2083       after  1712
step  4      before  1801       after  1534
step  5      before  1628       after  1313
step  6      before  1551       after  1263
step  7      before  1475       after  1185
step  8      before  1432       after  1167
step  9      before  1373       after  1092
step  10     before  1339       after  1134
step  11     before  1292       after  1056
step  12     before  1319       after  1030
step  13     before  1276       after  1004
step  14     before  1256       after  987
step  15     before  1228       after  992
step  16     before  1247       after  999

radix-tree with 1024*1024*128 slots:

tagged lookup

step  1      before  1086102841  after  674196409
step  2      before  816839155   after  498138306
step  7      before  599728907   after  240676762
step  15     before  555729253   after  185219677
step  63     before  606637748   after  128585664
step  64     before  608384432   after  102945089
step  65     before  596987114   after  123996019
step  128    before  304459225   after  56783056
step  256    before  158846855   after  31232481
step  512    before  86085652    after  18950595
step  12345  before  6517189     after  1674057

normal lookup

step  1      before  626064869  after  544418266
step  2      before  418809975  after  336321473
step  7      before  242303598  after  207755560
step  15     before  208380563  after  176496355
step  63     before  186854206  after  167283638
step  64     before  176188060  after  170143976
step  65     before  185139608  after  167487116
step  128    before  88181865   after  86913490
step  256    before  45733628   after  45143534
step  512    before  24506038   after  23859036
step  12345  before  2177425    after  2018662

* AMD Athlon 6000+ 2x1Mb L2, without L3

radix-tree with 1024 slots:

tag-lookup

step  1      before  8164        after  5379
step  2      before  5818        after  5581
step  3      before  4959        after  4213
step  4      before  4371        after  3386
step  5      before  4204        after  2997
step  6      before  4950        after  2744
step  7      before  4598        after  2480
step  8      before  4251        after  2288
step  9      before  4262        after  2243
step  10     before  4175        after  2131
step  11     before  3999        after  2024
step  12     before  3979        after  1994
step  13     before  3842        after  1929
step  14     before  3750        after  1810
step  15     before  3735        after  1810
step  16     before  3532        after  1660

normal-lookup

step  1      before  7875        after  5847
step  2      before  4808        after  4071
step  3      before  4073        after  3462
step  4      before  3677        after  3074
step  5      before  4308        after  2978
step  6      before  3911        after  3807
step  7      before  3635        after  3522
step  8      before  3313        after  3202
step  9      before  3280        after  3257
step  10     before  3166        after  3083
step  11     before  3066        after  3026
step  12     before  2985        after  2982
step  13     before  2925        after  2924
step  14     before  2834        after  2808
step  15     before  2805        after  2803
step  16     before  2647        after  2622

radix-tree with 1024*1024*128 slots:

tag-lookup

step  1      before  1288059720  after  951736580
step  2      before  961292300   after  884212140
step  7      before  768905140   after  547267580
step  15     before  771319480   after  456550640
step  63     before  504847640   after  242704304
step  64     before  392484800   after  177920786
step  65     before  491162160   after  246895264
step  128    before  208084064   after  97348392
step  256    before  112401035   after  51408126
step  512    before  75825834    after  29145070
step  12345  before  5603166     after  2847330

normal-lookup

step  1      before  1025677120  after  861375100
step  2      before  647220080   after  572258540
step  7      before  505518960   after  484041813
step  15     before  430483053   after  444815320	*
step  63     before  388113453   after  404250546	*
step  64     before  374154666   after  396027440	*
step  65     before  381423973   after  396704853	*
step  128    before  190078700   after  202619384	*
step  256    before  100886756   after  102829108	*
step  512    before  64074505    after  56158720
step  12345  before  4237289     after  4422299		*


* i686 on Sandy bridge

radix-tree with 1024 slots:

tagged lookup

step  1      before  7990        after  4019
step  2      before  5698        after  2897
step  3      before  5013        after  2475
step  4      before  4630        after  1721
step  5      before  4346        after  1759
step  6      before  4299        after  1556
step  7      before  4098        after  1513
step  8      before  4115        after  1222
step  9      before  3983        after  1390
step  10     before  4077        after  1207
step  11     before  3921        after  1231
step  12     before  3894        after  1116
step  13     before  3840        after  1147
step  14     before  3799        after  1090
step  15     before  3797        after  1059
step  16     before  3783        after  745

normal lookup

step  1      before  5103       after  3499
step  2      before  3299       after  2550
step  3      before  2489       after  2370
step  4      before  2034       after  2302		*
step  5      before  1846       after  2268		*
step  6      before  1752       after  2249		*
step  7      before  1679       after  2164		*
step  8      before  1627       after  2153		*
step  9      before  1542       after  2095		*
step  10     before  1479       after  2109		*
step  11     before  1469       after  2009		*
step  12     before  1445       after  2039		*
step  13     before  1411       after  2013		*
step  14     before  1374       after  2046		*
step  15     before  1340       after  1975		*
step  16     before  1331       after  2000		*

radix-tree with 1024*1024*128 slots:

tagged lookup

step  1      before  1225865377  after  667153553
step  2      before  842427423   after  471533007
step  7      before  609296153   after  276260116
step  15     before  544232060   after  226859105
step  63     before  519209199   after  141343043
step  64     before  588980279   after  141951339
step  65     before  521099710   after  138282060
step  128    before  298476778   after  83390628
step  256    before  149358342   after  43602609
step  512    before  76994713    after  22911077
step  12345  before  5328666     after  1472111

normal lookup

step  1      before  819284564  after  533635310
step  2      before  512421605  after  364956155
step  7      before  271443305  after  305721345	*
step  15     before  223591630  after  273960216	*
step  63     before  190320247  after  217770207	*
step  64     before  178538168  after  267411372	*
step  65     before  186400423  after  215347937	*
step  128    before  88106045   after  140540612	*
step  256    before  44812420   after  70660377		*
step  512    before  24435438   after  36328275		*
step  12345  before  2123924    after  2148062		*


bloat-o-meter delta for this patchset + patchset with related shmem cleanups

bloat-o-meter: x86_64

add/remove: 4/3 grow/shrink: 5/6 up/down: 928/-939 (-11)
function                                     old     new   delta
radix_tree_next_chunk                          -     499    +499
shmem_unuse                                  428     554    +126
shmem_radix_tree_replace                     131     227     +96
find_get_pages_tag                           354     419     +65
find_get_pages_contig                        345     407     +62
find_get_pages                               362     396     +34
__kstrtab_radix_tree_next_chunk                -      22     +22
__ksymtab_radix_tree_next_chunk                -      16     +16
__kcrctab_radix_tree_next_chunk                -       8      +8
radix_tree_gang_lookup_slot                  204     203      -1
static.shmem_xattr_set                       384     381      -3
radix_tree_gang_lookup_tag_slot              208     191     -17
radix_tree_gang_lookup                       231     187     -44
radix_tree_gang_lookup_tag                   247     199     -48
shmem_unlock_mapping                         278     190     -88
__lookup                                     217       -    -217
__lookup_tag                                 242       -    -242
radix_tree_locate_item                       279       -    -279

bloat-o-meter: i386

add/remove: 3/3 grow/shrink: 8/9 up/down: 1075/-1275 (-200)
function                                     old     new   delta
radix_tree_next_chunk                          -     757    +757
shmem_unuse                                  352     449     +97
find_get_pages_contig                        269     322     +53
shmem_radix_tree_replace                     113     154     +41
find_get_pages_tag                           277     318     +41
dcache_dir_lseek                             426     458     +32
__kstrtab_radix_tree_next_chunk                -      22     +22
vc_do_resize                                 968     977      +9
snd_pcm_lib_read1                            725     733      +8
__ksymtab_radix_tree_next_chunk                -       8      +8
netlbl_cipsov4_list                         1120    1127      +7
find_get_pages                               293     291      -2
new_slab                                     467     459      -8
bitfill_unaligned_rev                        425     417      -8
radix_tree_gang_lookup_tag_slot              177     146     -31
blk_dump_cmd                                 267     229     -38
radix_tree_gang_lookup_slot                  212     134     -78
shmem_unlock_mapping                         221     128     -93
radix_tree_gang_lookup_tag                   275     162    -113
radix_tree_gang_lookup                       255     126    -129
__lookup                                     227       -    -227
__lookup_tag                                 271       -    -271
radix_tree_locate_item                       277       -    -277



This patch:

Implement a clean, simple and effective radix-tree iteration routine.

Iterating divided into two phases:
* lookup next chunk in radix-tree leaf node
* iterating through slots in this chunk

Main iterator function radix_tree_next_chunk() returns pointer to first
slot, and stores in the struct radix_tree_iter index of next-to-last slot.
 For tagged-iterating it also constuct bitmask of tags for retunted chunk.
 All additional logic implemented as static-inline functions and macroses.

Also adds radix_tree_find_next_bit() static-inline variant of
find_next_bit() optimized for small constant size arrays, because
find_next_bit() too heavy for searching in an array with one/two long
elements.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Tested-by: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |  139 +++++++++++++++++++++++++++++++++
 lib/radix-tree.c           |  147 +++++++++++++++++++++++++++++++++++
 2 files changed, 286 insertions(+)

diff -puN include/linux/radix-tree.h~radix-tree-introduce-bit-optimized-iterator include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-introduce-bit-optimized-iterator
+++ a/include/linux/radix-tree.h
@@ -2,6 +2,7 @@
  * Copyright (C) 2001 Momchil Velikov
  * Portions Copyright (C) 2001 Christoph Hellwig
  * Copyright (C) 2006 Nick Piggin
+ * Copyright (C) 2012 Konstantin Khlebnikov
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -257,4 +258,142 @@ static inline void radix_tree_preload_en
 	preempt_enable();
 }
 
+struct radix_tree_iter {
+	unsigned long	index;		/* current index, do not overflow it */
+	unsigned long	next_index;	/* next-to-last index for this chunk */
+	unsigned long	tags;		/* bitmask for tag-iterating */
+};
+
+#define RADIX_TREE_ITER_TAG_MASK	0x00FF	/* tag index in lower byte */
+#define RADIX_TREE_ITER_TAGGED		0x0100	/* lookup tagged slots */
+#define RADIX_TREE_ITER_CONTIG		0x0200	/* stop at first hole */
+
+void **radix_tree_next_chunk(struct radix_tree_root *root,
+			     struct radix_tree_iter *iter, unsigned flags);
+
+static inline
+void **radix_tree_iter_init(struct radix_tree_iter *iter, unsigned long start)
+{
+	iter->index = 0; /* to bypass next_index overflow protection */
+	iter->next_index = start;
+	return NULL;
+}
+
+static inline unsigned long radix_tree_chunk_size(struct radix_tree_iter *iter)
+{
+	return iter->next_index - iter->index;
+}
+
+/**
+ * radix_tree_next_slot - find next slot in chunk
+ *
+ * @slot	pointer to slot
+ * @iter	iterator state
+ * @flags	RADIX_TREE_ITER_*
+ *
+ * Returns pointer to next slot, or NULL if no more left.
+ */
+static __always_inline
+void **radix_tree_next_slot(void **slot, struct radix_tree_iter *iter,
+			    unsigned flags)
+{
+	unsigned size, offset;
+
+	size = radix_tree_chunk_size(iter) - 1;
+	if (flags & RADIX_TREE_ITER_TAGGED) {
+		iter->tags >>= 1;
+		if (likely(iter->tags & 1ul)) {
+			iter->index++;
+			return slot + 1;
+		}
+		if ((flags & RADIX_TREE_ITER_CONTIG) && size)
+			return NULL;
+		if (likely(iter->tags)) {
+			offset = __ffs(iter->tags);
+			iter->tags >>= offset;
+			iter->index += offset + 1;
+			return slot + offset + 1;
+		}
+	} else {
+		while (size--) {
+			slot++;
+			iter->index++;
+			if (likely(*slot))
+				return slot;
+			if (flags & RADIX_TREE_ITER_CONTIG)
+				return NULL;
+		}
+	}
+	return NULL;
+}
+
+/**
+ * radix_tree_for_each_chunk - iterate over chunks
+ *
+ * @slot:	the void** for pointer to chunk first slot
+ * @root	the struct radix_tree_root pointer
+ * @iter	the struct radix_tree_iter pointer
+ * @start	starting index
+ * @flags	RADIX_TREE_ITER_* and tag index
+ *
+ * Locks can be released and reasquired between iterations.
+ */
+#define radix_tree_for_each_chunk(slot, root, iter, start, flags)	\
+	for ( slot = radix_tree_iter_init(iter, start) ;		\
+	      (slot = radix_tree_next_chunk(root, iter, flags)) ; )
+
+/**
+ * radix_tree_for_each_chunk_slot - iterate over slots in one chunk
+ *
+ * @slot:	the void** for pointer to slot
+ * @iter	the struct radix_tree_iter pointer
+ * @flags	RADIX_TREE_ITER_*
+ */
+#define radix_tree_for_each_chunk_slot(slot, iter, flags)	\
+	for ( ; slot ; slot = radix_tree_next_slot(slot, iter, flags) )
+
+/**
+ * radix_tree_for_each_slot - iterate over all slots
+ *
+ * @slot:	the void** for pointer to slot
+ * @root	the struct radix_tree_root pointer
+ * @iter	the struct radix_tree_iter pointer
+ * @start	starting index
+ */
+#define radix_tree_for_each_slot(slot, root, iter, start)	\
+	for ( slot = radix_tree_iter_init(iter, start) ;	\
+	      slot || (slot = radix_tree_next_chunk(root, iter, 0)) ; \
+	      slot = radix_tree_next_slot(slot, iter, 0) )
+
+/**
+ * radix_tree_for_each_contig - iterate over all contiguous slots
+ *
+ * @slot:	the void** for pointer to slot
+ * @root	the struct radix_tree_root pointer
+ * @iter	the struct radix_tree_iter pointer
+ * @start	starting index
+ */
+#define radix_tree_for_each_contig(slot, root, iter, start)		\
+	for ( slot = radix_tree_iter_init(iter, start) ;		\
+	      slot || (slot = radix_tree_next_chunk(root, iter,		\
+				RADIX_TREE_ITER_CONTIG)) ;		\
+	      slot = radix_tree_next_slot(slot, iter,			\
+				RADIX_TREE_ITER_CONTIG) )
+
+/**
+ * radix_tree_for_each_tagged - iterate over all tagged slots
+ *
+ * @slot:	the void** for pointer to slot
+ * @root	the struct radix_tree_root pointer
+ * @iter	the struct radix_tree_iter pointer
+ * @start	starting index
+ * @tag		tag index
+ */
+#define radix_tree_for_each_tagged(slot, root, iter, start, tag)	\
+	for ( slot = radix_tree_iter_init(iter, start) ;		\
+	      slot || (slot = radix_tree_next_chunk(root, iter,		\
+			      RADIX_TREE_ITER_TAGGED | tag)) ;		\
+	      slot = radix_tree_next_slot(slot, iter,			\
+				RADIX_TREE_ITER_TAGGED) )
+
 #endif /* _LINUX_RADIX_TREE_H */
diff -puN lib/radix-tree.c~radix-tree-introduce-bit-optimized-iterator lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-introduce-bit-optimized-iterator
+++ a/lib/radix-tree.c
@@ -3,6 +3,7 @@
  * Portions Copyright (C) 2001 Christoph Hellwig
  * Copyright (C) 2005 SGI, Christoph Lameter
  * Copyright (C) 2006 Nick Piggin
+ * Copyright (C) 2012 Konstantin Khlebnikov
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -146,6 +147,41 @@ static inline int any_tag_set(struct rad
 	}
 	return 0;
 }
+
+/**
+ * radix_tree_find_next_bit - find the next set bit in a memory region
+ * @addr: The address to base the search on
+ * @size: The bitmap size in bits
+ * @offset: The bitnumber to start searching at
+ *
+ * Unrollable variant of find_next_bit() for constant size arrays.
+ * Tail bits starting from size to roundup(size, BITS_PER_LONG) must be zero.
+ * Returns next bit offset, or size if nothing found.
+ */
+static inline unsigned long radix_tree_find_next_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset)
+{
+	if (!__builtin_constant_p(size))
+		return find_next_bit(addr, size, offset);
+
+	if (offset < size) {
+		unsigned long tmp;
+
+		addr += offset / BITS_PER_LONG;
+		tmp = *addr >> (offset % BITS_PER_LONG);
+		if (tmp)
+			return __ffs(tmp) + offset;
+		offset = (offset + BITS_PER_LONG) & ~(BITS_PER_LONG - 1);
+		while (offset < size) {
+			tmp = *++addr;
+			if (tmp)
+				return __ffs(tmp) + offset;
+			offset += BITS_PER_LONG;
+		}
+	}
+	return size;
+}
+
 /*
  * This assumes that the caller has performed appropriate preallocation, and
  * that the caller has pinned this thread of control to the current CPU.
@@ -613,6 +649,117 @@ int radix_tree_tag_get(struct radix_tree
 EXPORT_SYMBOL(radix_tree_tag_get);
 
 /**
+ * radix_tree_next_chunk - find next chunk of slots for iteration
+ *
+ * @root:		radix tree root
+ * @iter:		iterator state
+ * @flags		RADIX_TREE_ITER_* flags and tag index
+ *
+ * Returns pointer to first slots in chunk, or NULL if there no more left
+ */
+void **radix_tree_next_chunk(struct radix_tree_root *root,
+			     struct radix_tree_iter *iter, unsigned flags)
+{
+	unsigned shift, tag = flags & RADIX_TREE_ITER_TAG_MASK;
+	struct radix_tree_node *rnode, *node;
+	unsigned long i, index;
+
+	if ((flags & RADIX_TREE_ITER_TAGGED) && !root_tag_get(root, tag))
+		return NULL;
+
+	/*
+	 * Catch next_index overflow after ~0UL.
+	 * iter->index can be zero only at the beginning.
+	 * Because RADIX_TREE_MAP_SHIFT < BITS_PER_LONG we cannot
+	 * oveflow iter->next_index in single step.
+	 */
+	index = iter->next_index;
+	if (!index && iter->index)
+		return NULL;
+
+	rnode = rcu_dereference_raw(root->rnode);
+	if (radix_tree_is_indirect_ptr(rnode)) {
+		rnode = indirect_to_ptr(rnode);
+	} else if (rnode && !index) {
+		/* Single-slot tree */
+		iter->index = 0;
+		iter->next_index = 1;
+		iter->tags = 1;
+		return (void **)&root->rnode;
+	} else
+		return NULL;
+
+restart:
+	shift = (rnode->height - 1) * RADIX_TREE_MAP_SHIFT;
+	i = index >> shift;
+
+	/* Index ouside of the tree */
+	if (i >= RADIX_TREE_MAP_SIZE)
+		return NULL;
+
+	node = rnode;
+	while (1) {
+		if ((flags & RADIX_TREE_ITER_TAGGED) ?
+				!test_bit(i, node->tags[tag]) :
+				!node->slots[i]) {
+			/* Hole detected */
+			if (flags & RADIX_TREE_ITER_CONTIG)
+				return NULL;
+
+			if (flags & RADIX_TREE_ITER_TAGGED)
+				i = radix_tree_find_next_bit(node->tags[tag],
+						RADIX_TREE_MAP_SIZE, i + 1);
+			else
+				while (++i < RADIX_TREE_MAP_SIZE &&
+						!node->slots[i]);
+
+			index &= ~((RADIX_TREE_MAP_SIZE << shift) - 1);
+			index += i << shift;
+			/* Overflow after ~0UL */
+			if (!index)
+				return NULL;
+			if (i == RADIX_TREE_MAP_SIZE)
+				goto restart;
+		}
+
+		/* This is leaf-node */
+		if (!shift)
+			break;
+
+		node = rcu_dereference_raw(node->slots[i]);
+		if (node == NULL)
+			goto restart;
+		shift -= RADIX_TREE_MAP_SHIFT;
+		i = (index >> shift) & RADIX_TREE_MAP_MASK;
+	}
+
+	/* Update the iterator state */
+	iter->index = index;
+	iter->next_index = (index | RADIX_TREE_MAP_MASK) + 1;
+
+	/* Construct iter->tags bitmask from node->tags[tag] array */
+	if (flags & RADIX_TREE_ITER_TAGGED) {
+		unsigned tag_long, tag_bit;
+
+		tag_long = i / BITS_PER_LONG;
+		tag_bit  = i % BITS_PER_LONG;
+		iter->tags = node->tags[tag][tag_long] >> tag_bit;
+		/* This never happens if RADIX_TREE_TAG_LONGS == 1 */
+		if (tag_long < RADIX_TREE_TAG_LONGS - 1) {
+			/* Pick tags from next element */
+			if (tag_bit)
+				iter->tags |= node->tags[tag][tag_long + 1] <<
+						(BITS_PER_LONG - tag_bit);
+			/* Clip chunk size, here only BITS_PER_LONG tags */
+			iter->next_index = index + BITS_PER_LONG;
+		}
+	}
+
+	return node->slots + i;
+}
+EXPORT_SYMBOL(radix_tree_next_chunk);
+
+/**
  * radix_tree_range_tag_if_tagged - for each item in given range set given
  *				   tag if item has another tag set
  * @root:		radix tree root
_
Subject: Subject: radix-tree: introduce bit-optimized iterator

Patches currently in -mm which might be from khlebnikov@openvz.org are

memcg-free-mem_cgroup-by-rcu-to-fix-oops.patch
linux-next.patch
mm-add-rss-counters-consistency-check.patch
mm-make-get_mm_counter-static-inline.patch
mm-replace-page_migration-with-is_enabledconfig_migration.patch
mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
memcg-remove-pcg_cache-page_cgroup-flag-fix.patch
memcg-kill-dead-prev_priority-stubs.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-checkpatch-fixes.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch

