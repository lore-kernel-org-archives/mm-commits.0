Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A30C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbjDFCxy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbjDFCxb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AA59747
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF74564218
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27836C433EF;
        Thu,  6 Apr 2023 02:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749590;
        bh=eLEblPFc9OZZeAE+QznUp4eyYzeMLD53yRlZbeaoykk=;
        h=Date:To:From:Subject:From;
        b=a+hbO43mazTCYwBG+2/M68QUmwjjCLjyXTQMImvoLS6WUTBFW73Jv4a4eBneqDAYU
         QgZOlETdl17GHPWHGmrFq8Isep0SdfhMuGAMf8WNoZCFGkSnOu1JYvLoFWVMSzICP/
         zuWSCJYtu/uGAz5BaUV/0wUROF8M0+YmtLmk9kVg=
Date:   Wed, 05 Apr 2023 19:53:09 -0700
To:     mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com,
        pmladek@suse.com, peterz@infradead.org, linux@rasmusvillemoes.dk,
        john.ogness@linutronix.de, fuyuanli@didiglobal.com,
        ben.dooks@sifive.com, trix@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-hung_taskc-set-some-hung_taskc-variables-storage-class-specifier-to-static.patch removed from -mm tree
Message-Id: <20230406025310.27836C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/hung_task.c: set some hung_task.c variables storage-class-specifier to static
has been removed from the -mm tree.  Its filename was
     kernel-hung_taskc-set-some-hung_taskc-variables-storage-class-specifier-to-static.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 kernel/hung_task.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

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


