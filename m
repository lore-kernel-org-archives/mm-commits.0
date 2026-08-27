Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866D2390218
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 22:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787870363; cv=none; b=eXVWZpCP2xB0HE4MgP6nAMlc6Jm2gCafKGADsJYPCumH9iFYdP+fHqsNPPAWynFoTBg1pICBdl3rVXP4g/s/SGTEiCONsOqUCK/xXSjvDhEBu1iAeZPCKViixYy4msos0yevYCFvzHqra4n4vf5hFNly3gqES0SY0ky+O0lD9H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787870363; c=relaxed/simple;
	bh=8CvN1v5uu/dsHNL0SSA8J8/cxTlA1Hjsz9unu1L9/7o=;
	h=Date:To:From:Subject:Message-Id; b=cYs0tAjvHSrtPaUTcNEuuXxdJ37idKNkaMXeo3NWoYFgug8aVxPezP9vvE6JLV8bzzpfEFjzZbE43jW75/1HzZBcbCYVnazJ54c1pnozA6A6+IGhB8K1ufBpO0B6AStzdNYVSJKxd48OZIjrIWcatjkCHAAc+JJqyr9GImpFVwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Afii+KcJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Afii+KcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307E81F000E9;
	Thu, 27 Aug 2026 22:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787870359;
	bh=JlhpNvj9qO6GBlLsPNE0loN/xWe++yY5g9dEhR5T3fA=;
	h=Date:To:From:Subject;
	b=Afii+KcJ4WxXc27YQOy848nUrQoFsBfHa5xu9nLws9iBBi4+Kbx+Gs++tw7+jOkMS
	 cJcyyIq7hazaNGClhEjZzwi9PR98wrnZuzGIC+oB6Lcbq8NYsV45OG5Alpi9oTXEWe
	 vBa5S+plWsyvApdttCGbFEuMMNw8FJRUX2ptnJwo=
Date: Thu, 27 Aug 2026 15:39:18 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-remove-zone_absent_pages_in_node.patch added to mm-new branch
Message-Id: <20260827223919.307E81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: remove zone_absent_pages_in_node()
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-remove-zone_absent_pages_in_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-remove-zone_absent_pages_in_node.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/mm_init: remove zone_absent_pages_in_node()
Date: Thu, 27 Aug 2026 23:41:46 +0900

zone_absent_pages_in_node() returns 0 when the zone is empty and otherwise
calls __absent_pages_in_range(), which already returns 0 for an empty
range.

So remove it and call __absent_pages_in_range() directly.

No functional change.

Link: https://lore.kernel.org/20260827144151.486192-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-remove-zone_absent_pages_in_node
+++ a/mm/mm_init.c
@@ -1187,22 +1187,9 @@ unsigned long __init absent_pages_in_ran
 	return __absent_pages_in_range(MAX_NUMNODES, start_pfn, end_pfn);
 }
 
-/* Return the number of page frames in holes in a zone on a node */
-static unsigned long __init zone_absent_pages_in_node(int nid,
-					unsigned long zone_type,
-					unsigned long zone_start_pfn,
-					unsigned long zone_end_pfn)
-{
-	/* zone is empty, we don't have any absent pages */
-	if (zone_start_pfn == zone_end_pfn)
-		return 0;
-
-	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
-}
-
 /*
  * Return the number of pages a zone spans in a node, including holes
- * present_pages = zone_spanned_pages_in_node() - zone_absent_pages_in_node()
+ * present_pages = zone_spanned_pages_in_node() - __absent_pages_in_range()
  */
 static unsigned long __init zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
@@ -1292,9 +1279,8 @@ static void __init calculate_node_totalp
 						     node_end_pfn,
 						     &zone_start_pfn,
 						     &zone_end_pfn);
-		absent = zone_absent_pages_in_node(pgdat->node_id, i,
-						   zone_start_pfn,
-						   zone_end_pfn);
+		absent = __absent_pages_in_range(pgdat->node_id, zone_start_pfn,
+						 zone_end_pfn);
 
 		real_size = spanned - absent;
 
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-mm_init-remove-zone_absent_pages_in_node.patch

