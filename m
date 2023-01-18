Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0760EC678DF
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 23:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjARXxJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjARXwy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 18:52:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB7A4ABCC
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 15:52:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF56AB81F6C
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 23:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7564BC433EF;
        Wed, 18 Jan 2023 23:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674085938;
        bh=CcjgCaItjEHUYt0kqaBhP5rVuIGvz+9WQ6k8FRgaTDM=;
        h=Date:To:From:Subject:From;
        b=dk7nLHvt4CM7HAdqnfQG5o6oPVRa1hSAF5e6qqxRqgPpcuJh/pWoBPK5LHrtZwLSO
         +LM40Ch/TjUIqGX8dqEJBPjTFZj6XJfF/aLcbwePCEzZa8IguG5gR7L/dr636sCIXu
         hFWb80/V2x6Ehc1PgJSXWPVR/1yCbe9ge+GDn+50=
Date:   Wed, 18 Jan 2023 15:52:17 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-sysfs-schemes-implement-scheme-filters-fix.patch removed from -mm tree
Message-Id: <20230118235218.7564BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: Fix leaking a filter for wrong cgroup path
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-scheme-filters-fix.patch

This patch was dropped because it was folded into mm-damon-sysfs-schemes-implement-scheme-filters.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: Fix leaking a filter for wrong cgroup path
Date: Mon, 19 Dec 2022 17:18:06 +0000

Commit f36f860207efa ("mm/damon/sysfs-schemes: implement scheme filters")
on mm-unstable introduced 'damon_syfs_set_scheme_filters()', which does
not free newly allocated filter when it fails setting memcg id for the
filter.  As a result, the memory for the filter leaks.  Fix it by freeing
the filter before returning the error.

Coverity CID: 1530032

Link: https://lkml.kernel.org/r/20221219171807.55708-2-sj@kernel.org
Fixes: f36f860207ef ("mm/damon/sysfs-schemes: implement scheme filters") on mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-scheme-filters-fix
+++ a/mm/damon/sysfs-schemes.c
@@ -1464,8 +1464,10 @@ static int damon_sysfs_set_scheme_filter
 			err = damon_sysfs_memcg_path_to_id(
 					sysfs_filter->memcg_path,
 					&filter->memcg_id);
-			if (err)
+			if (err) {
+				damos_destroy_filter(filter);
 				return err;
+			}
 		}
 		damos_add_filter(scheme, filter);
 	}
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

