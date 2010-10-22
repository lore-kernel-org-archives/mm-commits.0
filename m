From: akpm@linux-foundation.org
Subject: + isdn-capi-unregister-capictr-notifier-after-init-failure.patch added to -mm tree
Date: Fri, 22 Oct 2010 13:05:56 -0700
Message-ID: <201010222005.o9MK5u7X004946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754968Ab0JVUGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 16:06:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, isdn@linux-pingi.de, jan.kiszka@web.de, mac@melware.de


The patch titled
     isdn/capi: unregister capictr notifier after init failure
has been added to the -mm tree.  Its filename is
     isdn-capi-unregister-capictr-notifier-after-init-failure.patch

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
Subject: isdn/capi: unregister capictr notifier after init failure
From: Tejun Heo <tj@kernel.org>

capidrv_init() could leave capictr notifier dangling after init failure. 
Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: Armin Schindler <mac@melware.de>
Cc: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capidrv.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/isdn/capi/capidrv.c~isdn-capi-unregister-capictr-notifier-after-init-failure drivers/isdn/capi/capidrv.c
--- a/drivers/isdn/capi/capidrv.c~isdn-capi-unregister-capictr-notifier-after-init-failure
+++ a/drivers/isdn/capi/capidrv.c
@@ -2297,6 +2297,7 @@ static int __init capidrv_init(void)
 
 	errcode = capi20_get_profile(0, &profile);
 	if (errcode != CAPI_NOERROR) {
+		unregister_capictr_notifier(&capictr_nb);
 		capi20_release(&global.ap);
 		return -EIO;
 	}
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
percpu-fix-list_head-init-bug-in-__percpu_counter_init.patch
linux-next.patch
isdn-capi-unregister-capictr-notifier-after-init-failure.patch
isdn-capi-make-kcapi-use-a-separate-workqueue.patch
stop_machine-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
percpu_counter-add-debugobj-support.patch
percpu_counter-use-this_cpu_ptr-instead-of-per_cpu_ptr.patch
pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-add-async-pps-event-handler.patch
pps-add-async-pps-event-handler-fix.patch
pps-dont-disable-interrupts-when-using-spin-locks.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

