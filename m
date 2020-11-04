Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB1E7C2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 02:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84877223C7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 02:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604458563;
	bh=JwSqlvaN+Wy/BQ9sHjBi0cheH5/dZ69Ei2+8xXnMF7E=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=H49d6IG492OijnB5EjKld8PNOw07iIgUz0TsAPLlv/aiLxG1LKnNFlG2mmZMpZv1w
	 eoQ7CgJWjKeNVsDEPd4Ey7Kjr+iXXn5vyAtCW6LEGXv5c3LOWoKANB+14AE574Jc3x
	 lYiSYXpasr4lFxpfdV3Q9pCK5wPp1ajCkrNlVEmc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729480AbgKDC4D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 21:56:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728972AbgKDC4C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 21:56:02 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D913D223C6;
        Wed,  4 Nov 2020 02:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604458562;
        bh=JwSqlvaN+Wy/BQ9sHjBi0cheH5/dZ69Ei2+8xXnMF7E=;
        h=Date:From:To:Subject:From;
        b=INJqap905+n4SB+YPNSjCEwBinAhE9K5OS9bDqUXbHxMyCrQbI6z9dKnQLfXGeKDh
         GmJ8LUyhnt7j9O8A/T+ibU42JIjQWV7aIxIH0URH6noeWepNib39cSz9wa6FQ5egY4
         k7MJ3Qp7wi3iGU2KW8aegx3sI/dt4sUhXEj37Fm0=
Date:   Tue, 03 Nov 2020 18:56:01 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
        Qiang.Zhang@windriver.com, pmladek@suse.com
Subject:  + kthread_worker-document-cpu-hotplug-handling.patch added
 to -mm tree
Message-ID: <20201104025601.W0JqW%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread_worker: document CPU hotplug handling
has been added to the -mm tree.  Its filename is
     kthread_worker-document-cpu-hotplug-handling.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kthread_worker-document-cpu-hotplug-handling.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kthread_worker-document-cpu-hotplug-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: kthread_worker: document CPU hotplug handling

The kthread worker API is simple.  In short, it allows to create, use, and
destroy workers.  kthread_create_worker_on_cpu() just allows to bind a
newly created worker to a given CPU.

It is up to the API user how to handle CPU hotplug.  They have to decide
how to handle pending work items, prevent queuing new ones, and restore
the functionality when the CPU goes off and on.  There are few catches:

   + The CPU affinity gets lost when it is scheduled on an offline CPU.

   + The worker might not exist when the CPU was off when the user
     created the workers.

A good practice is to implement two CPU hotplug callbacks and
destroy/create the worker when CPU goes down/up.

Mention this in the function description.

Link: https://lore.kernel.org/r/20201028073031.4536-1-qiang.zhang@windriver.com
Link: https://lkml.kernel.org/r/20201102101039.19227-1-pmladek@suse.com
Reported-by: Zhang Qiang <Qiang.Zhang@windriver.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/kernel/kthread.c~kthread_worker-document-cpu-hotplug-handling
+++ a/kernel/kthread.c
@@ -793,7 +793,25 @@ EXPORT_SYMBOL(kthread_create_worker);
  * A good practice is to add the cpu number also into the worker name.
  * For example, use kthread_create_worker_on_cpu(cpu, "helper/%d", cpu).
  *
- * Returns a pointer to the allocated worker on success, ERR_PTR(-ENOMEM)
+ * CPU hotplug:
+ * The kthread worker API is simple and generic. It just provides a way
+ * how to create, use, and destroy workers.
+ *
+ * It is up to the API user how to handle CPU hotplug. They have to decide
+ * how to handle pending work items, prevent queuing new ones, and
+ * restore the functionality when the CPU goes off and on. There are
+ * few catches:
+ *
+ *    - CPU affinity gets lost when it is scheduled on an offline CPU.
+ *
+ *    - The worker might not exist when the CPU was off when the user
+ *      created the workers.
+ *
+ * A good practice is to implement two CPU hotplug callbacks and
+ * destroy/create the worker when CPU goes down/up.
+ *
+ * Return:
+ * The pointer to the allocated worker on success, ERR_PTR(-ENOMEM)
  * when the needed structures could not get allocated, and ERR_PTR(-EINTR)
  * when the worker was SIGKILLed.
  */
_

Patches currently in -mm which might be from pmladek@suse.com are

kthread_worker-document-cpu-hotplug-handling.patch

