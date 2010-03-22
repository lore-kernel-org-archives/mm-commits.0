From: akpm@linux-foundation.org
Subject: + md-convert-cpu-notifier-to-return-encapsulate-errno-value.patch added to -mm tree
Date: Mon, 22 Mar 2010 14:49:27 -0700
Message-ID: <201003222149.o2MLnRXD029455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755764Ab0CVVt4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 17:49:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, neilb@suse.de


The patch titled
     md: convert cpu notifier to return encapsulate errno value
has been added to the -mm tree.  Its filename is
     md-convert-cpu-notifier-to-return-encapsulate-errno-value.patch

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
Subject: md: convert cpu notifier to return encapsulate errno value
From: Akinobu Mita <akinobu.mita@gmail.com>

By the previous modification, the cpu notifier can return encapsulate
errno value.  This converts the cpu notifiers for raid5.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/raid5.c~md-convert-cpu-notifier-to-return-encapsulate-errno-value drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/drivers/md/raid5.c
@@ -4659,7 +4659,7 @@ static int raid456_cpu_notify(struct not
 			kfree(percpu->scribble);
 			pr_err("%s: failed memory allocation for cpu%ld\n",
 			       __func__, cpu);
-			return NOTIFY_BAD;
+			return notifier_from_errno(-ENOMEM);
 		}
 		break;
 	case CPU_DEAD:
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

