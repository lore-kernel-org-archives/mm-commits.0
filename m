From: akpm@linux-foundation.org
Subject: + s390-convert-cpu-notifier-to-return-encapsulate-errno-value.patch added to -mm tree
Date: Mon, 22 Mar 2010 14:49:25 -0700
Message-ID: <201003222149.o2MLnQdV029452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756560Ab0CVVtf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 17:49:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     s390: convert cpu notifier to return encapsulate errno value
has been added to the -mm tree.  Its filename is
     s390-convert-cpu-notifier-to-return-encapsulate-errno-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390: convert cpu notifier to return encapsulate errno value
From: Akinobu Mita <akinobu.mita@gmail.com>

By the previous modification, the cpu notifier can return encapsulate
errno value.  This converts the cpu notifiers for s390.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/smp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/s390/kernel/smp.c~s390-convert-cpu-notifier-to-return-encapsulate-errno-value arch/s390/kernel/smp.c
--- a/arch/s390/kernel/smp.c~s390-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/arch/s390/kernel/smp.c
@@ -943,21 +943,21 @@ static int __cpuinit smp_cpu_notify(stru
 	struct cpu *c = &per_cpu(cpu_devices, cpu);
 	struct sys_device *s = &c->sysdev;
 	struct s390_idle_data *idle;
+	int err = 0;
 
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		idle = &per_cpu(s390_idle, cpu);
 		memset(idle, 0, sizeof(struct s390_idle_data));
-		if (sysfs_create_group(&s->kobj, &cpu_online_attr_group))
-			return NOTIFY_BAD;
+		err = sysfs_create_group(&s->kobj, &cpu_online_attr_group);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		sysfs_remove_group(&s->kobj, &cpu_online_attr_group);
 		break;
 	}
-	return NOTIFY_OK;
+	return notifier_from_errno(err);
 }
 
 static struct notifier_block __cpuinitdata smp_cpu_nb = {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

intel-iommu-use-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
cpu-hotplug-introduce-cpu_notify-__cpu_notify-cpu_notify_nofail.patch
cpu-hotplug-return-better-errno-on-cpu-hotplug-failure.patch
notifier-change-notifier_from_errno0-to-return-notify_ok.patch
x86-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
topology-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
kernel-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
slab-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
iucv-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
ehca-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
s390-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
md-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
fault-injection-add-cpu-notifier-error-injection-module.patch
bitops-remove-temporary-for_each_bit.patch

