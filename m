Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BFE134407
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 01:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721698132; cv=none; b=RtjF/zH92kc7ZhjU5B6xtY20ilGpBrua90c0Ycapqf4hoGKl/2o6SEa0tXdhb5Jj26Y52ujzXCJiIgrqvu/7YGYvoj1WnqsdXIZGkMLpFRNyWHYB809yLpp42XtFxy+izpvRnXKJAIn3GTNeHr0MjC0aR9vfYrtca9Twjw1hUS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721698132; c=relaxed/simple;
	bh=99bLZGIcoaOh4x7oPX4HaVoXAUGjEqFMz5LvdJUJBHc=;
	h=Date:To:From:Subject:Message-Id; b=hRtylAYf1PO6+aGhUggH+Lk9TPn2L4If2WV10mRHtYvq5rvfZQGQwKvur8FiVjpwYaoWatPQkpNxVM2p+4kr0He9Bj01TubUmfDKtVTn/msfULRBfUDlT7kzZtVEvuNP+0LQShaqqqeauand13LC1kzLB/gOhSD1U9fstsYDCpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vsHmV/nn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vsHmV/nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C31C116B1;
	Tue, 23 Jul 2024 01:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721698131;
	bh=99bLZGIcoaOh4x7oPX4HaVoXAUGjEqFMz5LvdJUJBHc=;
	h=Date:To:From:Subject:From;
	b=vsHmV/nni7IC8WU1IshBki3oxv2FqV5L9Mf9udB7RMO7XJxFEMM3UFgxEdrhdQxRj
	 fpn6NNuWWV5wvTtlBSBEBYxBDT7OYF6tppwCzLWjIZbSrSPJKeIZvCWbj+uf70OLbO
	 S6y2tAVj5qznb7Ah8N8ZzY8qjNPXTQEMt9HKTpBQ=
Date: Mon, 22 Jul 2024 18:28:51 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch added to mm-unstable branch
Message-Id: <20240723012851.A2C31C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory tiering: read last_cpupid correctly in do_huge_pmd_numa_page()
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Zi Yan <ziy@nvidia.com>
Subject: memory tiering: read last_cpupid correctly in do_huge_pmd_numa_page()
Date: Mon, 22 Jul 2024 13:29:15 -0400

last_cpupid is only available when memory tiering is off or the folio is
in toptier node.  Complete the check to read last_cpupid when it is
available.

Before the fix, the default last_cpupid will be used even if memory
tiering mode is turned off at runtime instead of the actual value.  This
can prevent task_numa_fault() from getting right numa fault stats, but
should not cause any crash.  User might see performance changes after the
fix.

Link: https://lkml.kernel.org/r/20240722172917.503370-1-ziy@nvidia.com
Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: David Hildenbrand <david@redhat.com>
Closes: https://lore.kernel.org/linux-mm/9af34a6b-ca56-4a64-8aa6-ade65f109288@redhat.com/
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page
+++ a/mm/huge_memory.c
@@ -1712,7 +1712,8 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	 * For memory tiering mode, cpupid of slow memory page is used
 	 * to record page access time.  So use default value.
 	 */
-	if (node_is_toptier(nid))
+	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) ||
+	    node_is_toptier(nid))
 		last_cpupid = folio_last_cpupid(folio);
 	target_nid = numa_migrate_prep(folio, vmf, haddr, nid, &flags);
 	if (target_nid == NUMA_NO_NODE)
_

Patches currently in -mm which might be from ziy@nvidia.com are

memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch
memory-tiering-introduce-folio_has_cpupid-check.patch
memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch

