Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C6FC07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C29E61CCC
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhGHBKL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhGHBKL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:10:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AB5461C77;
        Thu,  8 Jul 2021 01:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706449;
        bh=znrF2+WRfwrMCK9Ncbe8FPEdGuvrJvlO6GHoufEIyL4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jmabpG5sSHmPrmSrWnkioiBKX2AROYB6vapEAUbmp7ybjcKGZYZEJ1lMI5SzMXSXi
         P8kmsHMvdiTnKlalMebaJPKaLLroAKKjxU1W12QPD0stbLxP5b6hLM4RI7+ZBTO9S7
         3abwH+1IadPjJiQACSUS6GqcLqbdXytc1DJdzVbg=
Date:   Wed, 07 Jul 2021 18:07:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        torvalds@linux-foundation.org, yhs@fb.com
Subject:  [patch 01/54] lib/test: fix spelling mistakes
Message-ID: <20210708010728.HstovChwR%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: lib/test: fix spelling mistakes

Fix some spelling mistakes in comments found by "codespell":
thats ==> that's
unitialized ==> uninitialized
panicing ==> panicking
sucess ==> success
possitive ==> positive
intepreted ==> interpreted

Link: https://lkml.kernel.org/r/20210607133036.12525-2-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Yonghong Song <yhs@fb.com>	[test_bfp.c]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitops.c |    2 +-
 lib/test_bpf.c    |    2 +-
 lib/test_kasan.c  |    2 +-
 lib/test_kmod.c   |    6 +++---
 lib/test_scanf.c  |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

--- a/lib/test_bitops.c~lib-test-fix-spelling-mistakes
+++ a/lib/test_bitops.c
@@ -15,7 +15,7 @@
  *   get_count_order/long
  */
 
-/* use an enum because thats the most common BITMAP usage */
+/* use an enum because that's the most common BITMAP usage */
 enum bitops_fun {
 	BITOPS_4 = 4,
 	BITOPS_7 = 7,
--- a/lib/test_bpf.c~lib-test-fix-spelling-mistakes
+++ a/lib/test_bpf.c
@@ -1095,7 +1095,7 @@ static struct bpf_test tests[] = {
 	{
 		"RET_A",
 		.u.insns = {
-			/* check that unitialized X and A contain zeros */
+			/* check that uninitialized X and A contain zeros */
 			BPF_STMT(BPF_MISC | BPF_TXA, 0),
 			BPF_STMT(BPF_RET | BPF_A, 0)
 		},
--- a/lib/test_kasan.c~lib-test-fix-spelling-mistakes
+++ a/lib/test_kasan.c
@@ -651,7 +651,7 @@ static void kasan_global_oob(struct kuni
 {
 	/*
 	 * Deliberate out-of-bounds access. To prevent CONFIG_UBSAN_LOCAL_BOUNDS
-	 * from failing here and panicing the kernel, access the array via a
+	 * from failing here and panicking the kernel, access the array via a
 	 * volatile pointer, which will prevent the compiler from being able to
 	 * determine the array bounds.
 	 *
--- a/lib/test_kmod.c~lib-test-fix-spelling-mistakes
+++ a/lib/test_kmod.c
@@ -286,7 +286,7 @@ static int tally_work_test(struct kmod_t
  * If this ran it means *all* tasks were created fine and we
  * are now just collecting results.
  *
- * Only propagate errors, do not override with a subsequent sucess case.
+ * Only propagate errors, do not override with a subsequent success case.
  */
 static void tally_up_work(struct kmod_test_device *test_dev)
 {
@@ -543,7 +543,7 @@ static int trigger_config_run(struct kmo
 	 * wrong with the setup of the test. If the test setup went fine
 	 * then userspace must just check the result of config->test_result.
 	 * One issue with relying on the return from a call in the kernel
-	 * is if the kernel returns a possitive value using this trigger
+	 * is if the kernel returns a positive value using this trigger
 	 * will not return the value to userspace, it would be lost.
 	 *
 	 * By not relying on capturing the return value of tests we are using
@@ -585,7 +585,7 @@ trigger_config_store(struct device *dev,
 	 * Note: any return > 0 will be treated as success
 	 * and the error value will not be available to userspace.
 	 * Do not rely on trying to send to userspace a test value
-	 * return value as possitive return errors will be lost.
+	 * return value as positive return errors will be lost.
 	 */
 	if (WARN_ON(ret > 0))
 		return -EINVAL;
--- a/lib/test_scanf.c~lib-test-fix-spelling-mistakes
+++ a/lib/test_scanf.c
@@ -600,7 +600,7 @@ static void __init numbers_prefix_overfl
 	/*
 	 * 0x prefix in a field of width 2 using %i conversion: first field
 	 * converts to 0. Next field scan starts at the character after "0x",
-	 * which will convert if can be intepreted as decimal but will fail
+	 * which will convert if can be interpreted as decimal but will fail
 	 * if it contains any hex digits (since no 0x prefix).
 	 */
 	test_number_prefix(long long,	"0x67", "%2lli%lli", 0, 67, 2, check_ll);
_
