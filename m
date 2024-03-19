Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080662031D
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 16:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710866046; cv=none; b=HgVwzXlLj1G0quLeqixcmfilCTLMmPGbFAroFoGIH99ah/6N3qgswNUA+X4cvTrryd1tbMQ68WkhZyCbrExwF6NDo4/tGiZTIowGGuUnUg0tGvZccxFBwDhdX2LllycTd7Ye79qh1nRUE0wHosoSDIk5RrsVOZ5NtNGM7hKkUwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710866046; c=relaxed/simple;
	bh=8a990g1qB+B8jS9WvXbMgqqdY2zdV3iruaGNsvSUUVg=;
	h=Date:To:From:Subject:Message-Id; b=GkeXaz5xBQaEO4cnhTc0D4v8RMVeISBOoQNMyyVEXzrRS1KSH5p5kZXSFd5B9nwcbxNGWkhhSi0dDXX7cPcqw+LC8FEEP+40iKkjgFREjdj3ML5Eu9watiIm3x09hkx7GXFKEIgprNSi8fxgl648QxIaCII2Fb04fOxxPce85t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fxm42bsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fxm42bsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51D4C433C7;
	Tue, 19 Mar 2024 16:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710866045;
	bh=8a990g1qB+B8jS9WvXbMgqqdY2zdV3iruaGNsvSUUVg=;
	h=Date:To:From:Subject:From;
	b=fxm42bsxvMoNkSrw+U2oopqbgpNCp1MJxZGGeTh3jsc88PAi5VfUNyeD/i9NRmfjh
	 E9cIXVksRI9LEljIywaAf7OMm0G63nMlrl5ATJQyJ2x/h1xRvyqdMmvtlVc6NQexuI
	 EbckRnzNAIwc700o3TNOC4E5OOSVnGX1dLx1N/iY=
Date: Tue, 19 Mar 2024 09:34:05 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,ira.weiny@intel.com,hannes@cmpxchg.org,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-kernel-bug-in-sg_init_one.patch added to mm-hotfixes-unstable branch
Message-Id: <20240319163405.B51D4C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: fix kernel BUG in sg_init_one
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-fix-kernel-bug-in-sg_init_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-kernel-bug-in-sg_init_one.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: zswap: fix kernel BUG in sg_init_one
Date: Tue, 19 Mar 2024 12:47:06 +1300

sg_init_one() relies on linearly mapped low memory for the safe
utilization of virt_to_page().  Otherwise, we trigger a kernel BUG,

kernel BUG at include/linux/scatterlist.h:187!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 0 PID: 2997 Comm: syz-executor198 Not tainted 6.8.0-syzkaller #0
Hardware name: ARM-Versatile Express
PC is at sg_set_buf include/linux/scatterlist.h:187 [inline]
PC is at sg_init_one+0x9c/0xa8 lib/scatterlist.c:143
LR is at sg_init_table+0x2c/0x40 lib/scatterlist.c:128
Backtrace:
[<807e16ac>] (sg_init_one) from [<804c1824>] (zswap_decompress+0xbc/0x208 mm/zswap.c:1089)
 r7:83471c80 r6:def6d08c r5:844847d0 r4:ff7e7ef4
[<804c1768>] (zswap_decompress) from [<804c4468>] (zswap_load+0x15c/0x198 mm/zswap.c:1637)
 r9:8446eb80 r8:8446eb80 r7:8446eb84 r6:def6d08c r5:00000001 r4:844847d0
[<804c430c>] (zswap_load) from [<804b9644>] (swap_read_folio+0xa8/0x498 mm/page_io.c:518)
 r9:844ac800 r8:835e6c00 r7:00000000 r6:df955d4c r5:00000001 r4:def6d08c
[<804b959c>] (swap_read_folio) from [<804bb064>] (swap_cluster_readahead+0x1c4/0x34c mm/swap_state.c:684)
 r10:00000000 r9:00000007 r8:df955d4b r7:00000000 r6:00000000 r5:00100cca
 r4:00000001
[<804baea0>] (swap_cluster_readahead) from [<804bb3b8>] (swapin_readahead+0x68/0x4a8 mm/swap_state.c:904)
 r10:df955eb8 r9:00000000 r8:00100cca r7:84476480 r6:00000001 r5:00000000
 r4:00000001
[<804bb350>] (swapin_readahead) from [<8047cde0>] (do_swap_page+0x200/0xcc4 mm/memory.c:4046)
 r10:00000040 r9:00000000 r8:844ac800 r7:84476480 r6:00000001 r5:00000000
 r4:df955eb8
[<8047cbe0>] (do_swap_page) from [<8047e6c4>] (handle_pte_fault mm/memory.c:5301 [inline])
[<8047cbe0>] (do_swap_page) from [<8047e6c4>] (__handle_mm_fault mm/memory.c:5439 [inline])
[<8047cbe0>] (do_swap_page) from [<8047e6c4>] (handle_mm_fault+0x3d8/0x12b8 mm/memory.c:5604)
 r10:00000040 r9:842b3900 r8:7eb0d000 r7:84476480 r6:7eb0d000 r5:835e6c00
 r4:00000254
[<8047e2ec>] (handle_mm_fault) from [<80215d28>] (do_page_fault+0x148/0x3a8 arch/arm/mm/fault.c:326)
 r10:00000007 r9:842b3900 r8:7eb0d000 r7:00000207 r6:00000254 r5:7eb0d9b4
 r4:df955fb0
[<80215be0>] (do_page_fault) from [<80216170>] (do_DataAbort+0x38/0xa8 arch/arm/mm/fault.c:558)
 r10:7eb0da7c r9:00000000 r8:80215be0 r7:df955fb0 r6:7eb0d9b4 r5:00000207
 r4:8261d0e0
[<80216138>] (do_DataAbort) from [<80200e3c>] (__dabt_usr+0x5c/0x60 arch/arm/kernel/entry-armv.S:427)
Exception stack(0xdf955fb0 to 0xdf955ff8)
5fa0:                                     00000000 00000000 22d5f800 0008d158
5fc0: 00000000 7eb0d9a4 00000000 00000109 00000000 00000000 7eb0da7c 7eb0da3c
5fe0: 00000000 7eb0d9a0 00000001 00066bd4 00000010 ffffffff
 r8:824a9044 r7:835e6c00 r6:ffffffff r5:00000010 r4:00066bd4
Code: 1a000004 e1822003 e8860094 e89da8f0 (e7f001f2)
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	1a000004 	bne	0x18
   4:	e1822003 	orr	r2, r2, r3
   8:	e8860094 	stm	r6, {r2, r4, r7}
   c:	e89da8f0 	ldm	sp, {r4, r5, r6, r7, fp, sp, pc}
* 10:	e7f001f2 	udf	#18 <-- trapping instruction

Consequently, we have two choices: either employ kmap_to_page() alongside
sg_set_page(), or resort to copying high memory contents to a temporary
buffer residing in low memory.  However, considering the introduction of
the WARN_ON_ONCE in commit ef6e06b2ef870 ("highmem: fix kmap_to_page() for
kmap_local_page() addresses"), which specifically addresses high memory
concerns, it appears that memcpy remains the sole viable option.

Link: https://lkml.kernel.org/r/20240318234706.95347-1-21cnbao@gmail.com
Fixes: 270700dd06ca ("mm/zswap: remove the memcpy if acomp is not sleepable")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reported-by: syzbot+adbc983a1588b7805de3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000bbb3d80613f243a6@google.com/
Tested-by: syzbot+adbc983a1588b7805de3@syzkaller.appspotmail.com
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-kernel-bug-in-sg_init_one
+++ a/mm/zswap.c
@@ -1080,7 +1080,17 @@ static void zswap_decompress(struct zswa
 	mutex_lock(&acomp_ctx->mutex);
 
 	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
-	if (acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool)) {
+	/*
+	 * If zpool_map_handle is atomic, we cannot reliably utilize its mapped buffer
+	 * to do crypto_acomp_decompress() which might sleep. In such cases, we must
+	 * resort to copying the buffer to a temporary one.
+	 * Meanwhile, zpool_map_handle() might return a non-linearly mapped buffer,
+	 * such as a kmap address of high memory or even ever a vmap address.
+	 * However, sg_init_one is only equipped to handle linearly mapped low memory.
+	 * In such cases, we also must copy the buffer to a temporary and lowmem one.
+	 */
+	if ((acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool)) ||
+	    !virt_addr_valid(src)) {
 		memcpy(acomp_ctx->buffer, src, entry->length);
 		src = acomp_ctx->buffer;
 		zpool_unmap_handle(zpool, entry->handle);
@@ -1094,7 +1104,7 @@ static void zswap_decompress(struct zswa
 	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
 	mutex_unlock(&acomp_ctx->mutex);
 
-	if (!acomp_ctx->is_sleepable || zpool_can_sleep_mapped(zpool))
+	if (src != acomp_ctx->buffer)
 		zpool_unmap_handle(zpool, entry->handle);
 }
 
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-zswap-fix-kernel-bug-in-sg_init_one.patch

