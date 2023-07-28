Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FC3C0015E
	for <mm-commits@archiver.kernel.org>; Fri, 28 Jul 2023 17:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjG1RTr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jul 2023 13:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjG1RTq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2023 13:19:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB6830D4
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 10:19:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69F85621AD
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 17:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C191AC433C8;
        Fri, 28 Jul 2023 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690564784;
        bh=21cZP4LJkaqv36HlAr5yKa8oL7rEmUtNMijdDueDw0U=;
        h=Date:To:From:Subject:From;
        b=m1pPguXQDnFiOc669DjfQ3F6UzE2LyFUKlWrsHC0Dg5f3TfvYK9OKqcyKNeX3oiFG
         0EoeR46dk9eC7VuBtymZjDsPy9BDgEl+kcv0kNFsiv/KGQlT+n0bl/fz97rkyeXHgL
         xj/dqy8VUDYYkaluyuq/FpsePlJFG/eKaSK/6tdg=
Date:   Fri, 28 Jul 2023 10:19:44 -0700
To:     mm-commits@vger.kernel.org, shr@devkernel.io, david@redhat.com,
        ayush.jain3@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-ksm_merge_time-tests.patch added to mm-unstable branch
Message-Id: <20230728171944.C191AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: mm: add KSM_MERGE_TIME tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-ksm_merge_time-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-ksm_merge_time-tests.patch

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
From: Ayush Jain <ayush.jain3@amd.com>
Subject: selftests: mm: add KSM_MERGE_TIME tests
Date: Fri, 28 Jul 2023 22:11:02 +0530

add KSM_MERGE_TIME and KSM_MERGE_TIME_HUGE_PAGES tests with
size of 100.

./run_vmtests.sh -t ksm
-----------------------------
running ./ksm_tests -H -s 100
-----------------------------
Number of normal pages:    0
Number of huge pages:    50
Total size:    100 MiB
Total time:    0.399844662 s
Average speed:  250.097 MiB/s
[PASS]
-----------------------------
running ./ksm_tests -P -s 100
-----------------------------
Total size:    100 MiB
Total time:    0.451931496 s
Average speed:  221.272 MiB/s
[PASS]

Link: https://lkml.kernel.org/r/20230728164102.4655-1-ayush.jain3@amd.com
Signed-off-by: Ayush Jain <ayush.jain3@amd.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-add-ksm_merge_time-tests
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -305,6 +305,10 @@ CATEGORY="madv_populate" run_test ./madv
 
 CATEGORY="memfd_secret" run_test ./memfd_secret
 
+# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
+CATEGORY="ksm" run_test ./ksm_tests -H -s 100
+# KSM KSM_MERGE_TIME test with size of 100
+CATEGORY="ksm" run_test ./ksm_tests -P -s 100
 # KSM MADV_MERGEABLE test with 10 identical pages
 CATEGORY="ksm" run_test ./ksm_tests -M -p 10
 # KSM unmerge test
_

Patches currently in -mm which might be from ayush.jain3@amd.com are

selftests-mm-ksm-fix-incorrect-evaluation-of-parameter.patch
selftests-mm-add-ksm_merge_time-tests.patch

