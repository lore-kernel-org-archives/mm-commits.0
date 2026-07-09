Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006A74F7979
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 18:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622480; cv=none; b=mv5YqjoI3EsEOklh9oinbXC+NX/UJHQSnxikre656JRf9oNc8R2Y+9WYjX3TN3bFezKmx0Mqur11kzNNaWeLJwo4dqA7r0WOzE5t6DK45Wrhu2auf3QmmqhfArsE33jknItbRst1a7kWQjsdgSEHuHSgFIO2+4zPT9qnEQr3Xgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622480; c=relaxed/simple;
	bh=jGZiXFBCDpuFipwOZza/e7oYhidAyDeOtRkPJXKOSDk=;
	h=Date:To:From:Subject:Message-Id; b=Kla7a3ntJv7A0Y3wU+nXVHshElzeC8X6esDXATZTGhsYi9eoGAwZMKFkmcNzhLsZ/F8fYMAcz+mMwq8YGGeg836RTfamTE4rWxR7WlvdlQrH6ZKqjPGz6r6zNhtMOrgd+TcIOQO2TVwf56oo/z06/NqP+PxEeCEBUXTQhJW0O+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u37EhU6r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u37EhU6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2A51F000E9;
	Thu,  9 Jul 2026 18:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783622478;
	bh=LY7nw5bMhkp7JvRDLJPc/1apu+AKthiKwpjnVSW+iWQ=;
	h=Date:To:From:Subject;
	b=u37EhU6ra5/qcI1gx0HC3qH60f4+4riHpWb/ECRSS80aLsgYxXMmX/Dtu4IzKLPoP
	 C/wDk3UfW6fqcXmqmrpoXrNsy2RApK+HbonfdLLpoe6T8MTugF/0xq08+CdjFeVuW3
	 k6wr+lzb6hYV0mUaUSF19ekVaayQOOqncslbNe/g=
Date: Thu, 09 Jul 2026 11:41:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-stop-recording-free-page-order-in-page-private.patch added to mm-unstable branch
Message-Id: <20260709184118.9B2A51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: stop recording free page order in page->private
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-stop-recording-free-page-order-in-page-private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-stop-recording-free-page-order-in-page-private.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/compaction: stop recording free page order in page->private
Date: Thu, 09 Jul 2026 14:06:02 -0400

Commit 733aea0b3a7bb ("mm/compaction: add support for >0 order folio
memory compaction.") stores isolated free pages in an array indexed by
free page orders, it is no longer needed to store the order in each page's
->private field.  And there is no code using the stored order.  Stop doing
that.

It also prepares for an upcoming change that ensures subpage->private is
zero at page free time and the removal of set_page_private(0) from
prep_compound_tail().

Link: https://lore.kernel.org/20260709-keep-subpage-private-zero-at-free-v3-2-7e4fe155f5b9@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-stop-recording-free-page-order-in-page-private
+++ a/mm/compaction.c
@@ -645,7 +645,6 @@ static unsigned long isolate_freepages_b
 		isolated = __isolate_free_page(page, order);
 		if (!isolated)
 			break;
-		set_page_private(page, order);
 
 		nr_scanned += isolated - 1;
 		total_isolated += isolated;
@@ -1618,7 +1617,6 @@ static void fast_isolate_freepages(struc
 		/* Isolate the page if available */
 		if (page) {
 			if (__isolate_free_page(page, order)) {
-				set_page_private(page, order);
 				nr_isolated = 1 << order;
 				nr_scanned += nr_isolated - 1;
 				total_isolated += nr_isolated;
@@ -1847,7 +1845,6 @@ again:
 		size >>= 1;
 
 		list_add(&freepage[size].lru, &cc->freepages[start_order]);
-		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_owner-add-numa-node-filter-fix.patch
mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

