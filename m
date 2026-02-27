Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC25144D02D
	for <mm-commits@vger.kernel.org>; Fri, 27 Feb 2026 20:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772222981; cv=none; b=d7RNSngVSsmJBNb27HOgwuQlmBOJpOKIwbUDQpCVorrRJN/Xxi6sMva8O7AUBkx0I48IrDMqCAW0+vNSSvHlV/ClaZE50v7djZCCy++W1oRYrPa/xqCFPaOHA9/8+LF4YKYXN/VZNiV5B/kTzOBlYzNJRLabIzOpRb8tFi1gOO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772222981; c=relaxed/simple;
	bh=nyyLkGxTcKe1BaDoBTWOfeOEGvbbkDaYTG4/y00GVm8=;
	h=Date:To:From:Subject:Message-Id; b=cQYovutV2GyVGOYFJeuxcb1t0AhfRq3DaWaTH7pH7gZCM1uZ3bx9aI8Ft6r5QgXbl7xqHfMt4rRytSADpzl/ufGgnfohLlG48XTJyzr6pfpoL3urlQYlSiaV6f+BgLJWac6ILx+cHGcoX7YmjZAjE+7LtHqEogKwpPXhboJsXtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yU8X1bnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yU8X1bnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E4CC19421;
	Fri, 27 Feb 2026 20:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772222981;
	bh=nyyLkGxTcKe1BaDoBTWOfeOEGvbbkDaYTG4/y00GVm8=;
	h=Date:To:From:Subject:From;
	b=yU8X1bnLeFU2r0l8mDsRZKuCLroy29sn5+kzARPds3WVbaSazFSiUH3wHgJmnTG4e
	 ptA0hDLe0zGi9WIYzDOqB31DZERoXC1R7sMMsVERZ6ZX+d+OnPivZddCQaxeT5impU
	 xP0pCFLQN9lQqRUudevPLY4OmiLzJuxT5rs/hqLQ=
Date: Fri, 27 Feb 2026 12:09:40 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,kernel@xen0n.name,harry.yoo@oracle.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,corbet@lwn.net,cl@gentwo.org,chenhuacai@kernel.org,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-set-clear_compound_head-next-to-compound_head.patch added to mm-new branch
Message-Id: <20260227200941.60E4CC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move set/clear_compound_head() next to compound_head()
has been added to the -mm mm-new branch.  Its filename is
     mm-move-set-clear_compound_head-next-to-compound_head.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-set-clear_compound_head-next-to-compound_head.patch

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
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm: move set/clear_compound_head() next to compound_head()
Date: Fri, 27 Feb 2026 19:42:42 +0000

Move set_compound_head() and clear_compound_head() to be adjacent to the
compound_head() function in page-flags.h.

These functions encode and decode the same compound_info field, so keeping
them together makes it easier to verify their logic is consistent,
especially when the encoding changes.

Link: https://lkml.kernel.org/r/20260227194302.274384-5-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/include/linux/page-flags.h~mm-move-set-clear_compound_head-next-to-compound_head
+++ a/include/linux/page-flags.h
@@ -290,6 +290,17 @@ static __always_inline unsigned long _co
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
 
+static __always_inline void set_compound_head(struct page *tail,
+		const struct page *head, unsigned int order)
+{
+	WRITE_ONCE(tail->compound_info, (unsigned long)head + 1);
+}
+
+static __always_inline void clear_compound_head(struct page *page)
+{
+	WRITE_ONCE(page->compound_info, 0);
+}
+
 /**
  * page_folio - Converts from page to folio.
  * @p: The page.
@@ -870,17 +881,6 @@ static inline bool folio_test_large(cons
 	return folio_test_head(folio);
 }
 
-static __always_inline void set_compound_head(struct page *tail,
-		const struct page *head, unsigned int order)
-{
-	WRITE_ONCE(tail->compound_info, (unsigned long)head + 1);
-}
-
-static __always_inline void clear_compound_head(struct page *page)
-{
-	WRITE_ONCE(page->compound_info, 0);
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline void ClearPageCompound(struct page *page)
 {
_

Patches currently in -mm which might be from kas@kernel.org are

mm-move-max_folio_order-definition-to-mmzoneh.patch
mm-change-the-interface-of-prep_compound_tail.patch
mm-rename-the-compound_head-field-in-the-struct-page-to-compound_info.patch
mm-move-set-clear_compound_head-next-to-compound_head.patch
riscv-mm-align-vmemmap-to-maximal-folio-size.patch
loongarch-mm-align-vmemmap-to-maximal-folio-size.patch
mm-rework-compound_head-for-power-of-2-sizeofstruct-page.patch
mm-sparse-check-memmap-alignment-for-compound_info_has_mask.patch
mm-hugetlb-defer-vmemmap-population-for-bootmem-hugepages.patch
mm-hugetlb-refactor-code-around-vmemmap_walk.patch
x86-vdso-undefine-config_hugetlb_page_optimize_vmemmap-for-vdso32.patch
mm-hugetlb-remove-fake-head-pages.patch
mm-drop-fake-head-checks.patch
hugetlb-remove-vmemmap_synchronize_rcu.patch
mm-hugetlb-remove-hugetlb_optimize_vmemmap_key-static-key.patch
mm-remove-the-branch-from-compound_head.patch
hugetlb-update-vmemmap_deduprst.patch
mm-slab-use-compound_head-in-page_slab.patch

