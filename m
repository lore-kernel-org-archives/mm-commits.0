Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A05E13635C
	for <mm-commits@vger.kernel.org>; Fri, 19 Dec 2025 00:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766104813; cv=none; b=NblCzxympiLuNdFGQiF87HdO544DIJL+WT7lf973/nFi8x1ByDjbmbNK9loIY81qk7TlxrNO5JZPEn2GAFQNeIlGBaJRz/5dtLfobtzFSgmyxA8LFg7V7yKuIlzoWgEn9X04howGOXGUyTmHdNarBrEbm6TlnuEnSV2PcHjnfDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766104813; c=relaxed/simple;
	bh=2o2kl1ppqm2ZoSV2YmodlqbjJsR3roLnXkDQgUIDlKU=;
	h=Date:To:From:Subject:Message-Id; b=g9cv7mrmbe2B8xu0dCeDVa2C03mHE2i9vw+2fm5L4wM7zbr0wQNR/ASvBwq4ZHBl+2zK2rG20yBFNevNWV7fcQPGfnnbAkygWhBKfGOBu+o3UNkkB66dIOgy6qWvTvjdQHvhYBxA7mAbk2N5mQ02Yx0/ZpexVfmu0UVhvv0epKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hFcLaAB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hFcLaAB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE755C4CEFB;
	Fri, 19 Dec 2025 00:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766104813;
	bh=2o2kl1ppqm2ZoSV2YmodlqbjJsR3roLnXkDQgUIDlKU=;
	h=Date:To:From:Subject:From;
	b=hFcLaAB+FeRu6NxyQ/jLKPEXkbHIaOnVhxD9MGTtqq74BM3Tz8Fj3h6B+mtK940my
	 CSD9SxjTj1XDjpACjtv/d2vEwhc8DiIbNv2yvPQssamo8wVjbmmCgpr1sF65h7+lLV
	 kbyudD3O/4qcFPbNL8JxA8sOVXVJJk+5in3UrSHs=
Date: Thu, 18 Dec 2025 16:40:12 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rientjes@google.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,mgorman@suse.de,mclapinski@google.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,laoar.shao@gmail.com,joel.granados@kernel.org,jack@suse.cz,hannes@cmpxchg.org,gourry@gourry.net,david@redhat.com,corbet@lwn.net,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-implement-movable_gigantic_pages-sysctl-fix.patch added to mm-new branch
Message-Id: <20251219004012.EE755C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-implement-movable_gigantic_pages-sysctl-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-implement-movable_gigantic_pages-sysctl-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-implement-movable_gigantic_pages-sysctl-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-implement-movable_gigantic_pages-sysctl-fix
Date: Thu Dec 18 04:37:05 PM PST 2025

restore hugetlb_internal.h inclusion

Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Clapinski <mclapinski@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-hugetlb-implement-movable_gigantic_pages-sysctl-fix
+++ a/mm/hugetlb.c
@@ -49,6 +49,7 @@
 #include "internal.h"
 #include "hugetlb_vmemmap.h"
 #include "hugetlb_cma.h"
+#include "hugetlb_internal.h"
 #include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

genalloch-fix-htmldocs-warning.patch
x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix.patch
mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch
kasan-unpoison-vms-addresses-with-a-common-tag-fix.patch
mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-hugetlb-implement-movable_gigantic_pages-sysctl-fix.patch
kernel-watchdogc-fix-unused-var-warning.patch

