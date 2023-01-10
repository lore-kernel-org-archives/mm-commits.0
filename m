Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D737C54EBC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 22:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjAJWl0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 17:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbjAJWlZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 17:41:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4091E5F91F
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 14:41:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1C95617D0
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 22:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8AFC433D2;
        Tue, 10 Jan 2023 22:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673390484;
        bh=afCGemC7zYg/bjpRLsz4DtzsiReZNCKpzaxFjjKjEy0=;
        h=Date:To:From:Subject:From;
        b=UYYjfbLlnZ5AEFkp+nkeJ0YzE0Ze+95N55uk+dXH7Aw3X/s9KZ9G6Pyh3LRXaxFyo
         DDZafPds3jeTYrq9Nc52lwGmHp/jMESIe8zSM0qqIQl12XdrO3Y3/pe05zZI62+zE2
         D5Xe8rYfh5l4VDo0AcbU4yFPREcyMfFcNqzWDwAU=
Date:   Tue, 10 Jan 2023 14:41:23 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch added to mm-unstable branch
Message-Id: <20230110224124.2D8AFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: update kernel-doc comments for DAMOS action supports of each DAMON operations set
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: update kernel-doc comments for DAMOS action supports of each DAMON operations set
Date: Tue, 10 Jan 2023 19:03:53 +0000

Patch series "mm/damon: trivial fixups".

This patchset contains patches for trivial fixups of DAMON's
documentation, MAINTAINERS section, and selftests.


This patch (of 8):

Supports of each DAMOS action are up to DAMON operations set
implementation in use, but not well mentioned on the kernel-doc comments. 
Add the comment.

Link: https://lkml.kernel.org/r/20230110190400.119388-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230110190400.119388-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set
+++ a/include/linux/damon.h
@@ -91,6 +91,12 @@ struct damon_target {
  * @DAMOS_LRU_DEPRIO:	Deprioritize the region on its LRU lists.
  * @DAMOS_STAT:		Do nothing but count the stat.
  * @NR_DAMOS_ACTIONS:	Total number of DAMOS actions
+ *
+ * The support of each action is up to running &struct damon_operations.
+ * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR supports all actions except
+ * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS_PADDR
+ * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
+ * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
  */
 enum damos_action {
 	DAMOS_WILLNEED,
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

