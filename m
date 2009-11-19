From: akpm@linux-foundation.org
Subject: + x86-optimize-hweight32.patch added to -mm tree
Date: Thu, 19 Nov 2009 14:59:01 -0800
Message-ID: <200911192259.nAJMx1D2030785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757509AbZKSW65 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Nov 2009 17:58:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     x86: optimize hweight32()
has been added to the -mm tree.  Its filename is
     x86-optimize-hweight32.patch

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
Subject: x86: optimize hweight32()
From: Akinobu Mita <akinobu.mita@gmail.com>

Optimize hweight32 by using the same technique in hweight64.  The proof of
this technique can be found in the commit log for
f9b4192923fa6e38331e88214b1fe5fc21583fcc ("bitops: hweight() speedup").

The userspace benchmark on x86_32 showed 20% speedup with bitmap_weight()
which uses hweight32 to count bits for each unsigned long on 32bit
architectures.

int main(void)
{
	#define SZ (1024 * 1024 * 512)

	static DECLARE_BITMAP(bitmap, SZ) = {
	        [0 ... 100] = 1,
	};

	return bitmap_weight(bitmap, SZ);
}

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/hweight.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN lib/hweight.c~x86-optimize-hweight32 lib/hweight.c
--- a/lib/hweight.c~x86-optimize-hweight32
+++ a/lib/hweight.c
@@ -11,11 +11,18 @@
 
 unsigned int hweight32(unsigned int w)
 {
+#ifdef ARCH_HAS_FAST_MULTIPLIER
+	w -= (w >> 1) & 0x55555555;
+	w =  (w & 0x33333333) + ((w >> 2) & 0x33333333);
+	w =  (w + (w >> 4)) & 0x0f0f0f0f;
+	return (w * 0x01010101) >> 24;
+#else
 	unsigned int res = w - ((w >> 1) & 0x55555555);
 	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
 	res = (res + (res >> 4)) & 0x0F0F0F0F;
 	res = res + (res >> 8);
 	return (res + (res >> 16)) & 0x000000FF;
+#endif
 }
 EXPORT_SYMBOL(hweight32);
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
x86-optimize-hweight32.patch
ipath-use-bitmap_weight.patch
ntfs-use-bitmap_weight.patch
hpfs-use-hweight32.patch
hpfs-use-bitmap_weight.patch
qnx4-use-hweight8.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
iommu-helper-use-bitmap-library.patch
isp1362-hcd-use-bitmap_find_next_zero_area.patch
mlx4-use-bitmap_find_next_zero_area.patch
sparc-use-bitmap_find_next_zero_area.patch
ia64-use-bitmap_find_next_zero_area.patch
genalloc-use-bitmap_find_next_zero_area.patch

