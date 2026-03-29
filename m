Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AD813AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744922; cv=none; b=gEwf42zJcvLmGDmvglpw5k1HDuQY5Wz2VFTLJBs2b/vJY+xMpyi2DwzK2B4af4YU1IR3qVuY0tCJwnxSa1WU3fthtZkt782/Z30aj+arBb2g8lZ22xBW9CyhvwVEBdRE/x5xlB6KVCod1ihcfdkAQflNe+DvtlAArzrtQzz1Bvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744922; c=relaxed/simple;
	bh=V//adc2PB+KknTqfrZvl7Ywu4mLNlXsboArQXy3ScjE=;
	h=Date:To:From:Subject:Message-Id; b=DvpKUn6LaOVGe1FjWfQkbUkKeAnckdEUhO0ZsbwgX0iytoKXJnZMWoU+/MjSN4dmQ1j9nLvTe2EltYbxEJxu0ZLbk8JseCjxwxfC/+zHDRBT80XnW/u2SAIC32MCGC6SxV26+qTC7jF/07usN5F332p4zIPISHCYnRGlaONOK9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kFY0mQXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kFY0mQXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CA9C4CEF7;
	Sun, 29 Mar 2026 00:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744921;
	bh=V//adc2PB+KknTqfrZvl7Ywu4mLNlXsboArQXy3ScjE=;
	h=Date:To:From:Subject:From;
	b=kFY0mQXmNoJa6ey18lLzOEFlExmvdfmxmOmWtjSqCX5qBPX57v+z/20ORFJz5r4vq
	 MnrzgvwSufruGhrsPXEl0d1SkA8UpOV/hXFwQB8ZGRsrnx+d+KGiukutcqOlac41cg
	 9kiO4WSgv/e++1SG3/wk9eUzEIcpik98DxkQjj3g=
Date: Sat, 28 Mar 2026 17:42:01 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sidhartha.kumar@oracle.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-remove-for_each_valid_pfn-usage.patch removed from -mm tree
Message-Id: <20260329004201.B8CA9C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: remove for_each_valid_pfn() usage
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-remove-for_each_valid_pfn-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/memory_hotplug: remove for_each_valid_pfn() usage
Date: Fri, 20 Mar 2026 23:13:34 +0100

When offlining memory, we know that the memory range has no holes. 
Checking for valid pfns is not required.

Link: https://lkml.kernel.org/r/20260320-sparsemem_cleanups-v2-2-096addc8800d@kernel.org
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

 mm/memory_hotplug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-for_each_valid_pfn-usage
+++ a/mm/memory_hotplug.c
@@ -1745,7 +1745,7 @@ static int scan_movable_pages(unsigned l
 {
 	unsigned long pfn;
 
-	for_each_valid_pfn(pfn, start, end) {
+	for (pfn = start; pfn < end; pfn++) {
 		unsigned long nr_pages;
 		struct page *page;
 		struct folio *folio;
@@ -1795,7 +1795,7 @@ static void do_migrate_range(unsigned lo
 	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
 
-	for_each_valid_pfn(pfn, start_pfn, end_pfn) {
+	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		struct page *page;
 
 		page = pfn_to_page(pfn);
_

Patches currently in -mm which might be from david@kernel.org are


