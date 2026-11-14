Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794694257;
	b=o5iwPIaTeomnaLIiWqdpUw4rxOgYcI1RrWomp5KvHrUtAOIB6cNjuV5GlXQJDBoHQHCa
	 4OWcajXLnd6MNZp7pdplkiJalrWvQq1rTysxVhcxLxvT3YpX7OXAmBR1p0rx5IouaRj1O
	 sKXvv6oZxag6GO8mJxk0OOpRkvx4lHJeVyDOzALLoenH2L2MegwTDPNLEamNtxkR6NU2l
	 i+fShhD5IWMOKe3aoeO1quoGEw1RUzEb6yjZz97DNVC8UNuQzsDPekO4tI7b7mbY0RwP3
	 IOwIR3jvreWmqtNzX65OT6E7SXg7puRm4xBd02zdckTb5cOkmOX1bryWeY7ty32MQ7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794694257;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=F00K4XYeZTYXm/Z1GcWNaPgBJlTfB42E9BUx9qMyBSQ=;
	b=QpuZMtSYRM+DpnX1A4EUKODT9oxVhyeuEdwsZnfs+KyPDBPyNEK2SJ8cauoB/IZua6hX
	 pdd7pEciBlbRnAMpl81aZnhJ1bJVjD5bR+cbGAyNEBJBWAIa5LFoq3uvdnTTZ0bzqopBn
	 ALP/mw1YjSRrhfh6m+aEY9FHZB0hLF+Ifcw0SrEFF+ZykAH0enzRPlu96VBxeqGX/6sgD
	 sbgXPnwP2q6kiAzEMD4JkxREtiTxOURaGenaMH1IAuQoZnyPesomV9rQvrXvca3imW0/O
	 awdsHi7PBJWtguMVH3Z1+gR26hNfvNo1afyEgxPmiYxNRVSyuJGMu+QnQ5NKbsVCKtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CRtT+Tvn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D18606A323
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 22:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CRtT+Tvn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148BA1F000C4;
	Sat, 14 Nov 2026 22:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794694257;
	bh=F00K4XYeZTYXm/Z1GcWNaPgBJlTfB42E9BUx9qMyBSQ=;
	h=Date:To:From:Subject;
	b=CRtT+TvnG9BnGHnIIS/mBJq9BVgbthr291B1hgcT2txdXz5mCs0X68URd0AkDLBaR
	 cHN5Ngrngoq0VNj5LwLoMAofdaIVwwYIXzEgdU0C2iaiXkssw+Fs25+VRJAeCWNmQm
	 hjUbxevcHUP/gDqDWjql1gEkPkMWx+GsN5MThcXM=
Date: Sat, 14 Nov 2026 14:10:56 -0800
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-run-aging-when-one-type-is-drained-fix.patch added to mm-new branch
Message-Id: <20261114221057.148BA1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Date: Sun, 15 Nov 2026 10:24:32 +1300
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-run-aging-when-one-type-is-drained-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-run-aging-when-one-type-is-drained-fix.patch

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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Date: Sun, 15 Nov 2026 10:24:32 +1300
Subject: [PATCH] Fix-mm-mglru-Run-aging-when-one-type-is-drained.patch

address Sashiko issues

Link: https://lore.kernel.org/20261114214438.70148-1-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/sashiko-outbox-215014@kernel.org
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <hui.zhu@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: wang lian <lianux.mm@gmail.com>
Cc: <liuxiang.277@bytedance.com>
Cc: <lyugaofei@xiaomi.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hui Zhu <zhuhui@kylinos.cn>

 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-run-aging-when-one-type-is-drained-fix
+++ a/mm/vmscan.c
@@ -4788,6 +4788,9 @@ static int scan_folios(unsigned long nr_
 		seq = lrugen->max_seq;
 
 	seq = lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
+	if (seq < lrugen->min_seq[type])
+		return 0;
+
 	*scanned_seq = seq;
 	gen = lru_gen_from_seq(seq);
 	max_gen = lru_gen_from_seq(max_seq);
@@ -5273,7 +5276,7 @@ static bool try_to_shrink_lruvec(struct
 
 		if (!scanned) {
 			/* Retry once if aging advanced max_seq */
-			if (retried || new_seq == READ_ONCE(lruvec->lrugen.max_seq))
+			if (retried || max_seq == READ_ONCE(lruvec->lrugen.max_seq))
 				break;
 			retried = true;
 		}
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch
mm-mglru-avoid-placing-rejected-folios-below-populated-gen.patch
mm-mglru-run-aging-when-one-type-is-drained.patch
mm-mglru-run-aging-when-one-type-is-drained-fix.patch
mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch
mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch
mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

