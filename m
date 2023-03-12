Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05ED8C6FA99
	for <mm-commits@archiver.kernel.org>; Sun, 12 Mar 2023 20:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjCLURF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 12 Mar 2023 16:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbjCLUQu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 12 Mar 2023 16:16:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D787733454
        for <mm-commits@vger.kernel.org>; Sun, 12 Mar 2023 13:16:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4A6E7CE0CDF
        for <mm-commits@vger.kernel.org>; Sun, 12 Mar 2023 20:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E2AC433EF;
        Sun, 12 Mar 2023 20:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678652196;
        bh=DrsttvTO6vbmpTwbFT0vxiT2dxhmTd/V79AEApnvlDc=;
        h=Date:To:From:Subject:From;
        b=hiabJRDGj4TQwba7Z3vCMGMjTqn78oWueYR65WcWQ14R+Bj7Iu1zy9XDsO8wesWIt
         SXHzH61cXuewYKmH2HHiVqyOB59pz+JUyb9Hcp+r+845lfKXOTIRvW9atP8swG5AG/
         Bn8AyxpKJ7GWRSRlCmzMxmdmiAV9oGCm7SLNPCC0=
Date:   Sun, 12 Mar 2023 13:16:35 -0700
To:     mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com,
        pmladek@suse.com, peterz@infradead.org, linux@rasmusvillemoes.dk,
        john.ogness@linutronix.de, fuyuanli@didiglobal.com,
        ben.dooks@sifive.com, trix@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-hung_taskc-set-some-hung_taskc-variables-storage-class-specifier-to-static.patch added to mm-nonmm-unstable branch
Message-Id: <20230312201636.58E2AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/hung_task.c: set some hung_task.c variables storage-class-specifier to static
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-hung_taskc-set-some-hung_taskc-variables-storage-class-specifier-to-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-hung_taskc-set-some-hung_taskc-variables-storage-class-specifier-to-static.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Tom Rix <trix@redhat.com>
Subject: kernel/hung_task.c: set some hung_task.c variables storage-class-specifier to static
Date: Sun, 12 Mar 2023 12:46:45 -0400

smatch reports several warnings
kernel/hung_task.c:31:19: warning:
  symbol 'sysctl_hung_task_check_count' was not declared. Should it be static?
kernel/hung_task.c:50:29: warning:
  symbol 'sysctl_hung_task_check_interval_secs' was not declared. Should it be static?
kernel/hung_task.c:52:19: warning:
  symbol 'sysctl_hung_task_warnings' was not declared. Should it be static?
kernel/hung_task.c:75:28: warning:
  symbol 'sysctl_hung_task_panic' was not declared. Should it be static?

These variables are only used in hung_task.c, so they should be static

Link: https://lkml.kernel.org/r/20230312164645.471259-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Cc: Ben Dooks <ben.dooks@sifive.com>
Cc: fuyuanli <fuyuanli@didiglobal.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/kernel/hung_task.c~kernel-hung_taskc-set-some-hung_taskc-variables-storage-class-specifier-to-static
+++ a/kernel/hung_task.c
@@ -28,7 +28,7 @@
 /*
  * The number of tasks checked:
  */
-int __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
+static int __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
 
 /*
  * Limit number of tasks checked in a batch.
@@ -47,9 +47,9 @@ unsigned long __read_mostly sysctl_hung_
 /*
  * Zero (default value) means use sysctl_hung_task_timeout_secs:
  */
-unsigned long __read_mostly sysctl_hung_task_check_interval_secs;
+static unsigned long __read_mostly sysctl_hung_task_check_interval_secs;
 
-int __read_mostly sysctl_hung_task_warnings = 10;
+static int __read_mostly sysctl_hung_task_warnings = 10;
 
 static int __read_mostly did_panic;
 static bool hung_task_show_lock;
@@ -72,8 +72,8 @@ static unsigned int __read_mostly sysctl
  * Should we panic (and reboot, if panic_timeout= is set) when a
  * hung task is detected:
  */
-unsigned int __read_mostly sysctl_hung_task_panic =
-				IS_ENABLED(CONFIG_BOOTPARAM_HUNG_TASK_PANIC);
+static unsigned int __read_mostly sysctl_hung_task_panic =
+	IS_ENABLED(CONFIG_BOOTPARAM_HUNG_TASK_PANIC);
 
 static int
 hung_task_panic(struct notifier_block *this, unsigned long event, void *ptr)
_

Patches currently in -mm which might be from trix@redhat.com are

kernel-hung_taskc-set-some-hung_taskc-variables-storage-class-specifier-to-static.patch

