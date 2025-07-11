Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCAB1B0421
	for <mm-commits@vger.kernel.org>; Fri, 11 Jul 2025 23:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752275341; cv=none; b=qP/HurYf7/NK3nBFXM+/eT8kwj/7bgO8SLTLs7+s8CK4U9UNZw2iY8JKfaV/xCIflk/nZzJrK4kq4DJBuCSCIKG/tCdw1TSaU1ITEXFve7CbLguI9uvl4GdszQYtn39TPJ+llJgf7qG3pT39MG7WLZrvz/NDdpEUCAb518+1cLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752275341; c=relaxed/simple;
	bh=zRjd6t2b5+ipfolgycoqWx1w/d4rnSCzGYE1pBX3lZU=;
	h=Date:To:From:Subject:Message-Id; b=Wth2C6Li2wr9pvAafgDiouhl0q1HEcJ3cNTNf81pXPkB+HIm9f34g8lrI5f/LjB2EGaIachCoUzVY6tMYUZQAZE/Ha/VOXO6y4HBzhN9ICQbMhxenXnzpgdkulR2LPYqsJjfoLEGcgCw8byoVPYVvQK55LpxHtMm0dZ1ra8dKPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O76rVw9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O76rVw9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84660C4CEED;
	Fri, 11 Jul 2025 23:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752275340;
	bh=zRjd6t2b5+ipfolgycoqWx1w/d4rnSCzGYE1pBX3lZU=;
	h=Date:To:From:Subject:From;
	b=O76rVw9li6pn5RcEOS10VCwlYCNnKAPWSIVRqqblEnSfKdHK+3TJRGr8140qJq4L1
	 E2b74aAKdN1v+FmdUQHVZ4++OQBoqJeSJ8QLh1Y4yNrr23CUiie5XJNqyAIo3RMPuA
	 O65xSWImSAqpAMWyegqv6gpBBFDqYap8XKSxotpE=
Date: Fri, 11 Jul 2025 16:08:58 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-movable-flag-in-page-mapping-to-a-page-flag-fix.patch added to mm-unstable branch
Message-Id: <20250711230900.84660C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-convert-movable-flag-in-page-mapping-to-a-page-flag-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-movable-flag-in-page-mapping-to-a-page-flag-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-movable-flag-in-page-mapping-to-a-page-flag-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-convert-movable-flag-in-page-mapping-to-a-page-flag-fix
Date: Fri, 11 Jul 2025 11:57:37 +0200

add missing `:' in kerneldoc

Link: https://lkml.kernel.org/r/d96e2916-2c43-462c-b6a1-2375ef397d8b@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-convert-movable-flag-in-page-mapping-to-a-page-flag-fix
+++ a/include/linux/page-flags.h
@@ -1154,7 +1154,7 @@ SETPAGEFLAG_NOOP(MovableOps, movable_ops
 
 /**
  * page_has_movable_ops - test for a movable_ops page
- * @page The page to test.
+ * @page: The page to test.
  *
  * Test whether this is a movable_ops page. Such pages will stay that
  * way until freed.
_

Patches currently in -mm which might be from david@redhat.com are

mm-balloon_compaction-we-cannot-have-isolated-pages-in-the-balloon-list.patch
mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize.patch
mm-zsmalloc-drop-pageisolated-related-vm_bug_ons.patch
mm-page_alloc-let-page-freeing-clear-any-set-page-type.patch
mm-balloon_compaction-make-pageoffline-sticky-until-the-page-is-freed.patch
mm-zsmalloc-make-pagezsmalloc-sticky-until-the-page-is-freed.patch
mm-migrate-rename-isolate_movable_page-to-isolate_movable_ops_page.patch
mm-migrate-rename-putback_movable_folio-to-putback_movable_ops_page.patch
mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page.patch
mm-migrate-remove-folio_test_movable-and-folio_movable_ops.patch
mm-migrate-move-movable_ops-page-handling-out-of-move_to_new_folio.patch
mm-zsmalloc-stop-using-__clearpagemovable.patch
mm-balloon_compaction-stop-using-__clearpagemovable.patch
mm-migrate-remove-__clearpagemovable.patch
mm-migration-remove-pagemovable.patch
mm-rename-__pagemovable-to-page_has_movable_ops.patch
mm-page_isolation-drop-__folio_test_movable-check-for-large-folios.patch
mm-remove-__folio_test_movable.patch
mm-stop-storing-migration_ops-in-page-mapping.patch
mm-convert-movable-flag-in-page-mapping-to-a-page-flag.patch
mm-convert-movable-flag-in-page-mapping-to-a-page-flag-fix.patch
mm-rename-pg_isolated-to-pg_movable_ops_isolated.patch
mm-page-flags-rename-page_mapping_movable-to-page_mapping_anon_ksm.patch
mm-page-alloc-remove-pagemappingflags.patch
mm-page-flags-remove-folio_mapping_flags.patch
mm-simplify-folio_expected_ref_count.patch
mm-rename-page_mapping_-to-folio_mapping_.patch
docs-mm-convert-from-non-lru-page-migration-to-movable_ops-page-migration.patch
mm-balloon_compaction-movable_ops-doc-updates.patch
mm-balloon_compaction-provide-single-balloon_page_insert-and-balloon_mapping_gfp_mask.patch

