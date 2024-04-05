Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D63171085
	for <mm-commits@vger.kernel.org>; Fri,  5 Apr 2024 18:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712341209; cv=none; b=eKxfQS9y3sm9ZQFn+tFBYSVtrupk3IHBm8CaUdOC5Cxkimqkq3BnyGdsY1fTHnzFsyCKHcCj7vP9u9mI/zK94KJKlx5ro/oVoUC0eZxvEc6FfmYdoQp0EUBcPYPI/y1JU7sGuKSTalyxA2RKDmXu550Po7DWowaRHunYoLDG5TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712341209; c=relaxed/simple;
	bh=1B+wNTTvRiQ0IxzF9bttw17zzqILFYd+W8zhtMssqUQ=;
	h=Date:To:From:Subject:Message-Id; b=L4YnxQAShSoFa5dvja9mECLXl1daPYJXaBbhKhg+S7eEurMXXkTpemGs6gmp1fn01+pnkox2/hcQ7ApRj86zj/XQbcMiqxb2ILSQse9L583BOVkIIVSAap9kyJuSoEs+iTYS7GDMkyXD3yS9IRjKknd5zGwqenLqf4/B7ERy3Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g1ZBkqHc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g1ZBkqHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6911EC433F1;
	Fri,  5 Apr 2024 18:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712341208;
	bh=1B+wNTTvRiQ0IxzF9bttw17zzqILFYd+W8zhtMssqUQ=;
	h=Date:To:From:Subject:From;
	b=g1ZBkqHcegyKScfTpILXTtDXgnxC+swh++HZiDvSJQehicv5xyRlOUzIWo2xa1wed
	 f75TBOKycZSxZXFW129jaZ6ByNQjADoldu7MqiJQRAEy8o5IRpPbfxz+BvnnmRqJRt
	 qLAJ7WF215qb2K7kYbC63+Ltv2OXxlPqe3RZr+CU=
Date: Fri, 05 Apr 2024 11:20:07 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-fix-lockdep-warning-fix.patch removed from -mm tree
Message-Id: <20240405182008.6911EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmalloc-fix-lockdep-warning-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-lockdep-warning-fix.patch

This patch was dropped because it was folded into mm-vmalloc-fix-lockdep-warning.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-fix-lockdep-warning-fix
Date: Fri Apr  5 11:16:02 AM PDT 2024

fix comment typos, per Baoquan

Cc: Baoquan He <bhe@redhat.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-lockdep-warning-fix
+++ a/mm/vmalloc.c
@@ -1064,10 +1064,9 @@ repeat:
 	}
 
 	/*
-	 * Check if found VA exists, it might it is gone away.
-	 * In this case we repeat the search because a VA has
-	 * been removed concurrently thus we need to proceed
-	 * with next one what is a rare case.
+	 * Check if found VA exists, it might have gone away.  In this case we
+	 * repeat the search because a VA has been removed concurrently and we
+	 * need to proceed to the next one, which is a rare case.
 	 */
 	if (va_start_lowest) {
 		vn = addr_to_node(va_start_lowest);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmalloc-fix-lockdep-warning.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

