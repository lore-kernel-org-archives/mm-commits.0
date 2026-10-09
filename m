Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727393B52E2
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 04:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791519448; cv=none; b=JuAOhDjslfazAhNjFUzoYhGrRhJ7b+MQPvs4zB5M2LG1LhzXNg9q2jyBLrTfR8/3rUYwwwsv9jbWsd2CeNtsHreRmPN+urhGb4oIflF5gohPrrmd4rJmwfCwF0Nt2+cjKplPuMiXOvQy7tJtrakpnX7uKCpDtIIleRYMbAttrHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791519448; c=relaxed/simple;
	bh=Up6RI9uVC2c+wIJbpZm0V5bMiNhWTdbZgDD4nkbk5ts=;
	h=Date:To:From:Subject:Message-Id; b=pk/fIidgVnCGGBIpOwBc1rp8786Umz6qi6kdBUitJntUT+Zw71/IeiSkgXh3KkRh5ut0xyW4g/uFvX5hfYaSpYyPQZAu8GiQW7PvPceamSvGZ/dSl/Z5rGlYRrHbboArdN/lcjpWAY5KdWx0MCoRMza/ncsqWv4AiG2Lh2dAfMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QyBfy+Mu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QyBfy+Mu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DB11F000FF;
	Fri,  9 Oct 2026 04:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791519439;
	bh=UlLmMMicPljVsfClOsUHCrhuDVouNNDgCxmsoKw8VE0=;
	h=Date:To:From:Subject;
	b=QyBfy+MuEL8duDFjJfwcuF0AI7qk8lPDlf4uA16MPMRtfUOp6UulmoMnOGSA5GdoR
	 aOnSFEZul5Bo2W7GZlri1b8CrbppgsSchzTqtR+l8SZz8hX4BYwFhIUa0uZEKF9I/q
	 uDiqxsaBL9L1mR3YWBDvpkxHZD0ojBK/hpmXydwo=
Date: Thu, 08 Oct 2026 21:17:19 -0700
To: mm-commits@vger.kernel.org,sshegde@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,rdunlap@infradead.org,qi.zheng@linux.dev,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,lance.yang@linux.dev,david@kernel.org,corbet@lwn.net,chleroy@kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch removed from -mm tree
Message-Id: <20261009041719.A4DB11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup! powerpc/mm: switch device DAX to shared tail vmemmap pages
has been removed from the -mm tree.  Its filename was
     powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch

This patch was dropped because it was folded into powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: fixup! powerpc/mm: switch device DAX to shared tail vmemmap pages
Date: Wed, 30 Sep 2026 23:28:26 +0800

The PowerPC radix path takes one reference for every PTE that maps the
shared tail page.  Unlike the generic path, get_page() lets the counter
continue after it becomes non-positive and eventually cycle to zero.

Use try_get_page() so vmemmap population fails before the shared page
reference count can cycle, matching the generic implementation.

Link: https://lore.kernel.org/20260930152826.76084-1-songmuchun@bytedance.com
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

 arch/powerpc/mm/book3s64/radix_pgtable.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages-fix
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1042,13 +1042,17 @@ static pte_t * __meminit radix__vmemmap_
 			/*
 			 * When a PTE/PMD entry is freed from the init_mm
 			 * there's a free_pages() call to this page allocated
-			 * above. Thus this get_page() is paired with the
+			 * above. Thus this try_get_page() is paired with the
 			 * put_page_testzero() on the freeing path.
 			 * This can only called by certain ZONE_DEVICE path,
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
+			 *
+			 * Use try_get_page() to prevent the shared page refcount
+			 * from overflowing.
 			 */
-			get_page(reuse);
+			if (!try_get_page(reuse))
+				return NULL;
 			p = page_to_virt(reuse);
 			pr_debug("Tail page reuse vmemmap mapping\n");
 		}
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
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch
mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

