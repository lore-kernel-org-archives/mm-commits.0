Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A210B10E5
	for <mm-commits@vger.kernel.org>; Tue,  3 Jun 2025 02:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748916504; cv=none; b=Nx9aVlPcMUI4VpHdiRGlDTgx6RKle+NENny8iTl5P8hNDDnBBhGx/FV6WFS5XjxY9vggdZxFFnK/Pce+OGk3R9eaKWJdodr3nk0GwPmwf+fDmE3ZufL0AEYdJ/t7+Dt89g/91/3VSey4l9nIesljcfhbhCxd/yis1WOdHNnHSdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748916504; c=relaxed/simple;
	bh=u8tuIAsUpxrKb8gBQ11vUAknxS2uftcOH5M/QjseMlE=;
	h=Date:To:From:Subject:Message-Id; b=c2lsLFFo6xSin3cr+reOPZ8ODow2Pj1vUF+uKgByqa3R/gAljbj5khtgefoMabPAo5sgUbthrhphM+ySRxk5qqQyZejmHy7MjQiw1qSbETfbnSI1LN0U2ujr4pLROdPhHImL6S6X+G2FAi7QMjPIK4GXLPId+Dp4iVB/4MmqFIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q9lDgTWa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q9lDgTWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D76DC4CEEB;
	Tue,  3 Jun 2025 02:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748916504;
	bh=u8tuIAsUpxrKb8gBQ11vUAknxS2uftcOH5M/QjseMlE=;
	h=Date:To:From:Subject:From;
	b=Q9lDgTWa6aK0CI0tU9UxiDxtLVh2KIg1UAmmlrxANL6aiv1fcHq/LAAbx5tMIeo63
	 jDAwHhZTon2xzekjDAsrDFh7kEb/3Thff3jpBEDbiZgHZ3XofIhEzoSEyc7bWX6J7u
	 grIw/qiznza/nLAbcY7TOwqgL/tpZVKUDCzwTjmY=
Date: Mon, 02 Jun 2025 19:08:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,richardycc@google.com,osalvador@suse.de,mhocko@suse.com,mgorman@techsingularity.net,kirill.shutemov@linux.intel.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-support-for-initializing-pageblock-as-isolated-fix.patch added to mm-new branch
Message-Id: <20250603020824.1D76DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Date: Mon, 2 Jun 2025 21:51:25 -0400
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-add-support-for-initializing-pageblock-as-isolated-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-support-for-initializing-pageblock-as-isolated-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 2 Jun 2025 21:51:25 -0400
Subject: fixup: make init_pageblock_migratetype() set right migratetype

when page_group_by_mobility_disabled is 1.

Link: https://lkml.kernel.org/r/56683268-92C8-4FAE-9BAF-645C35227F24@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Richard Chang <richardycc@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-support-for-initializing-pageblock-as-isolated-fix
+++ a/mm/page_alloc.c
@@ -548,12 +548,14 @@ void __meminit init_pageblock_migratetyp
 					  enum migratetype migratetype,
 					  bool isolate)
 {
-	unsigned long flags = migratetype;
+	unsigned long flags;
 
 	if (unlikely(page_group_by_mobility_disabled &&
 		     migratetype < MIGRATE_PCPTYPES))
 		migratetype = MIGRATE_UNMOVABLE;
 
+	flags = migratetype;
+
 #ifdef CONFIG_MEMORY_ISOLATION
 	if (migratetype == MIGRATE_ISOLATE) {
 		VM_WARN_ONCE(
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_alloc-pageblock-flags-functions-clean-up.patch
mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_alloc-add-support-for-initializing-pageblock-as-isolated.patch
mm-page_alloc-add-support-for-initializing-pageblock-as-isolated-fix.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch

