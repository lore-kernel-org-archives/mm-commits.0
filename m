Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EEC9C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D98D7206CB
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709341;
	bh=EFPbf5coI4uOI/lJkIO43kab7umkpjQDH+tKXu8p2EQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Y9gCJnUEsFfnqUuibCr66GUQ4qP+hEovHys3qGY21NxTIErSvBd+idSc8KpUK46Do
	 ECxVLNmYvgRxl0Tevxie8SsCwaT3f0oE4k9lWn7Z2z9i8tA7DesNXk1bqR09NkjF24
	 k9AFrXU1G/zAsB3qT3gKyNH1ctwLTAB9fqTzNAmY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387696AbgJNVCV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387543AbgJNVCV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:21 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90B8B20725;
        Wed, 14 Oct 2020 21:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709339;
        bh=EFPbf5coI4uOI/lJkIO43kab7umkpjQDH+tKXu8p2EQ=;
        h=Date:From:To:Subject:From;
        b=rOpOGZ9bJVVSOJlo8BVQe8KtqiqaiR0GgwHqoKE8+FFld875Q9FQB1ph1Zvsy1hLQ
         cZwXyouTLPAsHRrJR0adqrs/ohwOy4E0zOFNFwUFnRhgBoyJ8dvhs62ZIcmBV6Oe0B
         U8QSujKnuKmJIicaTFtc8kDL+Q2D7RoAUp4kwm2A=
Date:   Wed, 14 Oct 2020 14:02:18 -0700
From:   akpm@linux-foundation.org
To:     a.p.zijlstra@chello.nl, andreyknvl@google.com,
        aryabinin@virtuozzo.com, brendanhiggins@google.com,
        davidgow@google.com, dvyukov@google.com, juri.lelli@redhat.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, shuah@kernel.org,
        trishalfonso@google.com, vincent.guittot@linaro.org
Subject:  [merged]
 mm-kasan-do-not-panic-if-both-panic_on_warn-and-kasan_multishot-set.patch
 removed from -mm tree
Message-ID: <20201014210218.dmnTRWE74%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kasan: do not panic if both panic_on_warn and kasan_multishot set
has been removed from the -mm tree.  Its filename was
     mm-kasan-do-not-panic-if-both-panic_on_warn-and-kasan_multishot-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Gow <davidgow@google.com>
Subject: mm: kasan: do not panic if both panic_on_warn and kasan_multishot set

KASAN errors will currently trigger a panic when panic_on_warn is set. 
This renders kasan_multishot useless, as further KASAN errors won't be
reported if the kernel has already paniced.  By making kasan_multishot
disable this behaviour for KASAN errors, we can still have the benefits of
panic_on_warn for non-KASAN warnings, yet be able to use kasan_multishot.

This is particularly important when running KASAN tests, which need to
trigger multiple KASAN errors: previously these would panic the system if
panic_on_warn was set, now they can run (and will panic the system should
non-KASAN warnings show up).

Link: https://lkml.kernel.org/r/20200915035828.570483-6-davidgow@google.com
Link: https://lkml.kernel.org/r/20200910070331.3358048-6-davidgow@google.com
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Patricia Alfonso <trishalfonso@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/report.c~mm-kasan-do-not-panic-if-both-panic_on_warn-and-kasan_multishot-set
+++ a/mm/kasan/report.c
@@ -95,7 +95,7 @@ static void end_report(unsigned long *fl
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
-	if (panic_on_warn) {
+	if (panic_on_warn && !test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags)) {
 		/*
 		 * This thread may hit another WARN() in the panic path.
 		 * Resetting this prevents additional WARN() from panicking the
_

Patches currently in -mm which might be from davidgow@google.com are


