From: akpm@linux-foundation.org
Subject: + bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch added to -mm tree
Date: Fri, 09 Oct 2009 16:43:50 -0700
Message-ID: <200910092343.n99NhoAo030590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934621AbZJIXpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 19:45:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, LW@KARO-electronics.de, benh@kernel.crashing.org, davem@davemloft.net, fenghua.yu@intel.com, fujita.tomonori@lab.ntt.co.jp, gregkh@suse.de, hpa@zytor.com, joerg.roedel@amd.com, mingo@redhat.com, paulus@samba.org, rolandd@cisco.com, tglx@linutronix.de, tony.luck@intel.com, yevgenyp@mellanox.co.il


The patch titled
     bitmap: introduce bitmap_set(), bitmap_clear(), bitmap_find_next_zero_area()
has been added to the -mm tree.  Its filename is
     bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch

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
Subject: bitmap: introduce bitmap_set(), bitmap_clear(), bitmap_find_next_zero_area()
From: Akinobu Mita <akinobu.mita@gmail.com>

This introduces new bitmap functions:

bitmap_set: Set specified bit area
bitmap_clear: Clear specified bit area
bitmap_find_next_zero_area: Find free bit area

These are stolen from iommu helper.

I changed the return value of bitmap_find_next_zero_area if there is
no zero area.

find_next_zero_area in iommu helper: returns -1
bitmap_find_next_zero_area: return >= bitmap size

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Lothar Wassmann <LW@KARO-electronics.de>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/bitmap.h~bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area
+++ a/include/linux/bitmap.h
@@ -42,6 +42,9 @@
  * bitmap_empty(src, nbits)			Are all bits zero in *src?
  * bitmap_full(src, nbits)			Are all bits set in *src?
  * bitmap_weight(src, nbits)			Hamming Weight: number set bits
+ * bitmap_set(dst, pos, nbits)			Set specified bit area
+ * bitmap_clear(dst, pos, nbits)		Clear specified bit area
+ * bitmap_find_next_zero_area(buf, len, pos, n, mask)	Find bit free area
  * bitmap_shift_right(dst, src, n, nbits)	*dst = *src >> n
  * bitmap_shift_left(dst, src, n, nbits)	*dst = *src << n
  * bitmap_remap(dst, src, old, new, nbits)	*dst = map(old, new)(src)
@@ -108,6 +111,14 @@ extern int __bitmap_subset(const unsigne
 			const unsigned long *bitmap2, int bits);
 extern int __bitmap_weight(const unsigned long *bitmap, int bits);
 
+extern void bitmap_set(unsigned long *map, int i, int len);
+extern void bitmap_clear(unsigned long *map, int start, int nr);
+extern unsigned long bitmap_find_next_zero_area(unsigned long *map,
+					 unsigned long size,
+					 unsigned long start,
+					 unsigned int nr,
+					 unsigned long align_mask);
+
 extern int bitmap_scnprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
 extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
diff -puN lib/bitmap.c~bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area lib/bitmap.c
--- a/lib/bitmap.c~bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area
+++ a/lib/bitmap.c
@@ -271,6 +271,53 @@ int __bitmap_weight(const unsigned long 
 }
 EXPORT_SYMBOL(__bitmap_weight);
 
+void bitmap_set(unsigned long *map, int i, int len)
+{
+	int end = i + len;
+
+	while (i < end) {
+		__set_bit(i, map);
+		i++;
+	}
+}
+EXPORT_SYMBOL(bitmap_set);
+
+void bitmap_clear(unsigned long *map, int start, int nr)
+{
+	int end = start + nr;
+
+	while (start < end) {
+		__clear_bit(start, map);
+		start++;
+	}
+}
+EXPORT_SYMBOL(bitmap_clear);
+
+unsigned long bitmap_find_next_zero_area(unsigned long *map,
+					 unsigned long size,
+					 unsigned long start,
+					 unsigned int nr,
+					 unsigned long align_mask)
+{
+	unsigned long index, end, i;
+again:
+	index = find_next_zero_bit(map, size, start);
+
+	/* Align allocation */
+	index = (index + align_mask) & ~align_mask;
+
+	end = index + nr;
+	if (end >= size)
+		return end;
+	i = find_next_bit(map, end, index);
+	if (i < end) {
+		start = i + 1;
+		goto again;
+	}
+	return index;
+}
+EXPORT_SYMBOL(bitmap_find_next_zero_area);
+
 /*
  * Bitmap printing & parsing functions: first version by Bill Irwin,
  * second version by Paul Jackson, third by Joe Korty.
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

iommu-helper-simplify-find_next_zero_area.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
iommu-helper-use-bitmap-library.patch
isp1362-hcd-use-bitmap_find_next_zero_area.patch
mlx4-use-bitmap_find_next_zero_area.patch
sparc-use-bitmap_find_next_zero_area.patch
ia64-use-bitmap_find_next_zero_area.patch
genalloc-use-bitmap_find_next_zero_area.patch

