From: akpm@linux-foundation.org
Subject: [merged]
 bitmap-cpumask-nodemask-remove-dedicated-formatting-functions.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:59 -0800
Message-ID: <54e2503b.NJoMflVQR7bmH2Xq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbbBPURf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap, cpumask, nodemask: remove dedicated formatting functions
has been removed from the -mm tree.  Its filename was
     bitmap-cpumask-nodemask-remove-dedicated-formatting-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: bitmap, cpumask, nodemask: remove dedicated formatting functions

Now that all bitmap formatting usages have been converted to
'%*pb[l]', the separate formatting functions are unnecessary.  The
following functions are removed.

* bitmap_scn[list]printf()
* cpumask_scnprintf(), cpulist_scnprintf()
* [__]nodemask_scnprintf(), [__]nodelist_scnprintf()
* seq_bitmap[_list](), seq_cpumask[_list](), seq_nodemask[_list]()
* seq_buf_bitmask()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |   32 ----------------------------
 include/linux/bitmap.h   |    7 ------
 include/linux/cpumask.h  |   31 ---------------------------
 include/linux/nodemask.h |   33 ++++++-----------------------
 include/linux/seq_buf.h  |    3 --
 include/linux/seq_file.h |   25 ----------------------
 lib/bitmap.c             |   41 -------------------------------------
 lib/seq_buf.c            |   36 --------------------------------
 8 files changed, 7 insertions(+), 201 deletions(-)

diff -puN fs/seq_file.c~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions fs/seq_file.c
--- a/fs/seq_file.c~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions
+++ a/fs/seq_file.c
@@ -539,38 +539,6 @@ int seq_dentry(struct seq_file *m, struc
 	return res;
 }
 
-int seq_bitmap(struct seq_file *m, const unsigned long *bits,
-				   unsigned int nr_bits)
-{
-	if (m->count < m->size) {
-		int len = bitmap_scnprintf(m->buf + m->count,
-				m->size - m->count, bits, nr_bits);
-		if (m->count + len < m->size) {
-			m->count += len;
-			return 0;
-		}
-	}
-	seq_set_overflow(m);
-	return -1;
-}
-EXPORT_SYMBOL(seq_bitmap);
-
-int seq_bitmap_list(struct seq_file *m, const unsigned long *bits,
-		unsigned int nr_bits)
-{
-	if (m->count < m->size) {
-		int len = bitmap_scnlistprintf(m->buf + m->count,
-				m->size - m->count, bits, nr_bits);
-		if (m->count + len < m->size) {
-			m->count += len;
-			return 0;
-		}
-	}
-	seq_set_overflow(m);
-	return -1;
-}
-EXPORT_SYMBOL(seq_bitmap_list);
-
 static void *single_start(struct seq_file *p, loff_t *pos)
 {
 	return NULL + (*pos == 0);
diff -puN include/linux/bitmap.h~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions
+++ a/include/linux/bitmap.h
@@ -52,16 +52,13 @@
  * bitmap_bitremap(oldbit, old, new, nbits)	newbit = map(old, new)(oldbit)
  * bitmap_onto(dst, orig, relmap, nbits)	*dst = orig relative to relmap
  * bitmap_fold(dst, orig, sz, nbits)		dst bits = orig bits mod sz
- * bitmap_scnprintf(buf, len, src, nbits)	Print bitmap src to buf
  * bitmap_parse(buf, buflen, dst, nbits)	Parse bitmap dst from kernel buf
  * bitmap_parse_user(ubuf, ulen, dst, nbits)	Parse bitmap dst from user buf
- * bitmap_scnlistprintf(buf, len, src, nbits)	Print bitmap src as list to buf
  * bitmap_parselist(buf, dst, nbits)		Parse bitmap dst from kernel buf
  * bitmap_parselist_user(buf, dst, nbits)	Parse bitmap dst from user buf
  * bitmap_find_free_region(bitmap, bits, order)	Find and allocate bit region
  * bitmap_release_region(bitmap, pos, order)	Free specified bit region
  * bitmap_allocate_region(bitmap, pos, order)	Allocate specified bit region
- * bitmap_print_to_pagebuf(list, buf, mask, nbits) Print bitmap src as list/hex
  */
 
 /*
@@ -147,14 +144,10 @@ bitmap_find_next_zero_area(unsigned long
 					      align_mask, 0);
 }
 
-extern int bitmap_scnprintf(char *buf, unsigned int len,
-			const unsigned long *src, int nbits);
 extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
 			unsigned long *dst, int nbits);
 extern int bitmap_parse_user(const char __user *ubuf, unsigned int ulen,
 			unsigned long *dst, int nbits);
-extern int bitmap_scnlistprintf(char *buf, unsigned int len,
-			const unsigned long *src, int nbits);
 extern int bitmap_parselist(const char *buf, unsigned long *maskp,
 			int nmaskbits);
 extern int bitmap_parselist_user(const char __user *ubuf, unsigned int ulen,
diff -puN include/linux/cpumask.h~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions include/linux/cpumask.h
--- a/include/linux/cpumask.h~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions
+++ a/include/linux/cpumask.h
@@ -547,21 +547,6 @@ static inline void cpumask_copy(struct c
 #define cpumask_of(cpu) (get_cpu_mask(cpu))
 
 /**
- * cpumask_scnprintf - print a cpumask into a string as comma-separated hex
- * @buf: the buffer to sprintf into
- * @len: the length of the buffer
- * @srcp: the cpumask to print
- *
- * If len is zero, returns zero.  Otherwise returns the length of the
- * (nul-terminated) @buf string.
- */
-static inline int cpumask_scnprintf(char *buf, int len,
-				    const struct cpumask *srcp)
-{
-	return bitmap_scnprintf(buf, len, cpumask_bits(srcp), nr_cpu_ids);
-}
-
-/**
  * cpumask_parse_user - extract a cpumask from a user string
  * @buf: the buffer to extract from
  * @len: the length of the buffer
@@ -591,22 +576,6 @@ static inline int cpumask_parselist_user
 }
 
 /**
- * cpulist_scnprintf - print a cpumask into a string as comma-separated list
- * @buf: the buffer to sprintf into
- * @len: the length of the buffer
- * @srcp: the cpumask to print
- *
- * If len is zero, returns zero.  Otherwise returns the length of the
- * (nul-terminated) @buf string.
- */
-static inline int cpulist_scnprintf(char *buf, int len,
-				    const struct cpumask *srcp)
-{
-	return bitmap_scnlistprintf(buf, len, cpumask_bits(srcp),
-				    nr_cpu_ids);
-}
-
-/**
  * cpumask_parse - extract a cpumask from from a string
  * @buf: the buffer to extract from
  * @dstp: the cpumask to set.
diff -puN include/linux/nodemask.h~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions include/linux/nodemask.h
--- a/include/linux/nodemask.h~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions
+++ a/include/linux/nodemask.h
@@ -8,14 +8,13 @@
  * See detailed comments in the file linux/bitmap.h describing the
  * data type on which these nodemasks are based.
  *
- * For details of nodemask_scnprintf() and nodemask_parse_user(),
- * see bitmap_scnprintf() and bitmap_parse_user() in lib/bitmap.c.
- * For details of nodelist_scnprintf() and nodelist_parse(), see
- * bitmap_scnlistprintf() and bitmap_parselist(), also in bitmap.c.
- * For details of node_remap(), see bitmap_bitremap in lib/bitmap.c.
- * For details of nodes_remap(), see bitmap_remap in lib/bitmap.c.
- * For details of nodes_onto(), see bitmap_onto in lib/bitmap.c.
- * For details of nodes_fold(), see bitmap_fold in lib/bitmap.c.
+ * For details of nodemask_parse_user(), see bitmap_parse_user() in
+ * lib/bitmap.c.  For details of nodelist_parse(), see bitmap_parselist(),
+ * also in bitmap.c.  For details of node_remap(), see bitmap_bitremap in
+ * lib/bitmap.c.  For details of nodes_remap(), see bitmap_remap in
+ * lib/bitmap.c.  For details of nodes_onto(), see bitmap_onto in
+ * lib/bitmap.c.  For details of nodes_fold(), see bitmap_fold in
+ * lib/bitmap.c.
  *
  * The available nodemask operations are:
  *
@@ -52,9 +51,7 @@
  * NODE_MASK_NONE			Initializer - no bits set
  * unsigned long *nodes_addr(mask)	Array of unsigned long's in mask
  *
- * int nodemask_scnprintf(buf, len, mask) Format nodemask for printing
  * int nodemask_parse_user(ubuf, ulen, mask)	Parse ascii string as nodemask
- * int nodelist_scnprintf(buf, len, mask) Format nodemask as list for printing
  * int nodelist_parse(buf, map)		Parse ascii string as nodelist
  * int node_remap(oldbit, old, new)	newbit = map(old, new)(oldbit)
  * void nodes_remap(dst, src, old, new)	*dst = map(old, new)(src)
@@ -312,14 +309,6 @@ static inline int __first_unset_node(con
 
 #define nodes_addr(src) ((src).bits)
 
-#define nodemask_scnprintf(buf, len, src) \
-			__nodemask_scnprintf((buf), (len), &(src), MAX_NUMNODES)
-static inline int __nodemask_scnprintf(char *buf, int len,
-					const nodemask_t *srcp, int nbits)
-{
-	return bitmap_scnprintf(buf, len, srcp->bits, nbits);
-}
-
 #define nodemask_parse_user(ubuf, ulen, dst) \
 		__nodemask_parse_user((ubuf), (ulen), &(dst), MAX_NUMNODES)
 static inline int __nodemask_parse_user(const char __user *buf, int len,
@@ -328,14 +317,6 @@ static inline int __nodemask_parse_user(
 	return bitmap_parse_user(buf, len, dstp->bits, nbits);
 }
 
-#define nodelist_scnprintf(buf, len, src) \
-			__nodelist_scnprintf((buf), (len), &(src), MAX_NUMNODES)
-static inline int __nodelist_scnprintf(char *buf, int len,
-					const nodemask_t *srcp, int nbits)
-{
-	return bitmap_scnlistprintf(buf, len, srcp->bits, nbits);
-}
-
 #define nodelist_parse(buf, dst) __nodelist_parse((buf), &(dst), MAX_NUMNODES)
 static inline int __nodelist_parse(const char *buf, nodemask_t *dstp, int nbits)
 {
diff -puN include/linux/seq_buf.h~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions include/linux/seq_buf.h
--- a/include/linux/seq_buf.h~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions
+++ a/include/linux/seq_buf.h
@@ -125,9 +125,6 @@ extern int seq_buf_putmem_hex(struct seq
 			      unsigned int len);
 extern int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc);
 
-extern int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
-			   int nmaskbits);
-
 #ifdef CONFIG_BINARY_PRINTF
 extern int
 seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary);
diff -puN include/linux/seq_file.h~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions include/linux/seq_file.h
--- a/include/linux/seq_file.h~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions
+++ a/include/linux/seq_file.h
@@ -126,31 +126,6 @@ int seq_path(struct seq_file *, const st
 int seq_dentry(struct seq_file *, struct dentry *, const char *);
 int seq_path_root(struct seq_file *m, const struct path *path,
 		  const struct path *root, const char *esc);
-int seq_bitmap(struct seq_file *m, const unsigned long *bits,
-				   unsigned int nr_bits);
-static inline int seq_cpumask(struct seq_file *m, const struct cpumask *mask)
-{
-	return seq_bitmap(m, cpumask_bits(mask), nr_cpu_ids);
-}
-
-static inline int seq_nodemask(struct seq_file *m, nodemask_t *mask)
-{
-	return seq_bitmap(m, mask->bits, MAX_NUMNODES);
-}
-
-int seq_bitmap_list(struct seq_file *m, const unsigned long *bits,
-		unsigned int nr_bits);
-
-static inline int seq_cpumask_list(struct seq_file *m,
-				   const struct cpumask *mask)
-{
-	return seq_bitmap_list(m, cpumask_bits(mask), nr_cpu_ids);
-}
-
-static inline int seq_nodemask_list(struct seq_file *m, nodemask_t *mask)
-{
-	return seq_bitmap_list(m, mask->bits, MAX_NUMNODES);
-}
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_open_size(struct file *, int (*)(struct seq_file *, void *), void *, size_t);
diff -puN lib/bitmap.c~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions lib/bitmap.c
--- a/lib/bitmap.c~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions
+++ a/lib/bitmap.c
@@ -370,24 +370,6 @@ EXPORT_SYMBOL(bitmap_find_next_zero_area
 #define BASEDEC 10		/* fancier cpuset lists input in decimal */
 
 /**
- * bitmap_scnprintf - convert bitmap to an ASCII hex string.
- * @buf: byte buffer into which string is placed
- * @buflen: reserved size of @buf, in bytes
- * @maskp: pointer to bitmap to convert
- * @nmaskbits: size of bitmap, in bits
- *
- * Exactly @nmaskbits bits are displayed.  Hex digits are grouped into
- * comma-separated sets of eight digits per set.  Returns the number of
- * characters which were written to *buf, excluding the trailing \0.
- */
-int bitmap_scnprintf(char *buf, unsigned int buflen,
-	const unsigned long *maskp, int nmaskbits)
-{
-	return scnprintf(buf, buflen, "%*pb", nmaskbits, maskp);
-}
-EXPORT_SYMBOL(bitmap_scnprintf);
-
-/**
  * __bitmap_parse - convert an ASCII hex string into a bitmap.
  * @buf: pointer to buffer containing string.
  * @buflen: buffer size in bytes.  If string is smaller than this
@@ -501,29 +483,6 @@ int bitmap_parse_user(const char __user
 EXPORT_SYMBOL(bitmap_parse_user);
 
 /**
- * bitmap_scnlistprintf - convert bitmap to list format ASCII string
- * @buf: byte buffer into which string is placed
- * @buflen: reserved size of @buf, in bytes
- * @maskp: pointer to bitmap to convert
- * @nmaskbits: size of bitmap, in bits
- *
- * Output format is a comma-separated list of decimal numbers and
- * ranges.  Consecutively set bits are shown as two hyphen-separated
- * decimal numbers, the smallest and largest bit numbers set in
- * the range.  Output format is compatible with the format
- * accepted as input by bitmap_parselist().
- *
- * The return value is the number of characters which were written to *buf
- * excluding the trailing '\0', as per ISO C99's scnprintf.
- */
-int bitmap_scnlistprintf(char *buf, unsigned int buflen,
-	const unsigned long *maskp, int nmaskbits)
-{
-	return scnprintf(buf, buflen, "%*pbl", nmaskbits, maskp);
-}
-EXPORT_SYMBOL(bitmap_scnlistprintf);
-
-/**
  * bitmap_print_to_pagebuf - convert bitmap to list or hex format ASCII string
  * @list: indicates whether the bitmap must be list
  * @buf: page aligned buffer into which string is placed
diff -puN lib/seq_buf.c~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions lib/seq_buf.c
--- a/lib/seq_buf.c~bitmap-cpumask-nodemask-remove-dedicated-formatting-functions
+++ a/lib/seq_buf.c
@@ -91,42 +91,6 @@ int seq_buf_printf(struct seq_buf *s, co
 	return ret;
 }
 
-/**
- * seq_buf_bitmask - write a bitmask array in its ASCII representation
- * @s:		seq_buf descriptor
- * @maskp:	points to an array of unsigned longs that represent a bitmask
- * @nmaskbits:	The number of bits that are valid in @maskp
- *
- * Writes a ASCII representation of a bitmask string into @s.
- *
- * Returns zero on success, -1 on overflow.
- */
-int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
-		    int nmaskbits)
-{
-	unsigned int len = seq_buf_buffer_left(s);
-	int ret;
-
-	WARN_ON(s->size == 0);
-
-	/*
-	 * Note, because bitmap_scnprintf() only returns the number of bytes
-	 * written and not the number that would be written, we use the last
-	 * byte of the buffer to let us know if we overflowed. There's a small
-	 * chance that the bitmap could have fit exactly inside the buffer, but
-	 * it's not that critical if that does happen.
-	 */
-	if (len > 1) {
-		ret = bitmap_scnprintf(s->buffer + s->len, len, maskp, nmaskbits);
-		if (ret < len) {
-			s->len += ret;
-			return 0;
-		}
-	}
-	seq_buf_set_overflow(s);
-	return -1;
-}
