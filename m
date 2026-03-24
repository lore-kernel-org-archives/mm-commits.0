Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55826372B37
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388649; cv=none; b=sUal5D2unnQEgrku58woQmds8pMsw8CrA9XzoEuMWBWKGChbRfRvcdeL3cUj2uiIwRvbshYVXOWTYz9WwlbzumTGLvHriwClUg+gj0TlkmZbGNdoMrRF/hwc83DNfoEoew6WuWXGdGXaN+5qa8vc/WYGlAnbjaae4XqEefYKrh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388649; c=relaxed/simple;
	bh=mqZwt+kdDE+2VHZTTOohIog7vKnvRACF9v+i6/neZk4=;
	h=Date:To:From:Subject:Message-Id; b=rESvUUarsLoh7rjCnpTvyu0Pf2RhkK5XGHMF1cHr+4H0iVV8+6Vg12XIqxIhbd7ySE9XRn7w2iL3KYKFNPx431nk3s449vZJdRiUqmmFeK3Is4NruNAveTs/OKp+JP6nYw9onpAlwo/vr3sD8RJWzLvufuyz8TCy+XlRKfoqkp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OjmfZOC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OjmfZOC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00ED4C19424;
	Tue, 24 Mar 2026 21:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388649;
	bh=mqZwt+kdDE+2VHZTTOohIog7vKnvRACF9v+i6/neZk4=;
	h=Date:To:From:Subject:From;
	b=OjmfZOC5zA0XuaqnAVqbVCAtXLaNqMEozhgxnIlGa44JyaN8ezy66gRWKHYfzXYXt
	 LUbE3GMJhI4aj+YHT4KbYeBCxQaAqHwA9rnV9fgUf1whw7cEdZDyaG2SJwQYuyYKvP
	 fczVukK41H6nTIZT9G4iS0UXWLM3i2HK0tLpfj0M=
Date: Tue, 24 Mar 2026 14:44:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,kernel@xen0n.name,harry.yoo@oracle.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,corbet@lwn.net,cl@gentwo.org,chenhuacai@kernel.org,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-remove-hugetlb_optimize_vmemmap_key-static-key.patch removed from -mm tree
Message-Id: <20260324214409.00ED4C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: remove hugetlb_optimize_vmemmap_key static key
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-hugetlb_optimize_vmemmap_key-static-key.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/hugetlb: remove hugetlb_optimize_vmemmap_key static key
Date: Fri, 27 Feb 2026 19:42:53 +0000

The hugetlb_optimize_vmemmap_key static key was used to guard fake head
detection in compound_head() and related functions.  It allowed skipping
the fake head checks entirely when HVO was not in use.

With fake heads eliminated and the detection code removed, the static key
serves no purpose.  Remove its definition and all increment/decrement
calls.

Link: https://lkml.kernel.org/r/20260227194302.274384-16-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 --
 mm/hugetlb_vmemmap.c       |   14 ++------------
 2 files changed, 2 insertions(+), 14 deletions(-)

--- a/include/linux/page-flags.h~mm-hugetlb-remove-hugetlb_optimize_vmemmap_key-static-key
+++ a/include/linux/page-flags.h
@@ -221,8 +221,6 @@ static __always_inline bool compound_inf
 	return is_power_of_2(sizeof(struct page));
 }
 
-DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
-
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-remove-hugetlb_optimize_vmemmap_key-static-key
+++ a/mm/hugetlb_vmemmap.c
@@ -385,9 +385,6 @@ static int vmemmap_remap_alloc(unsigned
 	return vmemmap_remap_range(start, end, &walk);
 }
 
-DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
-EXPORT_SYMBOL(hugetlb_optimize_vmemmap_key);
-
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 static int __init hugetlb_vmemmap_optimize_param(char *buf)
 {
@@ -419,10 +416,8 @@ static int __hugetlb_vmemmap_restore_fol
 	 * discarded vmemmap pages must be allocated and remapping.
 	 */
 	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
-	if (!ret) {
+	if (!ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
-		static_branch_dec(&hugetlb_optimize_vmemmap_key);
-	}
 
 	return ret;
 }
@@ -544,8 +539,6 @@ static int __hugetlb_vmemmap_optimize_fo
 	if (!vmemmap_tail)
 		return -ENOMEM;
 
-	static_branch_inc(&hugetlb_optimize_vmemmap_key);
-
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -581,10 +574,8 @@ static int __hugetlb_vmemmap_optimize_fo
 				 vmemmap_head, vmemmap_tail,
 				 vmemmap_pages, flags);
 out:
-	if (ret) {
-		static_branch_dec(&hugetlb_optimize_vmemmap_key);
+	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
-	}
 
 	return ret;
 }
@@ -650,7 +641,6 @@ static void __hugetlb_vmemmap_optimize_f
 			register_page_bootmem_memmap(pfn_to_section_nr(spfn),
 					&folio->page,
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-			static_branch_inc(&hugetlb_optimize_vmemmap_key);
 			continue;
 		}
 
_

Patches currently in -mm which might be from kas@kernel.org are


