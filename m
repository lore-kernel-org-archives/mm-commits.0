Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28EE7C54EBC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 22:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbjAJWqZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 17:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234634AbjAJWll (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 17:41:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1975EC04
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 14:41:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76C06B81889
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 22:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D1FC433EF;
        Tue, 10 Jan 2023 22:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673390496;
        bh=VtCk6i2v3MQI+4fS4igQ2ThYWhxk5rBWP0WEpqS8y48=;
        h=Date:To:From:Subject:From;
        b=abXI2vU8fEI94Nju2lHgmd3tsLT+yReeykcn6bHsKIqE8F+NUjfJ5ybrahnEo4hh6
         Gn14SXKqndtq/Uq37G1BivWG9i3UMWQkfMwpECMZCmylaJJgospy6V9eJtCWWM9j1P
         ygWqNKgoBOykKfyfy2xgq0nC8L7QSfU9cS7qM2Mk=
Date:   Tue, 10 Jan 2023 14:41:35 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfs-hide-expected-write-failures.patch added to mm-unstable branch
Message-Id: <20230110224136.25D1FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon/sysfs: hide expected write failures
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-sysfs-hide-expected-write-failures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfs-hide-expected-write-failures.patch

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
Subject: selftests/damon/sysfs: hide expected write failures
Date: Tue, 10 Jan 2023 19:03:59 +0000

DAMON selftests for sysfs (sysfs.sh) tests if some writes to DAMON sysfs
interface files fails as expected.  It makes the test results noisy with
the failure error message because it tests a number of such failures. 
Redirect the expected failure error messages to /dev/null to make the
results clean.

Link: https://lkml.kernel.org/r/20230110190400.119388-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-sysfs-hide-expected-write-failures
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -24,7 +24,7 @@ ensure_write_fail()
 	content=$2
 	reason=$3
 
-	if echo "$content" > "$file"
+	if (echo "$content" > "$file") 2> /dev/null
 	then
 		echo "writing $content to $file succeed ($fail_reason)"
 		echo "expected failure because $reason"
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

