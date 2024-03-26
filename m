Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CD16F07B
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476498; cv=none; b=TU5ZsyRHnWzU7kWrcluwo5R5Q3fTlvyNWFMX8T+RYfda8KChmeYKCllGS15B9p9JAw9I4nhUA6vNmp0MVBFrmmrPdUSrb4GgqUYBvFfUm3LE+W5h/XUIaJf8NFCdTPNra109/hkWBK1lWsTtgTFG8fwdOM/KJiPQEa/AxoSspoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476498; c=relaxed/simple;
	bh=dbs4KYsB1T2oR8OFfM49VB3/8zck2HbcFQBXTPQt10U=;
	h=Date:To:From:Subject:Message-Id; b=G7SOi5deZKmCtoJg2HFlYU0hwCHx9tU3+YqOVe3icmIFHY+7Hwzms8E5piDWK0AsWpNT3kVK3bGmGgR8hgUZb0p3OHm/00un8IzsB8jEdQ4TXY2YDtjgMrdA4A45Qv1LwAw/JQ6fULfSQsgjfxQhgZvqg5+RZBRQ4GjJAhU/LF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LUVzCdzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LUVzCdzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5F8C433F1;
	Tue, 26 Mar 2024 18:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476498;
	bh=dbs4KYsB1T2oR8OFfM49VB3/8zck2HbcFQBXTPQt10U=;
	h=Date:To:From:Subject:From;
	b=LUVzCdzCQGNHh7p1E3tRdX2E9+F/eW23Sh/lZQ0OsRlrt6jM6Bxt153l5o5wUuMlf
	 MqU2YTu+4lIjbWmbMIf5HGNTg5gsqszd5qPnAhz5yU2591YbGWtzzJyyNDk3IGvSAd
	 Kw6sTsgucI4pXDrvTVfpwRqV1ZF87YEmRY4R1GWI=
Date: Tue, 26 Mar 2024 11:08:17 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,ira.weiny@intel.com,hannes@cmpxchg.org,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zswap-fix-kernel-bug-in-sg_init_one.patch removed from -mm tree
Message-Id: <20240326180818.0F5F8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: fix kernel BUG in sg_init_one
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-kernel-bug-in-sg_init_one.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

arm64-mm-swap-support-thp_swap-on-hardware-with-mte.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch
documentation-coding-style-ask-function-like-macros-to-evaluate-parameters.patch

