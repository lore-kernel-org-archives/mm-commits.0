Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAF537DEA1
	for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 18:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472676; cv=none; b=N8kNdzbiO8oWF+wc8WhT2SbKDUeYYzLUSTDEWc6cVfmRtSKd8tIQ0n1thFy4/BUM2AxjaDrWi3RuYs/jHAoLBhVTAF1YQPbdTsgsLsCzo/yvWV980N7Tty785ueJFi2Qq4WRd7Vx51nnmcI/NjVctlgrwrFomFrR88QzvOiuge0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472676; c=relaxed/simple;
	bh=M2/Jf8ukYffmuk2X9wBc4mZ5b2zKyL2WHNSYexDFZiA=;
	h=Date:To:From:Subject:Message-Id; b=hSseZNoVuByOywdwUEp68g/P+NyCwTzYgB5hH75eIj5eCdLPKIMdx8Jk+Je59hlx2UWes3XyVgnPgsU79SrxdrcTzvVu/KbvpfvSKjkcFuuF2vXkUMQgnQ/Sjbr8BBsllNdd0ngO0AaIYLUAVeHSyRLXlvGeo6Wcpc3/r1o/Zu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1gfsd72K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1gfsd72K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C3D1F00A3A;
	Tue, 11 Aug 2026 18:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786472674;
	bh=bXSub9ySR2KLFPCHmIcIfzcj+m0sIwD9kuNWq3YS8sM=;
	h=Date:To:From:Subject;
	b=1gfsd72KrJkxMvV4pP/e1o3XM/gov+qYtm88ixHVbjK4sW0d7C58L29We/nQyrwV9
	 eHK5zwYh6/YU0FUO9KdR4YfV09ajxIIwvE3E8IRqwg2zScC7kYh5Nae0zB49Km0oLQ
	 EJ2NXg0w32x6NSckmxM5BDVrq8znDriiFAYE1fjo=
Date: Tue, 11 Aug 2026 11:24:34 -0700
To: mm-commits@vger.kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-documentation-clarify-where-the-mthp-stats-live.patch added to mm-unstable branch
Message-Id: <20260811182434.A3C3D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: Documentation: clarify where the mTHP stats live
has been added to the -mm mm-unstable branch.  Its filename is
     mm-documentation-clarify-where-the-mthp-stats-live.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-documentation-clarify-where-the-mthp-stats-live.patch

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
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: mm: Documentation: clarify where the mTHP stats live
Date: Tue, 11 Aug 2026 06:48:39 -0600

The note about khugepaged counters references /proc/vmstat for the PMD
case, but never mentions where the mTHPs stats can be found (i.e.:
/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/) Add a small
addition to this section for clarity.

Also fix a missing period while we are at it.

Link: https://lore.kernel.org/20260811-khugepaged_pte_refactor-v4-7-ddac39d61c4a@linux.dev
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-documentation-clarify-where-the-mthp-stats-live
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -224,7 +224,7 @@ khugepaged will be automatically started
 (either of the per-size anon control or the top-level control are set
 to "always" or "madvise"), and it'll be automatically shutdown when
 all THP sizes are disabled (when both the per-size anon control and the
-top-level control are "never")
+top-level control are "never").
 
 process THP controls
 --------------------
@@ -301,7 +301,9 @@ being replaced by a PMD mapping, or (2)
 hugepage of various sizes (PMD-sized or mTHP). Each may happen independently,
 or together, depending on the type of memory and the failures that occur.
 As such, this value should be interpreted roughly as a sign of progress,
-and counters in /proc/vmstat consulted for more accurate accounting)::
+and counters in /proc/vmstat consulted for more accurate accounting.
+Per-order mTHP collapse statistics are also available under
+/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/)::
 
 	/sys/kernel/mm/transparent_hugepage/khugepaged/pages_collapsed
 
_

Patches currently in -mm which might be from nico.pache@linux.dev are

mm-khugepaged-refactor-per-scan-state-clearing-into-collapse_control_init_scan.patch
mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper.patch
mm-khugepaged-introduce-a-count_collapse_event-helper.patch
mm-khugepaged-fix-outdated-comments.patch
mm-khugepaged-refactor-the-pte-state-checks-into-a-helper.patch
mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch
mm-documentation-clarify-where-the-mthp-stats-live.patch

