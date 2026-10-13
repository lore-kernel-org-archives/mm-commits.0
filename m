Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A925048592E
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866045; cv=none; b=YC/0JWAXSOzY/cIsqS+dQw47Wl/xyHYmjbJRjGKOg0OedCPgq3wuhnPXT95ubJd/L/O2uv9rw9uvM39/kwn86wiSHC/Y/ci43snZbLstwtn6EyUEczJUgU2sVGXK9QLfyEANBDUR3O3oTt6DSp1TKIsNmKdcw82nla709cjU368=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866045; c=relaxed/simple;
	bh=Vwiarm2bDz909YL+4s/DnAyto4JhvCT7/jjLq5mFACA=;
	h=Date:To:From:Subject:Message-Id; b=kKbBevrpROu97EL7d2RcSRcmQcOfTHgvI347UJhiQKrSeaphInGE1edvtwk39rE5vx06iyITAh+lMf1uoJuIz8+PsWqn7vFn3CmlIZ5Btce6dmZwICMbr+zv1zpSh5brnJ9Gwe3JJ+c4tshQNlnHl29wx6V8ZBtGffnEJqa0vZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eE11RX/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eE11RX/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843471F000FF;
	Tue, 13 Oct 2026 04:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866040;
	bh=CIxioLh1E9eS6SskMfxZ4XPti/ZSR3LuD5vrHDyphZg=;
	h=Date:To:From:Subject;
	b=eE11RX/ersS1RfgeQNj7UPCbRBlVgNKnsk+HSTvna/gILyPNpJbMJVB3CxY809ZFj
	 IrcbqVTliYHYiNKfU5WGrMfx6Rsyo8OBfQ8MN6fPg5Wslp3HV613FWdTrF3YmwFAyd
	 BfLx9wg5cgwNz1wErMpAzbsvfNEkX7LlWD8+dEHI=
Date: Mon, 12 Oct 2026 21:34:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kernel-team@meta.com,jgg@ziepe.ca,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agordeev@linux.ibm.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch removed from -mm tree
Message-Id: <20261013043400.843471F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: zap whole PTE tables in the khugepaged race harness
has been removed from the -mm tree.  Its filename was
     selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: zap whole PTE tables in the khugepaged race harness
Date: Sat, 19 Sep 2026 01:24:49 +0100

The harness's MADV_DONTNEED thread zaps 1 to 32 pages at a time, never a
whole PMD-aligned area, and only a zap that covers a full table frees the
table itself (CONFIG_PT_RECLAIM).

Make the thread zap a whole PMD-aligned area about one iteration in 64,
and keep the fine-grained zaps as the common case.  The new case frees
page tables, racing that against a collapse walking the same table.

Link: https://lore.kernel.org/20260919002451.496763-20-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Assisted-by: LLM
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kernel-team@meta.com
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/khugepaged_race.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged_race.c~selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness
+++ a/tools/testing/selftests/mm/khugepaged_race.c
@@ -118,8 +118,21 @@ static void *dontneed_fn(void *arg)
 		unsigned long page_idx = rand_page(&seed);
 		unsigned long nr = 1UL << (rand_r(&seed) % 6);	/* 1..32 pages */
 
-		madvise(region + page_idx * page_size,
-			room_from(page_idx, nr) * page_size, MADV_DONTNEED);
+		/*
+		 * Now and then zap a whole PMD-aligned area: only a zap that
+		 * covers the full table frees the table itself (CONFIG_PT_RECLAIM).
+		 */
+		if (!(rand_r(&seed) % 64)) {
+			unsigned long area = page_idx /
+					(hpage_pmd_size / page_size);
+
+			madvise(region + area * hpage_pmd_size,
+				hpage_pmd_size, MADV_DONTNEED);
+		} else {
+			madvise(region + page_idx * page_size,
+				room_from(page_idx, nr) * page_size,
+				MADV_DONTNEED);
+		}
 		usleep(rand_r(&seed) % 500);
 	}
 	return NULL;
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

