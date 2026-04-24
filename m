Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACF63E1207
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 16:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777047295; cv=none; b=VacyAigeXIr3ITh6giuzqPpInBc+5GrCfLvi3Kwc8Zsgtix8Hoi3afMiPMmlppUHhMdjjDx9rfioujmJZe9GWimV3yhPfxis4Ws4C4kkoSOkXkCBOfeRN4tGG3s1gB51g4X/htdEQjju+x5VzwmVPZBqtYD5VkmU3YgwbsY1h5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777047295; c=relaxed/simple;
	bh=XXY2NLj8TNfoxti9w4Z3fZ5j7/gMKTVjh7NQtevXr+Q=;
	h=Date:To:From:Subject:Message-Id; b=oSosYn8XT6qgpNj5NOMHYczS2sOeEJE8nypbvYDCkBwWGPv32nLPrD8V98q/WVFwTi6P1wsbWaoUiOw+lnGFGKC7tKQUX+xW/bsOQHhXvph575Ao04Itk+QALnHe5QcDZNNnyl12nZiKr4nz5iZWE26r9ktNqjNgEWbfZTL6oVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wfd7pe8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wfd7pe8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1916C19425;
	Fri, 24 Apr 2026 16:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777047294;
	bh=XXY2NLj8TNfoxti9w4Z3fZ5j7/gMKTVjh7NQtevXr+Q=;
	h=Date:To:From:Subject:From;
	b=Wfd7pe8/tHGeJiokesVfZyTgIVqwg/PH/yo4wXLSf2aEcdyVM5wzKSAh8UliDUFnJ
	 MjlToTmg8mS+uUzmztbBPmBWbazcCFF8+CBCva0quv7UOduBeSYzNvC8xBd/QqI1y0
	 kQ48nfHFQBPRrSJkAufYxDR5IgSN76R+GVXAJHEE=
Date: Fri, 24 Apr 2026 09:14:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-fix-%pgp-format-specifier-argument-type.patch added to mm-new branch
Message-Id: <20260424161454.D1916C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: fix %pGp format specifier argument type
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-fix-%pgp-format-specifier-argument-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-fix-%pgp-format-specifier-argument-type.patch

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
From: Zhen Ni <zhen.ni@easystack.cn>
Subject: mm/page_owner: fix %pGp format specifier argument type
Date: Tue, 14 Apr 2026 15:58:13 +0800

The %pGp format specifier expects an argument of type 'unsigned long *',
but page->flags is now of type 'memdesc_flags_t' (a struct containing an
unsigned long member 'f') after the introduction of memdesc_flags_t.

Fix the type mismatch by passing &page->flags.f instead of &page->flags,
which matches the expected type.

Link: https://lore.kernel.org/20260414075813.3425968-1-zhen.ni@easystack.cn
Fixes: 53fbef56e07d ("mm: introduce memdesc_flags_t")
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-fix-%pgp-format-specifier-argument-type
+++ a/mm/page_owner.c
@@ -588,7 +588,7 @@ print_page_owner(char __user *buf, size_
 			migratetype_names[page_mt],
 			pfn >> pageblock_order,
 			migratetype_names[pageblock_mt],
-			&page->flags);
+			&page->flags.f);
 
 	/* Print mode: full stack or stack handle */
 	if (READ_ONCE(owner_filter.print_mode) == PAGE_OWNER_PRINT_STACK_HANDLE) {
_

Patches currently in -mm which might be from zhen.ni@easystack.cn are

mm-page_owner-add-filter-infrastructure.patch
mm-page_owner-add-print_mode-filter.patch
mm-page_owner-add-numa-node-filter-with-nodelist-support.patch
mm-page_owner-fix-%pgp-format-specifier-argument-type.patch

