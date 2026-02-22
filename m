Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34E23502A9
	for <mm-commits@vger.kernel.org>; Sun, 22 Feb 2026 19:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771789709; cv=none; b=r1bQ0IcCJz79ieyTEmajfM7QPaJ3DJkHAcd6DmcL2wokzEkgiDP3kuSHkOi9RVFE4l+veHsnwO3/4K1CO6WNyhGICMJr2rCkjg7e9/1vTuAmfbYIQf3I7rf+1dDmnGOmgZaJdJVn6r8fRFlPq/rUJwHG11ejMuRJ1evtlNkMQsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771789709; c=relaxed/simple;
	bh=BNV5B/HQ3X814e15DhZyfY98s6aEISNwYtX36u3cQMw=;
	h=Date:To:From:Subject:Message-Id; b=AGTc77hswPU9vph/m0gzaGRetaG4X8LP0Pnubc9Gx5DjjexUq5sYeBE6+VLLT9KjSBJNwkVyxeJg4PivBWtc4y8PLJU8gME6YEpOZ943X2UtyyhiOz9idCMhqcIRj6I/1YAnB+tuNBeetGDPckQU6RFghYh5U9Z9aK/NyjfYBKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gmy898Ic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gmy898Ic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8185DC116D0;
	Sun, 22 Feb 2026 19:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771789708;
	bh=BNV5B/HQ3X814e15DhZyfY98s6aEISNwYtX36u3cQMw=;
	h=Date:To:From:Subject:From;
	b=gmy898Icow9c2nGooPbIpC6nGK9NHmMidA6T0QKtLHpZfeHr29cgi+W54vTJySm67
	 jAyDNVQdwHSuGbizwZ6aa48MU5jP3UqzOaautQJhargROk87kRqPOCirWtF7hdKOUH
	 m8ZH4WwEz5CIlLR0AtzC0hVe11wedaEeOmrngwrM=
Date: Sun, 22 Feb 2026 11:48:27 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio_test_lazyfree-helper.patch added to mm-new branch
Message-Id: <20260222194828.8185DC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add folio_test_lazyfree helper
has been added to the -mm mm-new branch.  Its filename is
     mm-add-folio_test_lazyfree-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_test_lazyfree-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Vernon Yang <yanglincheng@kylinos.cn>
Subject: mm: add folio_test_lazyfree helper
Date: Sat, 21 Feb 2026 17:39:17 +0800

Add folio_test_lazyfree() function to identify lazy-free folios to improve
code readability.

Link: https://lkml.kernel.org/r/20260221093918.1456187-4-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 +++++
 mm/rmap.c                  |    2 +-
 mm/vmscan.c                |    5 ++---
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/page-flags.h~mm-add-folio_test_lazyfree-helper
+++ a/include/linux/page-flags.h
@@ -724,6 +724,11 @@ static __always_inline bool folio_test_a
 	return ((unsigned long)folio->mapping & FOLIO_MAPPING_ANON) != 0;
 }
 
+static __always_inline bool folio_test_lazyfree(const struct folio *folio)
+{
+	return folio_test_anon(folio) && !folio_test_swapbacked(folio);
+}
+
 static __always_inline bool PageAnonNotKsm(const struct page *page)
 {
 	unsigned long flags = (unsigned long)page_folio(page)->mapping;
--- a/mm/rmap.c~mm-add-folio_test_lazyfree-helper
+++ a/mm/rmap.c
@@ -2046,7 +2046,7 @@ static bool try_to_unmap_one(struct foli
 		}
 
 		if (!pvmw.pte) {
-			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+			if (folio_test_lazyfree(folio)) {
 				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
 					goto walk_done;
 				/*
--- a/mm/vmscan.c~mm-add-folio_test_lazyfree-helper
+++ a/mm/vmscan.c
@@ -963,8 +963,7 @@ static void folio_check_dirty_writeback(
 	 * They could be mistakenly treated as file lru. So further anon
 	 * test is needed.
 	 */
-	if (!folio_is_file_lru(folio) ||
-	    (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
+	if (!folio_is_file_lru(folio) || folio_test_lazyfree(folio)) {
 		*dirty = false;
 		*writeback = false;
 		return;
@@ -1508,7 +1507,7 @@ retry:
 			}
 		}
 
-		if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+		if (folio_test_lazyfree(folio)) {
 			/* follow __remove_mapping for reference */
 			if (!folio_ref_freeze(folio, 1))
 				goto keep_locked;
_

Patches currently in -mm which might be from yanglincheng@kylinos.cn are

mm-khugepaged-set-to-next-mm-direct-when-mm-has-mmf_disable_thp_completely.patch
mm-khugepaged-add-trace_mm_khugepaged_scan-event.patch
mm-khugepaged-refine-scan-progress-number.patch
mm-add-folio_test_lazyfree-helper.patch
mm-khugepaged-skip-lazy-free-folios.patch

