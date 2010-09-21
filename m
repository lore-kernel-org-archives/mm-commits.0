From: akpm@linux-foundation.org
Subject: + mm-strictly-nested-kmap_atomic.patch added to -mm tree
Date: Tue, 21 Sep 2010 16:02:45 -0700
Message-ID: <201009212302.o8LN2jOf007955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394Ab0IUXEV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 19:04:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, cmetcalf@tilera.com, davem@davemloft.net, dhowells@redhat.com, hpa@zytor.com, hughd@google.com, mingo@elte.hu, paulus@samba.org, ralf@linux-mips.org, riel@redhat.com, rmk@arm.linux.org.uk, rostedt@goodmis.org, tglx@linutronix.de


The patch titled
     mm: strictly nested kmap_atomic()
has been added to the -mm tree.  Its filename is
     mm-strictly-nested-kmap_atomic.patch

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
Subject: mm: strictly nested kmap_atomic()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Ensure kmap_atomic() usage is strictly nested

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Miller <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/async_tx/async_memcpy.c |    2 +-
 crypto/blkcipher.c             |    2 +-
 drivers/block/loop.c           |    4 ++--
 include/linux/highmem.h        |    4 ++--
 kernel/power/snapshot.c        |    4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff -puN crypto/async_tx/async_memcpy.c~mm-strictly-nested-kmap_atomic crypto/async_tx/async_memcpy.c
--- a/crypto/async_tx/async_memcpy.c~mm-strictly-nested-kmap_atomic
+++ a/crypto/async_tx/async_memcpy.c
@@ -83,8 +83,8 @@ async_memcpy(struct page *dest, struct p
 
 		memcpy(dest_buf, src_buf, len);
 
-		kunmap_atomic(dest_buf, KM_USER0);
 		kunmap_atomic(src_buf, KM_USER1);
+		kunmap_atomic(dest_buf, KM_USER0);
 
 		async_tx_sync_epilog(submit);
 	}
diff -puN crypto/blkcipher.c~mm-strictly-nested-kmap_atomic crypto/blkcipher.c
--- a/crypto/blkcipher.c~mm-strictly-nested-kmap_atomic
+++ a/crypto/blkcipher.c
@@ -89,9 +89,9 @@ static inline unsigned int blkcipher_don
 		memcpy(walk->dst.virt.addr, walk->page, n);
 		blkcipher_unmap_dst(walk);
 	} else if (!(walk->flags & BLKCIPHER_WALK_PHYS)) {
-		blkcipher_unmap_src(walk);
 		if (walk->flags & BLKCIPHER_WALK_DIFF)
 			blkcipher_unmap_dst(walk);
+		blkcipher_unmap_src(walk);
 	}
 
 	scatterwalk_advance(&walk->in, n);
diff -puN drivers/block/loop.c~mm-strictly-nested-kmap_atomic drivers/block/loop.c
--- a/drivers/block/loop.c~mm-strictly-nested-kmap_atomic
+++ a/drivers/block/loop.c
@@ -101,8 +101,8 @@ static int transfer_none(struct loop_dev
 	else
 		memcpy(raw_buf, loop_buf, size);
 
-	kunmap_atomic(raw_buf, KM_USER0);
 	kunmap_atomic(loop_buf, KM_USER1);
+	kunmap_atomic(raw_buf, KM_USER0);
 	cond_resched();
 	return 0;
 }
@@ -130,8 +130,8 @@ static int transfer_xor(struct loop_devi
 	for (i = 0; i < size; i++)
 		*out++ = *in++ ^ key[(i & 511) % keysize];
 
-	kunmap_atomic(raw_buf, KM_USER0);
 	kunmap_atomic(loop_buf, KM_USER1);
+	kunmap_atomic(raw_buf, KM_USER0);
 	cond_resched();
 	return 0;
 }
diff -puN include/linux/highmem.h~mm-strictly-nested-kmap_atomic include/linux/highmem.h
--- a/include/linux/highmem.h~mm-strictly-nested-kmap_atomic
+++ a/include/linux/highmem.h
@@ -201,8 +201,8 @@ static inline void copy_user_highpage(st
 	vfrom = kmap_atomic(from, KM_USER0);
 	vto = kmap_atomic(to, KM_USER1);
 	copy_user_page(vto, vfrom, vaddr, to);
-	kunmap_atomic(vfrom, KM_USER0);
 	kunmap_atomic(vto, KM_USER1);
+	kunmap_atomic(vfrom, KM_USER0);
 }
 
 #endif
@@ -214,8 +214,8 @@ static inline void copy_highpage(struct 
 	vfrom = kmap_atomic(from, KM_USER0);
 	vto = kmap_atomic(to, KM_USER1);
 	copy_page(vto, vfrom);
-	kunmap_atomic(vfrom, KM_USER0);
 	kunmap_atomic(vto, KM_USER1);
+	kunmap_atomic(vfrom, KM_USER0);
 }
 
 #endif /* _LINUX_HIGHMEM_H */
diff -puN kernel/power/snapshot.c~mm-strictly-nested-kmap_atomic kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~mm-strictly-nested-kmap_atomic
+++ a/kernel/power/snapshot.c
@@ -984,8 +984,8 @@ static void copy_data_page(unsigned long
 		src = kmap_atomic(s_page, KM_USER0);
 		dst = kmap_atomic(d_page, KM_USER1);
 		do_copy_page(dst, src);
-		kunmap_atomic(src, KM_USER0);
 		kunmap_atomic(dst, KM_USER1);
+		kunmap_atomic(src, KM_USER0);
 	} else {
 		if (PageHighMem(d_page)) {
 			/* Page pointed to by src may contain some kernel
@@ -2273,8 +2273,8 @@ swap_two_pages_data(struct page *p1, str
 	memcpy(buf, kaddr1, PAGE_SIZE);
 	memcpy(kaddr1, kaddr2, PAGE_SIZE);
 	memcpy(kaddr2, buf, PAGE_SIZE);
-	kunmap_atomic(kaddr1, KM_USER0);
 	kunmap_atomic(kaddr2, KM_USER1);
+	kunmap_atomic(kaddr1, KM_USER0);
 }
 
 /**
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
mm-strictly-nested-kmap_atomic.patch
mm-stack-based-kmap_atomic.patch
mm-remove-pte_map_nested.patch
perf-x86-fix-up-kmap_atomic-type.patch
mm-highmem-documentation.patch
kernel-remove-pf_flusher.patch

