Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794693554;
	b=K3t4Ce8i8IHaS+1C3tdAcTH8lnSyVpZM3OimVMopfqpA/Ecvjylte8Sq1BtHCA/CxNEP
	 IR3ifWzR3MUc7djSMEx7eGTUP455qIUPg/s9GX4FAAgNdZ/3gWcwKAEMh3x3/XO+Hll5N
	 bTjpO53dXxkDvNv/yBPmnwk1nDYJGb2y9dfuhW3ukirkO3OK2NuSCNdNFpXRyiZl4uoiz
	 6fDLHiRzC9io6/G8TXCJwio7RMvrNggyLDqAH+qgyfNmzthp5tKhmYhd92m0cofQIOuUP
	 Gqg9T/Juh4V4VXb/pEW+d3wP1bZ4LgxUc+yWk5Jg25D/0uCbpo3uEN94h2T4s3rmhBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794693554;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=xGtmvJvY+0OYx7Ii8oZGOWic3juOni74uTshBs2tAbQ=;
	b=1b0sZ6CYKsRiA24Sb/VhZmx8mo7EH4WCfMpa8nwsjYir8FNcDDIsMNoTZa09+zAaKETc
	 HSPh+cPFdtpY5VWE2zdTEztl2TtX2Ayt03ev5fmUFwO2c8zZVI2h44UIzEOH8fiIKaOtr
	 Fdr+cm1bYO2KluEmumtCZXxndHSB/XnRttIQTn7u3vY/59UlAuAI4oINNvirTvbQFLd+H
	 qfe1JRuwtjXC2Z32ICv0JF/4fWwBou30NhGXTxThNTNoTqEEm8JOOU+GZ6trt18IQ8HRQ
	 lZNXMNoNZ4v419qdNwBHAkjvC9fYTTjsptMPKH7YlI0nkz5mo4//dDQs6Sr5eLUnxIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Y/kTleMJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EBC606A323
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 21:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y/kTleMJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724901F000C4;
	Sat, 14 Nov 2026 21:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794693554;
	bh=xGtmvJvY+0OYx7Ii8oZGOWic3juOni74uTshBs2tAbQ=;
	h=Date:To:From:Subject;
	b=Y/kTleMJVmmoRw0RA+/IRcoi02n7luBn+XlthnCtZxMgqZzB9xGdztNRDUTUPWBD9
	 tojbJPzqsOlxdPp/UL9NLvz/l0NxnZ8hnts4dDJYnMA8L7lY/VoC1/4oq+a3uUgdi+
	 Xf7Ep6+J2N9+GnJYkmKrBL9HZ/yH0QmJuB4ZukCg=
Date: Sat, 14 Nov 2026 13:59:14 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch removed from -mm tree
Message-Id: <20261114215914.724901F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: lift youngest gen protection for higher priority
has been removed from the -mm tree.  Its filename was
     mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: lift youngest gen protection for higher priority
Date: Sat, 14 Nov 2026 02:55:33 +0800

The forced protection of younger generations contradicts the goal of
minimizing the I/O cost of reclaim.  Under high memory pressure, MGLRU can
repeatedly trigger premature OOMs, while the classic LRU does not.

The problem is that aging may fail to keep up with reclaim.  When this
happens, reclaimers may all abort prematurely because they see only empty
generations or just two generations remaining.

Proactive aging does not solve this problem either.  The number of threads
performing proactive aging is limited, while the number of concurrent
reclaimers can be much larger.  This is a fundamental limitation of MGLRU.
One possible solution is to use an aging lock.  However, the aging lock
introduces significant jitter under heavy memory pressure and has been
reported to cause noticeable lags on Android.

Furthermore, the generation-based reclaim model can conflict with the goal
of swappiness, which is to minimize I/O cost rather than blindly follow
folio hotness.  The previous commit allowed reclaimers running at
non-default priorities to reclaim up to `lrugen->max_seq`, while
reclaimers at the default priority could reclaim only up to
`lrugen->min_seq`.

This patch further refines generation protection based on reclaim
priority.  At the default priority, reclaimers can reclaim generations
down to `lrugen->max_seq - MIN_NR_GENS`.  As reclaim priority increases,
reclaimers are progressively allowed to reclaim younger generations.  With
this graduated protection, premature OOMs are no longer observed, while
swappiness is also respected.

Link: https://lore.kernel.org/20261113185541.70203-9-baohua@kernel.org
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
---

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


