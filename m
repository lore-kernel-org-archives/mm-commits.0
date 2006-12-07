From: akpm@osdl.org
Subject: - cpuset-minor-code-refinements.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:19 -0800
Message-ID: <200612072302.kB7N2JAx029841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51669 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163783AbWLGXCV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: minor code refinements
has been removed from the -mm tree.  Its filename was
     cpuset-minor-code-refinements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpuset: minor code refinements
From: Paul Jackson <pj@sgi.com>

A couple of minor code simplifications to the kernel/cpuset.c code.  No
functional change.  Just a little less code and a little more readable.

Signed-off-by: Paul Jackson <pj@sgi.com>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/cpuset.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/cpuset.c~cpuset-minor-code-refinements kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-minor-code-refinements
+++ a/kernel/cpuset.c
@@ -729,9 +729,11 @@ static int validate_change(const struct 
 	}
 
 	/* Remaining checks don't apply to root cpuset */
-	if ((par = cur->parent) == NULL)
+	if (cur == &top_cpuset)
 		return 0;
 
+	par = cur->parent;
+
 	/* We must be a subset of our parent cpuset */
 	if (!is_cpuset_subset(trial, par))
 		return -EACCES;
@@ -1060,10 +1062,7 @@ static int update_flag(cpuset_flagbits_t
 	cpu_exclusive_changed =
 		(is_cpu_exclusive(cs) != is_cpu_exclusive(&trialcs));
 	mutex_lock(&callback_mutex);
-	if (turning_on)
-		set_bit(bit, &cs->flags);
-	else
-		clear_bit(bit, &cs->flags);
+	cs->flags = trialcs.flags;
 	mutex_unlock(&callback_mutex);
 
 	if (cpu_exclusive_changed)
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
mm-fallback_alloc-cpuset_zone_allowed-irq-fix.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch

