Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F432D12ED
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 23:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788045134; cv=none; b=qK4WXW/4f0ofwi9kOmNAhCTeQsITGdqwIW4E4udCZrez2iYLrhEkC3+DXV6VDH/Gbd20nkwNlNRVSsfFPlgHWZP5GcroHEiLyIWV9TqnHqrT2n9JTBYtnPrT6JxEqwQZvmC3r91KpnjELJt3MOMepwHRAKI/dsLZzEVkukSM9Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788045134; c=relaxed/simple;
	bh=ATpTtIoYf9sCa18Jl/6PdG8UwRLh1xDG7BzLSoEuaQY=;
	h=Date:To:From:Subject:Message-Id; b=SBy3yxHB2ni7KF/FU/iAEX+kBTDtzbziSPAQB7vPzCZDUiEz4A3U5bNmeL3f+3MUBumWTVLysNdhQ/LP6ueXaKat/uGW3WpVLr6T4+3dhUwsAnMxEdWVpr+y7uoBTt7uMpPqzduwu6a19x/pn7PNNoP7fU3M+/EedOVQHYcpzdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RLU7x3IV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RLU7x3IV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45111F000E9;
	Sat, 29 Aug 2026 23:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788045132;
	bh=osgXjimfg06nLzs4GXajvQa1TU3ByPFk03YosD266FM=;
	h=Date:To:From:Subject;
	b=RLU7x3IV+rhyOgsmcBtzUTwA650Vj5hQrfXQCq3/We46H8jkEymo70ejF0pSthOSg
	 yUh2EK+LnVJzldzP5kxTD6BSDnW4z1odPKa3U8xMW9d/xFNgEyiBOkxxptSTnhlkzD
	 UE5uPtUE3R4JQ3EnmD1fe+c6t0RMh7gspcU7aJj0=
Date: Sat, 29 Aug 2026 16:12:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-adjust-out-dated-document-of-__gfp_nofail.patch added to mm-new branch
Message-Id: <20260829231212.A45111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: adjust out-dated document of __GFP_NOFAIL
has been added to the -mm mm-new branch.  Its filename is
     mm-adjust-out-dated-document-of-__gfp_nofail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-adjust-out-dated-document-of-__gfp_nofail.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm: adjust out-dated document of __GFP_NOFAIL
Date: Sat, 29 Aug 2026 02:58:47 +0000

Commit ee040cbd6e48 ("mm/page_alloc: don't warn about large allocations
with __GFP_NOFAIL") remove a warning on allocating large folio with
__GFP_NOFAIL, which was placed there by commit 903edea6c53f ("mm: warn
about illegal __GFP_NOFAIL usage in a more appropriate location and
manner").

While in that commit, it also documented this behavior which is out-dated
now.

Adjust the document to align to current code, and adjust the comment while
at it.

Link: https://lore.kernel.org/20260829025847.26779-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp_types.h |    2 +-
 mm/page_alloc.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/gfp_types.h~mm-adjust-out-dated-document-of-__gfp_nofail
+++ a/include/linux/gfp_types.h
@@ -244,7 +244,7 @@ enum {
  * definitely preferable to use the flag rather than opencode endless
  * loop around allocator.
  * Allocating pages from the buddy with __GFP_NOFAIL and order > 1 is
- * not supported. Please consider using kvmalloc() instead.
+ * discouraged. Please consider using kvmalloc() instead if possible.
  */
 #define __GFP_IO	((__force gfp_t)___GFP_IO)
 #define __GFP_FS	((__force gfp_t)___GFP_FS)
--- a/mm/page_alloc.c~mm-adjust-out-dated-document-of-__gfp_nofail
+++ a/mm/page_alloc.c
@@ -4804,7 +4804,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 
 	if (unlikely(nofail)) {
 		/*
-		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
+		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
 		 * otherwise, we may result in lockup.
 		 */
 		WARN_ON_ONCE(!can_direct_reclaim);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-adjust-out-dated-document-of-__gfp_nofail.patch

