Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C3CC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjASBRN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjASBPb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C0669B14
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A8CD61B0B
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CDDC433D2;
        Thu, 19 Jan 2023 01:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090880;
        bh=gvj5VaDvf6lH+NLctqO8J9DHHzTsY7Myh2m6JIEoZWU=;
        h=Date:To:From:Subject:From;
        b=i9PCiAznRipzgsORmin74PP+/NrKmd/KIGciwx8Hm9Vn2js9uSPu8ZsrKYvxcRCb6
         O3Ho4Ac6NUfEf/Ffd+XmuyoSCYmxMqyjy0/F7fOvGz/J9gD3TFFdwT0g24TxS9QLcG
         wF+MMDlpG4XT20eMtY3uC8gClvVkBvw51f1uBy/8=
Date:   Wed, 18 Jan 2023 17:14:40 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfs-test-filters-directory.patch removed from -mm tree
Message-Id: <20230119011440.85CDDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/damon/sysfs: test filters directory
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfs-test-filters-directory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs: test filters directory
Date: Mon, 5 Dec 2022 23:08:28 +0000

Add simple test cases for scheme filters of DAMON sysfs interface.  The
test cases check if the files are populated as expected, receives some
valid inputs, and refuses some invalid inputs.

Link: https://lkml.kernel.org/r/20221205230830.144349-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |   29 +++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-sysfs-test-filters-directory
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -96,6 +96,34 @@ test_stats()
 	done
 }
 
+test_filter()
+{
+	filter_dir=$1
+	ensure_file "$filter_dir/type" "exist" "600"
+	ensure_write_succ "$filter_dir/type" "anon" "valid input"
+	ensure_write_succ "$filter_dir/type" "memcg" "valid input"
+	ensure_write_fail "$filter_dir/type" "foo" "invalid input"
+	ensure_file "$filter_dir/matching" "exist" "600"
+	ensure_file "$filter_dir/memcg_path" "exist" "600"
+}
+
+test_filters()
+{
+	filters_dir=$1
+	ensure_dir "$filters_dir" "exist"
+	ensure_file "$filters_dir/nr_filters" "exist" "600"
+	ensure_write_succ  "$filters_dir/nr_filters" "1" "valid input"
+	test_filter "$filters_dir/0"
+
+	ensure_write_succ  "$filters_dir/nr_filters" "2" "valid input"
+	test_filter "$filters_dir/0"
+	test_filter "$filters_dir/1"
+
+	ensure_write_succ "$filters_dir/nr_filters" "0" "valid input"
+	ensure_dir "$filters_dir/0" "not_exist"
+	ensure_dir "$filters_dir/1" "not_exist"
+}
+
 test_watermarks()
 {
 	watermarks_dir=$1
@@ -143,6 +171,7 @@ test_scheme()
 	test_access_pattern "$scheme_dir/access_pattern"
 	test_quotas "$scheme_dir/quotas"
 	test_watermarks "$scheme_dir/watermarks"
+	test_filters "$scheme_dir/filters"
 	test_stats "$scheme_dir/stats"
 	test_tried_regions "$scheme_dir/tried_regions"
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
scripts-spelling-add-a-few-more-typos.patch

