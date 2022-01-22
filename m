Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE9EC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbiAVBLm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:11:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43590 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiAVBLl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:11:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EB3661A9F
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CDEC340E1;
        Sat, 22 Jan 2022 01:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642813901;
        bh=NjHiOog+4/ffrWicZEDyNRxVJx9+f66FjMEYmchV92Y=;
        h=Date:From:To:Subject:From;
        b=FW6OCfJFnd8dr9oAG43ibvPbcaE/rlXvd4ZM/vhBzOc9Qk728QNzbezis/G5Ij708
         BnT66iAQwKNI11PjhN0REgr+c/44O6r17bQN9H/3usF+TdUhXPJwGk/ttsWkpFvZnR
         aA0Hb1JUWZhL2Xs7SvtfslEYIkGGkRU/vqpGwgOs=
Date:   Fri, 21 Jan 2022 17:11:39 -0800
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, akpm@linux-foundation.org, amir73il@gmail.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bcrl@kvack.org,
        benh@kernel.crashing.org, clemens@ladisch.de, crope@iki.fi,
        dgilbert@interlog.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, jack@suse.cz, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, jejb@linux.ibm.com,
        jlbec@evilplan.org, john.ogness@linutronix.de,
        joonas.lahtinen@linux.intel.com, joseph.qi@linux.alibaba.com,
        julia.lawall@inria.fr, keescook@chromium.org, kernel@tuxforce.de,
        mark@fasheh.com, martin.petersen@oracle.com, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, nixiaoming@huawei.com,
        penguin-kernel@I-love.SAKURA.ne.jp, peterz@infradead.org,
        phil@philpotter.co.uk, pjt@google.com, pmladek@suse.com,
        rafael@kernel.org, rodrigo.vivi@intel.com, rostedt@goodmis.org,
        senozhatsky@chromium.org, sre@kernel.org, steve@sk2.org,
        surenb@google.com, tytso@mit.edu, viro@zeniv.linux.org.uk,
        wangqing@vivo.com, yzaikin@google.com
Subject:  [folded-merged]
 sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
 removed from -mm tree
Message-ID: <20220122011139.v0gdy7B-Q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix
has been removed from the -mm tree.  Its filename was
     sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch

This patch was dropped because it was folded into sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix

update it for "mm/pagealloc: sysctl: change watermark_scale_factor max
limit to 30%".

Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Qing Wang <wangqing@vivo.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c  |    2 +-
 include/linux/sysctl.h |    3 ++-
 kernel/sysctl.c        |    3 +--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/proc/proc_sysctl.c~sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix
+++ a/fs/proc/proc_sysctl.c
@@ -26,7 +26,7 @@ static const struct file_operations proc
 static const struct inode_operations proc_sys_dir_operations;
 
 /* shared constants to be used in various sysctls */
-const int sysctl_vals[] = { -1, 0, 1, 2, 4, 100, 200, 1000, INT_MAX };
+const int sysctl_vals[] = { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MAX };
 EXPORT_SYMBOL(sysctl_vals);
 
 /* Support for permanently empty directories */
--- a/include/linux/sysctl.h~sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix
+++ a/include/linux/sysctl.h
@@ -46,7 +46,8 @@ struct ctl_dir;
 #define SYSCTL_ONE_HUNDRED		((void *)&sysctl_vals[5])
 #define SYSCTL_TWO_HUNDRED		((void *)&sysctl_vals[6])
 #define SYSCTL_ONE_THOUSAND		((void *)&sysctl_vals[7])
-#define SYSCTL_INT_MAX			((void *)&sysctl_vals[8])
+#define SYSCTL_THREE_THOUSAND		((void *)&sysctl_vals[8])
+#define SYSCTL_INT_MAX			((void *)&sysctl_vals[9])
 
 extern const int sysctl_vals[];
 
--- a/kernel/sysctl.c~sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix
+++ a/kernel/sysctl.c
@@ -117,7 +117,6 @@ static int sixty = 60;
 static unsigned long zero_ul;
 static unsigned long one_ul = 1;
 static unsigned long long_max = LONG_MAX;
-static int three_thousand = 3000;
 #ifdef CONFIG_PRINTK
 static int ten_thousand = 10000;
 #endif
@@ -2955,7 +2954,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= watermark_scale_factor_sysctl_handler,
 		.extra1		= SYSCTL_ONE,
-		.extra2		= &three_thousand,
+		.extra2		= SYSCTL_THREE_THOUSAND,
 	},
 	{
 		.procname	= "percpu_pagelist_high_fraction",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

