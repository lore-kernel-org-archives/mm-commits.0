Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709B8C4742C
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 02:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D1E5223FB
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 02:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604458565;
	bh=iaeHVrmnEI31zWE7yjgIWjPYBj3S8At2ytPUnBS7Ehg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=iOsCiKbtqyr1pl+TFoEY1c8amsgd606z2ArhTagxVFIS/icooL4QNfimANNtDSELT
	 ausDUeLWwE3Ogu0mXhn9ueIzSLLg53Qwb+vU8RppZ5Z5pEIJgxB0VH80kFe5ryoS90
	 5J1Nu/PzO6bVFGjf9yip3r6YJ5TQipz5fIr3NeUE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbgKDC4E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 21:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728972AbgKDC4E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 21:56:04 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B63ED22404;
        Wed,  4 Nov 2020 02:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604458564;
        bh=iaeHVrmnEI31zWE7yjgIWjPYBj3S8At2ytPUnBS7Ehg=;
        h=Date:From:To:Subject:From;
        b=DTl9a7fL+9ZWYiJPrymk+3wNd1xSJI3+Zoqf26ubKayIL3IL6i4Y3Ios1ynGJMP5O
         RcLKLSI6Gc50Su2Lh876eV1LdvJI7x+5io9d/adzN05K6XxVjfJlG+7bc6PuHLnSnz
         CVdf+TVc1+gRRe1/3pzUiHuZHbKzHP9D77kDmgnM=
Date:   Tue, 03 Nov 2020 18:56:03 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
        Qiang.Zhang@windriver.com, pmladek@suse.com,
        akpm@linux-foundation.org
Subject:  + kthread_worker-document-cpu-hotplug-handling-fix.patch
 added to -mm tree
Message-ID: <20201104025603.iWalr%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread_worker-document-cpu-hotplug-handling-fix
has been added to the -mm tree.  Its filename is
     kthread_worker-document-cpu-hotplug-handling-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kthread_worker-document-cpu-hotplug-handling-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kthread_worker-document-cpu-hotplug-handling-fix.patch

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
Subject: kthread_worker-document-cpu-hotplug-handling-fix

grammar tweaks

Cc: Petr Mladek <pmladek@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zhang Qiang <Qiang.Zhang@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/kthread.c~kthread_worker-document-cpu-hotplug-handling-fix
+++ a/kernel/kthread.c
@@ -795,11 +795,11 @@ EXPORT_SYMBOL(kthread_create_worker);
  *
  * CPU hotplug:
  * The kthread worker API is simple and generic. It just provides a way
- * how to create, use, and destroy workers.
+ * to create, use, and destroy workers.
  *
  * It is up to the API user how to handle CPU hotplug. They have to decide
  * how to handle pending work items, prevent queuing new ones, and
- * restore the functionality when the CPU goes off and on. There are
+ * restore the functionality when the CPU goes off and on. There are a
  * few catches:
  *
  *    - CPU affinity gets lost when it is scheduled on an offline CPU.
@@ -807,8 +807,8 @@ EXPORT_SYMBOL(kthread_create_worker);
  *    - The worker might not exist when the CPU was off when the user
  *      created the workers.
  *
- * A good practice is to implement two CPU hotplug callbacks and
- * destroy/create the worker when CPU goes down/up.
+ * Good practice is to implement two CPU hotplug callbacks and to
+ * destroy/create the worker when the CPU goes down/up.
  *
  * Return:
  * The pointer to the allocated worker on success, ERR_PTR(-ENOMEM)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

