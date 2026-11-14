Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794694248;
	b=ywAmjqAJ9enxTvZYkwqD8wcmCLrqmwPyx/EUxO4/5mySmDzHuke8px9LNpiQLFldraMJ
	 h8t18lnTVlASZyk2m6OiGGCdFo1IeF1q2hHcKqQPzyORvdSSW6UklY3iHX6Ngcr2TdC6H
	 a7tWfdakFRNPMFbX44GUl/tP2GcNYsY0n/vJ4OUXgD5FDQ9WNOmSCDKDFWgVrxO+MXzsX
	 2vmNanSMgY91GeoEpd7ia/hzbvSY8/csn3niwVnYquvXDzJXT3v4GV6vE4NGfT+AsKCbo
	 Ic8ws3Qr/BPoo190CpHOQFsD7wmAekYi7beo82KA1i+0MK1EqsgkseysOR2H6Nf3HNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794694248;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=oQYt97GvkNNNepdgahkKEaBNgp4DCTlAtxVNgKhO+NY=;
	b=gaVsADVMTv8w1W6xsWYrmyhYkIRbEakfI6Xi6meiWy69D+rH24Ui/oVsgjA7Of9hepwF
	 opKvKsdBmfdTa3RlpHI1gF+1LrlfQFjOPnBXcT4Y2Z1xuOcW7EF9VxDoFtdinUJYBjfft
	 dXi/g1UYUzQjjbNjfdRaidEhI17tayP0sY3LM4KSBnZEHf7uryh4o9Jn/I1k/7tKYw2df
	 JriNEmGmUTLIqUac6XjkwNaMbYaNj8q27KBN1boAS1U7bJRHzGlAChnNTZKUW5qv4dNfa
	 VOeRLjXQBqBy9ggWg+NO69GWyJLhT/TRUyfrEoULWEjPc7ddObAQIcK2dkN+7Xshi7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Zdx/VwGG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00001606A32E
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 22:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Zdx/VwGG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2A01F000C4;
	Sat, 14 Nov 2026 22:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794694247;
	bh=oQYt97GvkNNNepdgahkKEaBNgp4DCTlAtxVNgKhO+NY=;
	h=Date:To:From:Subject;
	b=Zdx/VwGGf70Vk6fhyDUuAT4rPMuys5QT5nxZi3bZ4m2zHFFrBuJSwzcfDaVmoCQ3N
	 DYjuqKuq+rF9f4fgXufnRgva6OmbjNZ3Y4Lb5vWgTokMzuuJws7ctR9RAZBaE3qS3J
	 bWOvT3WWPJu157VXw1w8qdPArzXmgjEsXSVVuFAQ=
Date: Sat, 14 Nov 2026 14:10:47 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch added to mm-new branch
Message-Id: <20261114221047.7E2A01F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: lift youngest gen protection for higher priority
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: lift youngest gen protection for higher priority
Date: Sun, 15 Nov 2026 04:07:55 +0800

The forced protection of younger generations contradicts the
goal of minimizing the I/O cost of reclaim. Under high memory
pressure, MGLRU can repeatedly trigger premature OOMs, while
the classic LRU does not.
The problem is that aging may fail to keep up with reclaim.
When this happens, reclaimers may all abort prematurely
because they see only empty generations or just two
generations remaining.
Proactive aging does not solve this problem either. The
number of threads performing proactive aging is limited,
while the number of concurrent reclaimers can be much
larger. This is a fundamental limitation of MGLRU. One
possible solution is to use an aging lock. However, the
aging lock introduces significant jitter under heavy memory
pressure and has been reported to cause noticeable lags
on Android.
Furthermore, the generation-based reclaim model can
conflict with the goal of swappiness, which is to minimize
I/O cost rather than blindly follow folio hotness.
The previous commit allowed reclaimers running at
non-default priorities to reclaim up to `lrugen->max_seq`,
while reclaimers at the default priority could reclaim only
up to `lrugen->min_seq`.
This patch further refines generation protection based on
reclaim priority. At the default priority, reclaimers can
reclaim generations down to `lrugen->max_seq - MIN_NR_GENS`.
As reclaim priority increases, reclaimers are progressively
allowed to reclaim younger generations.
With this graduated protection, premature OOMs are no
longer observed, while swappiness is also respected.

Link: https://lore.kernel.org/20261114200803.23129-9-baohua@kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <hui.zhu@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: wang lian <lianux.mm@gmail.com>
Cc: <liuxiang.277@bytedance.com>
Cc: <lyugaofei@xiaomi.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hui Zhu <zhuhui@kylinos.cn>
Cc: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: Kunwu Chan <chentao@kylinos.cn>
Cc: Bo Zhang <zhangbo0325@gmail.com>

 mm/vmscan.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-mglru-lift-youngest-gen-protection-for-higher-priority
+++ a/mm/vmscan.c
@@ -4772,12 +4772,14 @@ static int scan_folios(unsigned long nr_
 	VM_WARN_ON_ONCE(!list_empty(list));
 
 	/*
-	 * Respect the gen hotness distribution at low priority to avoid
-	 * aging and scan cost, but prefer to satisfy the reclaimers request
-	 * when under pressure to respect swappiness more and reduce IO cost.
+	 * Respect hotness at default priority, and only reach into the
+	 * newest generation when under severe pressure, so hot folios are
+	 * not evicted as soon as priority is raised.
 	 */
 	if (sc->priority == DEF_PRIORITY)
-		seq = lrugen->min_seq[type];
+		seq = lrugen->max_seq - MIN_NR_GENS;
+	else if (sc->priority > DEF_PRIORITY / 2)
+		seq = lrugen->max_seq - 1;
 	else
 		seq = lrugen->max_seq;
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-report-evictable-sizes-per-type.patch
mm-mglru-extract-lruvec_populated_min_seq-helper.patch
mm-mglru-reclaim-from-the-oldest-populated-gen.patch
mm-mglru-lift-the-forced-protection-of-reclaimer.patch
mm-mglru-skip-zones-above-reclaim_idx-instead-of-rotating-them.patch
mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch
mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch

