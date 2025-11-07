Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F981A9F96
	for <mm-commits@vger.kernel.org>; Fri,  7 Nov 2025 00:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762476057; cv=none; b=bVx3VwouAi3RVDEnFt0qzjG5KPLQ0x85iaCu7DmBSCzw6otqMoEtt25T6VSQO8Xkti4jj3tN5wlHiEBmlczxRevU4hfP/EiTxlhZlM3RUF9zxnfkwEHnkhAs+aakHY7eAkOg3QlolxzlfyoJqTJFySBA7lRghqQBwXxg3VSo6IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762476057; c=relaxed/simple;
	bh=4Fzm/CWnFUFe1vR77RIjHK+8al/eDyGogcEPGarDJx0=;
	h=Date:To:From:Subject:Message-Id; b=cs4kBCXmTW4t+0UnQjFgt76FE1uXMpCRqKdUljsYcSVIehmUl9bP9nzuHc6f8B7eAZ+BiREu73c1oBxP4foMrJoaxjVfChBZdj9OqTJVN/EuLMcibKf/0iuJMJPBvckxxUhtQIejimrHxkmlON3z4nzv3m6UdOXK9K4yk/U+ZEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E/P76eZe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E/P76eZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAE5C4CEFB;
	Fri,  7 Nov 2025 00:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762476057;
	bh=4Fzm/CWnFUFe1vR77RIjHK+8al/eDyGogcEPGarDJx0=;
	h=Date:To:From:Subject:From;
	b=E/P76eZeyl/jOjtPAQYoa/f7s/TkakpyrxSFvaUPj4FPbmDB2wDCzBtQebm0o+Jpt
	 G3f7aNXV4hSwxXzrKFWwMtjViNy13mXsSuUHp5/7lGv//eMDJX2sW7uAvbuePV0e0f
	 hftofMWBdNqeFp3IUXW5LCKYEGAAzVp5oNPhq2/I=
Date: Thu, 06 Nov 2025 16:40:56 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch added to mm-new branch
Message-Id: <20251107004056.EDAE5C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memory-introduce-enum-split_type-for-clarity-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-huge_memory-introduce-enum-split_type-for-clarity-fix
Date: Thu Nov  6 04:39:51 PM PST 2025

tweak layout, per David

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-introduce-enum-split_type-for-clarity-fix
+++ a/mm/huge_memory.c
@@ -4067,7 +4067,7 @@ int __split_huge_page_to_list_to_order(s
 	struct folio *folio = page_folio(page);
 
 	return __folio_split(folio, new_order, &folio->page, page, list,
-				SPLIT_TYPE_UNIFORM, unmapped);
+			     SPLIT_TYPE_UNIFORM, unmapped);
 }
 
 /**
@@ -4098,7 +4098,7 @@ int folio_split(struct folio *folio, uns
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
-				SPLIT_TYPE_NON_UNIFORM, false);
+			     SPLIT_TYPE_NON_UNIFORM, false);
 }
 
 int min_order_for_split(struct folio *folio)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
drivers-base-node-fold-register_node-into-register_one_node-fix.patch
mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch
memcg-manually-uninline-__memcg_memory_event-fix.patch
mm-change-type-of-state-in-struct-memory_block-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch

