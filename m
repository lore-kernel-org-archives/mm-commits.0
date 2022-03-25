Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5B5C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356532AbiCYBOe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357236AbiCYBO0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:14:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A818ABD7F5
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:12:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59187B81DE2
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1831EC340F1;
        Fri, 25 Mar 2022 01:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170761;
        bh=uuruo3c0c9pP7nGlc+DL3nYoqS/l/82NjfW3WXzMNWo=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=e24uEqeGCewNwUFmIWHRHWgJ1GIwfjIAyggZaTSBB4fgxO52NFk+sik7RCFp1qpRW
         7g2D0jGDuS6ZpPXrlt0injTh1HgWsakoBNh2fxEfB6wOn1fwNr2x0MVzgkjs7tROpu
         4gfCcWETMnruqHdsGD3SOvvLy6siKXGhMN64giys=
Date:   Thu, 24 Mar 2022 18:12:40 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 082/114] kasan: move disable_trace_on_warning to start_report
Message-Id: <20220325011241.1831EC340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: move disable_trace_on_warning to start_report

Move the disable_trace_on_warning() call, which enables the
/proc/sys/kernel/traceoff_on_warning interface for KASAN bugs, to
start_report(), so that it functions for all types of KASAN reports.

Link: https://lkml.kernel.org/r/7c066c5de26234ad2cebdd931adfe437f8a95d58.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kasan/report.c~kasan-move-disable_trace_on_warning-to-start_report
+++ a/mm/kasan/report.c
@@ -129,6 +129,8 @@ static DEFINE_SPINLOCK(report_lock);
 
 static void start_report(unsigned long *flags, bool sync)
 {
+	/* Respect the /proc/sys/kernel/traceoff_on_warning interface. */
+	disable_trace_on_warning();
 	/* Update status of the currently running KASAN test. */
 	update_kunit_status(sync);
 	/* Make sure we don't end up in loop. */
@@ -421,7 +423,6 @@ static void __kasan_report(unsigned long
 	void *untagged_addr;
 	unsigned long flags;
 
-	disable_trace_on_warning();
 	start_report(&flags, true);
 
 	tagged_addr = (void *)addr;
_
