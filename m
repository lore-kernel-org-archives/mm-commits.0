Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFB43EEAE2
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 22:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783377150; cv=none; b=IqisJ+N2SVvLHURLMn9Y5jwL2nW2MM6xCQvbJpv76AaGp+yXmsNMt8M3hzj1Weg8Z7hNrE5oA9313gZWY10bqJTNhjMyInYYKmgHk/GRBWbm1KH6IleO9t/A6FrDzB42d3mSIzVcLL7LHU/YSx1SKYkJ422QxoM6JLV24Zfwgx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783377150; c=relaxed/simple;
	bh=zUd/A6lsg6Hhb6fPNb1EBEOym2ycKQJUpEB/enB+W0U=;
	h=Date:To:From:Subject:Message-Id; b=jwx+Rj/OqsrWehtkd4nIxNT8W+r71w4IrQQtFrb/PPxD/UOi9kDbupZaNLJJ+HaWPS3r/ufx3PEW+94IHjfvkE86Ve/CT0u+OKWmov6y3sxDxpu43v9Xwq4ITZG0mBG8jwWCK8XTsQtk4ABtl4ElbqIbOHInYK8tDwZsKTFekJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eh3NZ73I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eh3NZ73I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135251F000E9;
	Mon,  6 Jul 2026 22:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783377149;
	bh=Ke1JnKWSXBIS4NaqdK5vj2/L3KQ7XbB1JVyNLenZphM=;
	h=Date:To:From:Subject;
	b=Eh3NZ73InRKcrpcIODm8OvnAj+ffv2tlzMpYtdg8yLSle+07I0Qw/deNwUScff7t8
	 h3Sx0hyIStTNA8mkqdzqNaAsAoEQ/FCB8OHEtw+QnlMBxn7DsFAnJ+Zr6jpD9/34eP
	 72kSqxI6GufEsotxCsINjyZooJUYv+0nlaINrm50=
Date: Mon, 06 Jul 2026 15:32:28 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tj@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,dennis@kernel.org,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-stop-recording-free-page-order-in-page-private.patch added to mm-new branch
Message-Id: <20260706223229.135251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: stop recording free page order in page->private
has been added to the -mm mm-new branch.  Its filename is
     mm-compaction-stop-recording-free-page-order-in-page-private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-stop-recording-free-page-order-in-page-private.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Fri, 03 Jul 2026 09:47:47 -0400

Commit 733aea0b3a7bb ("mm/compaction: add support for >0 order folio
memory compaction.") stores isolated free pages in an array indexed by
free page orders, it is no longer needed to store the order in each page's
->private field.  And there is no code using the stored order.  Stop doing
that.

It also prepares for an upcoming change that ensures subpage->private is
zero at page free time and the removal of set_page_private(0) from
prep_compound_tail().

Link: https://lore.kernel.org/20260703-keep-subpage-private-zero-at-free-v2-2-2970fe777dd6@nvidia.com
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

mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

