Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943EAC4708E
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 02:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjAFCh0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 21:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjAFChY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 21:37:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D7665AF3
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 18:37:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CC5AB81C1B
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 02:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481F1C433D2;
        Fri,  6 Jan 2023 02:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672972637;
        bh=pHg89O/BJGGBA7pXWCerHTBjv8RbCX1e9ftY3zbBc9w=;
        h=Date:To:From:Subject:From;
        b=zbdGtW5q7XHboJVjp1VEz0eucwlpW+rJE6U5L42ZP1CVwPGdjPDBAn6BBDjyk3JwC
         dBDu1hCM4WLXy5uHozRGMyL1sWko766owUQ3nbeA/xWXQwYwshM3O01dpXbjEnQPUo
         ljqoa/b3jRShTqyCSn1S9g9h+wTjY2FfJVBjsLAA=
Date:   Thu, 05 Jan 2023 18:37:16 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch added to mm-unstable branch
Message-Id: <20230106023717.481F1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/numaperf: increase depth of subsections
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch

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
Subject: Docs/admin-guide/mm/numaperf: increase depth of subsections
Date: Tue, 3 Jan 2023 18:07:54 +0000

Each section of numaperf.rst has zero depth, and therefore be exposed to
the index of admin-guide/mm.  Especially 'See Also' section on the index
makes the document weird.  Hide the sections from the index by giving the
document a title and increasing the depth of each section.

Link: https://lkml.kernel.org/r/20230103180754.129637-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/numaperf.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/numaperf.rst~docs-admin-guide-mm-numaperf-increase-depth-of-subsections
+++ a/Documentation/admin-guide/mm/numaperf.rst
@@ -1,6 +1,9 @@
 .. _numaperf:
 
-=============
+================
+NUMA Performance
+================
+
 NUMA Locality
 =============
 
@@ -61,7 +64,6 @@ that are CPUs and hence suitable for gen
 IO initiators such as GPUs and NICs.  Unlike access class 0, only
 nodes containing CPUs are considered.
 
-================
 NUMA Performance
 ================
 
@@ -96,7 +98,6 @@ for the platform.
 Access class 1 takes the same form but only includes values for CPU to
 memory activity.
 
-==========
 NUMA Cache
 ==========
 
@@ -170,7 +171,6 @@ The "size" is the number of bytes provid
 The "write_policy" will be 0 for write-back, and non-zero for
 write-through caching.
 
-========
 See Also
 ========
 
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
docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch
scripts-spelling-add-a-few-more-typos.patch

