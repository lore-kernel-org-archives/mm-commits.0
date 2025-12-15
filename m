Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFD532D0C2
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 20:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765830762; cv=none; b=REiKPEKVdzK8TZY5o1A6bTIK0RaX+TALii5UTMXPtVx+WmozBZ5NwlLCvmXY+2wlf/r0e4zlaib0EWX3DJwLJ+k0ruNThwyo3DXQFkVtqeB+C8rxgilmlsRzu9i4gKixu7Oqu51hUMo5EZ3BC046NHNa3mvRK00SRaeQNe+E+A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765830762; c=relaxed/simple;
	bh=ung3899I4A5xRMtgiJFkQ34Z4qku7r9AWl4BY5KcBUo=;
	h=Date:To:From:Subject:Message-Id; b=iihNwyjOwAzWGtp9aRP3yvakfV2Z9jDToy53BqGyrff2fJreWwU4De9rD4RnC/nZvXgzum2C/JxNJE9ksr4ltnb+iSMR5dlihfUPaPz0F1mVEmI6QKsYyK6CgJAURYwg8HltEKotY3Ne8htCsjhEEykJIFTvYECPfnIkgqirp0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zCWSBx/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zCWSBx/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC22FC4CEF5;
	Mon, 15 Dec 2025 20:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765830762;
	bh=ung3899I4A5xRMtgiJFkQ34Z4qku7r9AWl4BY5KcBUo=;
	h=Date:To:From:Subject:From;
	b=zCWSBx/bMx3koXgyUW0Idy5Q/uJ9v4HrQYBEsUuVNziof1XRx9Z36WtCNrVoUfb+l
	 aSmnyF48qDCLNuO9GdhiVuXrREI2p2jFeSwq1G1Mht5l0wFe2dF+/G105sIHfHrTrV
	 2bMJH6pReexQCAb2MYYDE2fi4b21IrYEJO76BQlk=
Date: Mon, 15 Dec 2025 12:32:41 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,tongweilin@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-mthp-swpout-fallback-statistics-in-shmem_writeout.patch added to mm-new branch
Message-Id: <20251215203241.EC22FC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: add mTHP swpout fallback statistics in shmem_writeout()
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-add-mthp-swpout-fallback-statistics-in-shmem_writeout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-add-mthp-swpout-fallback-statistics-in-shmem_writeout.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-shmem-add-mthp-swpout-fallback-statistics-in-shmem_writeout.patch

