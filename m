Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC03CC433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A798064EFA
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbhBYTkX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:40:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234003AbhBYTiU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:38:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 075C264E90;
        Thu, 25 Feb 2021 19:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614281859;
        bh=rCTQzWrgOuqHawgdcn/AwJH8afyoqThCUKDqNYRPw3g=;
        h=Date:From:To:Subject:From;
        b=EO7mlsojaem8CEi3ieVAX1haYGOTIGaoQzo7L7WPQG0seJvEaf8PY+jD6hqhX/WTp
         FwFB40gFNVDoLfvAyiiaR3xNRzMRauHHdEFiu2foHVKfhPljghnHbJxtppM/2PV4e2
         0gjfDVeUb+uKypk+7TAx8/26j4W24SCw7qr4X05c=
Date:   Thu, 25 Feb 2021 11:37:38 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, bigeasy@linutronix.de, bristot@redhat.com,
        mingo@kernel.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, paulmck@kernel.org, peterz@infradead.org,
        prarit@redhat.com, tglx@linutronix.de, valentin.schneider@arm.com
Subject:  + stop_machine-mark-helpers-__always_inline.patch added
 to -mm tree
Message-ID: <20210225193738.GjxHxfEkY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: stop_machine: mark helpers __always_inline
has been added to the -mm tree.  Its filename is
     stop_machine-mark-helpers-__always_inline.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/stop_machine-mark-helpers-__always_inline.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/stop_machine-mark-helpers-__always_inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: stop_machine: mark helpers __always_inline

With clang-13, some functions only get partially inlined, with a
specialized version referring to a global variable.  This triggers a
harmless build-time check for the intel-rng driver:

WARNING: modpost: drivers/char/hw_random/intel-rng.o(.text+0xe): Section mismatch in reference from the function stop_machine() to the function .init.text:intel_rng_hw_init()
The function stop_machine() references
the function __init intel_rng_hw_init().
This is often because stop_machine lacks a __init
annotation or the annotation of intel_rng_hw_init is wrong.

In this instance, an easy workaround is to force the stop_machine()
function to be inline, along with related interfaces that did not show the
same behavior at the moment, but theoretically could.

The combination of the two patches listed below triggers the behavior in
clang-13, but individually these commits are correct.

Link: https://lkml.kernel.org/r/20210225130153.1956990-1-arnd@kernel.org
Fixes: fe5595c07400 ("stop_machine: Provide stop_machine_cpuslocked()")
Fixes: ee527cd3a20c ("Use stop_machine_run in the Intel RNG driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stop_machine.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/include/linux/stop_machine.h~stop_machine-mark-helpers-__always_inline
+++ a/include/linux/stop_machine.h
@@ -128,7 +128,7 @@ int stop_machine_from_inactive_cpu(cpu_s
 				   const struct cpumask *cpus);
 #else	/* CONFIG_SMP || CONFIG_HOTPLUG_CPU */
 
-static inline int stop_machine_cpuslocked(cpu_stop_fn_t fn, void *data,
+static __always_inline int stop_machine_cpuslocked(cpu_stop_fn_t fn, void *data,
 					  const struct cpumask *cpus)
 {
 	unsigned long flags;
@@ -139,14 +139,15 @@ static inline int stop_machine_cpuslocke
 	return ret;
 }
 
-static inline int stop_machine(cpu_stop_fn_t fn, void *data,
-			       const struct cpumask *cpus)
+static __always_inline int
+stop_machine(cpu_stop_fn_t fn, void *data, const struct cpumask *cpus)
 {
 	return stop_machine_cpuslocked(fn, data, cpus);
 }
 
-static inline int stop_machine_from_inactive_cpu(cpu_stop_fn_t fn, void *data,
-						 const struct cpumask *cpus)
+static __always_inline int
+stop_machine_from_inactive_cpu(cpu_stop_fn_t fn, void *data,
+			       const struct cpumask *cpus)
 {
 	return stop_machine(fn, data, cpus);
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

linux-compiler-clangh-define-have_builtin_bswap.patch
memblock-fix-section-mismatch-warning.patch
stop_machine-mark-helpers-__always_inline.patch

