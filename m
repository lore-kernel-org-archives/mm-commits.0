From: akpm@linux-foundation.org
Subject: - cpusetc-remove-extra-variable.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:41 -0700
Message-ID: <200810202036.m9KKafqm011433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752310AbYJTUhd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:37:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset.c: remove extra variable
has been removed from the -mm tree.  Its filename was
     cpusetc-remove-extra-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset.c: remove extra variable
From: "Rakib Mullick" <rakib.mullick@gmail.com>

Remove the use of int cpus_nonempty variable from 'update_flag' function.

Signed-off-by: Md.Rakib H. Mullick <rakib.mullick@gmail.com>
Acked-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/cpuset.c~cpusetc-remove-extra-variable kernel/cpuset.c
--- a/kernel/cpuset.c~cpusetc-remove-extra-variable
+++ a/kernel/cpuset.c
@@ -1172,7 +1172,7 @@ static int update_flag(cpuset_flagbits_t
 {
 	struct cpuset trialcs;
 	int err;
-	int cpus_nonempty, balance_flag_changed;
+	int balance_flag_changed;
 
 	trialcs = *cs;
 	if (turning_on)
@@ -1184,7 +1184,6 @@ static int update_flag(cpuset_flagbits_t
 	if (err < 0)
 		return err;
 
-	cpus_nonempty = !cpus_empty(trialcs.cpus_allowed);
 	balance_flag_changed = (is_sched_load_balance(cs) !=
 		 			is_sched_load_balance(&trialcs));
 
@@ -1192,7 +1191,7 @@ static int update_flag(cpuset_flagbits_t
 	cs->flags = trialcs.flags;
 	mutex_unlock(&callback_mutex);
 
-	if (cpus_nonempty && balance_flag_changed)
+	if (!cpus_empty(trialcs.cpus_allowed) && balance_flag_changed)
 		async_rebuild_sched_domains();
 
 	return 0;
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

origin.patch

