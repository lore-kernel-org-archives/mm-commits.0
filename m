Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6A8C77B72
	for <mm-commits@archiver.kernel.org>; Fri, 14 Apr 2023 20:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjDNUwM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Apr 2023 16:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjDNUwI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Apr 2023 16:52:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DD930D8
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 13:52:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1FD4649BC
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 20:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C935C433D2;
        Fri, 14 Apr 2023 20:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681505526;
        bh=2grcerjUWccXCyt1xNPNaj3nTZP6zH/0/cl9HmPFYEg=;
        h=Date:To:From:Subject:From;
        b=H6R18mh0cJbj0mG03Pf07JEepF1XKM4AN7kfmewEijFU6QA6Z1tHCK2BXJJU33H1d
         uY0cmzlIOpdY/CDowP1I6/tXqKYFEbrkdF/RpU7eL6JJzvzEINGgyGCwkS9Hm7w2oK
         GGlb1G6EzhVieeiO926UaJb+QosD8kvYV0t5MbaY=
Date:   Fri, 14 Apr 2023 13:52:05 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, mark.rutland@arm.com,
        kirill.shutemov@linux.intel.com, aneesh.kumar@linux.ibm.com,
        chaitanyas.prakash@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-platform-independent-in-code-comments.patch added to mm-unstable branch
Message-Id: <20230414205206.3C935C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: add platform independent in code comments
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-platform-independent-in-code-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-platform-independent-in-code-comments.patch

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
From: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Subject: selftests/mm: add platform independent in code comments
Date: Thu, 23 Mar 2023 16:22:41 +0530

The in code comments for the selftest were made on the basis of 128TB
switch, an architecture feature specific to PowerPc and x86 platforms. 
Keeping in mind the support added for arm64 platforms which implements a
256TB switch, a more generic explanation has been provided.

Link: https://lkml.kernel.org/r/20230323105243.2807166-4-chaitanyas.prakash@arm.com
Signed-off-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.c |   15 ++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.c~selftests-mm-add-platform-independent-in-code-comments
+++ a/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -30,8 +30,8 @@
 #endif
 
 /*
- * >= 128TB is the hint addr value we used to select
- * large address space.
+ * The hint addr value is used to allocate addresses
+ * beyond the high address switch boundary.
  */
 
 #define ADDR_MARK_128TB	(1UL << 47)
@@ -73,9 +73,10 @@ static struct testcase testcases[] = {
 	},
 	{
 		/*
-		 * We should never allocate at the requested address or above it
-		 * The len cross the 128TB boundary. Without MAP_FIXED
-		 * we will always search in the lower address space.
+		 * Unless MAP_FIXED is specified, allocation based on hint
+		 * addr is never at requested address or above it, which is
+		 * beyond high address switch boundary in this case. Instead,
+		 * a suitable allocation is found in lower address space.
 		 */
 		.addr = ((void *)(ADDR_SWITCH_HINT - PAGE_SIZE)),
 		.size = 2 * PAGE_SIZE,
@@ -85,8 +86,8 @@ static struct testcase testcases[] = {
 	},
 	{
 		/*
-		 * Exact mapping at 128TB, the area is free we should get that
-		 * even without MAP_FIXED.
+		 * Exact mapping at high address switch boundary, should
+		 * be obtained even without MAP_FIXED as area is free.
 		 */
 		.addr = ((void *)(ADDR_SWITCH_HINT)),
 		.size = PAGE_SIZE,
_

Patches currently in -mm which might be from chaitanyas.prakash@arm.com are

selftests-mm-add-support-for-arm64-platform-on-va-switch.patch
selftests-mm-rename-va_128tbswitch-to-va_high_addr_switch.patch
selftests-mm-add-platform-independent-in-code-comments.patch
selftests-mm-configure-nr_hugepages-for-arm64.patch
selftests-mm-run-hugetlb-testcases-of-va-switch.patch

