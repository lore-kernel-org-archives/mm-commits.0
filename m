Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3723DC54EBC
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 00:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbjALAPh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 19:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235511AbjALAPb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 19:15:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1F21C93F
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 16:15:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 915DFB81CDE
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 00:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B7DC433D2;
        Thu, 12 Jan 2023 00:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482522;
        bh=FFx1+NUq3FOGRh86kovUKDEdBwA1xADVIKlAarWkNeQ=;
        h=Date:To:From:Subject:From;
        b=0Iai4emMVSS0FsC+vvQjYXrsStfh/ijyGqV476k7IjOTaPcBtwc/+LRNl35ZyeTpM
         munkZ3xnGiZWd4OjR/OcOFKYC1AAxmwUOLF15tgCwEV3fPjsX3uHCtoIOdmWBapjOh
         yAlSMxIDsaI95PjvELCDgtEPP5PFwRjpecCRfWnM=
Date:   Wed, 11 Jan 2023 16:15:21 -0800
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] include-linux-mm-fix-release_pages_arg-kernel-doc-comment.patch removed from -mm tree
Message-Id: <20230112001522.12B7DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/linux/mm: fix release_pages_arg kernel doc comment
has been removed from the -mm tree.  Its filename was
     include-linux-mm-fix-release_pages_arg-kernel-doc-comment.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: include/linux/mm: fix release_pages_arg kernel doc comment
Date: Fri, 6 Jan 2023 20:33:31 +0000

Commit 449c796768c9 ("mm: teach release_pages() to take an array of
encoded page pointers too") added the kernel doc comment for
release_pages() on top of 'union release_pages_arg', so making 'make
htmldocs' complains as below:

    ./include/linux/mm.h:1268: warning: cannot understand function prototype: 'typedef union '

The kernel doc comment for the function is already on top of the
function's definition in mm/swap.c, and the new comment is actually not
for the function but indeed release_pages_arg.  Fixing the comment to
reflect the intent would be one option.  But, kernel doc cannot parse
the union as below due to the attribute.

    ./include/linux/mm.h:1272: error: Cannot parse struct or union!

Modify the comment to reflect the intent but do not mark it as a kernel
doc comment.

Link: https://lkml.kernel.org/r/20230106203331.127532-1-sj@kernel.org
Fixes: 449c796768c9 ("mm: teach release_pages() to take an array of encoded page pointers too")
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~include-linux-mm-fix-release_pages_arg-kernel-doc-comment
+++ a/include/linux/mm.h
@@ -1270,10 +1270,10 @@ static inline void folio_put_refs(struct
 		__folio_put(folio);
 }
 
-/**
- * release_pages - release an array of pages or folios
+/*
+ * union release_pages_arg - an array of pages or folios
  *
- * This just releases a simple array of multiple pages, and
+ * release_pages() releases a simple array of multiple pages, and
  * accepts various different forms of said page array: either
  * a regular old boring array of pages, an array of folios, or
  * an array of encoded page pointers.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix-fix-2.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch
mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected.patch
maintainers-add-types-to-akpm-mm-git-trees-entries.patch
maintainers-memory-management-add-tools-vm-as-managed-files.patch
tools-vm-rename-tools-vm-to-tools-mm.patch
selftests-vm-rename-selftets-vm-to-selftests-mm.patch
selftests-vm-rename-selftets-vm-to-selftests-mm-fix.patch
docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch
docs-admin-guide-mm-numaperf-increase-depth-of-subsections-fix.patch
mm-damon-vaddr-rename-damon_young_walk_private-page_sz-to-folio_sz.patch
mm-damon-vaddr-support-folio-of-neither-hpage_pmd_size-nor-page_size.patch
mm-damon-vaddr-record-appropriate-folio-size-when-the-access-is-not-found.patch
mm-damon-paddr-rename-damon_pa_access_chk_result-page_sz-to-folio_sz.patch
mm-damon-paddr-remove-folio_sz-field-from-damon_pa_access_chk_result.patch
mm-damon-paddr-remove-damon_pa_access_chk_result-struct.patch
mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
scripts-spelling-add-a-few-more-typos.patch

