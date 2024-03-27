Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14E712FB08
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 18:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562477; cv=none; b=lW7pCheSdAITtw8ijfZcE+LAU01xboiRIinXdGI5H5Gq6Vyc3SSpw+YRvXdxw7OS7vsxebPVBNfxcb7t7dhgDMR+8iLyuv7beAYx/RDY7ruDPldyEWbEwCuI847ijtnFXzuuZHdMSaf64QeoQ5A3zS+f8Qj6Eyw7jLf4qqq2orw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562477; c=relaxed/simple;
	bh=4B91aEHS+HCVa58Nk58oP5jjTiDGgX9Gk+3FmwfABI4=;
	h=Date:To:From:Subject:Message-Id; b=fGg5r4vC6J/IvMa/85Mi0nq1ZM62Dp0SiZhSwwVOo3OErPFrwRQk4avn6wPrvLTZxiWfPAjPVNz+JCNFO0EZKWolhKugaqNJlQcyHGvorCVdeA6Ga+GM3KTH6Y3ZwMxmm/C41VB4lOjIF4Q/yAsFAm0lHxx9W6FsnkaStNiq+Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EEzpHrFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EEzpHrFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6A9C433F1;
	Wed, 27 Mar 2024 18:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711562477;
	bh=4B91aEHS+HCVa58Nk58oP5jjTiDGgX9Gk+3FmwfABI4=;
	h=Date:To:From:Subject:From;
	b=EEzpHrFyDGbeSPJLbW5imUh0+HUiDDCEKVsT8A9Hic1fAQoFlWb5cWGHoqeyur/0w
	 CxQjhDadyOMnsqQmDZ6XWPfxEnH+jONw4E+x2ilp71e9RU23jgPjeHozgXHsGDebkR
	 rbkfMqbr3hYxrQbkGqns7t2Y6GhtRKrmlkYlTFFQ=
Date: Wed, 27 Mar 2024 11:01:16 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,mhocko@suse.com,ioworker0@gmail.com,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-avoid-split-during-shrink_folio_list.patch added to mm-unstable branch
Message-Id: <20240327180117.7B6A9C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: avoid split during shrink_folio_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-avoid-split-during-shrink_folio_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-avoid-split-during-shrink_folio_list.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: vmscan: avoid split during shrink_folio_list()
Date: Wed, 27 Mar 2024 14:45:36 +0000

Now that swap supports storing all mTHP sizes, avoid splitting large
folios before swap-out.  This benefits performance of the swap-out path by
eliding split_folio_to_list(), which is expensive, and also sets us up for
swapping in large folios in a future series.

If the folio is partially mapped, we continue to split it since we want to
avoid the extra IO overhead and storage of writing out pages
uneccessarily.

Link: https://lkml.kernel.org/r/20240327144537.4165578-6-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Barry Song <v-songbaohua@oppo.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Gao Xiang <xiang@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-avoid-split-during-shrink_folio_list
+++ a/mm/vmscan.c
@@ -1206,11 +1206,12 @@ retry:
 					if (!can_split_folio(folio, NULL))
 						goto activate_locked;
 					/*
-					 * Split folios without a PMD map right
-					 * away. Chances are some or all of the
-					 * tail pages can be freed without IO.
+					 * Split partially mapped folios right
+					 * away. We can free the unmapped pages
+					 * without IO.
 					 */
-					if (!folio_entire_mapcount(folio) &&
+					if (data_race(!list_empty(
+						&folio->_deferred_list)) &&
 					    split_folio_to_list(folio,
 								folio_list))
 						goto activate_locked;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-swap-remove-cluster_flag_huge-from-swap_cluster_info-flags.patch
mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache.patch
mm-swap-simplify-struct-percpu_cluster.patch
mm-swap-allow-storage-of-all-mthp-orders.patch
mm-vmscan-avoid-split-during-shrink_folio_list.patch
mm-madvise-avoid-split-during-madv_pageout-and-madv_cold.patch

