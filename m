Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9AA8C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5B3A61994
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241981AbhKICiZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:38:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239643AbhKICiO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:38:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3222613B3;
        Tue,  9 Nov 2021 02:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425328;
        bh=Xh2oH2dovmeCyZKrHKfPy1i0ja13lNbY8yV7Qad5kAA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KLC307GNsdrI4Xy9G5+dCvKv2X+q5ohNUIrx3thBqXCC58kSL83SV4IlX1lMOhi+d
         cWtACy+vzxcPv3i8llL5hop69MydMyvqnEKOGE1LVbI40FGDz/b3Jc5gOsNakF5oBG
         Tw5ZfJxrPCEUkAX90mWp7/IWKJHLha9DNCfmdBCc=
Date:   Mon, 08 Nov 2021 18:35:28 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        bigeasy@linutronix.de, dvyukov@google.com, elver@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        williams@redhat.com
Subject:  [patch 76/87] Documentation/kcov: include types.h in the
 example
Message-ID: <20211109023528.X2I9NG2DL%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
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
