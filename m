Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF92C3D9027
	for <mm-commits@vger.kernel.org>; Wed, 30 Sep 2026 19:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794927; cv=none; b=Kvp+AQb/ONemxJFfS2QUlMYwnrfUXJ6AoZzbG7yhopXqAgNeu2no1yO5CQ8KD2y3vqBh62o3uCbP1oUHQi3cz/q5AyKHiGNHi1pq5zPrQyXvcSH/3r6/gGwHwL7v3Wc0TexJL+//LbHxzXIDiVc/s80SAcbpeHX1UVO9V8fIv7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794927; c=relaxed/simple;
	bh=XRIWCs2N3Mc1B+K/qR/2mHPXLrrKVNsSqcBkAEaDd4Y=;
	h=Date:To:From:Subject:Message-Id; b=ayimMFpGmBdkubGMQDE7a1bM2ehxaAMTn8OEQ9iLKgKWiZAB13GrUkqT1USoZ3PwuGoZXjeV76koljWUTAqW0AEoq8nDmsiKLZBaORhrqS/4JlXD+Lih1P3X/Nj4RsKHCzz3BdtyeHP0rtGcTTorf7ArqvCgElOj//D67NXtdDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nOXxCWn+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nOXxCWn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D061F00898;
	Wed, 30 Sep 2026 19:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790794925;
	bh=Kcj3QTNFWpHw2Io16TVL7LYIME57gl+3bFN6wsEaH0c=;
	h=Date:To:From:Subject;
	b=nOXxCWn+GizCbPuEx5h+XZpA6T9ZPLPX+t4FlUnvO1qbawAbYmh92tgMgcI82fSFa
	 PFK40RTY6jSWF4Zq+8fi3zJRuv3kQ4LgJyVmvkQZE6L5M4JcXiDBXlcl4Vw59zNHKL
	 JycOvJMYcbdQfB1KM0IpljayS3eMsRd4ffTJhmQo=
Date: Wed, 30 Sep 2026 12:02:05 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch added to mm-unstable branch
Message-Id: <20260930190205.68D061F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup! powerpc/mm: switch device DAX to shared tail vmemmap pages
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch

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

