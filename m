Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CF2158545
	for <mm-commits@vger.kernel.org>; Fri, 18 Apr 2025 03:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945879; cv=none; b=gYcpO5DwcNbfh9Dc1V7dKaq1wv3FdjBZYC2Oh5lCFTn6fmRksV5cge/ln19tszOtdXXRZCDw/4CjTGn8A+v1DWE03u+VXYm9IG4QvDMin9/fHSQqxEV3Hdt36nSh3ZaJwn1Xd4myRa2Wwsc+OQYqTgn7nTfEmPnrrLq1XwY6DCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945879; c=relaxed/simple;
	bh=Hihsp9ucKiJkFBpSL72jCh7KcSFHyGubew6bfzFnRPs=;
	h=Date:To:From:Subject:Message-Id; b=BRvK+qK9qcnqHFI9Arf433Rxy27Fbqx/HhGXvqpGhSIs+3KdXyXJzkkXSzMaFnrHw5M1yGZEZycVZ9rTT77dV+sFhJydh+g2tQ7duui87CNQTTaPZeqUzXxqRmhF7ZwPQtb+1F283xmKX03svUFTQB/oi2hTRHDpC7jmksPdVik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PlWBnpRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PlWBnpRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA65C4CEE4;
	Fri, 18 Apr 2025 03:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744945878;
	bh=Hihsp9ucKiJkFBpSL72jCh7KcSFHyGubew6bfzFnRPs=;
	h=Date:To:From:Subject:From;
	b=PlWBnpREjmvOUJX4K0QigrAEE63s+P2S8wxOtb/k55nmMqt7xFWvJll7b9ZK1dg2X
	 onIH1elf0kLyfqtNCh0+jfkkyQSFFrmpqgFDkNYEo9PJKVWumjZsAzXnaz1osvFVS1
	 vw7EisIJ/BviSAqW2BW4s+gKBgqmou4k2PYRWlqk=
Date: Thu, 17 Apr 2025 20:11:18 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-increment-the-number-of-pages-to-be-reset-on-hvo.patch removed from -mm tree
Message-Id: <20250418031118.AFA65C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, hugetlb: increment the number of pages to be reset on HVO
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-increment-the-number-of-pages-to-be-reset-on-hvo.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-hugetlb-avoid-passing-a-null-nodemask-when-there-is-mbind-policy.patch
mmhugetlb-allocate-frozen-pages-in-alloc_buddy_hugetlb_folio.patch

