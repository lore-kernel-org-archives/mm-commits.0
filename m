Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CEBC677F1
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 23:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjARX6s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjARX6Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 18:58:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C52A69B08
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 15:57:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59088B81FA0
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 23:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF000C433D2;
        Wed, 18 Jan 2023 23:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674086237;
        bh=duMWzHo0xeCW/ijOyH99JPs3Se7Rts6mqe0HAlPO1oI=;
        h=Date:To:From:Subject:From;
        b=1OLrVbKrZWBVk4GhtWz4nkk6LsVDkxBMr5P56PQserALIbcKd8iFbUAJGThiz30/P
         vkfsCRgk9lLWpxmib4s6WToLK3OOnz7qxt4RTynYgjj2Yetagx5CZNffOmHmunUMBF
         HD4tcRB2J2QhTzp1uJvnC4Kif439+zZFvMjVnpgU=
Date:   Wed, 18 Jan 2023 15:57:16 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-vm-rename-selftets-vm-to-selftests-mm-fix.patch removed from -mm tree
Message-Id: <20230118235716.EF000C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: convert missing vm->mm changes
has been removed from the -mm tree.  Its filename was
     selftests-vm-rename-selftets-vm-to-selftests-mm-fix.patch

This patch was dropped because it was folded into selftests-vm-rename-selftets-vm-to-selftests-mm.patch

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

mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch
mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected.patch
maintainers-add-types-to-akpm-mm-git-trees-entries.patch
maintainers-memory-management-add-tools-vm-as-managed-files.patch
tools-vm-rename-tools-vm-to-tools-mm.patch
selftests-vm-rename-selftets-vm-to-selftests-mm.patch
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

