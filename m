From: akpm@linux-foundation.org
Subject: - cpusets-fix-wrong-domain-attr-updates.patch removed from -mm tree
Date: Tue, 22 Jul 2008 14:32:17 -0700
Message-ID: <200807222132.m6MLWHfs018700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753388AbYGVVdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 17:33:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miaox@cn.fujitsu.com, mingo@elte.hu, nickpiggin@yahoo.com.au, pj@sgi.com, seto.hidetoshi@jp.fujitsu.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cpusets: fix wrong domain attr updates
has been removed from the -mm tree.  Its filename was
     cpusets-fix-wrong-domain-attr-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: fix wrong domain attr updates
From: Miao Xie <miaox@cn.fujitsu.com>

Fix wrong domain attr updates, or we will always update the first sched
domain attr.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>	[2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/cpuset.c~cpusets-fix-wrong-domain-attr-updates kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-fix-wrong-domain-attr-updates
+++ a/kernel/cpuset.c
@@ -679,7 +679,9 @@ restart:
 				if (apn == b->pn) {
 					cpus_or(*dp, *dp, b->cpus_allowed);
 					b->pn = -1;
-					update_domain_attr(dattr, b);
+					if (dattr)
+						update_domain_attr(dattr
+								   + nslot, b);
 				}
 			}
 			nslot++;
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

origin.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask-fix.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch

