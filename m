From: akpm@linux-foundation.org
Subject: +
 kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch added to -mm tree
Date: Tue, 09 Jul 2013 15:01:32 -0700
Message-ID: <51dc883c.vDE0wEuprBemCchX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3GIWBd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 18:01:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, udknight@gmail.com, gang.chen@asianux.com

Subject: + kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch added to -mm tree
To: gang.chen@asianux.com,udknight@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 15:01:32 -0700


The patch titled
     Subject: kernel/smp.c: free related resources when failure occurs in hotplug_cfd()
has been added to the -mm tree.  Its filename is
     kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: kernel/smp.c: free related resources when failure occurs in hotplug_cfd()

When failure occurs in hotplug_cfd(), need release related resources, or
will cause memory leak.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Acked-by: Wang YanQing <udknight@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/smp.c~kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd kernel/smp.c
--- a/kernel/smp.c~kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd
+++ a/kernel/smp.c
@@ -48,10 +48,13 @@ hotplug_cfd(struct notifier_block *nfb,
 				cpu_to_node(cpu)))
 			return notifier_from_errno(-ENOMEM);
 		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
-				cpu_to_node(cpu)))
+				cpu_to_node(cpu))) {
+			free_cpumask_var(cfd->cpumask);
 			return notifier_from_errno(-ENOMEM);
+		}
 		cfd->csd = alloc_percpu(struct call_single_data);
 		if (!cfd->csd) {
+			free_cpumask_var(cfd->cpumask_ipi);
 			free_cpumask_var(cfd->cpumask);
 			return notifier_from_errno(-ENOMEM);
 		}
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch
linux-next.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch
kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch

