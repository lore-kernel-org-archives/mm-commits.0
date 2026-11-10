Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270034;
	b=RVw4uoZkWeyJOCdvRsKM4cp/qIZvHHTS57/893HS/UYqBSBd0C6jIJTjyfBCc4BBaHJu
	 RIh19izDEgNzGtbhCa3XkNk5WYjAoJSVvBqkY1/LBC0IC7Xn3WNKtVyUgNawLm9jcIUhZ
	 EPTVkfVaEqyO+zZBi3n04OGm7e51zfIWkhpE6hg/0vVoi87Z3Ct1CLIiHXWkl6kCoaTyF
	 qaTYGpAZRn6vHh2wKCEVSfmxsRyUoVtjBH0Eqq9aOYyVVi+KBRjDvQXCRjMzB07floMcl
	 sNtiVNg2gHlIRkLOicm+rf3T2Blx0PEGTqKCS+l9v7ilYmba7UPQETTR83Ep3xIz2kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270034;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KpKHN5Z7MGRDxG3fCOFqOt25TPdOaWXh/T9jw6mjTnM=;
	b=2QP0yF09OC3XwuNR3/C+1skDGKk0OhMGpYjTY6i7/ChXgji40y5Ny7dSLmPsJ2jYQwWd
	 lntzhFebXZemUmAe3//qQT9knbldd3dUeGEpe3vnQTQbQgaOlX2Ybo1SeP9D9QBpFDKYq
	 CpuLZkkIlkxa/cNss3hQ74tbW7kGp/q4W4Dbieru+7pf3670iepP/E6t3/HS9A29X/gXA
	 Nmk+GE1SBotHJBXZY2GAjPHI6j+IvF75qEKZ4hJNNmuFM77SpGk3xhfCKcUlWOkMqlLSi
	 7Um/lEtZez5xI71Gemia46Mzvn0DfqTNHR65XEtIleyeOiyVEf15GUjzXdSxz+ZYicw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MYQ7kg1f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0158F606A335
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 00:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MYQ7kg1f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF441F0089F;
	Tue, 10 Nov 2026 00:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794270033;
	bh=KpKHN5Z7MGRDxG3fCOFqOt25TPdOaWXh/T9jw6mjTnM=;
	h=Date:To:From:Subject;
	b=MYQ7kg1fQPibwpELPj3TfTf/B/noHaOsEvGItdLari7cwAooxnh4lLqAagNZen1Fx
	 WAPY8NpZhztoBa5T1JnDhv47n6J+UVO9QQJRL0Y/C6G1kPTliELXf9dgHmCh+7wyxT
	 XHE5HdgRsZH3TnG7dR9oDRLVGl0cdkqEKUUX/xdw=
Date: Mon, 09 Nov 2026 16:20:33 -0800
To: mm-commits@vger.kernel.org,chengkaitao@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch removed from -mm tree
Message-Id: <20261110002033.9AF441F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed input
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch

This patch was dropped because an updated version will be issued

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

mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool.patch
mm-hugetlb-fix-nr_hugetlb-accounting-for-surplus-folios.patch

