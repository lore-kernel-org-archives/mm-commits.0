Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415AA3CF21F
	for <mm-commits@vger.kernel.org>; Wed, 30 Sep 2026 19:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794916; cv=none; b=lD5Ux8oqRa+MWVa8TGG+t3GuPkFSpWCKrm1QSRFqWqSvAJPyz8UJLyfinYn7GX8oyQda2Ta/JW1JpVQ37v3ZDdOKqOFZIAUQGBK73Y8ifNh9QGytAdPGgJC2fXDsoAcW818EOXsZ+iwlqrkxGK6ks/ccyZd/h/FB5gl2otlR+xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794916; c=relaxed/simple;
	bh=bBFZilPzbofiS+B9xKfIiv7wDcx2785sOTpvPH+LXHs=;
	h=Date:To:From:Subject:Message-Id; b=jhH0JV0TUI5IoJ5Zy5Z4cyz3otrZ1TNfKEaHd3AOKEp0M0Rp31DDLEz5miXlvQC7p8QEzbVxRSNVynMaxiuXvGxprC4n5WK3gVkNCXiPxCL0SXh8Bul3ytCSZX25oGQTLZGo0TxeadF/cSFlmP5d+ojbMj+nxXlmG6K5sHbvZGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fHbnZWW5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fHbnZWW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF9A1F000FF;
	Wed, 30 Sep 2026 19:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790794914;
	bh=uopkORC5lfjXvs4AtqUeHuBBbm0Lp2gTbg9kkA6IoNY=;
	h=Date:To:From:Subject;
	b=fHbnZWW5cvh3zPTalHEEv3kgZhMTU/tRGDMuUlbTaVbNy7/KW5ZfoNh5p90PDPMnK
	 m7bTJbKuKdvj+vRFTElEVvB2FvqaYVxwiGeSYKbAcrNvRe9V3dnnEysUr+DP9qkrpu
	 DpIcderfaLMEPg1vO+JV9sby0W0gCKlLVs9RFd+0=
Date: Wed, 30 Sep 2026 12:01:54 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch added to mm-unstable branch
Message-Id: <20260930190154.CFF9A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup! mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Muchun Song <muchun.song@linux.dev>
Subject: fixup! mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
Date: Wed, 30 Sep 2026 23:07:48 +0800

prep_compound_tail() makes PageCompound() true.  Calling
__SetPageReserved() afterwards violates the PF_NO_COMPOUND policy and
triggers VM_BUG_ON_PGFLAGS() when CONFIG_DEBUG_VM_PGFLAGS is enabled.

Set PG_reserved before preparing the compound tail.

Link: https://lore.kernel.org/20260930150748.1134516-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Lance Yang <lance.yang@linux.dev>
---

 mm/sparse-vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
+++ a/mm/sparse-vmemmap.c
@@ -224,9 +224,9 @@ struct page __ref *vmemmap_shared_tail_p
 		atomic_set(&page->_mapcount, -1);
 		set_page_node(page, zone_to_nid(zone));
 		set_page_zone(page, zone_idx(zone));
-		prep_compound_tail(page, NULL, order);
 		if (zone_is_zone_device(zone))
 			__SetPageReserved(page);
+		prep_compound_tail(page, NULL, order);
 	}
 
 	page = virt_to_page(addr);
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-allocate-shared-tail-page-array-dynamically.patch
mm-sparse-vmemmap-introduce-config_vmemmap_optimization.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-compound-page-orders.patch
mm-sparse-vmemmap-set-compound-page-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch
mm-sparse-vmemmap-move-vmemmap-optimization-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch
mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

