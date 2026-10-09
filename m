Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDAA339B41
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 04:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791519397; cv=none; b=nSO9Zh98FIMuyUO7nKaVgjiljPg5Fepv31AAXQM6Wb31orkzNfDlzdnQdbmMbw7UXNXNvnfP1reqZSNg46LhQ3usAVh4k38I5bQog9czKL45zJLV3KSaXS+aWQWavu+fA8dfqX1bpDdr7G1G4GFpL6zHMBHT7s4EOVgxWg24EWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791519397; c=relaxed/simple;
	bh=ksUJytXd1od1m4ilLkFXfBDU7k3uXKIgnu2LKDni/vw=;
	h=Date:To:From:Subject:Message-Id; b=S/sTJkA+WTJLD2yZAyTR6CdScp3XdjlKH/EtOjM1LaBlkWtPrYNM9gzBKCty6BlGFzMmLyvmOd5VSxv2BII8gUebhJLmGwxRgqiIVncQpvDVgI2zB5w71YcgxQj1TWnCj3xQafYogpEfVGC2/rb6JDhUUE7rTXQpewmc/f2qgn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eNTLn5a0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eNTLn5a0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B832B1F00898;
	Fri,  9 Oct 2026 04:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791519385;
	bh=r+Hykclfo4oLjkOYp7pz4VTe18s4VlIUT8W/5j6DLRM=;
	h=Date:To:From:Subject;
	b=eNTLn5a0DW6SRE68PEGp0+tkUGbNoGamH9Vv2JjJRojXVmvl80/LOo+yVtADqPHQh
	 PN03StwvEJVjL80M2SV2G3orgtbUAp+kZ15CvDsd0BpG7gNN7eidCvAOSD92YlqreT
	 Vo8oJUOLVeLQHu+rWpJnZQGFjdbs4hE0r3Rcs6ag=
Date: Thu, 08 Oct 2026 21:16:25 -0700
To: mm-commits@vger.kernel.org,sshegde@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,rdunlap@infradead.org,qi.zheng@linux.dev,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,lance.yang@linux.dev,david@kernel.org,corbet@lwn.net,chleroy@kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch removed from -mm tree
Message-Id: <20261009041625.B832B1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup! mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch

This patch was dropped because it was folded into mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch

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

