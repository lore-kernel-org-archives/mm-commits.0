Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69A7435AAB
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 22:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783377157; cv=none; b=TVUZKYXKBidXoTH9QMKpGAaBtaZKa0TDigL8vnUE/7qh46Cia+2U+bzz4Zh0o0wZDp5uc7tV44+lEbP7vrpXLNDb2WBzr+9D+5nW6Gg25kmFXIxqajSCRF7p5JIMgJOu4GLUZJj8uhnVOc37tBzV95YIEBbAQfTX1ZgmjLnHnQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783377157; c=relaxed/simple;
	bh=QHbXwk7dVX+ZEeQRsNr9nAcD4UrfLfEqURxk8ak6CYg=;
	h=Date:To:From:Subject:Message-Id; b=HONhrW6Ee61NvVUmB164JLw1+Q6v9iYRgr/FAfCE0KrFqwh2y5NKJ4otQhWkQQQPwi944CYcBMD+0N8Nv2ckGVlQZByUeNJezp8BwWOGA0uA2zQkw14w1Y7LHCHsifnci04RfghntHM1L2k8bC0fqdIFphUPlKQypcT772WJeBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lW6nCPsA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lW6nCPsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D30E1F000E9;
	Mon,  6 Jul 2026 22:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783377155;
	bh=k0UtRFm0sYZWffYC13gRORxV/CE5xmcOsts4PuILU9E=;
	h=Date:To:From:Subject;
	b=lW6nCPsA7Onqs1hRn4ufmGUsnAMhSUTzxU1tVU0/gBMOBApeY8LWSEoQnhgqcuLuL
	 w/vTsCs/0r44uGY6sONttUpprmI76YSjbtFkpeKlPb7rgCJy/iy7Qn8DSM2r9dofYz
	 +8jTFjG73dkEBeZkWgAgfJ3dk1I0WBP3xji6O6Pc=
Date: Mon, 06 Jul 2026 15:32:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tj@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,dennis@kernel.org,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch added to mm-new branch
Message-Id: <20260706223235.6D30E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: remove set_page_private() in prep_compound_tail()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

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
Subject: mm/page_alloc: remove set_page_private() in prep_compound_tail()
Date: Fri, 03 Jul 2026 09:47:50 -0400

Tail pages are expected to have (and optionally be checked) zeroed
->private when they are freed.  It stays true during subsequent
reallocation, so replace the tail_page->private initialization with a
VM_WARN_ON_ONCE() in compound page preparation.

Link: https://lore.kernel.org/20260703-keep-subpage-private-zero-at-free-v2-5-2970fe777dd6@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-page_alloc-remove-set_page_private-in-prep_compound_tail
+++ a/mm/internal.h
@@ -808,7 +808,7 @@ static inline void prep_compound_tail(st
 {
 	tail->mapping = TAIL_MAPPING;
 	set_compound_head(tail, head, order);
-	set_page_private(tail, 0);
+	VM_WARN_ON_ONCE(tail->private);
 }
 
 static inline void init_compound_tail(struct page *tail,
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

