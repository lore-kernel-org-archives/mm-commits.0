Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0213AC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 00:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345991AbiCYAew (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 20:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353962AbiCYAeu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 20:34:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45943D7B
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 17:33:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDE72B826A1
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 00:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AB1C340EC;
        Fri, 25 Mar 2022 00:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648168393;
        bh=+9e6LQLHcvj6gWQJ+NRV1zNzkegR6LJndHwklClxlSs=;
        h=Date:To:From:Subject:From;
        b=tBqKtwg9IyScL56g0QFV8GW3pQm7k2l5yBOgIgL2Sv91iFzr4UGAo1dDD8anR7V/8
         TFX7r32VsjpkynGFFFl2rLXQausI/Tm7p8A0IOXiejNLpWYJFiTrEcpFLiro4kJs9f
         AT8LcqgrK5fb0D+6m6XtcmjyLlig31RWDDG4MMR0=
Date:   Thu, 24 Mar 2022 17:33:12 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, elver@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-improve-vmalloc-tests-fix-3-fix.patch removed from -mm tree
Message-Id: <20220325003313.65AB1C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-improve-vmalloc-tests-fix-3-fix
has been removed from the -mm tree.  Its filename was
     kasan-improve-vmalloc-tests-fix-3-fix.patch

This patch was dropped because it was folded into kasan-improve-vmalloc-tests.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-improve-vmalloc-tests-fix-3-fix

fix build

lib/test_kasan.c: In function 'vmalloc_helpers_tags':
lib/test_kasan.c:1073:13: error: unused variable 'rv' [-Werror=unused-variable]
 1073 |         int rv;
      |             ^~
cc1: all warnings being treated as errors

Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/lib/test_kasan.c~kasan-improve-vmalloc-tests-fix-3-fix
+++ a/lib/test_kasan.c
@@ -1066,7 +1066,6 @@ static void kmalloc_double_kzfree(struct
 static void vmalloc_helpers_tags(struct kunit *test)
 {
 	void *ptr;
-	int rv;
 
 	/* This test is intended for tag-based modes. */
 	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_GENERIC);
@@ -1085,11 +1084,15 @@ static void vmalloc_helpers_tags(struct
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, vmalloc_to_page(ptr));
 
 #if !IS_MODULE(CONFIG_KASAN_KUNIT_TEST)
-	/* Make sure vmalloc'ed memory permissions can be changed. */
-	rv = set_memory_ro((unsigned long)ptr, 1);
-	KUNIT_ASSERT_GE(test, rv, 0);
-	rv = set_memory_rw((unsigned long)ptr, 1);
-	KUNIT_ASSERT_GE(test, rv, 0);
+	{
+		int rv;
+
+		/* Make sure vmalloc'ed memory permissions can be changed. */
+		rv = set_memory_ro((unsigned long)ptr, 1);
+		KUNIT_ASSERT_GE(test, rv, 0);
+		rv = set_memory_rw((unsigned long)ptr, 1);
+		KUNIT_ASSERT_GE(test, rv, 0);
+	}
 #endif
 
 	vfree(ptr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-improve-vmalloc-tests.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

