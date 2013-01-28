From: akpm@linux-foundation.org
Subject: + smp-fix-use-un-initialized-cpumask_ipi.patch added to -mm tree
Date: Mon, 28 Jan 2013 13:54:20 -0800
Message-ID: <20130128215420.96E0931C25A@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:36821 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3A1VyX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 16:54:23 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so326587yen.4
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 13:54:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: udknight@gmail.com, mingo@elte.hu


The patch titled
     Subject: smp: Fix use un-initialized cpumask_ipi
has been added to the -mm tree.  Its filename is
     smp-fix-use-un-initialized-cpumask_ipi.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang YanQing <udknight@gmail.com>
Subject: smp: Fix use un-initialized cpumask_ipi

c7b798525b502 ("smp: Fix SMP function call empty cpu mask race") use the
un-initialized variable cpumask_ipi when enable CONFIG_CPUMASK_OFFSTACK.

Signed-off-by: Wang YanQing <udknight@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/smp.c~smp-fix-use-un-initialized-cpumask_ipi kernel/smp.c
--- a/kernel/smp.c~smp-fix-use-un-initialized-cpumask_ipi
+++ a/kernel/smp.c
@@ -57,6 +57,9 @@ hotplug_cfd(struct notifier_block *nfb, 
 		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
 				cpu_to_node(cpu)))
 			return notifier_from_errno(-ENOMEM);
+		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
+				cpu_to_node(cpu)))
+			return notifier_from_errno(-ENOMEM);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -66,6 +69,7 @@ hotplug_cfd(struct notifier_block *nfb, 
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		free_cpumask_var(cfd->cpumask);
+		free_cpumask_var(cfd->cpumask_ipi);
 		break;
 #endif
 	};
_

Patches currently in -mm which might be from udknight@gmail.com are

linux-next.patch
smp-fix-use-un-initialized-cpumask_ipi.patch

