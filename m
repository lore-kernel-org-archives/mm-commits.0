Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40B018D63E
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 01:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744766937; cv=none; b=B2Zdqy4JbI/dgUq2lol9Spa1WVBwbu3Gzg5RONBoUbwjkjNZOzE2Vj+U87u1slFqxrMeHyjp/ImqpohRdZjxl+AoqIGgU1MbvOL7CGAjMtxoE/rcbMJc8wDWV5y2/VFmR/8L7d9zTsT/CyuG5B4SFiKzGftgIdXXo4bvGKZa7pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744766937; c=relaxed/simple;
	bh=87K3qU2X3XRCg27r2wRYBj0dsbGggbW33let/Bo7jzg=;
	h=Date:To:From:Subject:Message-Id; b=fi7F0We13beA0nOekFAGw/ufb4eHSEZW0/ROF7eJTuOW8M5vXin/3x2jCgataYRMtzpfaFkTVcZFWyz+D4uZ0sxI6J8jGtmP9KtOJ4J77PUn0cY3duuKUB3fQ7SBL+JU/q/wDoLcwfDxHOtHsHgjXNzPlF8TBvtLsYOLx/UYBTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=crCMRZaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="crCMRZaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D368C4CEE7;
	Wed, 16 Apr 2025 01:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744766937;
	bh=87K3qU2X3XRCg27r2wRYBj0dsbGggbW33let/Bo7jzg=;
	h=Date:To:From:Subject:From;
	b=crCMRZaX1J9/7zlacp8eCvI0M56nJDzM/ww45tN3wTJD0Ot7XsS3aQHFI2KGFCkcy
	 XmbZL84rVYl/1MSOQF7NdBuGQDmY4tSEYEWfnN81lqZw0pD0dHhK8IM11cOBTvRthF
	 3Y4rqeo/m315gQrpNDTOquJf8XUxRbSzRVliAAIE=
Date: Tue, 15 Apr 2025 18:28:56 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-increment-the-number-of-pages-to-be-reset-on-hvo.patch added to mm-hotfixes-unstable branch
Message-Id: <20250416012857.7D368C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, hugetlb: increment the number of pages to be reset on HVO
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-increment-the-number-of-pages-to-be-reset-on-hvo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-increment-the-number-of-pages-to-be-reset-on-hvo.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm, hugetlb: increment the number of pages to be reset on HVO
Date: Tue, 15 Apr 2025 13:18:59 +0200

commit 4eeec8c89a0c ("mm: move hugetlb specific things in folio to
page[3]") shifted hugetlb specific stuff, and now mapping overlaps
_hugetlb_cgroup field.

Upon restoring the vmemmap for HVO, only the first two tail pages are
reset, and this causes the check in free_tail_page_prepare() to fail as it
finds an unexpected mapping value in some tails.

Increment the number of pages to be reset to 4 (head + 3 tail pages)

Link: https://lkml.kernel.org/r/20250415111859.376302-1-osalvador@suse.de
Fixes: 4eeec8c89a0c ("mm: move hugetlb specific things in folio to page[3]")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-increment-the-number-of-pages-to-be-reset-on-hvo
+++ a/mm/hugetlb_vmemmap.c
@@ -238,11 +238,11 @@ static void vmemmap_remap_pte(pte_t *pte
  * struct page, the special metadata (e.g. page->flags or page->mapping)
  * cannot copy to the tail struct page structs. The invalid value will be
  * checked in the free_tail_page_prepare(). In order to avoid the message
- * of "corrupted mapping in tail page". We need to reset at least 3 (one
- * head struct page struct and two tail struct page structs) struct page
+ * of "corrupted mapping in tail page". We need to reset at least 4 (one
+ * head struct page struct and three tail struct page structs) struct page
  * structs.
  */
-#define NR_RESET_STRUCT_PAGE		3
+#define NR_RESET_STRUCT_PAGE		4
 
 static inline void reset_struct_pages(struct page *start)
 {
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-hugetlb-increment-the-number-of-pages-to-be-reset-on-hvo.patch
mm-hugetlb-avoid-passing-a-null-nodemask-when-there-is-mbind-policy.patch
mmhugetlb-allocate-frozen-pages-in-alloc_buddy_hugetlb_folio.patch

