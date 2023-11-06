Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9146C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 16:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjKFQ3j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 11:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjKFQ3j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 11:29:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F314A4
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 08:29:36 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DF9C433C7;
        Mon,  6 Nov 2023 16:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699288176;
        bh=UTX7W9hdPreXTx1h1H3o4Aw6qPXTKQofj81uEUAPWk8=;
        h=Date:To:From:Subject:From;
        b=MRy7UCfjs/OZyCxDGBkaAHDiqxYr5DNpKHVe1WmdI5yFDqkTnsxYZJyhqUef6MTGE
         3bAC8u3DR2z8vnUMD/0WaJXg6GjmzADG3ysgDY5OBFZmovDxDxxeFsx2wvV4+e6GRO
         h59rb/WGKiUKyiKM1tL5nmnp3IKeR5k010p8U7Cs=
Date:   Mon, 06 Nov 2023 08:29:35 -0800
To:     mm-commits@vger.kernel.org, ryan.roberts@arm.com,
        leitao@debian.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-restore-number-of-hugepages.patch added to mm-hotfixes-unstable branch
Message-Id: <20231106162936.06DF9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: restore number of hugepages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-restore-number-of-hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-restore-number-of-hugepages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

selftests-mm-restore-number-of-hugepages.patch
selftests-mm-add-hugetlb_fault_after_madv-to-gitignore.patch

