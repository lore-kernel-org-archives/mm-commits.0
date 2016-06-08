From: akpm@linux-foundation.org
Subject: + bitmap-bitmap_equal-memcmp-optimization-fix.patch added to -mm
 tree
Date: Wed, 08 Jun 2016 13:42:24 -0700
Message-ID: <57588330.zPSkUJUHc7rG/9ff%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423655AbcFHUmZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2016 16:42:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dahi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap-bitmap_equal-memcmp-optimization-fix
has been added to the -mm tree.  Its filename is
     bitmap-bitmap_equal-memcmp-optimization-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-bitmap_equal-memcmp-optimization-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-bitmap_equal-memcmp-optimization-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bitmap-bitmap_equal-memcmp-optimization-fix

remove two unneeded `else's

Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN include/linux/bitmap.h~bitmap-bitmap_equal-memcmp-optimization-fix include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-bitmap_equal-memcmp-optimization-fix
+++ a/include/linux/bitmap.h
@@ -266,13 +266,12 @@ static inline int bitmap_equal(const uns
 			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
-		return ! ((*src1 ^ *src2) & BITMAP_LAST_WORD_MASK(nbits));
+		return !((*src1 ^ *src2) & BITMAP_LAST_WORD_MASK(nbits));
 #ifdef CONFIG_S390
-	else if (__builtin_constant_p(nbits) && (nbits % BITS_PER_LONG) == 0)
+	if (__builtin_constant_p(nbits) && (nbits % BITS_PER_LONG) == 0)
 		return !memcmp(src1, src2, nbits / 8);
 #endif
-	else
-		return __bitmap_equal(src1, src2, nbits);
+	return __bitmap_equal(src1, src2, nbits);
 }
 
 static inline int bitmap_intersects(const unsigned long *src1,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

