Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A2713DDAE
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 18:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783621444; cv=none; b=lNUHW8Xn5tzPyyEJtBGOAO6N5xn7bA4NgLOJn0MPQHEo/in4WuqLM+WYLR8ovwKRsWkMMXMW6dsJpNinH197B5BJiwmumvsEK/gw/w/Z9ua1Aj7Aae+/N6KIW5e3dwsxDxhfK0fWGpzhes1n1DXKy3gfkiX3O18hMdWg28YC09k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783621444; c=relaxed/simple;
	bh=ysdo/nyht9Spo9nzJjofedgpkzHZzy8ORPUYFJgszuo=;
	h=Date:To:From:Subject:Message-Id; b=gGq0hB5rf5sEhb3Ra3FZpOuxpqiG9GH39eT1KY2SGxT+EQ3WoID3M0rC4aVnbfkdOknNJYCB1oepbRJZ1CSQaIjrZdMvuvHp0ODPrwEuqTC6EOFSsenLopKwmw3R6IBiWc4cofq56vRLiMQcBbkNJ1jTMkhJ8z/cVe7ptUqqJXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EV5bEiHg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EV5bEiHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C761F000E9;
	Thu,  9 Jul 2026 18:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783621443;
	bh=5+LWZ8CdTXPTJvX3fRBOSYDcRysvc0As142IX2SQOG0=;
	h=Date:To:From:Subject;
	b=EV5bEiHgzK3r1vegBzsRFN1UYrDRGkZj7D2AbdYKPAqVJpIMARHXAIRB9+vh4+CHl
	 CWFfXUktOz2h993ZUgYVlY+w6L12T4hmud+KPPYhOuvmiyb+CuVxtZREUcSMRn6jz2
	 hE1YDDn9us2yZmslttXY002VS0jBygaeZmJYnnek=
Date: Thu, 09 Jul 2026 11:24:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch removed from -mm tree
Message-Id: <20260709182403.21C761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: remove set_page_private() in prep_compound_tail()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

This patch was dropped because an updated version will be issued

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
@@ -741,7 +741,7 @@ static inline void prep_compound_tail(st
 {
 	tail->mapping = TAIL_MAPPING;
 	set_compound_head(tail, head, order);
-	set_page_private(tail, 0);
+	VM_WARN_ON_ONCE(tail->private);
 }
 
 static inline void init_compound_tail(struct page *tail,
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_owner-add-numa-node-filter-fix.patch

