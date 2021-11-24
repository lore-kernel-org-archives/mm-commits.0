Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520ADC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 22:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244154AbhKXWLR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:11:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:32984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345028AbhKXWLM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 17:11:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9FBA61039;
        Wed, 24 Nov 2021 22:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637791681;
        bh=IEpAWCCaZJ1dRqScNYUjWaq1hBEkmkYx6o30QPsW4i0=;
        h=Date:From:To:Subject:From;
        b=M2F8UdDgk+bmERjbBRDxdgYP6CF3yu2Dn5kji2TUTJSiuld+A6lDXTvzV/822waQQ
         vqVN3go0nhVX2nq+dOsNeCADQKf/hcGEYzRG1cvqC2MXwbUDM4yPSWw9osAuTHYVon
         tzB1Ww/iIpjth7B2DpqWi1+DJ8OGKWV2tJbN6OBs=
Date:   Wed, 24 Nov 2021 14:08:01 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, surenb@google.com
Subject:  +
 sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
 added to -mm tree
Message-ID: <20211124220801.ip01WsWPQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix
has been added to the -mm tree.  Its filename is
     sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix

update it for "mm/pagealloc: sysctl: change watermark_scale_factor max
limit to 30%".

Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Suren Baghdasaryan <surenb@google.com>
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
@@ -116,7 +116,6 @@ static int sixty = 60;
 static unsigned long zero_ul;
 static unsigned long one_ul = 1;
 static unsigned long long_max = LONG_MAX;
-static int three_thousand = 3000;
 #ifdef CONFIG_PRINTK
 static int ten_thousand = 10000;
 #endif
@@ -2954,7 +2953,7 @@ static struct ctl_table vm_table[] = {
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

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-git-rejects.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

