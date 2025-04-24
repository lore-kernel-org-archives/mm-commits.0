Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B4F19F471
	for <mm-commits@vger.kernel.org>; Thu, 24 Apr 2025 22:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745532201; cv=none; b=orQfai4EzNGGeruO6I7xrnhF/OlYg9S7BKJnj7cB7cPi83cqvDpRfsm6hsFGq9MSgGsXVR6tbNBFHsHhMG2osxORzeIZYReXsJO1BTendKxqW23AxbUI8kAj25fHMiWR/OWx1bD+TL1KrUu6TTSIyuTNWAvRahl8k1ctPJB0z+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745532201; c=relaxed/simple;
	bh=jXEDmGzARx/F/OFdwHbg0HmtsUvBNGePlIx/q3kXciM=;
	h=Date:To:From:Subject:Message-Id; b=PpD6S39UDekFx+ZV/lkHsXHz41qjoP7ydp7s6T2XUr2ekCtDnhcS6XQgQVwl0CX4BrtkR9vGg5qymGod3Hgc1fgflNRFDRjX6XFW8Vx+22F8OLvJOSI3f15SZYXweS7R/OFou3Zf81XmPGTPVD4nBfsRVeBn+bSSPOQXbeouIfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ukLQRMo8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ukLQRMo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C4AC4CEE3;
	Thu, 24 Apr 2025 22:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745532200;
	bh=jXEDmGzARx/F/OFdwHbg0HmtsUvBNGePlIx/q3kXciM=;
	h=Date:To:From:Subject:From;
	b=ukLQRMo8k9yO6GaiO/7Sc3sMzr546o7AW2M7bXNDagif5WYyQgZ9fz+EyNxRgyIlO
	 F6BaVZMhawgvDJGrPF9PN/6WkobhhsRCiH9OC424hlG4MXgVcAfwayohKJAAIZmgxD
	 HM9kpXQLgD+i9CJZytd5aSg98JT0GnqUYPBUPk2w=
Date: Thu, 24 Apr 2025 15:03:20 -0700
To: mm-commits@vger.kernel.org,mingzhe.yang@ly.com,david@redhat.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-inline-folio_test_large_maybe_mapped_shared-into-callers.patch added to mm-new branch
Message-Id: <20250424220320.B7C4AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: inline folio_test_large_maybe_mapped_shared() into callers
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-inline-folio_test_large_maybe_mapped_shared-into-callers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-inline-folio_test_large_maybe_mapped_shared-into-callers.patch

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
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/rmap: inline folio_test_large_maybe_mapped_shared() into callers
Date: Thu, 24 Apr 2025 23:56:06 +0800

To prevent the function from being used when CONFIG_MM_ID is disabled, we
intend to inline it into its few callers, which also would help maintain
the expected code placement.

Link: https://lkml.kernel.org/r/20250424155606.57488-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Mingzhe Yang <mingzhe.yang@ly.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |    2 +-
 include/linux/page-flags.h |    4 ----
 include/linux/rmap.h       |    2 +-
 mm/memory.c                |    4 ++--
 4 files changed, 4 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-rmap-inline-folio_test_large_maybe_mapped_shared-into-callers
+++ a/include/linux/mm.h
@@ -2111,7 +2111,7 @@ static inline bool folio_maybe_mapped_sh
 	 */
 	if (mapcount <= 1)
 		return false;
-	return folio_test_large_maybe_mapped_shared(folio);
+	return test_bit(FOLIO_MM_IDS_SHARED_BITNUM, &folio->_mm_ids);
 }
 
 #ifndef HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE
--- a/include/linux/page-flags.h~mm-rmap-inline-folio_test_large_maybe_mapped_shared-into-callers
+++ a/include/linux/page-flags.h
@@ -1230,10 +1230,6 @@ static inline int folio_has_private(cons
 	return !!(folio->flags & PAGE_FLAGS_PRIVATE);
 }
 
-static inline bool folio_test_large_maybe_mapped_shared(const struct folio *folio)
-{
-	return test_bit(FOLIO_MM_IDS_SHARED_BITNUM, &folio->_mm_ids);
-}
 #undef PF_ANY
 #undef PF_HEAD
 #undef PF_NO_TAIL
--- a/include/linux/rmap.h~mm-rmap-inline-folio_test_large_maybe_mapped_shared-into-callers
+++ a/include/linux/rmap.h
@@ -223,7 +223,7 @@ static inline void __folio_large_mapcoun
 	VM_WARN_ON_ONCE(folio_mm_id(folio, 1) != MM_ID_DUMMY &&
 			folio->_mm_id_mapcount[1] < 0);
 	VM_WARN_ON_ONCE(!folio_mapped(folio) &&
-			folio_test_large_maybe_mapped_shared(folio));
+			test_bit(FOLIO_MM_IDS_SHARED_BITNUM, &folio->_mm_ids));
 }
 
 static __always_inline void folio_set_large_mapcount(struct folio *folio,
--- a/mm/memory.c~mm-rmap-inline-folio_test_large_maybe_mapped_shared-into-callers
+++ a/mm/memory.c
@@ -3768,7 +3768,7 @@ static bool __wp_can_reuse_large_anon_fo
 	 * If all folio references are from mappings, and all mappings are in
 	 * the page tables of this MM, then this folio is exclusive to this MM.
 	 */
-	if (folio_test_large_maybe_mapped_shared(folio))
+	if (test_bit(FOLIO_MM_IDS_SHARED_BITNUM, &folio->_mm_ids))
 		return false;
 
 	VM_WARN_ON_ONCE(folio_test_ksm(folio));
@@ -3791,7 +3791,7 @@ static bool __wp_can_reuse_large_anon_fo
 	folio_lock_large_mapcount(folio);
 	VM_WARN_ON_ONCE(folio_large_mapcount(folio) < folio_ref_count(folio));
 
-	if (folio_test_large_maybe_mapped_shared(folio))
+	if (test_bit(FOLIO_MM_IDS_SHARED_BITNUM, &folio->_mm_ids))
 		goto unlock;
 	if (folio_large_mapcount(folio) != folio_ref_count(folio))
 		goto unlock;
_

Patches currently in -mm which might be from lance.yang@linux.dev are

mm-rmap-inline-folio_test_large_maybe_mapped_shared-into-callers.patch

