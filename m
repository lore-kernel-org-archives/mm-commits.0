Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BFAC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36AE0206D5
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633319;
	bh=Hxmhxt1/97UskelHGmuFxRg221/RYeRUneOk15xwgK4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=tyMfAP8bu0pUA8OC+LXtVZVckgI+cIzWoqTG7PDjQCHcAr6AVpYbSgn34sGfeBrGL
	 51qyN4ifQo/Q2tZARdC9LQCGYMjKpuFuSsSo5wDoIcaz1RiyrLs3JFzHRN7TsSdwcW
	 ffHZbVlbW2quUtX8n4s2X+LfoVV2UNMdMQUXyl3k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388452AbgJMXzS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388282AbgJMXzP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:55:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62F3E22227;
        Tue, 13 Oct 2020 23:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633315;
        bh=Hxmhxt1/97UskelHGmuFxRg221/RYeRUneOk15xwgK4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=v1Urg4Fm9RHekEk3DfHoBk1JHgNb3r9TkginRl3NRWmQjcjVIrJeZmhs0xHrvgl1u
         4kVqIC3eQk1JYU8baI0s+qbKW6Y2zk8OUoQYBwQj0iInBffQCKhn53NdAiTVctVRVX
         wYy8y5Pc0nsML1c2kVJ5m/UYKH0ui0QEPXOUDaSk=
Date:   Tue, 13 Oct 2020 16:55:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        andreyknvl@google.com, aryabinin@virtuozzo.com,
        brendanhiggins@google.com, davidgow@google.com, dvyukov@google.com,
        juri.lelli@redhat.com, linux-mm@kvack.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, shuah@kernel.org,
        torvalds@linux-foundation.org, trishalfonso@google.com,
        vincent.guittot@linaro.org
Subject:  [patch 124/181] mm: kasan: do not panic if both
 panic_on_warn and kasan_multishot set
Message-ID: <20201013235513.LlOSLYl1P%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
