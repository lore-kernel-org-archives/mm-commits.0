Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F70413AA2E
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010992; cv=none; b=RSjHmDJnB55z0h44KqdbEnldSMqoASKsQCz/+49x7p2uPuqzOIvDZGo2ILhg9j3dOcaTXYTtEC0J2uZbZte4x+HFM2xOmnPuoOEONJHlBuKOMgmkW+CXy+Hqj8D8tIczhXdHkp1qRibEWuTV7TAzMEeyjrey4CzmIYNEWGxG2lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010992; c=relaxed/simple;
	bh=nn6GyEbl4ic8+I3TnUyQq8b2W9n3Pyra4MF1EbZC5rI=;
	h=Date:To:From:Subject:Message-Id; b=JWBjqxqdAw/pMW6vlsnHa1PyS/8o4Soo3O05BV5+tDieCmdjGmYnFwqoITje0UtXOLoI9BqA73MEW9wEcx7MaCcWhdVJPwtVAjcEYdsQlkJSUA/NYBa2ivDaGDeX1NIVM3400Gok6lYYICqD0kWG3m+EIyr32RfqwMOvh9LOq2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FXcRksp9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FXcRksp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83550C4CEEF;
	Mon, 12 May 2025 00:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010991;
	bh=nn6GyEbl4ic8+I3TnUyQq8b2W9n3Pyra4MF1EbZC5rI=;
	h=Date:To:From:Subject:From;
	b=FXcRksp9F/8qdABe/gdPgA0+6GqPiBOqNKPo5ehA17gAX7z/UUY76oXvjpwcCnhCx
	 lXBja18Uz5dHbJcz7mkr0wvjCVsJWB+tIKMwjpsqmeXBVSHEFoOHuwbQ/3wlz9Ercr
	 tKXtDmFGE/60oRkt/sG1eZWpTzh1g811h10zJQkM=
Date: Sun, 11 May 2025 17:49:51 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-offset_in_thp.patch removed from -mm tree
Message-Id: <20250512004951.83550C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove offset_in_thp()
has been removed from the -mm tree.  Its filename was
     mm-remove-offset_in_thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove offset_in_thp()
Date: Wed, 2 Apr 2025 22:06:04 +0100

All callers have been converted to call offset_in_folio().

Link: https://lkml.kernel.org/r/20250402210612.2444135-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/mm.h~mm-remove-offset_in_thp
+++ a/include/linux/mm.h
@@ -2445,7 +2445,6 @@ static inline void clear_page_pfmemalloc
 extern void pagefault_out_of_memory(void);
 
 #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
-#define offset_in_thp(page, p)	((unsigned long)(p) & (thp_size(page) - 1))
 #define offset_in_folio(folio, p) ((unsigned long)(p) & (folio_size(folio) - 1))
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are


