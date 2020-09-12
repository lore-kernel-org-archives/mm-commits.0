Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B00AC433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 20:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FC7222204
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 20:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599940952;
	bh=JliQqWVN0/jVYKOJHw+9jFAO0iu1MeSb3gSMfiycqE0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=JMXNQm77SjgI+Mwp3MPg/KD+htboLQolGTZLMRo2paUugv/DYtJC8V4ugkRQvRtjW
	 vWAf3hVJ2Nt+xzV6wAxxyfc6iBlYCozKWfUCWIGz7OygnoNEzDMjHX9jVP3el20mNn
	 +uIxS6+Srtw+sCPB256JHy9RIG+JvjliR4e1tFO8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgILUC2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 16:02:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgILUCU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 16:02:20 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04DB8221E3;
        Sat, 12 Sep 2020 20:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599940940;
        bh=JliQqWVN0/jVYKOJHw+9jFAO0iu1MeSb3gSMfiycqE0=;
        h=Date:From:To:Subject:From;
        b=XjOASF+gYFB+gbQ8YyY0pyzcyOSUr4SVlklXAWUuJDLK9G8UL+L10EkKF7m2z+M0D
         r6v2nE9Ze2cSCIk67V1QKb6alIrKa+0b94tYNmkz1GRxUKP7RbrCc7HvBrsGuzopW2
         l5+gvDgKaYan0ACXd1M1FTSG7FRh/zkHNsuI+j3Y=
Date:   Sat, 12 Sep 2020 13:02:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vincent.guittot@linaro.org,
        trishalfonso@google.com, shuah@kernel.org, mingo@redhat.com,
        juri.lelli@redhat.com, dvyukov@google.com,
        brendanhiggins@google.com, aryabinin@virtuozzo.com,
        a.p.zijlstra@chello.nl, andreyknvl@google.com, davidgow@google.com
Subject:  +
 mm-kasan-do-not-panic-if-both-panic_on_warn-and-kasan_multishot-set.patch
 added to -mm tree
Message-ID: <20200912200219._xx9g%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kasan: do not panic if both panic_on_warn and kasan_multishot set
has been added to the -mm tree.  Its filename is
     mm-kasan-do-not-panic-if-both-panic_on_warn-and-kasan_multishot-set.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-do-not-panic-if-both-panic_on_warn-and-kasan_multishot-set.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-do-not-panic-if-both-panic_on_warn-and-kasan_multishot-set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-kasan-do-not-panic-if-both-panic_on_warn-and-kasan_multishot-set.patch

