Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD573BED27
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896700; cv=none; b=SWAWgOBsfNwrtay9O9eF/f1wPd+eQNnuRluryYafFXnr8wF3PgtqRxrnuXCl5PgU22hR7SXiniKCfdTR+DA0tRQS/tRA2ctW0FG3gg45MUjoDNEijAKkGG7v4rfDo64ZjkNrP2JGCB1WUjDh5CHEKu4SzIt7hoocYJjDbCkIJas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896700; c=relaxed/simple;
	bh=RC+6KwWgjpdpjsFUcb+Wp02ZUUGk2NjJIqA0cLIeZGQ=;
	h=Date:To:From:Subject:Message-Id; b=rvfWJZ+emnTdpocc5pfAmT+gktzpp4pYpK2N91B3ia2Pd/zCKhahLcNxFPBowSbq5LKC6prCt5r8ekzwrfnw+/LHMccZllf7WKGnFdrDYpUhwN1FMcKzMx914AY1icq9Y9Wav7EV6DvqzuyeYXxcxh/k+k1ZOnI9JcUaebgIt9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NYjqU6Bv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NYjqU6Bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BD41F000E9;
	Wed,  5 Aug 2026 02:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896699;
	bh=BpPMRM8DVnXfwrshmdbhC6YJEPQVuUDZmBLh3MnCA8o=;
	h=Date:To:From:Subject;
	b=NYjqU6BvqA1piOUjoi644rI+8RcVgbrxkA9YCXtCWoNoytJPVUkhMS5EYp910h4PZ
	 sYqfo6NRgVYllAjhjrRbgecS0xUsWho77Xjnb5ypLfpQEpP43LHrl20iNHO1zW/skW
	 z2tgBJs5xOPnuFMErQDjIkMJ+kiyyUfR4FMTHr3w=
Date: Tue, 04 Aug 2026 19:24:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sougupta@nvidia.com,david@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-fix-gup-fast-fallback-for-null-mapping-order-0-folios.patch removed from -mm tree
Message-Id: <20260805022458.E9BD41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: fix GUP-fast fallback for NULL-mapping order-0 folios
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-gup-fast-fallback-for-null-mapping-order-0-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: fix GUP-fast fallback for NULL-mapping order-0 folios
Date: Tue, 7 Jul 2026 17:57:45 -0700

Since commit f002882ca369 ("mm: merge folio_is_secretmem() and
folio_fast_pin_allowed() into gup_fast_folio_allowed()"),
gup_fast_folio_allowed() falls back to the slow path for any order-0 folio
with a NULL mapping when CONFIG_SECRETMEM=y.  This causes a performance
regression for drivers that allocate pages with alloc_page() and insert
them into VMAs via vm_insert_page().  These pages legitimately have a NULL
folio->mapping, but they cannot be secretmem pages.

Secretmem pages are always added to the secretmem inode's page cache via
filemap_add_folio(), which sets folio->mapping to the inode's i_mapping. 
A folio with a NULL mapping can never be a secretmem folio.  The
NULL-mapping check was intended to handle truncated file-backed pages (a
reject_file_backed concern), not secretmem detection.

When only check_secretmem is true (and reject_file_backed is false), a
NULL mapping is sufficient to prove the folio is not secretmem, so the
fast path can proceed.

Link: https://lore.kernel.org/20260708005745.164928-1-jhubbard@nvidia.com
Fixes: f002882ca369 ("mm: merge folio_is_secretmem() and folio_fast_pin_allowed() into gup_fast_folio_allowed()")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Tested-by: Sourab Gupta <sougupta@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-gup-fix-gup-fast-fallback-for-null-mapping-order-0-folios
+++ a/mm/gup.c
@@ -2784,12 +2784,17 @@ static bool gup_fast_folio_allowed(struc
 	mapping = READ_ONCE(folio->mapping);
 
 	/*
-	 * The mapping may have been truncated, in any case we cannot determine
-	 * if this mapping is safe - fall back to slow path to determine how to
-	 * proceed.
+	 * If the mapping is NULL (truncated, or never set), we cannot
+	 * determine whether the folio is file-backed, so a long-term writable
+	 * pin must fall back to the slow path.
+	 *
+	 * Otherwise, a NULL mapping proves this is not a secretmem folio
+	 * (secretmem folios always have a valid mapping to the secretmem
+	 * inode's address_space), so in that case, we can continue with the
+	 * fast path.
 	 */
 	if (!mapping)
-		return false;
+		return !reject_file_backed;
 
 	/* Anonymous folios pose no problem. */
 	mapping_flags = (unsigned long)mapping & FOLIO_MAPPING_FLAGS;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


