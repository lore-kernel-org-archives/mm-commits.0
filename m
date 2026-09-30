Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0DA175A89
	for <mm-commits@vger.kernel.org>; Wed, 30 Sep 2026 18:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793617; cv=none; b=sVNIWkQNPMQdythtckLCrNh2AFi8owybbBrX82lQ8pdG8P8aW3TUlEzS6TN6QBZRsS8rw6ry8T9WPkZfLoD+IwXPJMtXUeSRdw6mzBPw45F9ypJetzdi1eyiVJ9xXUgCqOq9GLiWfKe3KvEzo6nfOW8QcKkg0AwTN/nKVIhbl/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793617; c=relaxed/simple;
	bh=g+f6YDr11ze6DZbTEWKv190U8Q/HOKJQaoA0o4FkzAo=;
	h=Date:To:From:Subject:Message-Id; b=Dat0vRG1JKuC/g2bj541qulMhVgk5g5CZX4HfaCFd6Grjf2BKIK+n8w0NZFH5lr8WJ3HLshRjIci7nkzWK6gljuSTfi93Pxgpyz3DV8/aPzMUXeFpELv+YuN7+uUi1fT+RRbymbbWZgLmQ2sPfRPmBxQqfSlGvXf4cqkZWPf8U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dDXZU72j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dDXZU72j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C641F000FF;
	Wed, 30 Sep 2026 18:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790793616;
	bh=RkHWAK5foM8tg6nFRlYzrlwB0LAkTDHObGUIwwp300M=;
	h=Date:To:From:Subject;
	b=dDXZU72jrVC/59xaXFRJDR/ad3BSXFiGo6NR+KS0ThcnQT6lKpbhc5QdH6rMVYd9x
	 K+1/rMeyZjtsUE5PLa2EOXpaxxP38dlYwHQoQTJkPMYR+Twh2tewK3TmzlZGCPNZrQ
	 7kk+8q+wRRKU2IUIYqrZd+5t00WQhrvAzejjG1R8=
Date: Wed, 30 Sep 2026 11:40:15 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch removed from -mm tree
Message-Id: <20260930184015.E5C641F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
Date: Mon, 28 Sep 2026 12:41:48 +0800

Each PTE mapping the shared device DAX tail page takes a page reference.
A sufficiently large range could therefore cycle the reference count back
to zero if population were allowed to continue after it became
non-positive.

Use try_get_page() so further mappings fail once the reference count is no
longer positive. The section population error path tears down mappings
created for the failed section, while the warning makes this currently
impractical limit visible.

Link: https://lore.kernel.org/20260928044148.3300333-1-songmuchun@bytedance.com
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
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Lance Yang <lance.yang@linux.dev>
---

 mm/sparse-vmemmap.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
+++ a/mm/sparse-vmemmap.c
@@ -286,14 +286,18 @@ static pte_t * __meminit vmemmap_pte_pop
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
-			if (flags & VMEMMAP_POPULATE_DAX)
-				get_page(pfn_to_page(ptpfn));
+			if ((flags & VMEMMAP_POPULATE_DAX) &&
+			    !try_get_page(pfn_to_page(ptpfn)))
+				return NULL;
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
_

Patches currently in -mm which might be from muchun.song@linux.dev are

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

