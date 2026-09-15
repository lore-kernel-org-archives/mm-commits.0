Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DE629B781;
	Tue, 15 Sep 2026 03:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789441547; cv=none; b=YapURz4/2jOllMbABkSkiM0VZbScM8fXbOSO4bgKF2Qwnk+dfT7WjKCTknzO8HktaKer+m6KkwASYV2TVwEs+hXdqacKs6iQCQPljKroopCir9scERN18EKpuAAedktg7AyTYeEQlGb2/8znuyT8kIZXSyBSSl7bQYqEOQtzBvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789441547; c=relaxed/simple;
	bh=oNMZ+cto2HL7E+zVkc3wNKhPJT/lNVzeq9twaDd7Nj0=;
	h=Date:To:From:Subject:Message-Id; b=IjNCbUb+YOcnhaK/n5Poc1MoNknrENDeG/pIiLLn881DsbQppgIx6NAWYfkd/vYZzQE6LPbSsQvidi2Qo4Pm+6USs+rhYN3M3PnaGEkMXfLJExuc0UPwPGxtRO76sZhDYwASqHtOPIOYoaCREe/k84HbIpeStlfdbltfiEtsDjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r+asy+RY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r+asy+RY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECF41F000FF;
	Tue, 15 Sep 2026 03:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789441545;
	bh=CEALWbmZ9Qia7fbPhEJK3QzWRT6Hur9KW+VXqkxpBaU=;
	h=Date:To:From:Subject;
	b=r+asy+RY+42X5PuFyaaX3JquyPgw3d2JB0kkd9wBvPBKvAKk49qZYDliD0Huc20E5
	 gs4aMl8MDANeuN/mHXTbygQYuoo3+Z8s00/dNL0sMT9YoYGJ6J8o7zzP/iqpJmiL1w
	 Ey45SWVKErLB6UamcjNz8RTZibY+/SCUylL4KAC4=
Date: Mon, 14 Sep 2026 20:05:45 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,johan@kernel.org,david@kernel.org,jaewook376@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-preserve-mremap-address-delta-when-skipping-page-tables.patch added to mm-hotfixes-unstable branch
Message-Id: <20260915030545.8ECF41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: preserve mremap address delta when skipping page tables
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-preserve-mremap-address-delta-when-skipping-page-tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-preserve-mremap-address-delta-when-skipping-page-tables.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jaewook You <jaewook376@gmail.com>
Subject: mm/hugetlb: preserve mremap address delta when skipping page tables
Date: Mon, 14 Sep 2026 22:23:52 +0900

move_hugetlb_page_tables() optimizes mremap() by advancing to the last
entry in the page table when the source page table does not exist, either
initially or after unsharing a PMD table.  The common loop increment then
steps to the first entry in the next page table.

However, the code advances both the source and destination addresses to
the last entries in their respective page tables, which is wrong.  The
destination address must be advanced only by the same amount as the source
address.

If the source and destination offsets within their page tables differ, the
destination address can be advanced too far, causing follow-up issues. 
Fix this by advancing the destination address by the source advance
distance.

With a reproducer, we were able to trigger a kernel panic on x86-64.  With
this fix in place, we can no longer reproduce the issue.

Link: https://lore.kernel.org/20260914132352.472-1-jaewook376@gmail.com
Fixes: e95a9851787b ("hugetlb: skip to end of PT page mapping when pte not present")
Fixes: 4ddb4d91b82f ("hugetlb: do not update address in huge_pmd_unshare")
Signed-off-by: Jaewook You <jaewook376@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Johan Hovold <johan@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
---

 mm/hugetlb.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-preserve-mremap-address-delta-when-skipping-page-tables
+++ a/mm/hugetlb.c
@@ -5181,18 +5181,21 @@ int move_hugetlb_page_tables(struct vm_a
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(mapping);
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
+		const unsigned long offset_to_last_entry =
+			(old_addr | last_addr_mask) - old_addr;
+
 		src_pte = hugetlb_walk(vma, old_addr, sz);
 		if (!src_pte) {
-			old_addr |= last_addr_mask;
-			new_addr |= last_addr_mask;
+			old_addr += offset_to_last_entry;
+			new_addr += offset_to_last_entry;
 			continue;
 		}
 		if (huge_pte_none(huge_ptep_get(mm, old_addr, src_pte)))
 			continue;
 
 		if (huge_pmd_unshare(&tlb, vma, old_addr, src_pte)) {
-			old_addr |= last_addr_mask;
-			new_addr |= last_addr_mask;
+			old_addr += offset_to_last_entry;
+			new_addr += offset_to_last_entry;
 			continue;
 		}
 
_

Patches currently in -mm which might be from jaewook376@gmail.com are

mm-hugetlb-preserve-mremap-address-delta-when-skipping-page-tables.patch

