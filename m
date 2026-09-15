Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C163DB337
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 03:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789441471; cv=none; b=QK6iyJsnJSm6ZoArzTj+aHMbrcvK5rHZtV6cPNI5s4kFh0QGePF0cGFGLAlvE9uoVN51sF4jAV9EfaByPoGcqvEzRJj6iVQ+c5mcDSSv1IZou87XvXfVt5D/xhc/qGZ1LOn622VYE15FasJqGQpRKTC9jiBC+m89O6b3+1afGf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789441471; c=relaxed/simple;
	bh=PaYBfktKPCOVia+uHitZjiMQjJQW+XCs4nVFo6QmYxA=;
	h=Date:To:From:Subject:Message-Id; b=hWp7Mdp8SNEF1rWD8ojDjSzKA5WTCsstHjARlcTTusHjdlThwMJ/xYdrUkN5FHxgnMxQ6j3JWUd7XJ3Jc6gIKjq6+U0ghQZXnJSJy5cRlW/BP5KqtJz1mGI1gHJSGdL7gJytPG8SrCSMQh2Cg58hRqK8NF+Rc5VhCkHTwytA47U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qh/jyLzI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qh/jyLzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804C91F000FF;
	Tue, 15 Sep 2026 03:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789441469;
	bh=VSyWXslt08tFzgO1nrXRiYrE47xdiyNIdSOUjYhCjVQ=;
	h=Date:To:From:Subject;
	b=qh/jyLzIXplFyoV67aNBdQ6YUyAsiBeZ8P48civYXGX6zr+RQNadzTrks/qgRiSds
	 8dR8YMvqdDz3G+r2YnbtNcyrBoLu+c/68vChAmHomhF4aEO7C44r03oBwb+XCPAAn2
	 Eo1FlWTyppRM8NvDPgJjsu6uN81rzZGfjZQ/wb60=
Date: Mon, 14 Sep 2026 20:04:29 -0700
To: mm-commits@vger.kernel.org,jaewook376@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-preserve-mremap-address-delta-when-skipping-page-tables.patch removed from -mm tree
Message-Id: <20260915030429.804C91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: preserve mremap address delta when skipping page tables
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-preserve-mremap-address-delta-when-skipping-page-tables.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jaewook You <jaewook376@gmail.com>
Subject: mm/hugetlb: preserve mremap address delta when skipping page tables
Date: Sat, 12 Sep 2026 03:24:08 +0900

In move_hugetlb_page_tables(), optimize mremap() by advancing to the end
of the page table when the source page table does not exist, either
initially or after unsharing a PMD table.

However, the code advances both the source and destination addresses to
the end of their respective page tables, which is wrong.  The destination
address must be advanced only by the same amount as the source address.

If the source and destination offsets within their page tables differ, the
destination address can be advanced too far, causing follow-up issues. 
Fix this by advancing the destination address by the source advance
distance.

With a reproducer, we were able to trigger a kernel panic on x86-64.  With
this fix in place, we can no longer reproduce the issue.

Link: https://lore.kernel.org/20260911182408.75821-1-jaewook376@gmail.com
Fixes: e95a9851787b ("hugetlb: skip to end of PT page mapping when pte not present")
Fixes: 4ddb4d91b82f ("hugetlb: do not update address in huge_pmd_unshare")
Signed-off-by: Jaewook You <jaewook376@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Johan Hovold <johan@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-preserve-mremap-address-delta-when-skipping-page-tables
+++ a/mm/hugetlb.c
@@ -5226,18 +5226,21 @@ int move_hugetlb_page_tables(struct vm_a
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(mapping);
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
+		const unsigned long remaining_size =
+			(old_addr | last_addr_mask) - old_addr;
+
 		src_pte = hugetlb_walk(vma, old_addr, sz);
 		if (!src_pte) {
-			old_addr |= last_addr_mask;
-			new_addr |= last_addr_mask;
+			old_addr += remaining_size;
+			new_addr += remaining_size;
 			continue;
 		}
 		if (huge_pte_none(huge_ptep_get(mm, old_addr, src_pte)))
 			continue;
 
 		if (huge_pmd_unshare(&tlb, vma, old_addr, src_pte)) {
-			old_addr |= last_addr_mask;
-			new_addr |= last_addr_mask;
+			old_addr += remaining_size;
+			new_addr += remaining_size;
 			continue;
 		}
 
_

Patches currently in -mm which might be from jaewook376@gmail.com are


