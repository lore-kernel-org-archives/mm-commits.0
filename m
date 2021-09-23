Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21473C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B6006124F
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbhIWWGJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 18:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234844AbhIWWGH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 18:06:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAF2861242;
        Thu, 23 Sep 2021 22:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632434675;
        bh=v8mcbr+lAuBPfMUqHrGXGqR9wVcr9lZ82uEki/jmCAw=;
        h=Date:From:To:Subject:From;
        b=pMApNpDsv6l/9YTPlKs0BzlZcvkpTpal9xggt3QRZcBjqKA+MdyaDCXDkDRio0HHY
         +iraM6/k8mrgMmzHTM6SrFeJjTxlYKWpb4fFgr+5s51PKOi85I4jUCy/KBNzsH3Fym
         NXKwcPDbA78wMsQesVRqFTRnccdwSFzM20OWMZoM=
Date:   Thu, 23 Sep 2021 15:04:34 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bigeasy@linutronix.de, dvyukov@google.com,
        elver@google.com, mm-commits@vger.kernel.org, rostedt@goodmis.org,
        williams@redhat.com
Subject:  + documentation-kcov-define-ip-in-the-example.patch added
 to -mm tree
Message-ID: <20210923220434.W_WcYR4_b%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/kcov: define `ip' in the example
has been added to the -mm tree.  Its filename is
     documentation-kcov-define-ip-in-the-example.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/documentation-kcov-define-ip-in-the-example.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/documentation-kcov-define-ip-in-the-example.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Documentation/kcov: define `ip' in the example

The example code uses the variable `ip' but never declares it.

Declare `ip' as a 64bit variable which is the same type as the array
from which it loads its value.

Link: https://lkml.kernel.org/r/20210923164741.1859522-3-bigeasy@linutronix.de
Link: https://lore.kernel.org/r/20210830172627.267989-3-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kcov.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/dev-tools/kcov.rst~documentation-kcov-define-ip-in-the-example
+++ a/Documentation/dev-tools/kcov.rst
@@ -178,6 +178,8 @@ Comparison operands collection is simila
 	/* Read number of comparisons collected. */
 	n = __atomic_load_n(&cover[0], __ATOMIC_RELAXED);
 	for (i = 0; i < n; i++) {
+		uint64_t ip;
+
 		type = cover[i * KCOV_WORDS_PER_CMP + 1];
 		/* arg1 and arg2 - operands of the comparison. */
 		arg1 = cover[i * KCOV_WORDS_PER_CMP + 2];
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-disable-zsmalloc-on-preempt_rt.patch
documentation-kcov-include-typesh-in-the-example.patch
documentation-kcov-define-ip-in-the-example.patch
kcov-allocate-per-cpu-memory-on-the-relevant-node.patch
kcov-avoid-enabledisable-interrupts-if-in_task.patch
kcov-replace-local_irq_save-with-a-local_lock_t.patch

