Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800871EB2F
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 01:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750123740; cv=none; b=CarkfRgfE7ISUwCcW5jc+/q69id42B3S8MROgDg/OCbsSB1aS28zNB09XZfrNUVDoV/SleplCKXM5+W92IpZ0uiN8mz+y0+skyMII2NYEBcEg0vED4mNF35vbEqQ3/bYBxBYqZleuzWzbw/mAbYZ3PPgUG8D5IjmIzo8uFTLaWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750123740; c=relaxed/simple;
	bh=uQwz/ocg9VybLdqMai0CQ4KPQ7EubE3TDw/i7+s8Tr0=;
	h=Date:To:From:Subject:Message-Id; b=a+fz0CIidVg7oc/daWc5qmZcWNaPKBjxmOBDmI1qzXaCAQYKZyFesorHWeGCSaRZFCizb9rSosVGXDzTvsqSIqoM1tWkGpCM4Kvnl6m2ZnwoudwhioBjgOOxEgot4ivB/KC4/ccSmUdrZIYgywNz8YJ+EQxydA5qzARWHegQn0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pn39ClHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pn39ClHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED994C4CEEA;
	Tue, 17 Jun 2025 01:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750123740;
	bh=uQwz/ocg9VybLdqMai0CQ4KPQ7EubE3TDw/i7+s8Tr0=;
	h=Date:To:From:Subject:From;
	b=pn39ClHbcYn64eNax0nGcM7TRHs27nPVbzsD5JEjOgqJ8Z00SVwgn1yzKv0s1hp1B
	 eiItKTRZkBIi2tQEOpKkYjsgE+ImLoSRTw35Ep8hX16epooqhC5z5wUdnv1QJ6hANr
	 TTIYt7Se7jaXw+LyOtDpiJ7ZN9b5U/We42ClD4CM=
Date: Mon, 16 Jun 2025 18:28:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,richardycc@google.com,osalvador@suse.de,mhocko@suse.com,mgorman@techsingularity.net,kirill.shutemov@linux.intel.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix.patch added to mm-new branch
Message-Id: <20250617012859.ED994C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix
Date: Mon Jun 16 06:25:00 PM PDT 2025

kernel/kexec_handover.c uses set_pageblock_migratetype()

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
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    2 ++
 mm/page_alloc.c                |    3 +--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/page-isolation.h~mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix
+++ a/include/linux/page-isolation.h
@@ -45,6 +45,8 @@ void __meminit init_pageblock_migratetyp
 					  enum migratetype migratetype,
 					  bool isolate);
 
+void set_pageblock_migratetype(struct page *page, enum migratetype migratetype);
+
 bool pageblock_isolate_and_move_free_pages(struct zone *zone, struct page *page);
 bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *page);
 
--- a/mm/page_alloc.c~mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix
+++ a/mm/page_alloc.c
@@ -525,8 +525,7 @@ void clear_pfnblock_bit(const struct pag
  * @page: The page within the block of interest
  * @migratetype: migratetype to set
  */
-static void set_pageblock_migratetype(struct page *page,
-				      enum migratetype migratetype)
+void set_pageblock_migratetype(struct page *page, enum migratetype migratetype)
 {
 	if (unlikely(page_group_by_mobility_disabled &&
 		     migratetype < MIGRATE_PCPTYPES))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-convert-most-other-generic_file_mmap-users-to-mmap_prepare-fix.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix.patch

