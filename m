Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3247FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357427AbiCYBgC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357424AbiCYBfY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B4C13D02
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABABCB8261B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6598BC340ED;
        Fri, 25 Mar 2022 01:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171986;
        bh=1WaX9ugg37Is0YypX5pDudwkYv+zFJotfuYCSTpgTGM=;
        h=Date:To:From:Subject:From;
        b=SqK0Td12hyHIQkwxseDBybr7Dv9Xwq6WBHshBZOlbZGJZC/58lwfujuIvESefjpd5
         K/vs2AlBgpHyjldnDIB1hr7vRLWAgX/2JkTByOESTLqD39vy8Y2uS6OkH9hoVk5vHr
         MK3V7XNK9wxWwS/LywCcUSLBwX6q3bvqyrlBQHkg=
Date:   Thu, 24 Mar 2022 18:33:05 -0700
To:     mm-commits@vger.kernel.org, glider@google.com, dvyukov@google.com,
        elver@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kfence-allow-use-of-a-deferrable-timer.patch removed from -mm tree
Message-Id: <20220325013306.6598BC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: allow use of a deferrable timer
has been removed from the -mm tree.  Its filename was
     kfence-allow-use-of-a-deferrable-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: allow use of a deferrable timer

Allow the use of a deferrable timer, which does not force CPU wake-ups
when the system is idle.  A consequence is that the sample interval
becomes very unpredictable, to the point that it is not guaranteed that
the KFENCE KUnit test still passes.

Nevertheless, on power-constrained systems this may be preferable, so
let's give the user the option should they accept the above trade-off.

Link: https://lkml.kernel.org/r/20220308141415.3168078-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kfence.rst |   12 ++++++++++++
 lib/Kconfig.kfence                 |   12 ++++++++++++
 mm/kfence/core.c                   |   15 +++++++++++++--
 3 files changed, 37 insertions(+), 2 deletions(-)

--- a/Documentation/dev-tools/kfence.rst~kfence-allow-use-of-a-deferrable-timer
+++ a/Documentation/dev-tools/kfence.rst
@@ -41,6 +41,18 @@ guarded by KFENCE. The default is config
 ``CONFIG_KFENCE_SAMPLE_INTERVAL``. Setting ``kfence.sample_interval=0``
 disables KFENCE.
 
+The sample interval controls a timer that sets up KFENCE allocations. By
+default, to keep the real sample interval predictable, the normal timer also
+causes CPU wake-ups when the system is completely idle. This may be undesirable
+on power-constrained systems. The boot parameter ``kfence.deferrable=1``
+instead switches to a "deferrable" timer which does not force CPU wake-ups on
+idle systems, at the risk of unpredictable sample intervals. The default is
+configurable via the Kconfig option ``CONFIG_KFENCE_DEFERRABLE``.
+
+.. warning::
+   The KUnit test suite is very likely to fail when using a deferrable timer
+   since it currently causes very unpredictable sample intervals.
+
 The KFENCE memory pool is of fixed size, and if the pool is exhausted, no
 further KFENCE allocations occur. With ``CONFIG_KFENCE_NUM_OBJECTS`` (default
 255), the number of available guarded objects can be controlled. Each object
--- a/lib/Kconfig.kfence~kfence-allow-use-of-a-deferrable-timer
+++ a/lib/Kconfig.kfence
@@ -45,6 +45,18 @@ config KFENCE_NUM_OBJECTS
 	  pages are required; with one containing the object and two adjacent
 	  ones used as guard pages.
 
+config KFENCE_DEFERRABLE
+	bool "Use a deferrable timer to trigger allocations"
+	help
+	  Use a deferrable timer to trigger allocations. This avoids forcing
+	  CPU wake-ups if the system is idle, at the risk of a less predictable
+	  sample interval.
+
+	  Warning: The KUnit test suite fails with this option enabled - due to
+	  the unpredictability of the sample interval!
+
+	  Say N if you are unsure.
+
 config KFENCE_STATIC_KEYS
 	bool "Use static keys to set up allocations" if EXPERT
 	depends on JUMP_LABEL
--- a/mm/kfence/core.c~kfence-allow-use-of-a-deferrable-timer
+++ a/mm/kfence/core.c
@@ -95,6 +95,10 @@ module_param_cb(sample_interval, &sample
 static unsigned long kfence_skip_covered_thresh __read_mostly = 75;
 module_param_named(skip_covered_thresh, kfence_skip_covered_thresh, ulong, 0644);
 
+/* If true, use a deferrable timer. */
+static bool kfence_deferrable __read_mostly = IS_ENABLED(CONFIG_KFENCE_DEFERRABLE);
+module_param_named(deferrable, kfence_deferrable, bool, 0444);
+
 /* The pool of pages used for guard pages and objects. */
 char *__kfence_pool __read_mostly;
 EXPORT_SYMBOL(__kfence_pool); /* Export for test modules. */
@@ -740,6 +744,8 @@ late_initcall(kfence_debugfs_init);
 
 /* === Allocation Gate Timer ================================================ */
 
+static struct delayed_work kfence_timer;
+
 #ifdef CONFIG_KFENCE_STATIC_KEYS
 /* Wait queue to wake up allocation-gate timer task. */
 static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
@@ -762,7 +768,6 @@ static DEFINE_IRQ_WORK(wake_up_kfence_ti
  * avoids IPIs, at the cost of not immediately capturing allocations if the
  * instructions remain cached.
  */
-static struct delayed_work kfence_timer;
 static void toggle_allocation_gate(struct work_struct *work)
 {
 	if (!READ_ONCE(kfence_enabled))
@@ -790,7 +795,6 @@ static void toggle_allocation_gate(struc
 	queue_delayed_work(system_unbound_wq, &kfence_timer,
 			   msecs_to_jiffies(kfence_sample_interval));
 }
-static DECLARE_DELAYED_WORK(kfence_timer, toggle_allocation_gate);
 
 /* === Public interface ===================================================== */
 
@@ -809,8 +813,15 @@ static void kfence_init_enable(void)
 {
 	if (!IS_ENABLED(CONFIG_KFENCE_STATIC_KEYS))
 		static_branch_enable(&kfence_allocation_key);
+
+	if (kfence_deferrable)
+		INIT_DEFERRABLE_WORK(&kfence_timer, toggle_allocation_gate);
+	else
+		INIT_DELAYED_WORK(&kfence_timer, toggle_allocation_gate);
+
 	WRITE_ONCE(kfence_enabled, true);
 	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
+
 	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
 		CONFIG_KFENCE_NUM_OBJECTS, (void *)__kfence_pool,
 		(void *)(__kfence_pool + KFENCE_POOL_SIZE));
_

Patches currently in -mm which might be from elver@google.com are


