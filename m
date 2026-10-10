Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0D6359A81
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 20:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791665540; cv=none; b=AmmpfWU2TdCLBFbygJosZ7U3bVMQoB4KDCHDNzYO3sKfh4PW0qPMzDchzd/Ft4fmjZXC29xyNk5gB4D1Pe4uyCZ8n0FebtLkvPlYivqYz3Ncf5UdHyeogB9LlTyU+fvMfHFssQ8AZfiA+xIXu8BhTzJfz0dKc2s0L88guTOLDXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791665540; c=relaxed/simple;
	bh=cHpBuJicHLR5ue1Y9sv/+JJtg4FzkJCHuThtnL51/F4=;
	h=Date:To:From:Subject:Message-Id; b=JekM/2KeaY5HEVJLu950dJ3JnfeugCOnr67P/lQ5IV0xics1AGcZzLU5cTI3FCc7w3clJl+t5QW3k8hUKf4QvJK+kWNL2WywzjnRYWnpw0HDxhoj4rvlj4bA2o4BZfQtm0N7TdHp1IH8Q107iGShqWHPOAwflQFEbZkURVrfsjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JjEPcgLd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JjEPcgLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAA01F000FF;
	Sat, 10 Oct 2026 20:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791665539;
	bh=nCU7Yh6iu99Qvyx/zdff5MDsTT6IT7Kz5FOAi/+lAYE=;
	h=Date:To:From:Subject;
	b=JjEPcgLdO85ys5IYxu2hjMZcPUVEd8k1CS+IZjO6p4gv+j65kRkpRcf6Ud4bhE5+p
	 ngFW5OdX/57eDBUPTdGhmDkXV6c8TnPRozUCQWS8MPpbB0sGIWGK58BvYmULeh8+Wt
	 Dr6g1uz3CORdzQC3neSHrDjfjrSI9gbk32iKkfOQ=
Date: Sat, 10 Oct 2026 13:52:18 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,gourry@gourry.net,david@kernel.org,albinwyang@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-add-cond_resched-in-thp-branch-of-madvise_cold_or_pageout_pte_range.patch added to mm-unstable branch
Message-Id: <20261010205219.1AAA01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: add cond_resched() in THP branch of madvise_cold_or_pageout_pte_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-add-cond_resched-in-thp-branch-of-madvise_cold_or_pageout_pte_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-add-cond_resched-in-thp-branch-of-madvise_cold_or_pageout_pte_range.patch

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
From: Wei Yang <albinwyang@tencent.com>
Subject: mm/madvise: add cond_resched() in THP branch of madvise_cold_or_pageout_pte_range()
Date: Sat, 10 Oct 2026 10:40:42 +0800

During stress testing with stress-ng on a 256-CPU system, a softlockup was
observed when madvise(MADV_COLD) was called on a 31GB memory region backed
by transparent hugepages.  The region contains 15935 THP PMD entries, and
the softlockup was triggered after 14485 of them had been processed.

The THP branch of madvise_cold_or_pageout_pte_range() has no scheduling
point.  walk_pmd_range() invokes it once per 2MB PMD entry with no
cond_resched() anywhere in the loop.  Each iteration calls
pmdp_invalidate() which issues a synchronous TLB shootdown (dsb ish)
waiting for all CPUs to acknowledge.  This operation can be time-consuming
under heavy system load, causing the accumulated time across all PMD
entries to exceed the softlockup threshold (20s) and panic when
softlockup_panic=1.  On a CONFIG_PREEMPT_NONE=y kernel, there is no other
opportunity to reschedule during this entire traversal.

The regular PTE path already has an unconditional cond_resched() at the
function tail (introduced by commit 9c276cc65a58 ("mm: introduce
MADV_COLD") and commit 1a4e58cce84e ("mm: introduce MADV_PAGEOUT") when
MADV_COLD and MADV_PAGEOUT were first introduced) and a conditional one
inside the loop (commit b2f557a21bc8 ("mm/madvise: add cond_resched() in
madvise_cold_or_pageout_pte_range()")).  The THP branch never received
equivalent treatment.

Fix by adding cond_resched() at the huge_unlock exit path after
spin_unlock(ptl) and reclaim_pages(), which is the single exit point for
all goto paths in the THP branch.

Crash log:
  watchdog: BUG: soft lockup - CPU#63 stuck for 23s! [stress-ng-vm:1665914]
  ...
  Call trace:
  pmdp_invalidate+0x48/0x68
  madvise_cold_or_pageout_pte_range+0x84c/0xb00
  walk_pmd_range.isra.0+0x1ac/0x3b0
  walk_pud_range+0x120/0x190
  walk_pgd_range+0x170/0x1b8
  __walk_page_range+0x184/0x198
  walk_page_range_vma+0x94/0x128
  madvise_cold+0xd8/0x198
  madvise_vma_behavior+0x234/0x638
  madvise_walk_vmas.constprop.0+0xdc/0x210
  madvise_do_behavior+0xa8/0x328
  do_madvise+0xd8/0x140
  __arm64_sys_madvise+0x2c/0xe0

Link: https://lore.kernel.org/20261010024042.4070048-1-albin_yang@163.com
Signed-off-by: Wei Yang <albinwyang@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Gregory Price <gourry@gourry.net>
---

 mm/madvise.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/madvise.c~mm-madvise-add-cond_resched-in-thp-branch-of-madvise_cold_or_pageout_pte_range
+++ a/mm/madvise.c
@@ -455,6 +455,7 @@ huge_unlock:
 		spin_unlock(ptl);
 		if (pageout)
 			reclaim_pages(&folio_list);
+		cond_resched();
 		return 0;
 	}
 
_

Patches currently in -mm which might be from albinwyang@tencent.com are

mm-madvise-add-cond_resched-in-thp-branch-of-madvise_cold_or_pageout_pte_range.patch

