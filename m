Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E36E94104
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbjJFTSG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjJFTSE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:18:04 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D3D83
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:18:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B827C433C8;
        Fri,  6 Oct 2023 19:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619879;
        bh=f6f1x3q1sgWs/e1VxvmTSGOcpM+VTW2JNa/JQSMJQKo=;
        h=Date:To:From:Subject:From;
        b=SR352iOjnBCLkzdXAKujKIqZCV2IRFZ7pFGhrxaKMKODE5b24Aiu8ST+aV/1AmkfU
         DRqGFF4niSilHiyJu5JFfpH7+kHewCSCYlZhSFb5QWntPykTQyBD714gk8RF+8Ampq
         HNtlVXJLTaICbouDIAGDTjtHM3CiFYzqoVyU9koY=
Date:   Fri, 06 Oct 2023 12:17:57 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-unify-printk-prefixes.patch added to mm-unstable branch
Message-Id: <20231006191759.8B827C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: unify printk prefixes
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-unify-printk-prefixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-unify-printk-prefixes.patch

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
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: unify printk prefixes
Date: Fri, 6 Oct 2023 17:18:43 +0200

Unify prefixes for printk messages in mm/kasan/.

Link: https://lkml.kernel.org/r/35589629806cf0840e5f01ec9d8011a7bad648df.1696605143.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test.c        |    2 +-
 mm/kasan/kasan_test_module.c |    2 +-
 mm/kasan/quarantine.c        |    4 +++-
 mm/kasan/report_generic.c    |    6 +++---
 4 files changed, 8 insertions(+), 6 deletions(-)

--- a/mm/kasan/kasan_test.c~kasan-unify-printk-prefixes
+++ a/mm/kasan/kasan_test.c
@@ -5,7 +5,7 @@
  * Author: Andrey Ryabinin <a.ryabinin@samsung.com>
  */
 
-#define pr_fmt(fmt) "kasan_test: " fmt
+#define pr_fmt(fmt) "kasan: test: " fmt
 
 #include <kunit/test.h>
 #include <linux/bitops.h>
--- a/mm/kasan/kasan_test_module.c~kasan-unify-printk-prefixes
+++ a/mm/kasan/kasan_test_module.c
@@ -5,7 +5,7 @@
  * Author: Andrey Ryabinin <a.ryabinin@samsung.com>
  */
 
-#define pr_fmt(fmt) "kasan test: %s " fmt, __func__
+#define pr_fmt(fmt) "kasan: test: " fmt
 
 #include <linux/mman.h>
 #include <linux/module.h>
--- a/mm/kasan/quarantine.c~kasan-unify-printk-prefixes
+++ a/mm/kasan/quarantine.c
@@ -8,6 +8,8 @@
  * Based on code by Dmitry Chernenkov.
  */
 
+#define pr_fmt(fmt) "kasan: " fmt
+
 #include <linux/gfp.h>
 #include <linux/hash.h>
 #include <linux/kernel.h>
@@ -414,7 +416,7 @@ static int __init kasan_cpu_quarantine_i
 	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "mm/kasan:online",
 				kasan_cpu_online, kasan_cpu_offline);
 	if (ret < 0)
-		pr_err("kasan cpu quarantine register failed [%d]\n", ret);
+		pr_err("cpu quarantine register failed [%d]\n", ret);
 	return ret;
 }
 late_initcall(kasan_cpu_quarantine_init);
--- a/mm/kasan/report_generic.c~kasan-unify-printk-prefixes
+++ a/mm/kasan/report_generic.c
@@ -220,7 +220,7 @@ static bool __must_check tokenize_frame_
 		const size_t tok_len = sep - *frame_descr;
 
 		if (tok_len + 1 > max_tok_len) {
-			pr_err("KASAN internal error: frame description too long: %s\n",
+			pr_err("internal error: frame description too long: %s\n",
 			       *frame_descr);
 			return false;
 		}
@@ -233,7 +233,7 @@ static bool __must_check tokenize_frame_
 	*frame_descr = sep + 1;
 
 	if (value != NULL && kstrtoul(token, 10, value)) {
-		pr_err("KASAN internal error: not a valid number: %s\n", token);
+		pr_err("internal error: not a valid number: %s\n", token);
 		return false;
 	}
 
@@ -323,7 +323,7 @@ static bool __must_check get_address_sta
 
 	frame = (const unsigned long *)(mem_ptr + KASAN_GRANULE_SIZE);
 	if (frame[0] != KASAN_CURRENT_STACK_FRAME_MAGIC) {
-		pr_err("KASAN internal error: frame info validation failed; invalid marker: %lu\n",
+		pr_err("internal error: frame has invalid marker: %lu\n",
 		       frame[0]);
 		return false;
 	}
_

Patches currently in -mm which might be from andreyknvl@google.com are

arm64-kasan-update-comment-in-kasan_init.patch
kasan-unify-printk-prefixes.patch
kasan-use-unchecked-__memset-internally.patch
kasan-fix-and-update-kunit_expect_kasan_fail-comment.patch
documentation-san-drop-the-from-article-titles.patch

