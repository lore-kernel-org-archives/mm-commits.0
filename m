Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793393565;
	b=Nl22e5DZzn+dKk8B1g6OQIFSvEIuTKypURWbhs/tRgNHHpAGEu2jxlIxM45YPH1HX1t2
	 d/asd2mEkSZJgMpv3LQphwVsqjpEKvtiqQKMj+YJ2qOz/3lO8/0eWs/FcxGrKUcTB3m8b
	 daIJkEbRFiV2JmKhFO5v8F37Tq1AtHwyGkDUPIwNLP1rU9p0dzOvdqxgv4rAbFNXAoASs
	 6Q6YtJ2JBN6JqQSb9i2Ln7QXqP6clwXTX+EDqsGSdYycNBRD3gTAxE4tbrtGzZsv6AR4y
	 n/UDFO9PEerlOPdRREWJwWsk4e9fjs+Dtizx5v2liO2cFiqkNJ+tqsmcd74EbSh6evw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793393565;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=boqYif9PTnNTsfpaTkHocovHmPSIaJT2dahjhBiXCvc=;
	b=WOgvOSiqNRKbUEM/Kz/ZIwfwpVTQGQKuNSfQYEbBpcdvwcBQeQM7czTvqYxoRXJitFLw
	 XywCTITeiR9IMdoTMOmm458SxEvnVvDXnfWfpC5PONkhZMt7AmJl8ro5HQr73y5mvD5hi
	 kOt3eAxFzu7B1wfOvrf36S/W2nt0+2ZC4HEq/3rIn+wNJdipw/qvjEzXl2jaJWdhzQamp
	 GUhg/d25jWKnWG1vmHTmAjmjHjELDSw7LNuwd1dGDUIQLacxMleMyN3LgMxhsvI4NXIlc
	 XZVFPJQon/Ycommmiog9HOhb3gQC1u1awqMTy9l2n5xUkRkVlgCELPjshGSPOiO/C/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KjJ9xgef;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5300606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 20:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KjJ9xgef
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668281F0093A;
	Fri, 30 Oct 2026 20:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793393564;
	bh=boqYif9PTnNTsfpaTkHocovHmPSIaJT2dahjhBiXCvc=;
	h=Date:To:From:Subject;
	b=KjJ9xgef3oeYIBi8B0u04wO/Cuf/wQ8fFRw3oTN4wFx7vBkaOyuGO6zzrZSvARN6b
	 mKWcLzpRhRezersTbxtZJAmHlN0lkA5Hb9YJoQKpQILK60ZlWIGFahasSP5SgQ6c57
	 PDNC/xwhvsUhWn49PCsSvtHa6+1cAI4cXD8ViPSo=
Date: Fri, 30 Oct 2026 13:52:44 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,nphamcs@gmail.com,
	kasong@tencent.com,hch@lst.de,hannes@cmpxchg.org,chrisl@kernel.org,
	chengming.zhou@linux.dev,alex@ghiti.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-plug-the-writeback-io-of-an-lru-walk.patch added to mm-new branch
Message-Id: <20261030205244.668281F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/zswap: plug the writeback IO of an LRU walk
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-plug-the-writeback-io-of-an-lru-walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-plug-the-writeback-io-of-an-lru-walk.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Alexandre Ghiti <alex@ghiti.fr>
Subject: mm/zswap: plug the writeback IO of an LRU walk
Date: Wed, 07 Oct 2026 17:34:44 +0200

zswap writeback only appends an entry to the pending bio when its slot
directly follows the previous one, and submits the pending bio
otherwise.

Plug the LRU walk so that the block layer can merge what the batch
cannot.

Kernel build (defconfig, -j4) in a 600M memory.max cgroup with the zswap
shrinker enabled, swapping to an NVMe partition with iocost enabled. It
runs alone, and next to a sibling fio random writer with 10 times its
io.weight so that iocost throttles it. Mean +- stddev, counters from the
build's cgroup:

Alone:

                                unplugged       plugged
  build time (s)                1061 +- 2     1057 +- 2   -0.4%
  write requests (k)            622 +- 34     579 +- 21   -6.8%
  pages per write request    1.30 +- 0.02  1.36 +- 0.05   +4.9%
  iocost debt (s)             14.0 +- 2.5   11.0 +- 1.7   -21.6%
  iocost wait (s)              7.7 +- 1.8    7.1 +- 1.1   -7.9%
  IO full pressure (s)        18.3 +- 1.4   17.5 +- 1.3   -4.5%

Next to the writer:

                                unplugged       plugged
  build time (s)               2188 +- 45    2104 +- 75   -3.8%
  write requests (k)            594 +- 21     567 +- 24   -4.6%
  pages per write request    1.30 +- 0.01  1.35 +- 0.02   +3.6%
  iocost debt (s)               648 +- 22     645 +- 29   -0.5%
  iocost wait (s)               624 +- 23     633 +- 29   +1.5%
  IO full pressure (s)          615 +- 31     550 +- 44   -10.6%

Link: https://lore.kernel.org/20261007153507.50715-3-alex@ghiti.fr
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
---

 mm/zswap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/zswap.c~mm-zswap-plug-the-writeback-io-of-an-lru-walk
+++ a/mm/zswap.c
@@ -20,6 +20,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/atomic.h>
+#include <linux/blkdev.h>
 #include <linux/swap_ops.h>
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
@@ -1283,6 +1284,7 @@ static unsigned long zswap_shrinker_scan
 		.encountered_page_in_swapcache = &encountered_page_in_swapcache,
 	};
 	unsigned long shrink_ret;
+	struct blk_plug plug;
 
 	if (!zswap_shrinker_enabled ||
 			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
@@ -1290,10 +1292,12 @@ static unsigned long zswap_shrinker_scan
 		return SHRINK_STOP;
 	}
 
+	blk_start_plug(&plug);
 	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
 		&ctl);
 
 	swap_write_submit(&ctl.io_ctx);
+	blk_finish_plug(&plug);
 
 	if (encountered_page_in_swapcache)
 		return SHRINK_STOP;
@@ -1401,6 +1405,7 @@ static int shrink_memcg(struct mem_cgrou
 {
 	struct zswap_shrink_ctl ctl = {};
 	int nid, shrunk = 0, scanned = 0;
+	struct blk_plug plug;
 
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
@@ -1412,6 +1417,7 @@ static int shrink_memcg(struct mem_cgrou
 	if (memcg && !mem_cgroup_online(memcg))
 		return -ENOENT;
 
+	blk_start_plug(&plug);
 	for_each_node_state(nid, N_NORMAL_MEMORY) {
 		unsigned long nr_to_walk = SWAP_CLUSTER_MAX;
 
@@ -1421,6 +1427,7 @@ static int shrink_memcg(struct mem_cgrou
 	}
 
 	swap_write_submit(&ctl.io_ctx);
+	blk_finish_plug(&plug);
 
 	/* Nothing was scanned: every LRU under @memcg was empty. */
 	if (!scanned)
_

Patches currently in -mm which might be from alex@ghiti.fr are

mm-zswap-batch-the-writeback-io-of-consecutive-entries.patch
mm-zswap-plug-the-writeback-io-of-an-lru-walk.patch

