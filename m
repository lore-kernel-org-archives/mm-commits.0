Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE18E156898
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 17:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721840436; cv=none; b=YXLqT2NurNh8WokazFPnjWK1fhSWB21CnhT8pboALiGqLDgTy490Bqy2HghxiYz+GaVPrsKQqBZVWADvBe8hZ0UweEZEdoW82JmnDXm8kmeR+Xm2AqkgE5ivdpsJ7ZdUgn6I1X7sx9hVV5C2080QeKDtD6oHlDChyzwPwsWvsPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721840436; c=relaxed/simple;
	bh=kWSJcBhBYgjUbgxm4Q+vcIvLkEWHI9CEwQTUiPc973U=;
	h=Date:To:From:Subject:Message-Id; b=eCnyDbNEZOuaNzuyBUQiD7ENijtr5dhMLRyoL3l0n002zJbzd1rvwzYy/+Zv42p/Dv8w8pwbHLiWTGA5xqSWImRYzQc8DSpJmJsXGhSwDcFDbl2bHlURVsJr3wT8VGyP9SQ5lOEzCH2JybdU0f/6jbMStSYzvVqCEqB4+yXUM3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ow0zjK59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ow0zjK59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9C6C32781;
	Wed, 24 Jul 2024 17:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721840435;
	bh=kWSJcBhBYgjUbgxm4Q+vcIvLkEWHI9CEwQTUiPc973U=;
	h=Date:To:From:Subject:From;
	b=Ow0zjK59MKTtsmWz6Hf9heE/ziiYMCX2OKmDXWCYxWKLP1yEGpD6lc8b8+Bk+6RRM
	 0ysK6kASSIw5VHog393e2+LVLxHJi/TrA0zQY0dSfLalQCt54bzlkF0M1hV/Cvv063
	 XObaHIqsDLgfmRmQizbcElxiAf1KI8vu6/V9qQVk=
Date: Wed, 24 Jul 2024 10:00:34 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,lorenzo.stoakes@oracle.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch added to mm-unstable branch
Message-Id: <20240724170035.4F9C6C32781@smtp.kernel.org>
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
Date: Wed, 24 Jul 2024 09:01:13 -0400

Patch series "Various memory tiering fixes", v3.


This patch (of 3):

last_cpupid is only available when memory tiering is off or the folio is
in toptier node.  Complete the check to read last_cpupid when it is
available.

Before the fix, the default last_cpupid will be used even if memory
tiering mode is turned off at runtime instead of the actual value.  This
can prevent task_numa_fault() from getting right numa fault stats, but
should not cause any crash.  User might see performance changes after the
fix.

Link: https://lkml.kernel.org/r/20240724130115.793641-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20240724130115.793641-2-ziy@nvidia.com
Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: David Hildenbrand <david@redhat.com>
Closes: https://lore.kernel.org/linux-mm/9af34a6b-ca56-4a64-8aa6-ade65f109288@redhat.com/
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page
+++ a/mm/huge_memory.c
@@ -1707,7 +1707,8 @@ vm_fault_t do_huge_pmd_numa_page(struct
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
memory-tiering-introduce-folio_use_access_time-check.patch
memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch

