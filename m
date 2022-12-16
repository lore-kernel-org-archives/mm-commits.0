Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2EEC3DA6E
	for <mm-commits@archiver.kernel.org>; Sat, 17 Dec 2022 00:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiLQAAG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 19:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiLPX7t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 18:59:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FD073320
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 15:59:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4091622BF
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 23:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06ADCC433EF;
        Fri, 16 Dec 2022 23:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671235187;
        bh=HpSo/ZG2dDYJHhwe59RDyi6eVjIDIFu6M5eDmPPCJf8=;
        h=Date:To:From:Subject:From;
        b=o3UFQKYCZbQhYgslslv1S+5JF04v4p7EmM2XuGff7CkTr1jhL0mvrgmZFnBN3xAcq
         UF7jU47TzbWA+eVDs7fV+NS8mmJ2EXdcnSKT5Z6MB7/xUvirDmGUxEZQr6AgvXQ6MM
         6aWu4STaeHr9bUZ7h+D7jY/Li1Yy/m1xCutwzfnw=
Date:   Fri, 16 Dec 2022 15:59:46 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfs-test-filters-directory.patch added to mm-unstable branch
Message-Id: <20221216235947.06ADCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon/sysfs: test filters directory
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-sysfs-test-filters-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfs-test-filters-directory.patch

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

