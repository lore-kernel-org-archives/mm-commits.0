Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE15C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiCYWoo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234015AbiCYWo0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED5E20C2E8
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A19D61582
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62356C36AE2;
        Fri, 25 Mar 2022 22:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248170;
        bh=TRPWk/VJm1tNXRCPvaL0cGI+8LW+WQXV3OwxfNue1Wg=;
        h=Date:To:From:Subject:From;
        b=cvHQ/7p+A9IIp4vki1Wlk2hetRMppjC9KOEFaB8DY7wrb2LR7IDovrg413RBsSqdW
         AhlPiD4MURLwThiyqbQzwzMTqAuLzLx5zvLFBN9zzPVCkyvHmWRQ5XAHV1E2p2eFg/
         IOpvNBRYJswlMJol2Uqx+U0Kewvj6sf2oY5PtNy4=
Date:   Fri, 25 Mar 2022 15:42:49 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-move-disable_trace_on_warning-to-start_report.patch removed from -mm tree
Message-Id: <20220325224250.62356C36AE2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: move disable_trace_on_warning to start_report
has been removed from the -mm tree.  Its filename was
     kasan-move-disable_trace_on_warning-to-start_report.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

