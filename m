Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13624C5479D
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 23:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjAFXfN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Jan 2023 18:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbjAFXfL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2023 18:35:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D5A73E3A
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 15:35:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03A57B81E44
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 23:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C64C433D2;
        Fri,  6 Jan 2023 23:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673048107;
        bh=Yiz9Ripo016iMZwnjznO6pQTT5VGKegFrHCmeayl1Yw=;
        h=Date:To:From:Subject:From;
        b=Yw138VwRA7nHMujSicJZBksJpWhfWXcL0AMF+43/hfn8zIjh1mFgkpfIFAuUAdVXp
         AZqEy/7SFG3tfu/tMeMxAW5AZCCf9FmpbI2I303pJ5UMQJRJnAaC6abEWkztOazXJI
         w0sLmgByWXxTXu7uFYSyMkwu4MJI5qsKpuPEr2lM=
Date:   Fri, 06 Jan 2023 15:35:06 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-numaperf-increase-depth-of-subsections-fix.patch added to mm-unstable branch
Message-Id: <20230106233507.98C64C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/numaperf: change title to fix duplicate label warning
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-numaperf-increase-depth-of-subsections-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-numaperf-increase-depth-of-subsections-fix.patch

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
Subject: Docs/admin-guide/mm/numaperf: change title to fix duplicate label warning
Date: Fri, 6 Jan 2023 19:49:27 +0000

Commit 1564fac284b1 ("Docs/admin-guide/mm/numaperf: increase depth of
subsections") in mm-unstable titled numaperf.rst as 'NUMA Performance'. 
The name overlaps with an existing subsection title of the document, so
sphinx makes below warning.

    linux/Documentation/admin-guide/mm/numaperf.rst:68: WARNING: duplicate label admin-guide/mm/numaperf:numa performance, other instance in linux/Documentation/admin-guide/mm/numaperf.rst

Fix the warning by changing the title of the document to 'NUMA Memory
Performance'.  It may look more consistent with its sibling document,
'NUMA Memory Policy'.

Link: https://lkml.kernel.org/r/20230106194927.152663-1-sj@kernel.org
Fixes: 1564fac284b1 ("Docs/admin-guide/mm/numaperf: increase depth of subsections") in mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/numaperf.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/numaperf.rst~docs-admin-guide-mm-numaperf-increase-depth-of-subsections-fix
+++ a/Documentation/admin-guide/mm/numaperf.rst
@@ -1,8 +1,8 @@
 .. _numaperf:
 
-================
-NUMA Performance
-================
+=======================
+NUMA Memory Performance
+=======================
 
 NUMA Locality
 =============
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
mm-switch-vma_merge-split_vma-and-__split_vma-to-vma-iterator-fix.patch
maintainers-add-types-to-akpm-mm-git-trees-entries.patch
maintainers-memory-management-add-tools-vm-as-managed-files.patch
tools-vm-rename-tools-vm-to-tools-mm.patch
selftests-vm-rename-selftets-vm-to-selftests-mm.patch
docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch
docs-admin-guide-mm-numaperf-increase-depth-of-subsections-fix.patch
scripts-spelling-add-a-few-more-typos.patch

