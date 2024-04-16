Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAF91E511
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 22:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307231; cv=none; b=Nkh8/p7/sU0xGbpQyTQNK08I501qfwazpCvRXVd4ME4zm3jo691H/z3+MaTi1dqJgDk/AL7z+zYRdIV+PaemObpGUkPrlWZ2LxVxYEYyJMLePDwn56hCQyZngRCVosXgsKLcRgDG/Eg1cWz5DqR8LXjc3T6e3DbFFicu+WP1UhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307231; c=relaxed/simple;
	bh=UO2e3N9x77KoNQZPPgFss5ACzQobBI9mU56dfyLXoFM=;
	h=Date:To:From:Subject:Message-Id; b=P1Yq69fhZfxrSq7Pl2QdGZwY7G9lgS+x2hTo94Nr8nay1oXFiEG69au8yZ9TnZwsffEbwqXsh+LEUhBk5AMDDUqbsrMMOhTmDZrIQPeB2N/0z7XlphPwkxGsc3kWlR+oY7oBWiQ3d7B9zz/+l+fkRRUOCGVBAIJgLcKXoG4bhuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=moGWjo8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="moGWjo8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CDBC113CE;
	Tue, 16 Apr 2024 22:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713307231;
	bh=UO2e3N9x77KoNQZPPgFss5ACzQobBI9mU56dfyLXoFM=;
	h=Date:To:From:Subject:From;
	b=moGWjo8zbSoTkUFGCiH5KN67iVulKppOm6T84Pmq5vIu5E9gY3i+Fq1lNx3jpdiMq
	 GzM+DFUGUtmu7NhUFbgITMK1izuITomsnSlPZIBj/maQ97k75GHR06pDNQszOc+cHL
	 EVVTyC3PidSzo9sIthxo7luKggswxSZXCHiw5kco=
Date: Tue, 16 Apr 2024 15:40:30 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mmpage_owner-defer-enablement-of-static-branch.patch removed from -mm tree
Message-Id: <20240416224031.22CDBC113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,page_owner: defer enablement of static branch
has been removed from the -mm tree.  Its filename was
     mmpage_owner-defer-enablement-of-static-branch.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


