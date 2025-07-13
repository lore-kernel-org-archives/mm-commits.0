Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DA110E5
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752449625; cv=none; b=eIxJ+cQZvom69APTvZgeLlppADqrNx13Mz+Tr504jWgXBSnRUsldmIh6ad1zQSAbZ7lh/sLkWpAPdhFMkH73BfEO4xjyvbhuKglkRowUZBY4L8YpYeExQ0ALTLRvHjzKz1V9nC0lIN77Cd3XSoDHBcJsEg2UPDmWPpgLo4Q62PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752449625; c=relaxed/simple;
	bh=jSkbJMJAvmjHGv9xBeGiiWQ4671hucCaXTXnP/2SGLY=;
	h=Date:To:From:Subject:Message-Id; b=ZNLgHQQqIkkghnHjRo/ko7sV6Gx0mE3l+iUrGn7WYw4MKctFZhUxT1P8yfuul7EDSR9TB332kMqHWR28zOuDBv2a++nbKCkk7Z/T6Jdq71DScOncavJslVUy2PBVY7BoYSL0yYMcXjXFMCoFc7NdIZ0JuTB9o2Ckk25RcfxIJrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=efi+tl4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="efi+tl4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC158C4CEE3;
	Sun, 13 Jul 2025 23:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752449625;
	bh=jSkbJMJAvmjHGv9xBeGiiWQ4671hucCaXTXnP/2SGLY=;
	h=Date:To:From:Subject:From;
	b=efi+tl4o7/gVdn79x50/mdXNe466fHp21Y0PjvsFnJ4IcTn5/olBNz9BX7D+EtSyO
	 c6kBC+F0gh5ibksHMS35+QKYqp6vz0nj8unNcvbJezSHSNh+U4xl8tpsa+7X41uvLA
	 mCbwcU2FApLzGE4XgH7B5an4H+7W2gTnnrHatV9Y=
Date: Sun, 13 Jul 2025 16:33:44 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-convert-movable-flag-in-page-mapping-to-a-page-flag-fix.patch removed from -mm tree
Message-Id: <20250713233344.EC158C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-convert-movable-flag-in-page-mapping-to-a-page-flag-fix
has been removed from the -mm tree.  Its filename was
     mm-convert-movable-flag-in-page-mapping-to-a-page-flag-fix.patch

This patch was dropped because it was folded into mm-convert-movable-flag-in-page-mapping-to-a-page-flag.patch

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
mm-rename-pg_isolated-to-pg_movable_ops_isolated.patch
mm-page-flags-rename-page_mapping_movable-to-page_mapping_anon_ksm.patch
mm-page-alloc-remove-pagemappingflags.patch
mm-page-flags-remove-folio_mapping_flags.patch
mm-simplify-folio_expected_ref_count.patch
mm-rename-page_mapping_-to-folio_mapping_.patch
docs-mm-convert-from-non-lru-page-migration-to-movable_ops-page-migration.patch
mm-balloon_compaction-movable_ops-doc-updates.patch
mm-balloon_compaction-provide-single-balloon_page_insert-and-balloon_mapping_gfp_mask.patch
mm-convert-fpb_ignore_-into-fpb_respect_.patch
mm-smaller-folio_pte_batch-improvements.patch
mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch
mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch
mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch

