Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415113;
	b=cJhGGXmQ2+J1pE5dwcI+9mggaFCayB4P+0sDk1p6aUa32MvQbQeOiwsg78YXLWCvMdds
	 B3mvmsh+PZRhG4pdFiLQtER5HdvRl4JV9spe5u1I5J9MNWbUlY5DTo0Htht5JUpS++GcW
	 0pvUZ/N2Gfablbh4ZGQBWVlpNasihezEgCZH221+Jh1xeTd3ZP/YuP9XhCmkBgWf9K8Rj
	 jfwPRvY5LJ7ya5LRNDaLXI6nQT5Ne7vIHT/mc9V66QZo15UH3/eDS1+P1FHILWo99NWyE
	 abnkhTeoaW0yxjOnxltryUs/hjp+qSDftCoN68QEBcCgZO6MyhTNmO9K2PNREonIm0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415113;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=4C18oEwdIUoGW8Y0SpBhxom5XPxehN35uGWJKAbE63Y=;
	b=zpX4tNAcGEZRvert9zPJ/JRWrEsvGrpHHtIAI9YXHI5TD1zionD8iZxn4QVIB8HZRMaL
	 aNeBHPLTvfFQ+rqP24BFkxzAzNdHlePeIj/TiCG6zaH1VGbXUdTqXfDeMmxsCSpinLd4/
	 CulocmL6IT8XZq6Gaho4nvKxyqx8QC7wtyo6EvO7TCvauicl/5eXajV3GGaTsjmpGYBl9
	 sqCNLlvZcumkZgHm1j2k3c8xVREafQF+i3Vx7X94FdqCb+9zRioRjGpKaSbzr/k/16NTP
	 ZjIgcvaLqkw+I2R6d4epvVKkxIoPUW+A9M0FCcTTz75VcxobJJZyAoiSGczmcwinoAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="xV0/YMb+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59660606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 06:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xV0/YMb+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214A81F000D4;
	Mon, 23 Nov 2026 06:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415113;
	bh=4C18oEwdIUoGW8Y0SpBhxom5XPxehN35uGWJKAbE63Y=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=xV0/YMb+VleYz2dweVhatMiCF3BxQEyjd1no2rRPe5rQi8J7AxJ5U74/biRzF60Ht
	 4FCwr9HF5V0IRw8JdflDOTT80h6TIVCpS+LV40Ue2+wBdP8M/2QNI2R1gb4ar52i+w
	 Vkx0MIJiaDfd85yB0nqtCOWR6z2awTYlFaIOpf4g=
Date: Sun, 22 Nov 2026 22:25:12 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,
	sj@kernel.org,shakeel.butt@linux.dev,ryncsn@gmail.com,ridong.chen@linux.dev,
	qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,
	lianux.mm@gmail.com,lance.yang@linux.dev,kasong@tencent.com,
	hannes@cmpxchg.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
References: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
Subject: [merged mm-hotfixes-stable] maintainers-memory-management-mglru-multi-gen-lru-update.patch removed from -mm tree
Message-Id: <20261123062513.214A81F000D4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU) update
has been removed from the -mm tree.  Its filename was
     maintainers-memory-management-mglru-multi-gen-lru-update.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU) update
Date: Mon, 09 Nov 2026 19:31:53 +0100

Patch series "MAINTAINERS: MM updates (2)".

Some more MAINTAINERS updates with a focus on MGLRU and reclaim this time.


This patch (of 2):

MGLRU is currently the only MM component without a dedicated component
maintainer.  Fortunately, Kairui and Barry have been actively contributing
to MGLRU and have volunteered to take on more responsibility by officially
taking care of it.

Given that Kairui is already an established MM component maintainer in a
related MM component (SWAP), add him as an MGLRU maintainer right away.

For Barry, the idea is to transition him towards a component maintainer
role over the coming months, starting by moving him to the top of the
reviewer list.

Link: https://lore.kernel.org/20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org
Link: https://patch.msgid.link/20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-memory-management-mglru-multi-gen-lru-update
+++ a/MAINTAINERS
@@ -17633,10 +17633,10 @@ K:	(?i:vmemmap)
 
 MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
 M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Kairui Song <kasong@tencent.com>
+M:	Kairui Song <kasong@tencent.com>
+R:	Barry Song <baohua@kernel.org>
 R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
-R:	Barry Song <baohua@kernel.org>
 R:	Axel Rasmussen <axelrasmussen@google.com>
 R:	Yuanchu Xie <yuanchu@google.com>
 R:	Wei Xu <weixugc@google.com>
_

Patches currently in -mm which might be from david@kernel.org are

mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch
mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch
mm-userfaultfd-prevent-poison-marker-loss.patch
mm-hugetlb-compare-against-persistent-count-when-freeing-lowmem-folios.patch
mm-hugetlb-preserve-reservations-when-shrinking-on-highmem.patch
mm-hugetlb-account-temporary-folios-separately.patch
mm-hugetlb-account-temporary-folios-separately-fix.patch
mm-hugetlb-serialize-page-cache-allocations-with-truncation.patch
mm-memfd-recheck-the-page-cache-before-allocating-a-hugetlb-folio.patch
mm-hugetlb-count-again-if-the-reserve-map-shrank.patch
mm-hugetlb-account-restored-reservations-before-freeing-folios.patch
mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush.patch

