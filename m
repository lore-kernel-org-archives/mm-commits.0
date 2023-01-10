Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B8FCC54EBD
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 01:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjAJBHX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 20:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjAJBHW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 20:07:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED74BB0E
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 17:07:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8399161489
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 01:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6F6C433F2;
        Tue, 10 Jan 2023 01:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673312839;
        bh=U/70A5f9kD2drN3rLVWVcTO7Uwj90Iv5dtFufN429Qo=;
        h=Date:To:From:Subject:From;
        b=uDDLsOKilPau/V6F2wrdrQOfXQxm9fE5sfyAQ3eIvoKFftWAMDCzYXjzcWnf++/Nc
         z0varQCE7xl/LkpB9caNyrKYZqwA/86piL7733i5OxIgZfnIgsXtxwZc8g13fhDBqC
         4XVuMXHYar2KSFUJIv8thIx7FwoxJ6pl9siv934s=
Date:   Mon, 09 Jan 2023 17:07:18 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-rename-selftets-vm-to-selftests-mm-fix.patch added to mm-unstable branch
Message-Id: <20230110010719.AB6F6C433F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: convert missing vm->mm changes
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-rename-selftets-vm-to-selftests-mm-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-rename-selftets-vm-to-selftests-mm-fix.patch

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
Subject: selftests/mm: convert missing vm->mm changes
Date: Sat, 7 Jan 2023 23:06:43 +0000

Commit 6b380799d251 ("selftests/vm: rename selftests/vm to selftests/mm")
in mm-unstable is missing some files that need to be updated for the
renaming.  This commit adds the changes.

Link: https://lkml.kernel.org/r/20230107230643.252273-1-sj@kernel.org
Fixes: 6b380799d251 ("selftests/vm: rename selftests/vm to selftests/mm") in mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile          |    2 +-
 tools/testing/selftests/kselftest_deps.sh |    6 +++---
 tools/testing/selftests/mm/Makefile       |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/kselftest_deps.sh~selftests-vm-rename-selftets-vm-to-selftests-mm-fix
+++ a/tools/testing/selftests/kselftest_deps.sh
@@ -12,9 +12,9 @@ usage()
 
 echo -e "Usage: $0 -[p] <compiler> [test_name]\n"
 echo -e "\tkselftest_deps.sh [-p] gcc"
-echo -e "\tkselftest_deps.sh [-p] gcc vm"
+echo -e "\tkselftest_deps.sh [-p] gcc mm"
 echo -e "\tkselftest_deps.sh [-p] aarch64-linux-gnu-gcc"
-echo -e "\tkselftest_deps.sh [-p] aarch64-linux-gnu-gcc vm\n"
+echo -e "\tkselftest_deps.sh [-p] aarch64-linux-gnu-gcc mm\n"
 echo "- Should be run in selftests directory in the kernel repo."
 echo "- Checks if Kselftests can be built/cross-built on a system."
 echo "- Parses all test/sub-test Makefile to find library dependencies."
@@ -120,7 +120,7 @@ l1_tests=$(grep -r --include=Makefile "^
 # Level 2
 # Some tests have multiple valid LDLIBS lines for individual sub-tests
 # that need dependency checks. Find them and append them to the tests
-# e.g: vm/Makefile:$(OUTPUT)/userfaultfd: LDLIBS += -lpthread
+# e.g: mm/Makefile:$(OUTPUT)/userfaultfd: LDLIBS += -lpthread
 # Filter out VAR_LDLIBS to discard the following:
 # 	memfd/Makefile:$(OUTPUT)/fuse_mnt: LDLIBS += $(VAR_LDLIBS)
 # Append space at the end of the list to append more tests.
--- a/tools/testing/selftests/Makefile~selftests-vm-rename-selftets-vm-to-selftests-mm-fix
+++ a/tools/testing/selftests/Makefile
@@ -85,7 +85,7 @@ TARGETS += tmpfs
 TARGETS += tpm2
 TARGETS += user
 TARGETS += vDSO
-TARGETS += vm
+TARGETS += mm
 TARGETS += x86
 TARGETS += zram
 #Please keep the TARGETS list alphabetically sorted
--- a/tools/testing/selftests/mm/Makefile~selftests-vm-rename-selftets-vm-to-selftests-mm-fix
+++ a/tools/testing/selftests/mm/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
-# Makefile for vm selftests
+# Makefile for mm selftests
 
-LOCAL_HDRS += $(selfdir)/vm/local_config.h $(top_srcdir)/mm/gup_test.h
+LOCAL_HDRS += $(selfdir)/mm/local_config.h $(top_srcdir)/mm/gup_test.h
 
 include local_config.mk
 
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
scripts-spelling-add-a-few-more-typos.patch

