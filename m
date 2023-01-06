Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4785AC5479D
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 23:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbjAFXgd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Jan 2023 18:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbjAFXgb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2023 18:36:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E882A551C6
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 15:36:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C75B61FA4
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 23:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914E9C433EF;
        Fri,  6 Jan 2023 23:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673048189;
        bh=UHPgGOwhtiRd9DteA0RjKtqWBKlm6LKp+2wpXbUqsE8=;
        h=Date:To:From:Subject:From;
        b=MQbbpeI3AXAkh6Ds13tpDyY5Jd8K/fqL736cyk0TeAkLdXZxHHaxB1xPVQiACAzi0
         VvXIHcH12U63RhI2vYY3HEND78AuBKpcCLIFiJenvKaCfavt1Z5wYv0weJxhG0tA9/
         P3oJ9jZnohtDoopZ5RfUx0VJJ/tilOz/NP4qyITo=
Date:   Fri, 06 Jan 2023 15:36:28 -0800
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + include-linux-mm-fix-release_pages_arg-kernel-doc-comment.patch added to mm-hotfixes-unstable branch
Message-Id: <20230106233629.914E9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mm: fix release_pages_arg kernel doc comment
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     include-linux-mm-fix-release_pages_arg-kernel-doc-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-linux-mm-fix-release_pages_arg-kernel-doc-comment.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

include-linux-mm-fix-release_pages_arg-kernel-doc-comment.patch
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
mm-switch-vma_merge-split_vma-and-__split_vma-to-vma-iterator-fix.patch
maintainers-add-types-to-akpm-mm-git-trees-entries.patch
maintainers-memory-management-add-tools-vm-as-managed-files.patch
tools-vm-rename-tools-vm-to-tools-mm.patch
selftests-vm-rename-selftets-vm-to-selftests-mm.patch
docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch
docs-admin-guide-mm-numaperf-increase-depth-of-subsections-fix.patch
scripts-spelling-add-a-few-more-typos.patch

