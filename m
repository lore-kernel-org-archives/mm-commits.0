Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22046EE49B2
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjHUUjc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjHUUjV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906CE131
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 734FB64A7B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C008AC433C8;
        Mon, 21 Aug 2023 20:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650358;
        bh=GYNck1AfsfcdaS1dZsgsEzzv0xp/SrGCgMjcdm9mKfI=;
        h=Date:To:From:Subject:From;
        b=j7f98lo1lfP+NcHcNDQPFFiswL1sctxbOfMmXyatd+6VRm4OEkA9MDWEeNYiVi0PD
         h0dpIgb8Xa/6b3ygicoegFxuQaVgPyPO5v0bEzVzd2GiFdtjkm1idTZETEeuyocogJ
         jo8yjnZynWNrD7vTVEebZ0NV3YalKRzcKMoULUKM=
Date:   Mon, 21 Aug 2023 13:39:18 -0700
To:     mm-commits@vger.kernel.org, shr@devkernel.io, david@redhat.com,
        ayush.jain3@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-ksm_merge_time-tests.patch removed from -mm tree
Message-Id: <20230821203918.C008AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: mm: add KSM_MERGE_TIME tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-ksm_merge_time-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ayush Jain <ayush.jain3@amd.com>
Subject: selftests: mm: add KSM_MERGE_TIME tests
Date: Fri, 28 Jul 2023 22:11:02 +0530

Add KSM_MERGE_TIME and KSM_MERGE_TIME_HUGE_PAGES tests with
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


