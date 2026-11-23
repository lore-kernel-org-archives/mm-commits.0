Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415115;
	b=qR7E/nGJ9w1MKZlE3sE1NmV7VMgTU+zrMK8z3hAn2Uph0yed3Q17E4yQ9t4IzseBUhWm
	 dQaiBGNpH8Csgy6/uNdVJuk5lZAbybotIPcigS0bDhYHyavKDcw4l09EMagNvJqkRTUpZ
	 Nq1ruPIw7fytyllhhGyHxK4cChascyXflyhB61d7l19hAb6yzzwewGkcCq+8z89o5NoO+
	 rv57Zr68GF1Xfw6o58GLx5m1GeXBidfRKYprJOD0jznTW+XvUx1eniI+HZFIq+JB79foY
	 hCjkHoWu+3zzx7bQONO847X1Wyxmpd6c3x4tT7um+32a6No9cU1V+n4GIrmXkp0q7SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415115;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=6SAGj2VAHb37TKcIdUOPT944wn94c6YXJ3pm54WAah0=;
	b=o3XrgJnMtIe15sNXfKoHwLYKXE9Z47tge8ymqGwM4bkwhKYtS78nXaDKNERjfwTvfwOX
	 B2vg0Q8z5s7Mp0dQ1iDz9wDOLp/6blAM8k2GIiixFlNwCWSWJU6LqTwMK6mKVJL97OBvp
	 cdcRvVakHOk/wjM8sMbv1lRmGWqsiKPvyvQp0RvGusi+KbQCkJCyHDV9bXDElKb8YfnCG
	 UbF2R2SHQ/cqz/m9RHGKwh9DareTDjD2IMX4BP7JZcKofkaJAP6ldizUa3/vIDKfWuQAD
	 X9+8Be8YDa9UdlWXdXXWZ6yNEA6sWW8Uk7J2/hoj6vz/y4yxTJdQ6c1n3y2SfAVr4vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yepCUpNa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CA4606A32A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 06:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yepCUpNa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932051F000C6;
	Mon, 23 Nov 2026 06:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415114;
	bh=6SAGj2VAHb37TKcIdUOPT944wn94c6YXJ3pm54WAah0=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=yepCUpNaGogt9EL6hnTvWuYyJKI1iV969x70y0uN6fXrGVs34sqUNDyEIWpkzWKBu
	 sd4aPCqkTZLwztAsoeGRIfQJb5sznO5/AEjKxSHWxiV/OHjZcpYWbFSlpc9ZStfR8y
	 BYxy6gfntHmi/ixKYj2Glz1KsFU13emoCP3O2zl0=
Date: Sun, 22 Nov 2026 22:25:14 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,
	sj@kernel.org,shakeel.butt@linux.dev,ridong.chen@linux.dev,
	qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,
	lianux.mm@gmail.com,lance.yang@linux.dev,kasong@tencent.com,
	hannes@cmpxchg.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261109-maintainers_mglru-v1-2-c25e6de60bcc@kernel.org>
References: <20261109-maintainers_mglru-v1-2-c25e6de60bcc@kernel.org>
Subject: [merged mm-hotfixes-stable] maintainers-remove-myself-from-memory-management-reclaim.patch removed from -mm tree
Message-Id: <20261123062514.932051F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: remove myself from MEMORY MANAGEMENT - RECLAIM
has been removed from the -mm tree.  Its filename was
     maintainers-remove-myself-from-memory-management-reclaim.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: MAINTAINERS: remove myself from MEMORY MANAGEMENT - RECLAIM
Date: Mon, 09 Nov 2026 19:31:54 +0100

I don't really get to look at most reclaim related stuff.  For things that
are actually relevant for me, I'm sure people will CC me.

So remove myself from the MEMORY MANAGEMENT - RECLAIM section for now to
have a bit less noise in my inbox.

Link: https://patch.msgid.link/20261109-maintainers_mglru-v1-2-c25e6de60bcc@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Lian Wang <lianux.mm@gmail.com>

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-myself-from-memory-management-reclaim
+++ a/MAINTAINERS
@@ -17805,7 +17805,6 @@ F:	tools/mm/page_owner_sort.c
 MEMORY MANAGEMENT - RECLAIM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Johannes Weiner <hannes@cmpxchg.org>
-R:	David Hildenbrand <david@kernel.org>
 R:	Michal Hocko <mhocko@kernel.org>
 R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
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

