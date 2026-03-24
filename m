Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614E436215C
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388591; cv=none; b=Y/Fe/zC5FQccMk8cskrhM3/OoVdGxlVoR4kU9OcTHtcGDCJeIOW5xIERt/hqcdAYEt9WvBWZHBuNQV/QBdsplgHiJ9MfeESOPaq/vCYX5zFLDXvIdRAAnr4wNB5ov4B/WZTry6YDD46Mxvev+BjBMikOdj/vEhe88YCJVdoXGlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388591; c=relaxed/simple;
	bh=IZLZb9bHLSS83BeAyE8kBl81/Uc+8s5bDg53lOfrmAU=;
	h=Date:To:From:Subject:Message-Id; b=rPHXYmmMBEkp1pt/oDYuBrShYeaq815eVHLSaaiRsj6/7/zUbidksvfMfjarMFpBsOwWUOVYvhS88GOoFmVF9fR8hQGIzCiyqMXdgAfhFfJ21pSZAtFXF4NCFh3y+NxYyVfl2Vzevyf0XfZr88wG2jX8azjKw7iVCqpl0tT8+qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0MM5rWXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0MM5rWXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38816C19424;
	Tue, 24 Mar 2026 21:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388591;
	bh=IZLZb9bHLSS83BeAyE8kBl81/Uc+8s5bDg53lOfrmAU=;
	h=Date:To:From:Subject:From;
	b=0MM5rWXiN6SX1mWJXlm88/7UEj1AQwCKI7eKyMvsM3QsLRZC0Eb9o+0nr3I5aVOZK
	 cyrr4530lsK1uijS4m2A25TvUetA+qAtb0kbm9366LAZCxteOxrGv7lq8OrL7Fyr3V
	 9YnIoZra3ZfXre1T2J6Hx9wgmbr+AUDwuT1aJo6o=
Date: Tue, 24 Mar 2026 14:43:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-skip-lazy-free-folios.patch removed from -mm tree
Message-Id: <20260324214311.38816C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: skip lazy-free folios
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-skip-lazy-free-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vernon Yang <yanglincheng@kylinos.cn>
Subject: mm: khugepaged: skip lazy-free folios
Date: Sat, 21 Feb 2026 17:39:18 +0800

For example, create three task: hot1 -> cold -> hot2.  After all three
task are created, each allocate memory 128MB.  the hot1/hot2 task
continuously access 128 MB memory, while the cold task only accesses its
memory briefly and then call madvise(MADV_FREE).  However, khugepaged
still prioritizes scanning the cold task and only scans the hot2 task
after completing the scan of the cold task.

All folios in VM_DROPPABLE are lazyfree, Collapsing maintains that
property, so we can just collapse and memory pressure in the future will
free it up.  In contrast, collapsing in !VM_DROPPABLE does not maintain
that property, the collapsed folio will not be lazyfree and memory
pressure in the future will not be able to free it up.

So if the user has explicitly informed us via MADV_FREE that this memory
will be freed, and this vma does not have VM_DROPPABLE flags, it is
appropriate for khugepaged to skip it only, thereby avoiding unnecessary
scan and collapse operations to reducing CPU wastage.

Here are the performance test results:
(Throughput bigger is better, other smaller is better)

Testing on x86_64 machine:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
| cycles per access   |  4.96         |  2.21         | -55.44% |
| Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
| dTLB-load-misses    |  284814532    |  69597236     | -75.56% |

Testing on qemu-system-x86_64 -enable-kvm:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
| cycles per access   |  7.29         |  2.07         | -71.60% |
| Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
| dTLB-load-misses    |  241600871    |  3216108      | -98.67% |

[vernon2gm@gmail.com: add comment about VM_DROPPABLE in code, make it clearer]
  Link: https://lkml.kernel.org/r/i4uowkt4h2ev47obm5h2vtd4zbk6fyw5g364up7kkjn2vmcikq@auepvqethj5r
Link: https://lkml.kernel.org/r/20260221093918.1456187-5-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    1 +
 mm/khugepaged.c                    |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-skip-lazy-free-folios
+++ a/include/trace/events/huge_memory.h
@@ -25,6 +25,7 @@
 	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
 	EM( SCAN_PAGE_LOCK,		"page_locked")			\
 	EM( SCAN_PAGE_ANON,		"page_not_anon")		\
+	EM( SCAN_PAGE_LAZYFREE,		"page_lazyfree")		\
 	EM( SCAN_PAGE_COMPOUND,		"page_compound")		\
 	EM( SCAN_ANY_PROCESS,		"no_process_for_page")		\
 	EM( SCAN_VMA_NULL,		"vma_null")			\
--- a/mm/khugepaged.c~mm-khugepaged-skip-lazy-free-folios
+++ a/mm/khugepaged.c
@@ -46,6 +46,7 @@ enum scan_result {
 	SCAN_PAGE_LRU,
 	SCAN_PAGE_LOCK,
 	SCAN_PAGE_ANON,
+	SCAN_PAGE_LAZYFREE,
 	SCAN_PAGE_COMPOUND,
 	SCAN_ANY_PROCESS,
 	SCAN_VMA_NULL,
@@ -577,6 +578,16 @@ static enum scan_result __collapse_huge_
 		folio = page_folio(page);
 		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
 
+		/*
+		 * If the vma has the VM_DROPPABLE flag, the collapse will
+		 * preserve the lazyfree property without needing to skip.
+		 */
+		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
+		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
+			result = SCAN_PAGE_LAZYFREE;
+			goto out;
+		}
+
 		/* See hpage_collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
@@ -1325,6 +1336,16 @@ static enum scan_result hpage_collapse_s
 		}
 		folio = page_folio(page);
 
+		/*
+		 * If the vma has the VM_DROPPABLE flag, the collapse will
+		 * preserve the lazyfree property without needing to skip.
+		 */
+		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
+		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
+			result = SCAN_PAGE_LAZYFREE;
+			goto out_unmap;
+		}
+
 		if (!folio_test_anon(folio)) {
 			result = SCAN_PAGE_ANON;
 			goto out_unmap;
_

Patches currently in -mm which might be from yanglincheng@kylinos.cn are


