From: akpm@linux-foundation.org
Subject: + cpusets-fix-wrong-domain-attr-updates.patch added to -mm tree
Date: Wed, 16 Jul 2008 02:09:59 -0700
Message-ID: <200807160909.m6G99xcL016108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754201AbYGPJKz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 05:10:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miaox@cn.fujitsu.com, mingo@elte.hu, nickpiggin@yahoo.com.au, pj@sgi.com, seto.hidetoshi@jp.fujitsu.com, stable@kernel.org


The patch titled
     cpusets: fix wrong domain attr updates
has been added to the -mm tree.  Its filename is
     cpusets-fix-wrong-domain-attr-updates.patch

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
@@ -680,7 +680,9 @@ restart:
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

cpusets-fix-wrong-domain-attr-updates.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask-fix.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch

