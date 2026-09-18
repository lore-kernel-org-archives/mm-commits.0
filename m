Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAC828C840;
	Fri, 18 Sep 2026 05:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789710237; cv=none; b=jdvpCLN3MxnxP/wTKe9vRgyIvkeB0Y0zDttiUThEpM0usAmnRHbfU828Ip0pKMG5BmorsIC0chjsi6Ah5+9MvxbukiyEbpW+IFICV3BrseYdwHmYV4OefLyedmXvet1s4XiORFKK+uvH+lbxqxnl/zY776KU2NF4ELtAJRUhFts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789710237; c=relaxed/simple;
	bh=S6Gs2QJ3JGX54S2jV95cLlROaN/6GVkB25VnjA2wU2Q=;
	h=Date:To:From:Subject:Message-Id; b=rXVfqhIK21vbQzk9G2C1UPzBEUbOWIR5WVxwkLXjtK0AceFLp48sZHMFAbqSI8qkRbw9Ir0kL7MNCcW6eDr5tUb+yZbrXvVuK7AfbAxLT2596DEtcFHlY4b6m5knwUsulg2XkXNp4TsxfyB9dVUTBihzB+UUb7TC0oP4vWaagcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bUA6sHPB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bUA6sHPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FF81F00893;
	Fri, 18 Sep 2026 05:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789710236;
	bh=9AC1D9iJRMC7e0HpM/QdjQHkFNb1p1Wayyku2vQ7nh0=;
	h=Date:To:From:Subject;
	b=bUA6sHPBeLDZQrv5uIhx00BqWOk2bi8aMSeXaoG0SEuIjz65auKzsUt5jQroSGM0V
	 2/nK8yN2Oc6IbQjuFZFDtB1NttQy8IT+u+jn5/KNmTk1V1pk9Z1EmoaLD5QFIONr4t
	 GLQlHA6EXj89RGxHdrfGOwTsMP5zox5013AWPYao=
Date: Thu, 17 Sep 2026 22:43:56 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,johan@kernel.org,david@kernel.org,jaewook376@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-preserve-mremap-address-delta-when-skipping-page-tables.patch removed from -mm tree
Message-Id: <20260918054356.64FF81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: preserve mremap address delta when skipping page tables
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-preserve-mremap-address-delta-when-skipping-page-tables.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -5170,18 +5170,21 @@ int move_hugetlb_page_tables(struct vm_a
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


