Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF2C7C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9384E61241
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbhIWWGF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 18:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234844AbhIWWGF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 18:06:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F09E660F24;
        Thu, 23 Sep 2021 22:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632434673;
        bh=9KJHcg/402TVTF/ToY6IwxSlP6KXFvn6A+rvA8V/QN0=;
        h=Date:From:To:Subject:From;
        b=LZ1/ruqUssgcgOrB8olB0m0pSK2eDnSocqhtwH3IqpLSXbCV2p+4aIiN+GB9qVJXg
         e4FY7cCP6uNO+FkLOabsssBlihWZgs/B6WkFBK/71LzMyjQOemtaYY3+uaDLTjP4jR
         aXvajKKYR4t/UI67YyRjD5JBayPY17KDqwZRjuTo=
Date:   Thu, 23 Sep 2021 15:04:32 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bigeasy@linutronix.de, dvyukov@google.com,
        elver@google.com, mm-commits@vger.kernel.org, rostedt@goodmis.org,
        williams@redhat.com
Subject:  + documentation-kcov-include-typesh-in-the-example.patch
 added to -mm tree
Message-ID: <20210923220432.MZ0oQBBUv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/kcov: include types.h in the example
has been added to the -mm tree.  Its filename is
     documentation-kcov-include-typesh-in-the-example.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/documentation-kcov-include-typesh-in-the-example.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/documentation-kcov-include-typesh-in-the-example.patch

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
Subject: Documentation/kcov: include types.h in the example

Patch series "kcov: PREEMPT_RT fixup + misc", v2.

The last patch in series is follow-up to address the PREEMPT_RT issue
within in kcov reported by Clark [1].  Patches 1-3 are smaller things that
I noticed while staring at it.  Patch 4 is small change which makes
replacement in #5 simpler / more obvious.

[1] https://lkml.kernel.org/r/20210809155909.333073de@theseus.lan


This patch (of 5):

The first example code has includes at the top, the following two
example share that part. The last example (remote coverage collection)
requires the linux/types.h header file due its __aligned_u64 usage.

Add the linux/types.h to the top most example and a comment that the
header files from above are required as it is done in the second
example.

Link: https://lkml.kernel.org/r/20210923164741.1859522-1-bigeasy@linutronix.de
Link: https://lore.kernel.org/r/20210830172627.267989-2-bigeasy@linutronix.de
Link: https://lkml.kernel.org/r/20210923164741.1859522-2-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Clark Williams <williams@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kcov.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/dev-tools/kcov.rst~documentation-kcov-include-typesh-in-the-example
+++ a/Documentation/dev-tools/kcov.rst
@@ -50,6 +50,7 @@ program using kcov:
     #include <sys/mman.h>
     #include <unistd.h>
     #include <fcntl.h>
+    #include <linux/types.h>
 
     #define KCOV_INIT_TRACE			_IOR('c', 1, unsigned long)
     #define KCOV_ENABLE			_IO('c', 100)
@@ -251,6 +252,8 @@ selectively from different subsystems.
 
 .. code-block:: c
 
+    /* Same includes and defines as above. */
+
     struct kcov_remote_arg {
 	__u32		trace_mode;
 	__u32		area_size;
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-disable-zsmalloc-on-preempt_rt.patch
documentation-kcov-include-typesh-in-the-example.patch
documentation-kcov-define-ip-in-the-example.patch
kcov-allocate-per-cpu-memory-on-the-relevant-node.patch
kcov-avoid-enabledisable-interrupts-if-in_task.patch
kcov-replace-local_irq_save-with-a-local_lock_t.patch

