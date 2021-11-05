Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 093F1C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E916061288
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbhKEUsb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233504AbhKEUsa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:48:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD8BB6135A;
        Fri,  5 Nov 2021 20:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145150;
        bh=7ZJA7MgHrNxIdcFZRAMa17flxOE2HjkgQ9lSst71BAo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lg3yat1FYZjdZcQ9s26P7ZwMYp4g6lVSV5CSHr6qf7QkUtYYEF8n8vPm8ld+jaAJQ
         NBTnNHN85PVrPG76Xjpc7SQsyyD5iWl15FFKywmS8fJg0+5CmkOlMbyow3GCOEJVcm
         Q/IEAHUSegIn3NKsA5JHlmVippOKwlASRPVmRQsk=
Date:   Fri, 05 Nov 2021 13:45:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dvyukov@google.com, elver@google.com,
        glider@google.com, jannh@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 213/262] kfence: default to dynamic branch instead
 of static keys mode
Message-ID: <20211105204549.5RJKPBc9C%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: kfence: default to dynamic branch instead of static keys mode

We have observed that on very large machines with newer CPUs, the static
key/branch switching delay is on the order of milliseconds.  This is due
to the required broadcast IPIs, which simply does not scale well to
hundreds of CPUs (cores).  If done too frequently, this can adversely
affect tail latencies of various workloads.

One workaround is to increase the sample interval to several seconds,
while decreasing sampled allocation coverage, but the problem still exists
and could still increase tail latencies.

As already noted in the Kconfig help text, there are trade-offs: at lower
sample intervals the dynamic branch results in better performance;
however, at very large sample intervals, the static keys mode can result
in better performance -- careful benchmarking is recommended.

Our initial benchmarking showed that with large enough sample intervals
and workloads stressing the allocator, the static keys mode was slightly
better.  Evaluating and observing the possible system-wide side-effects of
the static-key-switching induced broadcast IPIs, however, was a blind spot
(in particular on large machines with 100s of cores).

Therefore, a major downside of the static keys mode is, unfortunately,
that it is hard to predict performance on new system architectures and
topologies, but also making conclusions about performance of new workloads
based on a limited set of benchmarks.

Most distributions will simply select the defaults, while targeting a
large variety of different workloads and system architectures.  As such,
the better default is CONFIG_KFENCE_STATIC_KEYS=n, and re-enabling it is
only recommended after careful evaluation.

For reference, on x86-64 the condition in kfence_alloc() generates exactly
2 instructions in the kmem_cache_alloc() fast-path:

 | ...
 | cmpl   $0x0,0x1a8021c(%rip)  # ffffffff82d560d0 <kfence_allocation_gate>
 | je     ffffffff812d6003      <kmem_cache_alloc+0x243>
 | ...

which, given kfence_allocation_gate is infrequently modified, should be
well predicted by most CPUs.

Link: https://lkml.kernel.org/r/20211019102524.2807208-2-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kfence.rst |   12 ++++++++----
 lib/Kconfig.kfence                 |   26 +++++++++++++++-----------
 2 files changed, 23 insertions(+), 15 deletions(-)

--- a/Documentation/dev-tools/kfence.rst~kfence-default-to-dynamic-branch-instead-of-static-keys-mode
+++ a/Documentation/dev-tools/kfence.rst
@@ -231,10 +231,14 @@ Guarded allocations are set up based on
 of the sample interval, the next allocation through the main allocator (SLAB or
 SLUB) returns a guarded allocation from the KFENCE object pool (allocation
 sizes up to PAGE_SIZE are supported). At this point, the timer is reset, and
-the next allocation is set up after the expiration of the interval. To "gate" a
-KFENCE allocation through the main allocator's fast-path without overhead,
-KFENCE relies on static branches via the static keys infrastructure. The static
-branch is toggled to redirect the allocation to KFENCE.
+the next allocation is set up after the expiration of the interval.
+
+When using ``CONFIG_KFENCE_STATIC_KEYS=y``, KFENCE allocations are "gated"
+through the main allocator's fast-path by relying on static branches via the
+static keys infrastructure. The static branch is toggled to redirect the
+allocation to KFENCE. Depending on sample interval, target workloads, and
+system architecture, this may perform better than the simple dynamic branch.
+Careful benchmarking is recommended.
 
 KFENCE objects each reside on a dedicated page, at either the left or right
 page boundaries selected at random. The pages to the left and right of the
--- a/lib/Kconfig.kfence~kfence-default-to-dynamic-branch-instead-of-static-keys-mode
+++ a/lib/Kconfig.kfence
@@ -25,17 +25,6 @@ menuconfig KFENCE
 
 if KFENCE
 
-config KFENCE_STATIC_KEYS
-	bool "Use static keys to set up allocations"
-	default y
-	depends on JUMP_LABEL # To ensure performance, require jump labels
-	help
-	  Use static keys (static branches) to set up KFENCE allocations. Using
-	  static keys is normally recommended, because it avoids a dynamic
-	  branch in the allocator's fast path. However, with very low sample
-	  intervals, or on systems that do not support jump labels, a dynamic
-	  branch may still be an acceptable performance trade-off.
-
 config KFENCE_SAMPLE_INTERVAL
 	int "Default sample interval in milliseconds"
 	default 100
@@ -56,6 +45,21 @@ config KFENCE_NUM_OBJECTS
 	  pages are required; with one containing the object and two adjacent
 	  ones used as guard pages.
 
+config KFENCE_STATIC_KEYS
+	bool "Use static keys to set up allocations" if EXPERT
+	depends on JUMP_LABEL
+	help
+	  Use static keys (static branches) to set up KFENCE allocations. This
+	  option is only recommended when using very large sample intervals, or
+	  performance has carefully been evaluated with this option.
+
+	  Using static keys comes with trade-offs that need to be carefully
+	  evaluated given target workloads and system architectures. Notably,
+	  enabling and disabling static keys invoke IPI broadcasts, the latency
+	  and impact of which is much harder to predict than a dynamic branch.
+
+	  Say N if you are unsure.
+
 config KFENCE_STRESS_TEST_FAULTS
 	int "Stress testing of fault handling and error reporting" if EXPERT
 	default 0
_
