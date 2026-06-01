Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CF837CD39
	for <mm-commits@vger.kernel.org>; Mon,  1 Jun 2026 19:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780340448; cv=none; b=lL2YfCTIWscxM3C53uLmDRJIdea0Q25ZdbQlpODsjIDloGBP1AIPahzuQLnbQAwbZ+YMQM+nxX5eg4XH46Ezrrf+iNEdfhABVoM+jv0bxu9q94u/jtSBolMzhFxLMv5oZRTAmdeejs7V7GOsTZjx+imWmM0vIPAKHISuUH6tsck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780340448; c=relaxed/simple;
	bh=G0hZBzf10Zn/3uHirfShbGkYEChae9MyqBHjEIiqTEI=;
	h=Date:To:From:Subject:Message-Id; b=FpeB3m4+uezAZIXAafzM2NkTGN0PJ7x8Xj9YdmJetBnmgIeMwD/zoa7MxB/bZef8URdGpwhVhgjxOj5euctCrknFYzVqblYyD7oS41CC0MqvjMV209EXXSyQEgilO6SxDlAcBWFIJCNM9GndQyMXGxnJpC7xUqFuh8WF97MqRgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bWyJZQCV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bWyJZQCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49D21F00893;
	Mon,  1 Jun 2026 19:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780340435;
	bh=IerNJ2wZQOc+FHdwuy7MZqf9Ucz9g341520kTR0TzkA=;
	h=Date:To:From:Subject;
	b=bWyJZQCVmbt3Y4GWyWNW5KAb9djL76JYY2TNoFVKvj1DwZANlzsJPuTZDu8oXtCOi
	 IXctlYPTRWF0JRo1UNvHyKQ+3QSMB1cobjAtsb7E5/7IzJ2c+D0tjvEXzF2OdqO0OY
	 KJDx3NJuMLsvDnLUTCvRvs8hks5k/4bl2dmdCLH8=
Date: Mon, 01 Jun 2026 12:00:34 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ljs@kernel.org,david@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-delete-stale-comment-about-cachelines.patch added to mm-unstable branch
Message-Id: <20260601190034.E49D21F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: delete stale comment about cachelines
has been added to the -mm mm-unstable branch.  Its filename is
     mm-delete-stale-comment-about-cachelines.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-delete-stale-comment-about-cachelines.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm: delete stale comment about cachelines
Date: Mon, 01 Jun 2026 11:40:09 +0000

These comments have been wrong since commit a211c6550efc ("mm: page_alloc:
defrag_mode kswapd/kcompactd watermarks") added NR_FREE_PAGES_BLOCKS. 
Since nobody has complained about it in the last year, it seems unlikely
these comments were particularly useful anyway, so delete them.

Link: https://lore.kernel.org/20260601-zone_stat_item-comment-v1-1-f452dd91d5eb@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/mmzone.h~mm-delete-stale-comment-about-cachelines
+++ a/include/linux/mmzone.h
@@ -214,7 +214,6 @@ enum numa_stat_item {
 #endif
 
 enum zone_stat_item {
-	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
 	NR_FREE_PAGES_BLOCKS,
 	NR_ZONE_LRU_BASE, /* Used only for compaction and reclaim retry */
@@ -225,7 +224,6 @@ enum zone_stat_item {
 	NR_ZONE_UNEVICTABLE,
 	NR_ZONE_WRITE_PENDING,	/* Count of dirty, writeback and unstable pages */
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
-	/* Second 128 byte cacheline */
 #if IS_ENABLED(CONFIG_ZSMALLOC)
 	NR_ZSPAGES,		/* allocated in zsmalloc */
 #endif
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-introduce-for_each_free_list.patch
mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch
mm-rejig-pageblock-mask-definitions.patch
mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch
mm-page_alloc-drop-a-misleading-__always_inline.patch
mm-page_alloc-document-that-alloc_pages_nolock-uses-rcu.patch
mm-page_alloc-remove-vm_bug_ons-from-pindex-helpers.patch
mm-delete-stale-comment-about-cachelines.patch

