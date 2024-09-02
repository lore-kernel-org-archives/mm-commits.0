Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37DB3EA76
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247683; cv=none; b=Hd8Ot+a/7gI3OLV4ZaWT2Vl/SswoJ3+FIymDCV4erYbz4JTSrmlgaxkcfLgzkwuzaYKK+LGFUBiz7/WBkIfgWyNxh5TuUgKTbKgnNGOaloynPmYjb3brBP7JWamMPzaDFJ+j5OdD/9rx49IAukl3S0NC+sVnLxFIvo0++ZM3HSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247683; c=relaxed/simple;
	bh=LjOO+vkFFV9xT4xJQqHHepZGwW5yS6KhT4v/v2ASpWs=;
	h=Date:To:From:Subject:Message-Id; b=qO7nQVWlIV0pD6Gdspxih9oFjc3riZhiubHKBrWVhAuVrvS+/K+kx3peUlcUAfalezkvwQsBgdcYXhpUId97s3P+zmb9uWUQlc9d/7FPwxYA7R7vGSgAGMWAMR5bwGQP33v8Z2MfMyrgHMttKbsb4qrZ+dhJ7VOOGQhOwqVMeCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RfXmPrCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RfXmPrCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88987C4CEC2;
	Mon,  2 Sep 2024 03:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247683;
	bh=LjOO+vkFFV9xT4xJQqHHepZGwW5yS6KhT4v/v2ASpWs=;
	h=Date:To:From:Subject:From;
	b=RfXmPrCmSwwG5MVDx8+/Qrtwtov3ZfXXAwwvGaViFLtB2nj6hhGh8sVrYObQZSi1Z
	 FhpQwleISRsqb0yiacoa0C2//0T/IgAhGiD/wFvCcvypqOyxB8POpftGT8KaxBR4wY
	 OdSd5p6yskmMU1Te5rCbnQtksicN5PlmDM/YOKj8=
Date: Sun, 01 Sep 2024 20:28:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,baohua@kernel.org,justinjiang@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shrink-skip-folio-mapped-by-an-exiting-process.patch removed from -mm tree
Message-Id: <20240902032803.88987C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shrink skip folio mapped by an exiting process
has been removed from the -mm tree.  Its filename was
     mm-shrink-skip-folio-mapped-by-an-exiting-process.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhiguo Jiang <justinjiang@vivo.com>
Subject: mm: shrink skip folio mapped by an exiting process
Date: Wed, 10 Jul 2024 16:36:41 +0800

The releasing process of the non-shared anonymous folio mapped solely by
an exiting process may go through two flows: 1) the anonymous folio is
firstly is swaped-out into swapspace and transformed into a swp_entry in
shrink_folio_list; 2) then the swp_entry is released in the process
exiting flow.  This will result in the high cpu load of releasing a
non-shared anonymous folio mapped solely by an exiting process.

When the low system memory and the exiting process exist at the same time,
it will be likely to happen, because the non-shared anonymous folio mapped
solely by an exiting process may be reclaimed by shrink_folio_list.

This patch is that shrink skips the non-shared anonymous folio solely
mapped by an exting process and this folio is only released directly in
the process exiting flow, which will save swap-out time and alleviate the
load of the process exiting.

Barry provided some effectiveness testing in [1].  "I observed that
this patch effectively skipped 6114 folios (either 4KB or 64KB mTHP),
potentially reducing the swap-out by up to 92MB (97,300,480 bytes)
during the process exit.  The working set size is 256MB."

Link: https://lkml.kernel.org/r/20240710083641.546-1-justinjiang@vivo.com
Link: https://lore.kernel.org/linux-mm/20240710033212.36497-1-21cnbao@gmail.com/ [1]
Signed-off-by: Zhiguo Jiang <justinjiang@vivo.com>
Acked-by: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c   |   15 +++++++++++++++
 mm/vmscan.c |    7 ++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

--- a/mm/rmap.c~mm-shrink-skip-folio-mapped-by-an-exiting-process
+++ a/mm/rmap.c
@@ -75,6 +75,7 @@
 #include <linux/memremap.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/mm_inline.h>
+#include <linux/oom.h>
 
 #include <asm/tlbflush.h>
 
@@ -870,6 +871,20 @@ static bool folio_referenced_one(struct
 			continue;
 		}
 
+		/*
+		 * Skip the non-shared swapbacked folio mapped solely by
+		 * the exiting or OOM-reaped process. This avoids redundant
+		 * swap-out followed by an immediate unmap.
+		 */
+		if ((!atomic_read(&vma->vm_mm->mm_users) ||
+		    check_stable_address_space(vma->vm_mm)) &&
+		    folio_test_anon(folio) && folio_test_swapbacked(folio) &&
+		    !folio_likely_mapped_shared(folio)) {
+			pra->referenced = -1;
+			page_vma_mapped_walk_done(&pvmw);
+			return false;
+		}
+
 		if (pvmw.pte) {
 			if (lru_gen_enabled() &&
 			    pte_young(ptep_get(pvmw.pte))) {
--- a/mm/vmscan.c~mm-shrink-skip-folio-mapped-by-an-exiting-process
+++ a/mm/vmscan.c
@@ -863,7 +863,12 @@ static enum folio_references folio_check
 	if (vm_flags & VM_LOCKED)
 		return FOLIOREF_ACTIVATE;
 
-	/* rmap lock contention: rotate */
+	/*
+	 * There are two cases to consider.
+	 * 1) Rmap lock contention: rotate.
+	 * 2) Skip the non-shared swapbacked folio mapped solely by
+	 *    the exiting or OOM-reaped process.
+	 */
 	if (referenced_ptes == -1)
 		return FOLIOREF_KEEP;
 
_

Patches currently in -mm which might be from justinjiang@vivo.com are


