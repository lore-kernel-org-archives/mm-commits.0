Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D8018EFD1
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 23:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763163756; cv=none; b=lvM8jOJOfHi+wfWOZLO13YPum5ZjtzbhOmt+fiq4z60iQ3KABT1I6EvCOn4SEKM19qN6XxymQN2+I/5/sgBZG/tw4mq/J6Xi0d7ZWNt/bnVj2MurlCwvLFp2JY1T9Kk6BnLo4tKePLRpL5w42n1oogvPh0cbGNC+CE7XqTs8h8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763163756; c=relaxed/simple;
	bh=8dwH+x2HfjcIWmY0VWK16fHo+T7mtUs2f/O93WwzI7o=;
	h=Date:To:From:Subject:Message-Id; b=q7DkhN2jJCQhslJst88tJ8GqN6vrhYdp5WX0Zd4NMjLw8lIel5xiMw0lzPhMi94jd2RX3clyZvFhxWNEZHqLtBH/THRUIB12QvS31sxuTHQF+jG5D61pF+RQbR4/2cjYNMt5wSh8M3RaYT9ISwkY7BuPRwyQyBLi7/0++H/WTww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N1LKlpSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N1LKlpSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1589C19421;
	Fri, 14 Nov 2025 23:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763163755;
	bh=8dwH+x2HfjcIWmY0VWK16fHo+T7mtUs2f/O93WwzI7o=;
	h=Date:To:From:Subject:From;
	b=N1LKlpSwXZDLpzU1Y52rLZxGnOmQC4XRlSR5kxfgC1yvG2mVzVcSFOAVJheXEjlt/
	 EPQolPGaSHM6nBUG/9QGZlZbfXHbX7v8fX/LsW/WCGWu+7pFwgugjdQDcbZU6vyMMB
	 6wPe8lX2LWYCg0Qn85RaE03AsRw+b1cUw3FY0cKY=
Date: Fri, 14 Nov 2025 15:42:35 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-continue-to-collapse-on-scan_pmd_none.patch added to mm-new branch
Message-Id: <20251114234235.B1589C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: continue to collapse on SCAN_PMD_NONE
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-continue-to-collapse-on-scan_pmd_none.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-continue-to-collapse-on-scan_pmd_none.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/khugepaged: continue to collapse on SCAN_PMD_NONE
Date: Fri, 14 Nov 2025 03:00:27 +0000

SCAN_PMD_NONE means current pmd is empty, but we can still continue
collapse next pmd range.

Link: https://lkml.kernel.org/r/20251114030028.7035-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/khugepaged.c~mm-khugepaged-continue-to-collapse-on-scan_pmd_none
+++ a/mm/khugepaged.c
@@ -2833,6 +2833,7 @@ handle_result:
 			goto handle_result;
 		/* Whitelisted set of results where continuing OK */
 		case SCAN_PMD_NULL:
+		case SCAN_PMD_NONE:
 		case SCAN_PTE_NON_PRESENT:
 		case SCAN_PTE_UFFD_WP:
 		case SCAN_LACK_REFERENCED_PAGE:
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-huge_memory-avoid-reinvoking-folio_test_anon.patch
mm-huge_memory-update-folio-stat-after-successful-split.patch
mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split.patch
mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch
mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch
mm-huge_memory-introduce-enum-split_type-for-clarity.patch
mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_supported.patch
mm-khugepaged-remove-redundant-clearing-of-struct-collapse_control.patch
mm-khugepaged-continue-to-collapse-on-scan_pmd_none.patch
mm-khugepaged-unify-scan_pmd_none-and-scan_pmd_null-into-scan_no_pte_table.patch

