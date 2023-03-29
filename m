Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A1DC74A5B
	for <mm-commits@archiver.kernel.org>; Wed, 29 Mar 2023 20:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjC2UWF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjC2UV7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2023 16:21:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DDF61AD
        for <mm-commits@vger.kernel.org>; Wed, 29 Mar 2023 13:21:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6C76B8235A
        for <mm-commits@vger.kernel.org>; Wed, 29 Mar 2023 20:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4938DC433D2;
        Wed, 29 Mar 2023 20:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680121315;
        bh=d8yk1sOBtdAEfNv/VCS1m/+XuykEiQf7R8afoF+5ILI=;
        h=Date:To:From:Subject:From;
        b=do30B3wcn8kYOV31vy954Vg749qW2jP+aWDbqxS/luzm69ANa5u3fwl1GVpnsnxme
         IMrAAEsdz0nl94SxqG5bA+TqixFxM6VTq5LrbKQ/AenH0pSw6uE0MuKS7PHdocVfDh
         MCl5M6d034mbekRaEtk3yAssVAb0DHQNSyYDJCCI=
Date:   Wed, 29 Mar 2023 13:21:54 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        ouyangweizhao@zeku.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-suppress-recursive-reports-for-hw_tags-v2.patch added to mm-unstable branch
Message-Id: <20230329202155.4938DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: suppress recursive reports for HW_TAGS
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-suppress-recursive-reports-for-hw_tags-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-suppress-recursive-reports-for-hw_tags-v2.patch

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
Subject: kasan: suppress recursive reports for HW_TAGS
Date: Wed, 29 Mar 2023 20:37:48 +0200

disable preemption instead of migration, fix comment typo

Link: https://lkml.kernel.org/r/d14417c8bc5eea7589e99381203432f15c0f9138.1680114854.git.andreyknvl@google.com
Fixes: 2e903b914797 ("kasan, arm64: implement HW_TAGS runtime")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: Weizhao Ouyang <ouyangweizhao@zeku.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/kasan/report.c~kasan-suppress-recursive-reports-for-hw_tags-v2
+++ a/mm/kasan/report.c
@@ -81,7 +81,7 @@ __setup("kasan_multi_shot", kasan_set_mu
  *
  * Hardware Tag-Based KASAN instead relies on:
  * For #1: Resetting tags via kasan_reset_tag().
- * For #2: Supression of tag checks via CPU, see report_suppress_start/end().
+ * For #2: Suppression of tag checks via CPU, see report_suppress_start/end().
  */
 static bool report_suppressed_sw(void)
 {
@@ -96,10 +96,10 @@ static void report_suppress_start(void)
 {
 #ifdef CONFIG_KASAN_HW_TAGS
 	/*
-	 * Disable migration for the duration of printing a KASAN report, as
+	 * Disable preemption for the duration of printing a KASAN report, as
 	 * hw_suppress_tag_checks_start() disables checks on the current CPU.
 	 */
-	migrate_disable();
+	preempt_disable();
 	hw_suppress_tag_checks_start();
 #else
 	kasan_disable_current();
@@ -110,7 +110,7 @@ static void report_suppress_stop(void)
 {
 #ifdef CONFIG_KASAN_HW_TAGS
 	hw_suppress_tag_checks_stop();
-	migrate_enable();
+	preempt_enable();
 #else
 	kasan_enable_current();
 #endif
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-drop-empty-tagging-related-defines.patch
kasan-arm64-rename-tagging-related-routines.patch
arm64-mte-rename-tco-routines-v2.patch
kasan-arm64-add-arch_suppress_tag_checks_start-stop.patch
kasan-arm64-add-arch_suppress_tag_checks_start-stop-v2.patch
kasan-suppress-recursive-reports-for-hw_tags.patch
kasan-suppress-recursive-reports-for-hw_tags-v2.patch
kcov-improve-documentation.patch
kcov-improve-documentation-v2.patch
kcov-improve-documentation-v3.patch

