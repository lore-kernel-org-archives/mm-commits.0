Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCF884D25
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 21:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723066910; cv=none; b=rwTcApbzup7Alewo7VQmTooD7tPWY56jYUE+ygVm+D64QOBJWHqMIjWsRSXzhmsgwAggh/Q88B68r64Mmnw8u4hKtSab7/WNUKE8lbNG0xDuctVfNmb1pF1RxkfU2qDs62BStZnKQywJqivF++6bMs+jSNijyrcJ8NhHUZ8iMBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723066910; c=relaxed/simple;
	bh=SSH3Y987SReoOO7a2WF9A2bJcstc0XKfUKdMBEChg5k=;
	h=Date:To:From:Subject:Message-Id; b=kb0qWXCS20987i85T5Y+8NgI3Hzfuy8Hil/lT4ekk+fcHvhvxSAKEMGWWLHUjtYKTnHZTKQpRaXTyWGwUlTf8ZqHa8jELz67PqOFRfjoNa68IKn8AP8folSMAtORzvXCQrZKeDg8htJcDicHfXrol/5ATNNmNfdWsCiF0KcXPQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lkZOGq63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lkZOGq63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D94C32781;
	Wed,  7 Aug 2024 21:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723066910;
	bh=SSH3Y987SReoOO7a2WF9A2bJcstc0XKfUKdMBEChg5k=;
	h=Date:To:From:Subject:From;
	b=lkZOGq63K/Z0j8XuJgJY+ET5woOEq6ahkhbzeuKVtIV4uqPKq/4BNOrBqPXuzIteg
	 utpcHlo6UvdlH+hd381YcDZwl2pSA/ATb62aPgT32DPWZ5LEnEU/YnqTFKhZEJmWeu
	 cJDrsyQqjIjLp/jHMF8mjOjKZMEl/SCsTvBoOtZI=
Date: Wed, 07 Aug 2024 14:41:49 -0700
To: mm-commits@vger.kernel.org,yi.zhang@redhat.com,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,rppt@kernel.org,rientjes@google.com,nphamcs@gmail.com,muchun.song@linux.dev,lizhijian@fujitsu.com,j.granados@samsung.com,hannes@cmpxchg.org,david@redhat.com,cerasuolodomenico@gmail.com,alison.schofield@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-account-memmap-on-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20240807214150.46D94C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: don't account memmap on failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-dont-account-memmap-on-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dont-account-memmap-on-failure.patch

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm: don't account memmap on failure
Date: Wed, 7 Aug 2024 21:19:28 +0000

When in alloc_vmemmap_page_list() memmap is failed to allocate, do not
account, the memory is going to be release at the function exit.

Link: https://lkml.kernel.org/r/20240807211929.3433304-3-pasha.tatashin@soleen.com
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-dont-account-memmap-on-failure
+++ a/mm/hugetlb_vmemmap.c
@@ -392,13 +392,10 @@ static int alloc_vmemmap_page_list(unsig
 
 	for (i = 0; i < nr_pages; i++) {
 		page = alloc_pages_node(nid, gfp_mask, 0);
-		if (!page) {
-			mod_node_page_state(NODE_DATA(nid), NR_MEMMAP, i);
+		if (!page)
 			goto out;
-		}
 		list_add(&page->lru, list);
 	}
-
 	mod_node_page_state(NODE_DATA(nid), NR_MEMMAP, nr_pages);
 
 	return 0;
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-update-the-memmap-stat-before-page-is-freed.patch
mm-dont-account-memmap-on-failure.patch
mm-dont-account-memmap-per-node.patch
memcg-increase-the-valid-index-range-for-memcg-stats-v5.patch
vmstat-kernel-stack-usage-histogram.patch
task_stack-uninline-stack_not_used.patch

