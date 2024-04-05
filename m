Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB88D171E5B;
	Fri,  5 Apr 2024 18:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712341328; cv=none; b=GF3nUswNMKJqAQ84+JY/AEm2rXYkkEWnW22VteqUBcXgqvFclwg6XLtnasbR6kxJU70QT25rbwQj3ikV2bzz1yUy59TWyAQ9JfsTzV/XhYsNe7XXIy6F5y5LT0Voz9dC6aESfg4IaeoWlm9RlTqpfrFwheV8jGz8rZec3XS4ZCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712341328; c=relaxed/simple;
	bh=MAA2j2LUcLvyJ76WZX8GyIt+FJpLYz8om1awMYUzrKQ=;
	h=Date:To:From:Subject:Message-Id; b=HSBrk2iMfyKr0oSpCcZb+buQ49AaivLMb/+CS2GpYsoBbkz/+jaU6r8rNedBxaeF5j7QkRzHg4d3RKBG0YGc8LlGypl6bVW6/WQo6e+yYTDHE0i4x3ef6B62/978N39ztOXOzD98h1Yzr1SqDNTdJz5Hqbc3kKWHgndGUB75QC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mPm33djd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mPm33djd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53365C433F1;
	Fri,  5 Apr 2024 18:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712341327;
	bh=MAA2j2LUcLvyJ76WZX8GyIt+FJpLYz8om1awMYUzrKQ=;
	h=Date:To:From:Subject:From;
	b=mPm33djdo/9rLb4gJEnHg2YQaGwlNgJogit2aCTEBzXvELrVIeqb7wYX7Pur1GhR9
	 5zCdr+qBzFUFQc6UwrB0wIEcBleUWvEzvg8G18LvaqnZFFDQ6tSKxIZoAkpXU/zY7f
	 PaoJ4XtujWp+PcV0+XoWA2gvP7kplmeKphFPLZPU=
Date: Fri, 05 Apr 2024 11:22:06 -0700
To: mm-commits@vger.kernel.org,xrivendell7@gmail.com,stable@vger.kernel.org,samsun1006219@gmail.com,rppt@kernel.org,mszeredi@redhat.com,miklos@szeredi.hu,lstoakes@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch removed from -mm tree
Message-Id: <20240405182207.53365C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/secretmem: fix GUP-fast succeeding on secretmem folios
has been removed from the -mm tree.  Its filename was
     mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/secretmem: fix GUP-fast succeeding on secretmem folios
Date: Tue, 26 Mar 2024 15:32:08 +0100

folio_is_secretmem() currently relies on secretmem folios being LRU
folios, to save some cycles.

However, folios might reside in a folio batch without the LRU flag set, or
temporarily have their LRU flag cleared.  Consequently, the LRU flag is
unreliable for this purpose.

In particular, this is the case when secretmem_fault() allocates a fresh
page and calls filemap_add_folio()->folio_add_lru().  The folio might be
added to the per-cpu folio batch and won't get the LRU flag set until the
batch was drained using e.g., lru_add_drain().

Consequently, folio_is_secretmem() might not detect secretmem folios and
GUP-fast can succeed in grabbing a secretmem folio, crashing the kernel
when we would later try reading/writing to the folio, because the folio
has been unmapped from the directmap.

Fix it by removing that unreliable check.

Link: https://lkml.kernel.org/r/20240326143210.291116-2-david@redhat.com
Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: xingwei lee <xrivendell7@gmail.com>
Reported-by: yue sun <samsun1006219@gmail.com>
Closes: https://lore.kernel.org/lkml/CABOYnLyevJeravW=QrH0JUPYEcDN160aZFb7kwndm-J2rmz0HQ@mail.gmail.com/
Debugged-by: Miklos Szeredi <miklos@szeredi.hu>
Tested-by: Miklos Szeredi <mszeredi@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/secretmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/secretmem.h~mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios
+++ a/include/linux/secretmem.h
@@ -13,10 +13,10 @@ static inline bool folio_is_secretmem(st
 	/*
 	 * Using folio_mapping() is quite slow because of the actual call
 	 * instruction.
-	 * We know that secretmem pages are not compound and LRU so we can
+	 * We know that secretmem pages are not compound, so we can
 	 * save a couple of cycles here.
 	 */
-	if (folio_test_large(folio) || !folio_test_lru(folio))
+	if (folio_test_large(folio))
 		return false;
 
 	mapping = (struct address_space *)
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch
mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch
mm-remove-prot-parameter-from-move_pte.patch
mm-gup-consistently-name-gup-fast-functions.patch
mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch
mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch

