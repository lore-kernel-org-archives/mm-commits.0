Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2622256742
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247781; cv=none; b=Kqd6e9H4SgbeUzUTHEu89CguKR781qmZNn6/pTIvWjhWCpVTt5GuniLup1+aQZPnnSEh7piRJl6ATEosHz8wt2U0j1WQ/oA/p50p2T1Yi0teeMFwPp2tEy5R9swfgcmdXm/a3zCBl4H8jo+5SRo6YQu2USD5qCWl5AQdJL/CnCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247781; c=relaxed/simple;
	bh=8XoKk5BlMGEWWj7ThEQJy5ydKffy9WljOuYQ9VACf2w=;
	h=Date:To:From:Subject:Message-Id; b=Q1hCXMpZ+wGYLpLP9UXrnFgOZQC1cSw+ZsGLLEPqd52LjSg6TEwuuIep4HWMvaISTg61jHTA3/8mVI6O2DKA5HgehXqx1/v7oSUtNTDRR6eW0AJ2/8+wyxjKYkEWbKQfa6qxiV/Jb1jt84g0pY9Vj1HrJriM8Ffep0fqKRb2K64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0s+HrnWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0s+HrnWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E255BC4CEC2;
	Mon,  2 Sep 2024 03:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247781;
	bh=8XoKk5BlMGEWWj7ThEQJy5ydKffy9WljOuYQ9VACf2w=;
	h=Date:To:From:Subject:From;
	b=0s+HrnWTANrW03EbbyruDXqCug5zvkNooBBqsmjMzCnVRvB6di0GBmaNW6HgA+AWq
	 LtwBxbLKxBkB/qdpOlnd+DLKQRPiL8cQNjb0T9elCjlbJzmr8nlFCS44AJJEGzPFsB
	 sYGNaSo5DvbJeoAbH3nNS1vEHZ/tIulR3RwUO8to=
Date: Sun, 01 Sep 2024 20:29:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.lendacky@amd.com,rppt@kernel.org,mgorman@suse.de,hannes@cmpxchg.org,david@redhat.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-accept-memory-in-__alloc_pages_bulk.patch removed from -mm tree
Message-Id: <20240902032940.E255BC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: accept memory in __alloc_pages_bulk()
has been removed from the -mm tree.  Its filename was
     mm-accept-memory-in-__alloc_pages_bulk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: accept memory in __alloc_pages_bulk()
Date: Fri, 9 Aug 2024 14:48:49 +0300

Currently, the kernel only accepts memory in get_page_from_freelist(), but
there is another path that directly takes pages from free lists -
__alloc_page_bulk().  This function can consume all accepted memory and
will resort to __alloc_pages_noprof() if necessary.

Conditionally accepted in __alloc_pages_bulk().

The same issue may arise due to deferred page initialization.  Kick the
deferred initialization machinery before abandoning the zone, as the
kernel does in get_page_from_freelist().

Link: https://lkml.kernel.org/r/20240809114854.3745464-4-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/page_alloc.c~mm-accept-memory-in-__alloc_pages_bulk
+++ a/mm/page_alloc.c
@@ -4577,12 +4577,23 @@ unsigned long alloc_pages_bulk_noprof(gf
 			goto failed;
 		}
 
+		cond_accept_memory(zone, 0);
+retry_this_zone:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages;
 		if (zone_watermark_fast(zone, 0,  mark,
 				zonelist_zone_idx(ac.preferred_zoneref),
 				alloc_flags, gfp)) {
 			break;
 		}
+
+		if (cond_accept_memory(zone, 0))
+			goto retry_this_zone;
+
+		/* Try again if zone has deferred pages */
+		if (deferred_pages_enabled()) {
+			if (_deferred_grow_zone(zone, 0))
+				goto retry_this_zone;
+		}
 	}
 
 	/*
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


