Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15683364931
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388639; cv=none; b=XMHWJqd12Ezqwk3s0GLVXI7OdSv0ugtAQ8gDvPCt1bk8JQLNRkFe+NXpbjf0wbjbZME+acL0tycL1qLUMHbHvz1U0zkHRv8Ud0TeUPW3NFBelDumqX0z3hHZUIfGbnUIv6WFcGJb8T7qmuPyUm82+rupe/yMxVOdzeNWEoOgouQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388639; c=relaxed/simple;
	bh=eaV6CY1NhFlkOz2+9xGfPx/uIdAcgxZ3ATpldp3iYyI=;
	h=Date:To:From:Subject:Message-Id; b=NlUxYLLkbT5mAknFrNCKNA183erxgpTyhyIWTNlXLYj1vQpnGHiKwkyrIR/LkjAQ7MQhE0KBsa4+il2Cvr/0sNoj+rELuDukvJGbbW34l0vYK0tFu5Ksy7IpiTqiuDclNyI3PXi5B/CY515wT7i69rwpLO7EQyQVp/6Q0r95bms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D0sf2VDz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D0sf2VDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22F5C19424;
	Tue, 24 Mar 2026 21:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388639;
	bh=eaV6CY1NhFlkOz2+9xGfPx/uIdAcgxZ3ATpldp3iYyI=;
	h=Date:To:From:Subject:From;
	b=D0sf2VDzR5ZxzZ6yRSlKYTxCqDiLl8dZD6jwd3IIddocpvPvmLMc6wFf1dHhrOA7h
	 TRqgvVorQNkP8UueHGzcutbNyP2KtvIrEd042dszGYpKv4F6JhBpo94Ai3wRH7fAsX
	 zqzuKEZKZ73bcs1uX020oOtSte/Ct7qhojRh5FD4=
Date: Tue, 24 Mar 2026 14:43:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,kernel@xen0n.name,harry.yoo@oracle.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,corbet@lwn.net,cl@gentwo.org,chenhuacai@kernel.org,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-check-memmap-alignment-for-compound_info_has_mask.patch removed from -mm tree
Message-Id: <20260324214358.E22F5C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: check memmap alignment for compound_info_has_mask()
has been removed from the -mm tree.  Its filename was
     mm-sparse-check-memmap-alignment-for-compound_info_has_mask.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/sparse: check memmap alignment for compound_info_has_mask()
Date: Fri, 27 Feb 2026 19:42:46 +0000

If page->compound_info encodes a mask, it is expected that vmemmap to be
naturally aligned to the maximum folio size.

Add a VM_WARN_ON_ONCE() to check the alignment.

Link: https://lkml.kernel.org/r/20260227194302.274384-9-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Hildenbrand (arm) <david@kernel.org>
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
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/sparse.c~mm-sparse-check-memmap-alignment-for-compound_info_has_mask
+++ a/mm/sparse.c
@@ -600,6 +600,11 @@ void __init sparse_init(void)
 	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
 	memblocks_present();
 
+	if (compound_info_has_mask()) {
+		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
+				    MAX_FOLIO_VMEMMAP_ALIGN));
+	}
+
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
 
_

Patches currently in -mm which might be from kas@kernel.org are


