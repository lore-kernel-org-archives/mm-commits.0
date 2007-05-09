From: akpm@linux-foundation.org
Subject: - vmstat-use-our-own-timer-events-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 02:03:22 -0700
Message-ID: <200705090903.l4993Mhj018699@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516AbXEIJDc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:03:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, arjan@linux.intel.com, clameter@sgi.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     vmstat-use-our-own-timer-events-fix
has been removed from the -mm tree.  Its filename was
     vmstat-use-our-own-timer-events-fix.patch

This patch was dropped because it was folded into vmstat-use-our-own-timer-events.patch

------------------------------------------------------
Subject: vmstat-use-our-own-timer-events-fix
From: Jiri Slaby <jirislaby@gmail.com>

add missing break

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmstat.c~vmstat-use-our-own-timer-events-fix mm/vmstat.c
--- a/mm/vmstat.c~vmstat-use-our-own-timer-events-fix
+++ a/mm/vmstat.c
@@ -675,6 +675,7 @@ static int __cpuinit vmstat_cpuup_callba
 	case CPU_DOWN_PREPARE_FROZEN:
 		cancel_rearming_delayed_work(&per_cpu(vmstat_work, cpu));
 		per_cpu(vmstat_work, cpu).work.func = NULL;
+		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		start_cpu_timer(cpu);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
