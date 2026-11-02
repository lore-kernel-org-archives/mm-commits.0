Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793659988;
	b=1ukYNjPy/6gdUaBHrnkiEj2T7wv+SqSD/EEuo/HSDT1q8IED2PGZwyVkLuDIWjz7jz4g
	 5isp2Kr1R6ZVBWH0WKBEcGARTZh6njqpC9Rf7oL/4UpBI9X0xJuL7kp5PXAKtQ601bbRx
	 XoLjLW6IrnIbMFJ3owyznXyCHN4VLxF349LNmVwkrzQ+JkOX1BSrtw1nThpfExfOiVys5
	 wJQAstcNvN4nFXfG5bE3ktB4qitpS7HV0KNA/VIaR9jdBd9SvaN7TsKrbgDbYH9tP9AZS
	 U0ZDXF9XqGLR5uiZjweV9DCAqnU6qqQehKdCuL2U8Mgo3wULWWpD8lnq3dp5NHdStrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793659988;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=tzO9ErMtL6hfVqn+FqFDlSxZOFt0iba+obyxFe/3riI=;
	b=CHT9AjrxJjjuBEKXNSO2+xOgKqI/ZcFNZRmdG3+NzOyd3ZqPOgwI0WjYAk62Emil37lN
	 QqSZjCp8TRDrk/CD4NOw/cnw2WbYoK+fmxGYTPo+SB5hSC0Gor4TQvPpNOmSS8Fo/8gg+
	 2oiguBohCzGeDwWPLdF9m/GemlmxF+9+W5HNFAJLY87Fnyz2zmecgHB9mxqt8ySAlV89v
	 aSRN/31Vj9iPO2hRBWDEyvvDb2ye2BZPjuZQKXvGw3A36tNSqWhfiVesfga89U70TKcFY
	 /LDjfahB7imCd+5yQwmmEvZZB4BhgcNu9oSvYNpdiAQSU4HlZi7FEU4nNC9q5pB6R3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BA1ZwCay;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C483606A32C
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 22:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BA1ZwCay
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925211F00A16;
	Mon,  2 Nov 2026 22:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793659987;
	bh=tzO9ErMtL6hfVqn+FqFDlSxZOFt0iba+obyxFe/3riI=;
	h=Date:To:From:Subject;
	b=BA1ZwCayekfxNPrama3qJr3d+pGHa72zMsRDSg+c6VVXQKVX4sCA811JSLJM80tFk
	 v14L0/vAHE1uShu/H3XwXq4pn7yfV8wsI4LavnOjvs7fzzenEErEsdjtSrztZIFVC1
	 EZ81qavcpGkPvvLBRN6WBeK5vMzptqr/rbADEmHA=
Date: Mon, 02 Nov 2026 14:53:07 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,
	rppt@kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,
	osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,
	mt4022@columbia.edu,mike.kravetz@oracle.com,mhocko@kernel.org,
	linmiaohe@huawei.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,
	fvdl@google.com,david@kernel.org,chris@chrisdown.name,
	baolin.wang@linux.alibaba.com,chengkaitao@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch added to mm-new branch
Message-Id: <20261102225307.925211F00A16@smtp.kernel.org>
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
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch

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
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed input
Date: Mon, 02 Nov 2026 10:49:08 +0800

Patch series "mm/hugetlb: Fix CMA parsing, flags and usage accounting", v2.

This series fixes three independent HugeTLB issues reported by Sashiko,
covering CMA parameter parsing, persistent folio flags, and NR_HUGETLB
accounting on allocation rollback.

Patch 1 rejects a global hugetlb_cma size following node-specific entries.
This prevents malformed input from overwriting valid per-node reservations
with an incorrectly parsed global size.

Patch 2 preserves persistent folio flags when a failed vmemmap restore
returns a folio to the pool. This retains CMA allocation tracking and
raw hardware poison information, while ensuring transient flags are
cleared before returning the folio.

Patch 3 moves NR_HUGETLB node accounting to the underlying folio state
transitions and separates it from memcg statistics. This keeps the
counter balanced when surplus folios are freed during reservation
gathering or after a failed overcommit recheck.


This patch (of 3):

When hugetlb_cma contains a global size after node-specific entries,
cmdline_parse_hugetlb_cma() enters the global branch and reparses the
original parameter string. For hugetlb_cma=1:2G,4G, this interprets the
initial node ID as a one-byte global size and clears the 2 GiB reservation
recorded for node 1.

Global and node-specific formats cannot be mixed. Return -EINVAL when a
global entry follows a node-specific entry, before updating any settings.
This preserves the valid prefix, so the example retains node 1's 2 GiB
reservation and reports the malformed option.

Link: https://lore.kernel.org/20261102024910.31486-1-kaitao.cheng@linux.dev
Link: https://lore.kernel.org/20261102024910.31486-2-kaitao.cheng@linux.dev
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
mm-hugetlb-fix-nr_hugetlb-accounting-for-surplus-folios.patch

