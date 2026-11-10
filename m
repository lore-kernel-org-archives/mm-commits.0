Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270248;
	b=bL92n82rvwJpqbz4QLIE/V1mdx18N2XJ6kMmOjK7Z8SK3Ud4cgJM+4NrsqwbQUYbXNJK
	 Xdf2brdgqkieg78bVsZNN0CmoTuZyxY+A3RPrAwj2NJbJn9iQlHdjzdFNRE0vZmkW3ShC
	 Q+SPmy9N1mZgCryFElCy6l61zpYNfcoD7NSNRBsMjbj9NdQ58AoQZUwr8PIvrtuLxwRY0
	 ZJODWQVzoK0GV/llskLonTNhkhNrOXDvVr/AgyJ4ZDGDWhBZeZ2PY2k+UvEvP/sZRiNGT
	 4hhYtQY8YvCN1mPMd3mpWsJX7XuXCWXVCriW8gJ5Tjmp6ZoXyOTezp5JAzd+DLIPqpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270248;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=RhTXBzJoznNMTjuymEfT3rfzmTwoiqOH4EBdnBJRiTk=;
	b=aYfzpYT0YrH4W/auu0oq2RYeFjIx81ORmyjfHTxTyAkQ6hPYfYBmqGqTYiNIZIzwFQEn
	 8lzZdac227w3+ir7N9MpwRx1btxJsV3j4z02WsXfTXt/BN+PHWUKvAl5G9o2uakdzzNvU
	 Ncmx3GAfAo2ZjJNRgRCWxgETBhiKds0vB5R93nzBE/Wgc07VDBDJMH7RnQJU3lKy7xHhL
	 DvEA1YgaIry1DbCK06dTjr11T+Y6Kf7SQWdY3OWsVCHV7w8FG18QeChwiMBF6DF7odCPH
	 FRFn/R2fF94c7pdCYA2NmZG02w7C9KsIXd6zh/TtesO+1xJazliBJDbEXkYsalezAGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tp+Z8Q70;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F175F606A325
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 00:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tp+Z8Q70
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84E91F008A1;
	Tue, 10 Nov 2026 00:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794270247;
	bh=RhTXBzJoznNMTjuymEfT3rfzmTwoiqOH4EBdnBJRiTk=;
	h=Date:To:From:Subject;
	b=tp+Z8Q70ewgBEaaf9nHpKmFXkqrzPz46s9EpuvDkyLbMCbkm+0oCwxBmvdXVS9DpH
	 ki7rhlol92+M7Il8CtyY/EuGblqwx1DY+wCBWM8Ttiln5VDDWZjIawDnDEcogtxDfh
	 4SOGQvc4RSEEjHpfsFuXDl2TbFkaQ0TTmgMom9mc=
Date: Mon, 09 Nov 2026 16:24:07 -0800
To: mm-commits@vger.kernel.org,chengkaitao@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch added to mm-unstable branch
Message-Id: <20261110002407.A84E91F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed input
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed input
Date: Fri, 06 Nov 2026 18:05:18 +0800

Patch series "Subject: [PATCH v3 0/4] mm/hugetlb: Fix CMA parsing, flags
and usage accounting", v3.

This series fixes three independent HugeTLB issues reported by Sashiko
and includes a follow-up cleanup of NR_HUGETLB accounting.

Patch 1 rejects a global hugetlb_cma size following node-specific entries.
This prevents malformed input from overwriting valid per-node reservations
with an incorrectly parsed global size.

Patch 2 preserves persistent folio flags when a failed vmemmap restore
returns a folio to the pool. This retains CMA allocation tracking and
raw hardware poison information, while ensuring transient flags are
cleared before returning the folio.

Patch 3 retains the minimal NR_HUGETLB accounting fix, as suggested by
Muchun Song, to keep it straightforward to backport. It balances the
counter before freeing unused surplus folios during reservation
gathering or after a failed overcommit recheck.

Patch 4 moves NR_HUGETLB node accounting to the underlying folio state
transitions and separates it from memcg statistics. This cleans up
the accounting in the allocation and surplus cleanup paths.


This patch (of 4):

When hugetlb_cma contains a global size after node-specific entries,
cmdline_parse_hugetlb_cma() enters the global branch and reparses the
original parameter string. For hugetlb_cma=1:2G,4G, this interprets the
initial node ID as a one-byte global size and clears the 2 GiB reservation
recorded for node 1.

Global and node-specific formats cannot be mixed. Return -EINVAL when a
global entry follows a node-specific entry, before updating any settings.
This preserves the valid prefix, so the example retains node 1's 2 GiB
reservation and reports the malformed option.

Link: https://lore.kernel.org/20261106100521.30099-1-kaitao.cheng@linux.dev
Link: https://lore.kernel.org/20261106100521.30099-2-kaitao.cheng@linux.dev
Fixes: 38e719ab2673 ("hugetlb: support node specified when using cma for gigantic hugepages")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-10f40d3e-3feb-4622-9da8-1fedecb2d0e2
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
---

 mm/hugetlb_cma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input
+++ a/mm/hugetlb_cma.c
@@ -165,6 +165,9 @@ static int __init cmdline_parse_hugetlb_
 		} else {
 			char *next;
 
+			if (s != p)
+				return -EINVAL;
+
 			tmp = memparse(p, &next);
 			if (*next == '%') {
 				if (tmp > 100) {
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch
mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool.patch
mm-hugetlb-fix-nr_hugetlb-accounting-for-unused-surplus-folios.patch
mm-hugetlb-account-nr_hugetlb-at-folio-state-transitions.patch

