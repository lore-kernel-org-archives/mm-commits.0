Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5E1C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 23:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25C9C61A89
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 23:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhKRXmg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 18:42:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:43406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229911AbhKRXme (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 18:42:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA3F461A89;
        Thu, 18 Nov 2021 23:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637278774;
        bh=NLeYlMBSFhNfyS/cUaVdWXZYGXHR4atLTDCdyNOMNZA=;
        h=Date:From:To:Subject:From;
        b=PuUvFkuKU4lYdC+AWzM17eHhwao4d6M4Dgk/AoBDYiyMOwcu+Vuf6ewaNh2NLasuX
         ulYCA4N4A3AhaIQQecAX3p2hEvGn2MNUKh7yqMT2IEFPvPfYZWCJBUuKMdiOcODHIM
         dDq6elMymbVXjtNjP5dj+ABySoAJCUM89RFkS+l4=
Date:   Thu, 18 Nov 2021 15:39:33 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, caihuoqing@baidu.com,
        mm-commits@vger.kernel.org
Subject:  +
 kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch added to -mm
 tree
Message-ID: <20211118233933.CWNWX1SRw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread-add-the-helper-function-kthread_run_on_cpu-fix
has been added to the -mm tree.  Its filename is
     kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch

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
Subject: kthread-add-the-helper-function-kthread_run_on_cpu-fix

export kthread_create_on_cpu to modules

ERROR: modpost: "kthread_create_on_cpu" [drivers/infiniband/sw/siw/siw.ko] undefined!
ERROR: modpost: "kthread_create_on_cpu" [kernel/rcu/rcutorture.ko] undefined!

Cc: Cai Huoqing <caihuoqing@baidu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/kthread.c~kthread-add-the-helper-function-kthread_run_on_cpu-fix
+++ a/kernel/kthread.c
@@ -523,6 +523,7 @@ struct task_struct *kthread_create_on_cp
 	to_kthread(p)->cpu = cpu;
 	return p;
 }
+EXPORT_SYMBOL(kthread_create_on_cpu);
 
 void kthread_set_per_cpu(struct task_struct *k, int cpu)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

