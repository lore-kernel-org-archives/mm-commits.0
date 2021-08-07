Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B44DC4338F
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E090960EAF
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhHGTgl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Aug 2021 15:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhHGTgl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Aug 2021 15:36:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8CD760E9B;
        Sat,  7 Aug 2021 19:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628364983;
        bh=hWlkWV1Ows1YdwsmaEY6d5urtKc3ZN+/HHsGxqiO8oI=;
        h=Date:From:To:Subject:From;
        b=esyWMqEC78I1M6SPm6GvmXfBo/T8o9p58MBfDrRZl6q21w5Bs17i3aGcqDLLbY9Ur
         kTrIWkvGQfiEUF7OvkOb/As76rmVAkDTOTlz7FcNTGMKlhnE8wzr3+O515Sok2MRKN
         iVBxhHwRDhcrFgDCl5LHDK6+zWU3NMWdLF5Ni04Y=
Date:   Sat, 07 Aug 2021 12:36:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mingo@kernel.org,
        mingo@elte.hu, mgorman@techsingularity.net, hughd@google.com,
        tglx@linutronix.de
Subject:  [obsolete] preempt-provide-preempt__nort-variants.patch
 removed from -mm tree
Message-ID: <20210807193621.josHF%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: preempt: provide preempt_*_(no)rt variants
has been removed from the -mm tree.  Its filename was
     preempt-provide-preempt__nort-variants.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: preempt: provide preempt_*_(no)rt variants

Patch series "Protect vmstats on PREEMPT_RT".

When adding local_lock support to mm/page_alloc.c and reducing the
overhead of vmstats in general, I wondered how vmstats could be safe on
PREEMPT_RT as it partially relies on interrupts being disabled for the
stats that must be accurate for correctness.  As it turns out, the
preempt-rt tree already encountered the same problem.

This series protects just the primary counters.  While there is another
vmstat-related patch, it is related to memcg getting using local_lock and
I have not fully considered those patches and whether they are ok as-is or
need modification but this series makes a start.

Patch 1 is authored by Thomas and has not being altered.

Patch 2 is authored by Ingo but I modified what he implemented for reasons
explained in the changelog.


This patch (of 2):

RT needs a few preempt_disable/enable points which are not necessary
otherwise.  Implement variants to avoid #ifdeffery.

Link: https://lkml.kernel.org/r/20210723100034.13353-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20210723100034.13353-2-mgorman@techsingularity.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/preempt.h |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/include/linux/preempt.h~preempt-provide-preempt__nort-variants
+++ a/include/linux/preempt.h
@@ -184,7 +184,11 @@ do { \
 	preempt_count_dec(); \
 } while (0)
 
-#define preempt_enable_no_resched() sched_preempt_enable_no_resched()
+#ifdef CONFIG_PREEMPT_RT
+# define preempt_enable_no_resched() sched_preempt_enable_no_resched()
+#else
+# define preempt_enable_no_resched() preempt_enable()
+#endif
 
 #define preemptible()	(preempt_count() == 0 && !irqs_disabled())
 
@@ -278,6 +282,18 @@ do { \
 		set_preempt_need_resched(); \
 } while (0)
 
+#ifdef CONFIG_PREEMPT_RT
+# define preempt_disable_rt()		preempt_disable()
+# define preempt_enable_rt()		preempt_enable()
+# define preempt_disable_nort()		barrier()
+# define preempt_enable_nort()		barrier()
+#else
+# define preempt_disable_rt()		barrier()
+# define preempt_enable_rt()		barrier()
+# define preempt_disable_nort()		preempt_disable()
+# define preempt_enable_nort()		preempt_enable()
+#endif
+
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
 struct preempt_notifier;
_

Patches currently in -mm which might be from tglx@linutronix.de are


