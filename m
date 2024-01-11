Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4855B58128
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 20:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zGTvBEdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9784BC43394;
	Thu, 11 Jan 2024 20:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705005154;
	bh=V53yTAD12JEwRdzx3fHRJldipqylhlfplJ3Wx1AP6fg=;
	h=Date:To:From:Subject:From;
	b=zGTvBEdgHoI/3rDLDpYJL4qudtGzudqo6mMfeEtfbw8YKQqftPw1gMlhBHKZKjS4F
	 gdbPhdFrpfqtsxtf73e4jNQeiiQ+2qmSqgFtj76q4eJz/5fRBsU4kxp85A4dETWus8
	 s+LXYUlCLgp1pSCq9dosggiriAtvQqBbY6l+nlO4=
Date: Thu, 11 Jan 2024 12:32:34 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-use-pfn_swap_entry_folio-where-obvious.patch added to mm-unstable branch
Message-Id: <20240111203234.9784BC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: use pfn_swap_entry_folio where obvious
has been added to the -mm mm-unstable branch.  Its filename is
     proc-use-pfn_swap_entry_folio-where-obvious.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-use-pfn_swap_entry_folio-where-obvious.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc: use pfn_swap_entry_folio where obvious
Date: Thu, 11 Jan 2024 15:24:21 +0000

These callers only pass the result to PageAnon(), so we can save the extra
call to compound_head() by using pfn_swap_entry_folio().

Link: https://lkml.kernel.org/r/20240111152429.3374566-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~proc-use-pfn_swap_entry_folio-where-obvious
+++ a/fs/proc/task_mmu.c
@@ -1807,7 +1807,7 @@ static unsigned long pagemap_page_catego
 		if (p->masks_of_interest & PAGE_IS_FILE) {
 			swp = pte_to_swp_entry(pte);
 			if (is_pfn_swap_entry(swp) &&
-			    !PageAnon(pfn_swap_entry_to_page(swp)))
+			    !folio_test_anon(pfn_swap_entry_folio(swp)))
 				categories |= PAGE_IS_FILE;
 		}
 		if (pte_swp_soft_dirty(pte))
@@ -1873,7 +1873,7 @@ static unsigned long pagemap_thp_categor
 		if (p->masks_of_interest & PAGE_IS_FILE) {
 			swp = pmd_to_swp_entry(pmd);
 			if (is_pfn_swap_entry(swp) &&
-			    !PageAnon(pfn_swap_entry_to_page(swp)))
+			    !folio_test_anon(pfn_swap_entry_folio(swp)))
 				categories |= PAGE_IS_FILE;
 		}
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

memcg-convert-mem_cgroup_move_charge_pte_range-to-use-a-folio.patch
memcg-return-the-folio-in-union-mc_target.patch
memcg-use-a-folio-in-get_mctgt_type.patch
memcg-use-a-folio-in-get_mctgt_type_thp.patch
mm-add-pfn_swap_entry_folio.patch
proc-use-pfn_swap_entry_folio-where-obvious.patch
mprotect-use-pfn_swap_entry_folio.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

