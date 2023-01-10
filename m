Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9ECC54EBC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 22:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbjAJWlp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 17:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbjAJWld (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 17:41:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43ED60CED
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 14:41:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56C0BB81982
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 22:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FEEC433EF;
        Tue, 10 Jan 2023 22:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673390490;
        bh=jOmxC6Wy/69mDplP5/+qRjRfzCqQ8+Nbn3lRkqCX+Ek=;
        h=Date:To:From:Subject:From;
        b=vrrLRmzcoZTnJumvUw6HpdXLaGODHV2phVrWwFeIs7K4ru3actienKC9bDxNeYKVI
         sM60q9CzJVBktwFRe3Un/r1AsUe93HpKICpBsoeOrJL6v/IQ6lJVwo3pXrV2lu8Fby
         oVdoeY/B3Smlh6v0u4LwvKLQbOatMaXZ69GqrAPQ=
Date:   Tue, 10 Jan 2023 14:41:29 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch added to mm-unstable branch
Message-Id: <20230110224129.F0FEEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update DAMOS actions/filters supports of each DAMON operations set
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch

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
Subject: Docs/admin-guide/mm/damon/usage: update DAMOS actions/filters supports of each DAMON operations set
Date: Tue, 10 Jan 2023 19:03:56 +0000

Supports of each DAMOS action and filters are up to DAMON operations set
implementation, but it's not mentioned in detail on the documentation. 
Update the information on the usage document.

Link: https://lkml.kernel.org/r/20230110190400.119388-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   41 +++++++++++------
 1 file changed, 28 insertions(+), 13 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -279,14 +279,25 @@ The ``action`` file is for setting and g
 memory regions having specific access pattern of the interest.  The keywords
 that can be written to and read from the file and their meaning are as below.
 
- - ``willneed``: Call ``madvise()`` for the region with ``MADV_WILLNEED``
- - ``cold``: Call ``madvise()`` for the region with ``MADV_COLD``
- - ``pageout``: Call ``madvise()`` for the region with ``MADV_PAGEOUT``
- - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``
- - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``
+Note that support of each action depends on the running DAMON operations set
+`implementation <sysfs_contexts>`.
+
+ - ``willneed``: Call ``madvise()`` for the region with ``MADV_WILLNEED``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
+ - ``cold``: Call ``madvise()`` for the region with ``MADV_COLD``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
+ - ``pageout``: Call ``madvise()`` for the region with ``MADV_PAGEOUT``.
+   Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
+ - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
+ - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
  - ``lru_prio``: Prioritize the region on its LRU lists.
+   Supported by ``paddr`` operations set.
  - ``lru_deprio``: Deprioritize the region on its LRU lists.
- - ``stat``: Do nothing but count the statistics
+   Supported by ``paddr`` operations set.
+ - ``stat``: Do nothing but count the statistics.
+   Supported by all operations sets.
 
 schemes/<N>/access_pattern/
 ---------------------------
@@ -388,8 +399,8 @@ pages of all memory cgroups except ``/ha
     echo /having_care_already > 1/memcg_path
     echo N > 1/matching
 
-Note that filters could be ignored depend on the running DAMON operations set
-`implementation <sysfs_contexts>`.
+Note that filters are currently supported only when ``paddr``
+`implementation <sysfs_contexts>` is being used.
 
 .. _sysfs_schemes_stats:
 
@@ -618,11 +629,15 @@ The ``<action>`` is a predefined integer
 DAMON will apply to the regions having the target access pattern.  The
 supported numbers and their meanings are as below.
 
- - 0: Call ``madvise()`` for the region with ``MADV_WILLNEED``
- - 1: Call ``madvise()`` for the region with ``MADV_COLD``
- - 2: Call ``madvise()`` for the region with ``MADV_PAGEOUT``
- - 3: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``
- - 4: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``
+ - 0: Call ``madvise()`` for the region with ``MADV_WILLNEED``.  Ignored if
+   ``target`` is ``paddr``.
+ - 1: Call ``madvise()`` for the region with ``MADV_COLD``.  Ignored if
+   ``target`` is ``paddr``.
+ - 2: Call ``madvise()`` for the region with ``MADV_PAGEOUT``.
+ - 3: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.  Ignored if
+   ``target`` is ``paddr``.
+ - 4: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.  Ignored if
+   ``target`` is ``paddr``.
  - 5: Do nothing but count the statistics
 
 Quota
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

