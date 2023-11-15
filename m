Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B789FC2BB3F
	for <mm-commits@archiver.kernel.org>; Wed, 15 Nov 2023 23:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbjKOXaz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Nov 2023 18:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjKOXat (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2023 18:30:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323E5196
        for <mm-commits@vger.kernel.org>; Wed, 15 Nov 2023 15:30:46 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54FFC433C9;
        Wed, 15 Nov 2023 23:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700091045;
        bh=V8uyEHQLqB6qVWp7GXNY5cxMQoexYj3ghc3fMHnK+bQ=;
        h=Date:To:From:Subject:From;
        b=OYzPVD6ScY6jUpi5y9kJQ1jdsHl2h3uvxY7ZViyE9+NB4Lj2a6XjkTvzNp/fR4SCJ
         5KU4xtHFmCGONdXESNGTyWJxjJGId4RrdcyV6K0mibJm0nZteonBrWKE/EJjCa3OnG
         JB+/sdYBzSjeVcumtB8qlZHhFZz3DC96DykEF9uE=
Date:   Wed, 15 Nov 2023 15:30:45 -0800
To:     mm-commits@vger.kernel.org, ryan.roberts@arm.com,
        leitao@debian.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-restore-number-of-hugepages.patch removed from -mm tree
Message-Id: <20231115233045.B54FFC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: restore number of hugepages
has been removed from the -mm tree.  Its filename was
     selftests-mm-restore-number-of-hugepages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: selftests/mm: restore number of hugepages
Date: Fri, 3 Nov 2023 10:33:59 -0700

The test mm `hugetlb_fault_after_madv` selftest needs one and only one
huge page to run, thus it sets `/proc/sys/vm/nr_hugepages` to 1.

The problem is that further tests require the previous number of hugepages
allocated in order to succeed.

Save the number of huge pages before changing it, and restore it once the
test finishes, so, further tests could run successfully.

Link: https://lkml.kernel.org/r/20231103173400.1608403-1-leitao@debian.org
Fixes: 116d57303a05 ("selftests/mm: add a new test for madv and hugetlb")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lore.kernel.org/all/662df57e-47f1-4c15-9b84-f2f2d587fc5c@arm.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-restore-number-of-hugepages
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -223,9 +223,12 @@ CATEGORY="hugetlb" run_test ./hugepage-m
 CATEGORY="hugetlb" run_test ./hugepage-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
 
+nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
 # For this test, we need one and just one huge page
 echo 1 > /proc/sys/vm/nr_hugepages
 CATEGORY="hugetlb" run_test ./hugetlb_fault_after_madv
+# Restore the previous number of huge pages, since further tests rely on it
+echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
 
 if test_selected "hugetlb"; then
 	echo "NOTE: These hugetlb tests provide minimal coverage.  Use"
_

Patches currently in -mm which might be from leitao@debian.org are


