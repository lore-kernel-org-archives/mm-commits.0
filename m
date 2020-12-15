Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C99C2BBCD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9675D22D05
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgLOXQh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730982AbgLOXQb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:16:31 -0500
Date:   Tue, 15 Dec 2020 15:15:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074142;
        bh=Tg5ASOXd7vhkX3/8jSXsCVUAK1QnUeQhyKsER7hWqKk=;
        h=From:To:Subject:From;
        b=v2HC+rcI5/JuWJhhFCVZkQlQlUnRQ6QJV28g4iaecQjLto64cSNwsRBKt6ZPODRHH
         GCCtmT4AJ7WT4tlIWfQt2JZLCH1o8JXq/jSQMg5eber59apn6mrIeDOtpgSLJieci6
         F4ygfARRYhceqpsPtXUfLRDMlcN3741WDWHVtEf4=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, pmladek@suse.com,
        Qiang.Zhang@windriver.com, tglx@linutronix.de, tj@kernel.org
Subject:  [merged]
 kthread_worker-document-cpu-hotplug-handling.patch removed from -mm tree
Message-ID: <20201215231541.Q_Zob5Wlt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread_worker: document CPU hotplug handling
has been removed from the -mm tree.  Its filename was
     kthread_worker-document-cpu-hotplug-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from pmladek@suse.com are


