Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18F0C47081
	for <mm-commits@archiver.kernel.org>; Tue,  8 Feb 2022 22:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387650AbiBHWZ7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386464AbiBHUgJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2022 15:36:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCD9C0612C0
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 12:36:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CF916160D
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 20:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13B2C004E1;
        Tue,  8 Feb 2022 20:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644352567;
        bh=tsBuy0E3r+Ynq1g124tOPsGG1RrW7gM/1SUkQUGwnkg=;
        h=Date:To:From:Subject:From;
        b=D+m5JB6h83/njTaZoCFcD61qVBtY54aibZ7XXSPEKLazlGcnS7IKhtx1FWx+GiFZU
         RtY6n1biPiMeKqsylAUDhIUbAEEFdx+ciHg9GKppYWLRaV7VkTsEUBp1ZrIk7EwdwV
         QoEVj9h1LyVCNxBqZgCagRWYJplYGlNv+LlaGTK8=
Date:   Tue, 08 Feb 2022 12:36:07 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        lixuefeng@loongson.cn, elver@google.com, corbet@lwn.net,
        bhe@redhat.com, yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-no-need-to-unset-panic_on_warn-in-end_report.patch added to -mm tree
Message-Id: <20220208203607.C13B2C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: no need to unset panic_on_warn in end_report()
has been added to the -mm tree.  Its filename is
     kasan-no-need-to-unset-panic_on_warn-in-end_report.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-no-need-to-unset-panic_on_warn-in-end_report.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-no-need-to-unset-panic_on_warn-in-end_report.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: kasan: no need to unset panic_on_warn in end_report()

panic_on_warn is unset inside panic(), so no need to unset it before
calling panic() in end_report().

Link: https://lkml.kernel.org/r/1644324666-15947-6-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/mm/kasan/report.c~kasan-no-need-to-unset-panic_on_warn-in-end_report
+++ a/mm/kasan/report.c
@@ -117,16 +117,8 @@ static void end_report(unsigned long *fl
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
-	if (panic_on_warn && !test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags)) {
-		/*
-		 * This thread may hit another WARN() in the panic path.
-		 * Resetting this prevents additional WARN() from panicking the
-		 * system on this thread.  Other threads are blocked by the
-		 * panic_mutex in panic().
-		 */
-		panic_on_warn = 0;
+	if (panic_on_warn && !test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
 		panic("panic_on_warn set ...\n");
-	}
 	if (kasan_arg_fault == KASAN_ARG_FAULT_PANIC)
 		panic("kasan.fault=panic set ...\n");
 	kasan_enable_current();
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

docs-kdump-update-description-about-sysfs-file-system-support.patch
docs-kdump-add-scp-example-to-write-out-the-dump-file.patch
panic-unset-panic_on_warn-inside-panic.patch
ubsan-no-need-to-unset-panic_on_warn-in-ubsan_epilogue.patch
kasan-no-need-to-unset-panic_on_warn-in-end_report.patch

