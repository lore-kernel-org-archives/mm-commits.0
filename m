Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE314C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjDRXjO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbjDRXhT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:37:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37A0AF25
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:36:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA14D60244
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1036EC433EF;
        Tue, 18 Apr 2023 23:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860960;
        bh=pYo5DSOtKRuPBfAkbzV7tDfCWuGLg4dgV63YdfdVNx8=;
        h=Date:To:From:Subject:From;
        b=ne5ezeP/4XkbB7/K04OqY4SAud+98yqVFlXxc98+aNLbEKenqyfw44GP/WmSgN/5O
         RePqGK63i4SYOP2CltM6L4NHHXu/n2ypYy6zIrT8AaiPo9sWeXip1DzuRtaoYsQiic
         gcBFNBwbkk2lCS+FOqSegopiI/W+aq2Oj1PU3tmo=
Date:   Tue, 18 Apr 2023 16:35:59 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, mark.rutland@arm.com,
        kirill.shutemov@linux.intel.com, aneesh.kumar@linux.ibm.com,
        chaitanyas.prakash@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-platform-independent-in-code-comments.patch removed from -mm tree
Message-Id: <20230418233600.1036EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: add platform independent in code comments
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-platform-independent-in-code-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-configure-nr_hugepages-for-arm64.patch
selftests-mm-run-hugetlb-testcases-of-va-switch.patch

