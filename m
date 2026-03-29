Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B051B13AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744926; cv=none; b=up9sTqt5eE2KfFYz8Lpvl8QHndllNJV5fxadmZ16ZXCKlr+h7W1IOHsiZKjvWZaU4kVFQz9nXwLncCd21RDJYKee6qqX6OsISoz2gs3oFFrshuhQQvXxvjlPXBhPZhz1AYFetbkwT2ZqYBfdKjC3KbNumWTwN/fWAAgIjmWQJmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744926; c=relaxed/simple;
	bh=sCTDq1Ghg+vA4C+E73HEakt5V4JnVGSRbTxRIXKtOmo=;
	h=Date:To:From:Subject:Message-Id; b=M4dz5CiwHmu44tF/1gFoySIjEYiHFiq7iWWSolba+rJszMEhIZoKNv1YpHN1rQOuAydnnkdTe2OCA4ZctfeFTOG1YM7OUb4cwp98K9PwDwGnOudbJbnNopgMzMUamT17v1KgP266neNGKbSjuEccR9LtGDH4NG55yzd89OhfWp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wAPdaWs0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wAPdaWs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87010C4CEF7;
	Sun, 29 Mar 2026 00:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744926;
	bh=sCTDq1Ghg+vA4C+E73HEakt5V4JnVGSRbTxRIXKtOmo=;
	h=Date:To:From:Subject:From;
	b=wAPdaWs01G02/qzfqZ2yyuGmnJ75fIn80X1YIBU0CgWAlETDz4nFz/J4MZqHJ+YUK
	 j1KDENr3qlTY8HlFazbrIBOKe54kSfT4VlCMF3NMk4ZbClwWxlYk9KTrOZnyy5cFL3
	 N4CXD909oFI02jXa7/zcQxtJwsorV2G3fFR9gW1I=
Date: Sat, 28 Mar 2026 17:42:06 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sidhartha.kumar@oracle.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-simplify-check_pfn_span.patch removed from -mm tree
Message-Id: <20260329004206.87010C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: simplify check_pfn_span()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-simplify-check_pfn_span.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/memory_hotplug: simplify check_pfn_span()
Date: Fri, 20 Mar 2026 23:13:37 +0100

We now always have CONFIG_SPARSEMEM_VMEMMAP, so remove the dead code.

Link: https://lkml.kernel.org/r/20260320-sparsemem_cleanups-v2-5-096addc8800d@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-simplify-check_pfn_span
+++ a/mm/memory_hotplug.c
@@ -319,21 +319,13 @@ static void release_memory_resource(stru
 static int check_pfn_span(unsigned long pfn, unsigned long nr_pages)
 {
 	/*
-	 * Disallow all operations smaller than a sub-section and only
-	 * allow operations smaller than a section for
-	 * SPARSEMEM_VMEMMAP. Note that check_hotplug_memory_range()
-	 * enforces a larger memory_block_size_bytes() granularity for
-	 * memory that will be marked online, so this check should only
-	 * fire for direct arch_{add,remove}_memory() users outside of
-	 * add_memory_resource().
+	 * Disallow all operations smaller than a sub-section.
+	 * Note that check_hotplug_memory_range() enforces a larger
+	 * memory_block_size_bytes() granularity for memory that will be marked
+	 * online, so this check should only fire for direct
+	 * arch_{add,remove}_memory() users outside of add_memory_resource().
 	 */
-	unsigned long min_align;
-
-	if (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP))
-		min_align = PAGES_PER_SUBSECTION;
-	else
-		min_align = PAGES_PER_SECTION;
-	if (!IS_ALIGNED(pfn | nr_pages, min_align))
+	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION))
 		return -EINVAL;
 	return 0;
 }
_

Patches currently in -mm which might be from david@kernel.org are


