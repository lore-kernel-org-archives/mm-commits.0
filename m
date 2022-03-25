Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE83C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357210AbiCYBON (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357206AbiCYBOD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:14:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82655BD7CF
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:12:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 123166185F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68820C340ED;
        Fri, 25 Mar 2022 01:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170749;
        bh=r5idV1IUWOr1mv9pfTf8SslHP9r/IjdZQN39xBzUOkY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=EI+3EBaH+2XOjHWZyto5y6n6IPhcX/xPbkVX2xnbLTGI33alV92igX8iMMMCKpfsU
         PnZgU+XLLCiiptj9cXgO4C9npSEDMoYKgaufQW8oRmAzU91ljbfmJjC6FgCAIiIJEU
         X1buElKx3t85Rl3Bu1o4G5WYZnL9VIl3keNP4RoI=
Date:   Thu, 24 Mar 2022 18:12:28 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 078/114] kasan: simplify async check in end_report()
Message-Id: <20220325011229.68820C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: simplify async check in end_report()

Currently, end_report() does not call trace_error_report_end() for bugs
detected in either async or asymm mode (when kasan_async_fault_possible()
returns true), as the address of the bad access might be unknown.

However, for asymm mode, the address is known for faults triggered by read
operations.

Instead of using kasan_async_fault_possible(), simply check that the addr
is not NULL when calling trace_error_report_end().

Link: https://lkml.kernel.org/r/1c8ce43f97300300e62c941181afa2eb738965c5.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/report.c~kasan-simplify-async-check-in-end_report
+++ a/mm/kasan/report.c
@@ -112,7 +112,7 @@ static void start_report(unsigned long *
 
 static void end_report(unsigned long *flags, unsigned long addr)
 {
-	if (!kasan_async_fault_possible())
+	if (addr)
 		trace_error_report_end(ERROR_DETECTOR_KASAN, addr);
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
_
