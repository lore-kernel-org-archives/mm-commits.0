Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A0F27FB28
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966019; cv=none; b=VJwog+ZIIL+iBm6QeQlFOYIiiGungjOYKqEZ81G7ZkLJrmSFQqKvjD1ZzpSqt04259WKflJnhaZrB7eM+eYc4ptjKfe690JjzTedf9PXKPwxkCjmeQmqygpapJGswjSjfhVa1BANWBPBV7hDYpTFxwlWxIfBabYH6n1mttXOU+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966019; c=relaxed/simple;
	bh=hn63OAyvA3NTPSgEktF77YLkr2+0qPUynVVCQmvbehU=;
	h=Date:To:From:Subject:Message-Id; b=gqfg8+d645xQN/tzIEZ/VeIq3g3QtslUVmgQR9aqIC+kD6P5KW35WyGuhHfgh0ARDzXa0U0LxL64oR+cekGysrPU73xBi/Jj6yIjaMx22L3egG/Fpb3SJ+qM5PBiRyNpEKWk4lXJaxD/eN93ozGBjdv5y9UBsSRUzH+l2uRDN7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SDvBzTAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SDvBzTAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EF0C16AAE;
	Wed, 21 Jan 2026 03:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966019;
	bh=hn63OAyvA3NTPSgEktF77YLkr2+0qPUynVVCQmvbehU=;
	h=Date:To:From:Subject:From;
	b=SDvBzTAAM7raMahV1lVxS/Sxnh3C0avEajFkUpC7dnFkh/T/mCFw8lc593PBu2UXB
	 Rsu/n/ZDnp9tOm0hCNn381dxz4h0dncNa2RGF9nST0x9/jcIwN7nDkjl7V2gwMqlez
	 9GhK7oZX5Z4N2HdjVGOYenmZ2Vv8AW+1SxP5NBe0=
Date: Tue, 20 Jan 2026 19:26:58 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,tongweilin@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-add-mthp-swpout-fallback-statistics-in-shmem_writeout.patch removed from -mm tree
Message-Id: <20260121032659.12EF0C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: add mTHP swpout fallback statistics in shmem_writeout()
has been removed from the -mm tree.  Its filename was
     mm-shmem-add-mthp-swpout-fallback-statistics-in-shmem_writeout.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Weilin Tong <tongweilin@linux.alibaba.com>
Subject: mm/shmem: add mTHP swpout fallback statistics in shmem_writeout()
Date: Mon, 15 Dec 2025 10:46:32 +0800

Currently, when shmem mTHPs are split and swapped out via
shmem_writeout(), there are no unified statistics to trace these mTHP
swpout fallback events.  This makes it difficult to analyze the prevalence
of mTHP splitting and fallback during swap operations, which is important
for memory diagnostics.

Here we add statistics counting for mTHP fallback to small pages when
splitting and swapping out in shmem_writeout().

Link: https://lkml.kernel.org/r/20251215024632.250149-1-tongweilin@linux.alibaba.com
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/shmem.c~mm-shmem-add-mthp-swpout-fallback-statistics-in-shmem_writeout
+++ a/mm/shmem.c
@@ -1593,11 +1593,23 @@ int shmem_writeout(struct folio *folio,
 	}
 
 	if (split) {
+		int order;
+
 try_split:
+		order = folio_order(folio);
 		/* Ensure the subpages are still dirty */
 		folio_test_set_dirty(folio);
 		if (split_folio_to_list(folio, folio_list))
 			goto redirty;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		if (order >= HPAGE_PMD_ORDER) {
+			count_memcg_folio_events(folio, THP_SWPOUT_FALLBACK, 1);
+			count_vm_event(THP_SWPOUT_FALLBACK);
+		}
+#endif
+		count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
+
 		folio_clear_dirty(folio);
 	}
 
_

Patches currently in -mm which might be from tongweilin@linux.alibaba.com are


