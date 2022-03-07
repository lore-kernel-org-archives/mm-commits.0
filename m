Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09F2C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 23:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbiCGXdN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Mar 2022 18:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiCGXdM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2022 18:33:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E431FE0D0
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 15:32:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95B4CB8174B
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 23:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAF9C340E9;
        Mon,  7 Mar 2022 23:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646695934;
        bh=tsBuy0E3r+Ynq1g124tOPsGG1RrW7gM/1SUkQUGwnkg=;
        h=Date:To:From:Subject:From;
        b=sJIyjzBBVbvYsmowKP5vbWZTapeMpRpjyT+HVYVc37IJgrdg+wSlxn+MfyYm7AfU4
         Dah9VxSSkrAnHkabEVuO4mJ9modGjltK3wTe3UcQxPDTdCtXCNNV/RW7/F+UsNxlHf
         tyfddzXG+leFwEtlvr2zl6iQaIn32WBUCnDxSrUw=
Date:   Mon, 07 Mar 2022 15:32:13 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        lixuefeng@loongson.cn, elver@google.com, corbet@lwn.net,
        bhe@redhat.com, yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-no-need-to-unset-panic_on_warn-in-end_report.patch added to -mm tree
Message-Id: <20220307233214.4BAF9C340E9@smtp.kernel.org>
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

