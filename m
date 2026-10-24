Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832494;
	b=IqseJktbe9ts+Fwkh4QaToJYwfl5oHfEVF4bPWZcYr8a+H+vrfGJBrx8K+FMItRh5vJB
	 ckQO0HYC+mZ0W2ZBuoKvcDR6s+wXoyfpOVx7NDaZeHlXgrR4tAwB5wnihMXYk9C3bJZLa
	 b0n+zxVjPShmFvSvQXbd2HRvaevMDony+nmPPafMl4ynzZxFssjTkkn9sV7LwlgrKRF9s
	 51rEv0UVuAi+qvGm42eYF82D60RiahBGuGcFL+GY6mP1FjLUfYXjPkUO22E6fUQu8VPxp
	 KyIxRoKZOfefcSSju0gtYaM5KlqEWXV3IBDmqpMIlC0laEur4D5DS93bG5Pha+A9x5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832494;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=dqnw2lOQsnrt48wxgZetEHc+2tTCT3UX8J93MKuyoBA=;
	b=paSMnazcsNJkA0+F6Z2SITgUE96h3bEYcoa1JHr5kZy0YEF4nIQSVmyzRhoKYfOE7w90
	 PRaP+YXU3VlWKhEbwxcnpJ9+o2Wcxdoz+f5Zi+HQWfGf2B/w9KF4FXTJCbGGLfBUSD6Q9
	 KuoCPnAjtIi5XAi4KE6vxkcucqXZht7sbo975lWzQlVbsDf135oJH1yuh7iASyF1qLYkZ
	 4dAVvGy3SvNNomNeENfVdKBAAnvL3mffSFo2VIr7F++WDYiEp2ztRXtp0MGw6vVH/pQ9l
	 OTAFLm5xD1HOZJBa5yjt9LvLGCdLzjcj27j/Ycqt3YmZGgMwuRn0bauyO80rHyC/26A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qeT74vLr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C185606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qeT74vLr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C401F01825;
	Sat, 24 Oct 2026 09:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832494;
	bh=dqnw2lOQsnrt48wxgZetEHc+2tTCT3UX8J93MKuyoBA=;
	h=Date:To:From:Subject;
	b=qeT74vLrPrIVp8TBF3+6xSxww89AzkA3KIbbcFgoGV5XCkqeuf7qEw5m8tqa8eMLV
	 qGRzYLOhZ7dQikwA5vdiBopT5z+wxaSAUVNf5uyBz7frfdmsrp52S04beutWa298mJ
	 ecd9xMMRHOszJ1TBDgkrnnNKxSRpehGaXmqBpJkk=
Date: Sat, 24 Oct 2026 02:01:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,ryan.roberts@arm.com,nico.pache@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-collapse-call-collapse_file-from-collapse_single_pmd.patch removed from -mm tree
Message-Id: <20261024090134.06C401F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/collapse: call collapse_file() from collapse_single_pmd()
has been removed from the -mm tree.  Its filename was
     mm-collapse-call-collapse_file-from-collapse_single_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/collapse: call collapse_file() from collapse_single_pmd()
Date: Wed, 14 Oct 2026 18:11:41 +0100

collapse_scan_file() reads the page cache to decide whether a table is
worth collapsing and, when it is, calls collapse_file() itself.  The
caller cannot get between the decision and the collapse.

Move the collapse_file() call up into collapse_single_pmd(), so the scan
stops at the decision.

Two things change with it.  The writeback retry re-runs collapse_file()
alone instead of rescanning first; collapse_file() repeats the scan's
checks under the page cache lock anyway.  And mm_khugepaged_scan_file
fires before the collapse, so for an accepted table its status reads
SCAN_SUCCEED; what the collapse made of the table is for
mm_khugepaged_collapse_file to report.

Preparation for splitting a collapse into a scan under mmap_lock and a
run without it.  The file scan has to stop where the anonymous one will.

Link: https://lore.kernel.org/20261014171145.3292736-9-kas@kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
---

 mm/khugepaged.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/khugepaged.c~mm-collapse-call-collapse_file-from-collapse_single_pmd
+++ a/mm/khugepaged.c
@@ -2763,13 +2763,9 @@ static enum scan_result collapse_scan_fi
 	else
 		cc->progress += HPAGE_PMD_NR;
 
-	if (result == SCAN_SUCCEED) {
-		if (present < HPAGE_PMD_NR - max_ptes_none) {
-			result = SCAN_EXCEED_NONE_PTE;
-			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-		} else {
-			result = collapse_file(mm, addr, file, start, cc);
-		}
+	if (result == SCAN_SUCCEED && present < HPAGE_PMD_NR - max_ptes_none) {
+		result = SCAN_EXCEED_NONE_PTE;
+		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 	}
 
 	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap, result);
@@ -2800,8 +2796,16 @@ static enum scan_result collapse_single_
 
 	mmap_read_unlock(mm);
 	*lock_dropped = true;
-retry:
+
+	/*
+	 * SCAN_PTE_MAPPED_HUGEPAGE is work too: the page cache already holds
+	 * the PMD folio, and only the PTE table is left to retract.
+	 */
 	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+	if (result != SCAN_SUCCEED)
+		goto put;
+retry:
+	result = collapse_file(mm, addr, file, pgoff, cc);
 
 	/* Dirty pages are worth a writeback and one more try, if asked for */
 	if (cc->policy.file_writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
@@ -2813,6 +2817,7 @@ retry:
 		triggered_wb = true;
 		goto retry;
 	}
+put:
 	fput(file);
 
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
_

Patches currently in -mm which might be from kas@kernel.org are


