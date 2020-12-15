Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCFEC2BB9A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BA4922507
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgLODEE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:04:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgLODEA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:04:00 -0500
Date:   Mon, 14 Dec 2020 19:03:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001399;
        bh=JTZselB6iQ6qe7aYEhKtuDQBEYiGDApJvZHeofX/UpQ=;
        h=From:To:Subject:In-Reply-To:From;
        b=gCC0UNLzg6btKvAB9CMm0Fmlh1YMCW8guHH7B4NQgM7JHhgnHleNH/G/Wc+s7erqH
         cBIyIlSk5BJGTIAjLO6mv4X5Vq0JfADpOSpXImCY++45iRDFFZ8Uk7pQVTK5Rg7XFG
         Uq1sfbft8mbMvwXPtrLdS6qjjDUTj9AVZUAf3gLY=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pmladek@suse.com,
        Qiang.Zhang@windriver.com, tglx@linutronix.de, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 002/200] kthread_worker: document CPU hotplug
 handling
Message-ID: <20201215030318.XQgHtWq6k%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

[akpm@linux-foundation.org: grammar tweaks]
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
+ * to create, use, and destroy workers.
+ *
+ * It is up to the API user how to handle CPU hotplug. They have to decide
+ * how to handle pending work items, prevent queuing new ones, and
+ * restore the functionality when the CPU goes off and on. There are a
+ * few catches:
+ *
+ *    - CPU affinity gets lost when it is scheduled on an offline CPU.
+ *
+ *    - The worker might not exist when the CPU was off when the user
+ *      created the workers.
+ *
+ * Good practice is to implement two CPU hotplug callbacks and to
+ * destroy/create the worker when the CPU goes down/up.
+ *
+ * Return:
+ * The pointer to the allocated worker on success, ERR_PTR(-ENOMEM)
  * when the needed structures could not get allocated, and ERR_PTR(-EINTR)
  * when the worker was SIGKILLed.
  */
_
