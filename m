Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA457558BC
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247788; cv=none; b=bn0Hp2Pit3xKzuUZRT7EE7v/0NxcVt4M4F/K24TJaAhC3l53tWIrLfeMBB6nBv+6chGj0oJtVjjNqwIdONQsYR18aXZ4CXQPqtAD4srrYjLl+Q6Xo9GLUmJ11xiYtgbXoQswbeD9hhN/BFO/M57iYv1cISuKnCIcMG7VF2Qp8WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247788; c=relaxed/simple;
	bh=GAHunUPAiY0f0Q/Iw8llKesUPFH6jHbXryKETV3PT2I=;
	h=Date:To:From:Subject:Message-Id; b=t66tPmBycuwoYqkpRJ/MOsUiV/xpeUvzw9ChlBiGR+SYPgEU41pJ64g38WJ8sGdT+EIZS2iwtynh5FDt42QMVMRzmJywq7qCmbXLd4heghnIRJ/3ROvBXqPE5aVz/MLEmSpa4fs5vZqVE9VIglfMdFqqNlOErbwD9JJItehUGBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GE/whky3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GE/whky3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D01C4CEC2;
	Mon,  2 Sep 2024 03:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247787;
	bh=GAHunUPAiY0f0Q/Iw8llKesUPFH6jHbXryKETV3PT2I=;
	h=Date:To:From:Subject:From;
	b=GE/whky3Z8h5JExinTs5t5VMuBO8XGrajlUCdQ/CIb6QvRkr5Per04Smnmh/8t3Ss
	 PSrx0KGE1+2uMtc355U70CySiHuNPYfOOI0iB0yjyirxpB1TIpaNSiHXEPbktKpS/j
	 Bgu7joZpcZvjGG6giAXJYnIWuZY2mEOQjFBy4FVk=
Date: Sun, 01 Sep 2024 20:29:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.lendacky@amd.com,rppt@kernel.org,mgorman@suse.de,hannes@cmpxchg.org,david@redhat.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_isolation-handle-unaccepted-memory-isolation.patch removed from -mm tree
Message-Id: <20240902032947.68D01C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_isolation: handle unaccepted memory isolation
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-handle-unaccepted-memory-isolation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: page_isolation: handle unaccepted memory isolation
Date: Fri, 9 Aug 2024 14:48:53 +0300

Page isolation machinery doesn't know anything about unaccepted memory and
considers it non-free.  It leads to alloc_contig_pages() failure.

Treat unaccepted memory as free and accept memory on pageblock isolation. 
Once memory is accepted it becomes PageBuddy() and page isolation knows
how to deal with them.

Link: https://lkml.kernel.org/r/20240809114854.3745464-8-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A.  Shutemov <kirill.shutemov@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/page_isolation.c~mm-page_isolation-handle-unaccepted-memory-isolation
+++ a/mm/page_isolation.c
@@ -152,6 +152,9 @@ static int set_migratetype_isolate(struc
 	unsigned long flags;
 	unsigned long check_unmovable_start, check_unmovable_end;
 
+	if (PageUnaccepted(page))
+		accept_page(page);
+
 	spin_lock_irqsave(&zone->lock, flags);
 
 	/*
@@ -367,6 +370,11 @@ static int isolate_single_pageblock(unsi
 		VM_BUG_ON(!page);
 		pfn = page_to_pfn(page);
 
+		if (PageUnaccepted(page)) {
+			pfn += MAX_ORDER_NR_PAGES;
+			continue;
+		}
+
 		if (PageBuddy(page)) {
 			int order = buddy_order(page);
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


