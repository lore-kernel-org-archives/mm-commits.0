Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604EBC61DB3
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 22:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbjAJWlq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 17:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbjAJWla (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 17:41:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305CF5F900
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 14:41:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF52A617D0
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 22:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEA0C433D2;
        Tue, 10 Jan 2023 22:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673390488;
        bh=oixvn2PCiX4LFvYY/V6tv8hUFObcIHpxatCozWt7aJo=;
        h=Date:To:From:Subject:From;
        b=AeH3so5FEntohK71P/t2RvvVlcTVWP7WTukgFPvW8jVkFgEzEp20ouxKCd4oIdVha
         /h8LpC47kHbPfA9EpFtRlr8UBNt5UcOxjD4oV3NdTjV+Zfc6Fj4P/oAluXvnITZ6sK
         Mqay9o1QoaLDG9r+4+3usegomBh0vhY/yYeUIHGc=
Date:   Tue, 10 Jan 2023 14:41:27 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-index-mention-damos-on-the-intro.patch added to mm-unstable branch
Message-Id: <20230110224128.1CEA0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/index: mention DAMOS on the intro
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-index-mention-damos-on-the-intro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-index-mention-damos-on-the-intro.patch

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
Subject: Docs/mm/damon/index: mention DAMOS on the intro
Date: Tue, 10 Jan 2023 19:03:55 +0000

What DAMON aims to do is not only access monitoring but efficient and
effective access-aware system operations.  And DAMon-based Operation
Schemes (DAMOS) is the important feature of DAMON for the goal.  Make the
intro of DAMON documentation to emphasize the goal and mention DAMOS.

Link: https://lkml.kernel.org/r/20230110190400.119388-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/index.rst |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/Documentation/mm/damon/index.rst~docs-mm-damon-index-mention-damos-on-the-intro
+++ a/Documentation/mm/damon/index.rst
@@ -4,8 +4,9 @@
 DAMON: Data Access MONitor
 ==========================
 
-DAMON is a data access monitoring framework subsystem for the Linux kernel.
-The core mechanisms of DAMON (refer to :doc:`design` for the detail) make it
+DAMON is a Linux kernel subsystem that provides a framework for data access
+monitoring and the monitoring results based system operations.  The core
+monitoring mechanisms of DAMON (refer to :doc:`design` for the detail) make it
 
  - *accurate* (the monitoring output is useful enough for DRAM level memory
    management; It might not appropriate for CPU Cache levels, though),
@@ -14,12 +15,16 @@ The core mechanisms of DAMON (refer to :
  - *scalable* (the upper-bound of the overhead is in constant range regardless
    of the size of target workloads).
 
-Using this framework, therefore, the kernel's memory management mechanisms can
-make advanced decisions.  Experimental memory management optimization works
-that incurring high data accesses monitoring overhead could implemented again.
-In user space, meanwhile, users who have some special workloads can write
-personalized applications for better understanding and optimizations of their
-workloads and systems.
+Using this framework, therefore, the kernel can operate system in an
+access-aware fashion.  Because the features are also exposed to the user space,
+users who have special information about their workloads can write personalized
+applications for better understanding and optimizations of their workloads and
+systems.
+
+For easier development of such systems, DAMON provides a feature called DAMOS
+(DAMon-based Operation Schemes) in addition to the monitoring.  Using the
+feature, DAMON users in both kernel and user spaces can do access-aware system
+operations with no code but simple configurations.
 
 .. toctree::
    :maxdepth: 2
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

