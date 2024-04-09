Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E464038DC9
	for <mm-commits@vger.kernel.org>; Tue,  9 Apr 2024 21:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712697737; cv=none; b=oi73Cf4iXNKy99Qz+NiOHpPqogzdvU5Y/A52ulk69vkflWAIDZ4sZZuQ/KPMai7drM+MFSYmdHgFxHKUzK9SGdEyFqOtaAHIPPMhsFAtD6wL3pFGl9v3pVICf9NYZy+S/BaRoWwLIIubCOpCSB5qISRDwRn3AShusYQx1nMKOgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712697737; c=relaxed/simple;
	bh=N6dV517Mmf9g0gZmYvX21erctyfM/Vk45Jana/iEe1k=;
	h=Date:To:From:Subject:Message-Id; b=rdtwwM/ERy4mRbNXg5hzaDJ+n4bQGPqqa5H7qIVlxACORJamnIsizX3LjZbbGfSwPDLKa7wBgw6ZvZrvnP2b0r7wANnNU9xOSqdVOtE8gsBQWVhRv7DdVQKWtp1rtz5yH7GevoHZo8G9MNWujDNCrPlksZYvMkZ+93dqozwVr7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OUHkCcnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OUHkCcnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62508C433C7;
	Tue,  9 Apr 2024 21:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712697736;
	bh=N6dV517Mmf9g0gZmYvX21erctyfM/Vk45Jana/iEe1k=;
	h=Date:To:From:Subject:From;
	b=OUHkCcnpPIAiOy9Lg2DoekXBzJoj2OhWO1sKUUJ5hKYcIfbjqYOJAcUJfSJ3GTFGJ
	 cGZVfjJ3+KVrj1LXW/y1EXn4x/8gPDvVQMJwN3KxChKTK5RKoPbNbrM+49MPFC61/X
	 nSl0G+1Zs3b+9f7tJSIfniTjZJda0nv9Z7HIc+z8=
Date: Tue, 09 Apr 2024 14:22:14 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-defer-enablement-of-static-branch.patch added to mm-hotfixes-unstable branch
Message-Id: <20240409212216.62508C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,page_owner: defer enablement of static branch
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mmpage_owner-defer-enablement-of-static-branch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_owner-defer-enablement-of-static-branch.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_owner: defer enablement of static branch
Date: Tue, 9 Apr 2024 15:17:15 +0200

Kefeng Wang reported that he was seeing some memory leaks with kmemleak
with page_owner enabled.

The reason is that we enable the page_owner_inited static branch and then
proceed with the linking of stack_list struct to dummy_stack, which means
that exists a race window between these two steps where we can have pages
already being allocated calling add_stack_record_to_list(), allocating
objects and linking them to stack_list, but then we set stack_list
pointing to dummy_stack in init_page_owner.  Which means that the objects
that have been allocated during that time window are unreferenced and
lost.

Fix this by deferring the enablement of the branch until we have properly
set up the list.

Link: https://lkml.kernel.org/r/20240409131715.13632-1-osalvador@suse.de
Fixes: 4bedfb314bdd ("mm,page_owner: maintain own list of stack_records structs")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reported-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Closes: https://lore.kernel.org/linux-mm/74b147b0-718d-4d50-be75-d6afc801cd24@huawei.com/
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mmpage_owner-defer-enablement-of-static-branch
+++ a/mm/page_owner.c
@@ -118,7 +118,6 @@ static __init void init_page_owner(void)
 	register_dummy_stack();
 	register_failure_stack();
 	register_early_stack();
-	static_branch_enable(&page_owner_inited);
 	init_early_allocated_pages();
 	/* Initialize dummy and failure stacks and link them to stack_list */
 	dummy_stack.stack_record = __stack_depot_get_stack_record(dummy_handle);
@@ -129,6 +128,7 @@ static __init void init_page_owner(void)
 		refcount_set(&failure_stack.stack_record->count, 1);
 	dummy_stack.next = &failure_stack;
 	stack_list = &dummy_stack;
+	static_branch_enable(&page_owner_inited);
 }
 
 struct page_ext_operations page_owner_ops = {
_

Patches currently in -mm which might be from osalvador@suse.de are

mmpage_owner-update-metadata-for-tail-pages.patch
mmpage_owner-fix-refcount-imbalance.patch
mmpage_owner-fix-accounting-of-pages-when-migrating.patch
mmpage_owner-fix-printing-of-stack-records.patch
mmswapops-update-check-in-is_pfn_swap_entry-for-hwpoison-entries.patch
mmpage_owner-defer-enablement-of-static-branch.patch

