From: akpm@linux-foundation.org
Subject: + keep-rd-online-and-cpu_online_map-in-sync.patch added to -mm tree
Date: Mon, 10 Mar 2008 16:32:16 -0700
Message-ID: <200803102332.m2ANWGBZ011544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbYCJXcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 19:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ghaskins@novell.com, akpm@linux-foundation.org, ego@in.ibm.com, mingo@elte.hu, rjw@sisk.pl, suresh.b.siddha@intel.com


The patch titled
     keep rd->online and cpu_online_map in sync
has been added to the -mm tree.  Its filename is
     keep-rd-online-and-cpu_online_map-in-sync.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keep rd->online and cpu_online_map in sync
From: Gregory Haskins <ghaskins@novell.com>

It is possible to allow the root-domain cache of online cpus to become out of
sync with the global cpu_online_map.  This is because we currently trigger
removal of cpus too early in the notifier chain.  Other DOWN_PREPARE handlers
may in fact run and reconfigure the root-domain topology, thereby stomping on
our own offline handling.

The end result is that rd->online may become out of sync with cpu_online_map,
which results in potential task misrouting.

So change the offline handling to be more tightly coupled with the global
offline process by triggering on CPU_DYING intead of CPU_DOWN_PREPARE.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/sched.c~keep-rd-online-and-cpu_online_map-in-sync kernel/sched.c
--- a/kernel/sched.c~keep-rd-online-and-cpu_online_map-in-sync
+++ a/kernel/sched.c
@@ -5956,7 +5956,8 @@ migration_call(struct notifier_block *nf
 		spin_unlock_irq(&rq->lock);
 		break;
 
-	case CPU_DOWN_PREPARE:
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
 		/* Update our root-domain */
 		rq = cpu_rq(cpu);
 		spin_lock_irqsave(&rq->lock, flags);
_

Patches currently in -mm which might be from ghaskins@novell.com are

git-kvm.patch
keep-rd-online-and-cpu_online_map-in-sync.patch
cpu-hotplug-register-update_sched_domains-notifier-with-higher-prio.patch

