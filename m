From: akpm@linux-foundation.org
Subject: + topology-convert-cpu-notifier-to-return-encapsulate-errno-value.patch added to -mm tree
Date: Mon, 22 Mar 2010 14:49:11 -0700
Message-ID: <201003222149.o2MLnB7r029431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756545Ab0CVVtW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 17:49:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, gregkh@suse.de


The patch titled
     topology: convert cpu notifier to return encapsulate errno value
has been added to the -mm tree.  Its filename is
     topology-convert-cpu-notifier-to-return-encapsulate-errno-value.patch

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
Subject: topology: convert cpu notifier to return encapsulate errno value
From: Akinobu Mita <akinobu.mita@gmail.com>

By the previous modification, the cpu notifier can return encapsulate
errno value.  This converts the cpu notifiers for topology.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/topology.c~topology-convert-cpu-notifier-to-return-encapsulate-errno-value drivers/base/topology.c
--- a/drivers/base/topology.c~topology-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/drivers/base/topology.c
@@ -162,7 +162,7 @@ static int __cpuinit topology_cpu_callba
 		topology_remove_dev(cpu);
 		break;
 	}
-	return rc ? NOTIFY_BAD : NOTIFY_OK;
+	return notifier_from_errno(rc);
 }
 
 static int __cpuinit topology_sysfs_init(void)
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

