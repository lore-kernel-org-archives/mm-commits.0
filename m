Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB6B21A931
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 06:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686444; cv=none; b=flitfYxdh6ZR+vRf8sSNXqRNBUM77L+DLjCVVhr0YtLi/s5yy6/Olb5H82K3EqKervFLHZ1fimLbETK79T/M3S9CmCXJJRosRWaUtw46WzLFW1APdPZQ/xrFdct9zkVuukRnpG/pcuuwk7CiYgO4fZpChqEbOEsM8Wv6B2P2KlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686444; c=relaxed/simple;
	bh=VS/+cp643bnERPI3WxT7LaDxV56mkByh9wLfwA6qO6U=;
	h=Date:To:From:Subject:Message-Id; b=FWgPKcGoYhT3AMa1i/lkj9ATDqhSMZe+jCKNqqXmhTjKhvVUIgMltQoyEQGnM3oO28y+rVwwUbDwJiZ0jTxW7cih2c2SCw76F9Gz+frdFx/XuCD4aIeEQ510LLalEimVAq9oaljuF7HU9GFE/+IygABZxhUN+1MMQp7QfNL+5rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yzu2l6Qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yzu2l6Qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CBEC4CEEB;
	Thu,  8 May 2025 06:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686444;
	bh=VS/+cp643bnERPI3WxT7LaDxV56mkByh9wLfwA6qO6U=;
	h=Date:To:From:Subject:From;
	b=yzu2l6Qe8Q2zHsZdJcBquDZHJNyqqoaHr7uBdgNAEXwUIgOhyK0HQyLgJ4jFv6GG8
	 +SicO35IlADMj3kGoebcB4pq7jxOmRnp10uNhBeh71HLR8/1rR5yHD+Z9NuLGSM2F8
	 WRT+StK+iFSBgxdiE1iOmRg5Qt1/IrpUTWhKUNFI=
Date: Wed, 07 May 2025 23:40:44 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@oracle.com,harry.yoo@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-reverse-mapping-section.patch removed from -mm tree
Message-Id: <20250508064044.82CBEC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add reverse mapping section
has been removed from the -mm tree.  Its filename was
     maintainers-add-reverse-mapping-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add reverse mapping section
Date: Fri, 18 Apr 2025 16:00:52 +0100

Separate out the reverse mapping part of memory management and assign
appropriate maintainers and reviewers.

David has long been invovled in work with the reverse mapping and
continues to do so, so is well suited to maintain this area of the kernel.

I have a lot of experience working with the anonymous reverse mapping and
continue to work in this area, and also have good knowledge of the walking
code and code related to VMAs.

This helps people identify who to ask for help, and also additionally makes
life easier in review.

Link: https://lkml.kernel.org/r/20250418150052.299220-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-reverse-mapping-section
+++ a/MAINTAINERS
@@ -15505,7 +15505,6 @@ F:	include/linux/mm_*.h
 F:	include/linux/mmzone.h
 F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
-F:	include/linux/rmap.h
 F:	include/trace/events/ksm.h
 F:	mm/
 F:	tools/mm/
@@ -15545,6 +15544,19 @@ F:	mm/page_alloc.c
 F:	include/linux/gfp.h
 F:	include/linux/compaction.h
 
+MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Rik van Riel <riel@surriel.com>
+R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Harry Yoo <harry.yoo@oracle.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	include/linux/rmap.h
+F:	mm/rmap.c
+
 MEMORY MANAGEMENT - SECRETMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-mm-gup-section.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch
mm-abstract-initial-stack-setup-to-mm-subsystem.patch
mm-move-dup_mmap-to-mm.patch
mm-perform-vma-allocation-freeing-duplication-in-mm.patch
mm-introduce-new-mmap_prepare-file-callback.patch
mm-secretmem-convert-to-mmap_prepare-hook.patch
mm-vma-remove-mmap-retry-merge.patch

