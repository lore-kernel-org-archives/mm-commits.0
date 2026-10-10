Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FB3352C5B
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 20:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791664492; cv=none; b=RWL1zesC609PiNiZYApIcPJcgSU7Bj8QMTSoOYXmOkK0hofWGjqeLPkJqdl0wtxS9wxYLEBkN0dyViY42k9OPez+Yh+IXBVPDOKSFIqYixd3mJ0cdS5kmvGRbJhzdiBJSZcsa+JIEsGFdpJiDjlDUaVuu0zsgiRmPbVugkNbKzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791664492; c=relaxed/simple;
	bh=XurWiyC5cXlDI/E8+GeqdPBpR1ux6zjMlg4zS8x6qRI=;
	h=Date:To:From:Subject:Message-Id; b=W1qjg67JhAKI01eYfT3PWqKryIejkl+3LiCHkKAKoSiLFGhg7zk8Ln9VCYXMTUI4+OC4avuKuNLASSz+Jp7FH9seSC8mJ1BqUB+GVc11wkPwAADAcpEMxnON7YaDyJ0eMDrOj1KPtXuxdLZ+/boNAjO0ZEfc5THFzDnWL460NAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sscCiE3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sscCiE3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E2D1F00893;
	Sat, 10 Oct 2026 20:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791664491;
	bh=vSZkmDwfTpz7szKPtJ1bGEQh8AtVOROpk2YO8deTVgI=;
	h=Date:To:From:Subject;
	b=sscCiE3W9vjlDlodd1Z0SHnPLVELUe4H2fzzrNZu4hSZjJhzMduqdABmeYuPtr6P1
	 wMSZapCbNipRH+BNiPVhFkUdQXNb6eYNToREhuvLdPBOTtBSxKUblAiRYj7xUzqh2W
	 dgDuCgodiwECE1cdzUWRzpOTip0qXnKwcg177hmg=
Date: Sat, 10 Oct 2026 13:34:51 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mm_init-add-zone-mismatch-warning-during-page-init.patch removed from -mm tree
Message-Id: <20261010203451.A8E2D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: add zone mismatch warning during page init
has been removed from the -mm tree.  Its filename was
     mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/mm_init: add zone mismatch warning during page init
Date: Tue, 29 Sep 2026 13:32:31 +0800

For vmemmap-optimized sections, tail struct pages may be backed by shared
vmemmap pages.  Those shared pages must carry the same page zone ID as the
struct pages initialized for the section.

Warn in __init_single_page() if the shared tail page has a different
page_zone_id(), which would indicate inconsistent initialization.

Link: https://lore.kernel.org/20260929053231.66085-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ayush Ranjan <ayushr@modal.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>
---

 mm/mm_init.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/mm_init.c~mm-mm_init-add-zone-mismatch-warning-during-page-init
+++ a/mm/mm_init.c
@@ -609,6 +609,9 @@ void __meminit __init_single_page(struct
 	if (!is_highmem_idx(zone))
 		set_page_address(page, __va(pfn << PAGE_SHIFT));
 #endif
+	VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)) &&
+			page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
+			page_zone_id(page));
 }
 
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

