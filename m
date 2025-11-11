Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863F32F39C5
	for <mm-commits@vger.kernel.org>; Tue, 11 Nov 2025 23:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762903496; cv=none; b=l+sinJZkopdaNTrUtrxyANRXfKNAieZcduRopBj9dhLXzsD33UihIOg5d/RFCYYzMttHdHdVesfbODD3Z+CwFfJfMEjtDXMLlZs+pbuvLMVs4RAqllaJG5wB2hckJP0OjtK1DCuXrycxLq+tY30egC49IpeFF7ReRn2N3nIggC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762903496; c=relaxed/simple;
	bh=LEJDcffSG9rllOadv9vSGKqXsDgHgIm+turdGNyUgH0=;
	h=Date:To:From:Subject:Message-Id; b=IeCckUI87Nn+8YctAB//iOrrSgqd/wayBQV8rm1gtZmQqS2zVfwxSUUntr2kpG8s/C1fGDUi92yml///4nmqidI3hvEAMERRwLBwafDeE0sErFErjtq1a8e9xxHmvKF0mefsCidVr6Dzj0UJIMJngDX0bW7CgZZb8J4DLGeS1WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1gn/Fqc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1gn/Fqc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE518C16AAE;
	Tue, 11 Nov 2025 23:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762903496;
	bh=LEJDcffSG9rllOadv9vSGKqXsDgHgIm+turdGNyUgH0=;
	h=Date:To:From:Subject:From;
	b=1gn/Fqc6kyLyD5i0F9OcvQeFfgYxPkGQF/A8BxG2siBmK5kFQFoESWl75CCyQA5Z4
	 No1GJEIRbgPwrbkn/onSvBeMb6F56VTn5nKRBYmHzsvYqLJW/aEI9TvwKlvhl7lb0R
	 68X+wU2kKc8okWfW+Nv9u+ldauXBoi9jftcUHsog=
Date: Tue, 11 Nov 2025 15:24:55 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-remove-folio_test_private-check-in-pageout-fix-2.patch added to mm-unstable branch
Message-Id: <20251111232455.DE518C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmscan-remove-folio_test_private-check-in-pageout-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-remove-folio_test_private-check-in-pageout-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-remove-folio_test_private-check-in-pageout-fix-2.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-vmscan-remove-folio_test_private-check-in-pageout-fix-2
Date: Mon, 22 Sep 2025 14:02:28 +0800

remove comment and WARNing, per Hugh and others

Link: https://lkml.kernel.org/r/392a9ca3-31ac-4447-bd44-3c656d63e4ca@linux.alibaba.com
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-folio_test_private-check-in-pageout-fix-2
+++ a/mm/vmscan.c
@@ -697,17 +697,8 @@ static pageout_t pageout(struct folio *f
 	 * swap_backing_dev_info is bust: it doesn't reflect the
 	 * congestion state of the swapdevs.  Easy to fix, if needed.
 	 */
-	if (!is_page_cache_freeable(folio))
+	if (!is_page_cache_freeable(folio) || !mapping)
 		return PAGE_KEEP;
-	if (!mapping) {
-		/*
-		 * We should no longer have dirty folios with clean buffers and
-		 * a NULL mapping. However, let's be careful for now.
-		 */
-		VM_WARN_ON_FOLIO(true, folio);
-		return PAGE_KEEP;
-	}
-
 	if (!shmem_mapping(mapping) && !folio_test_anon(folio))
 		return PAGE_ACTIVATE;
 	if (!folio_clear_dirty_for_io(folio))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-vmscan-remove-folio_test_private-check-in-pageout.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix-2.patch
mm-vmscan-simplify-the-folio-refcount-check-in-pageout.patch
mm-vmscan-simplify-the-folio-refcount-check-in-pageout-fix.patch
mm-vmscan-filter-out-the-dirty-file-folios-for-node_reclaim.patch
mm-vmscan-simplify-the-logic-for-activating-dirty-file-folios.patch

