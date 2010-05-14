From: akpm@linux-foundation.org
Subject: + cpufreq-revert-remove-rwsem-lock-from-cpufreq_gov_stop-call-second-call-site.patch added to -mm tree
Date: Fri, 14 May 2010 15:15:58 -0700
Message-ID: <201005142215.o4EMFw4N025717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968Ab0ENWQW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 May 2010 18:16:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrej.gelenberg@udo.edu, davej@codemonkey.org.uk, mathieu.desnoyers@polymtl.ca, venkatesh.pallipadi@intel.com


The patch titled
     cpufreq: revert "[CPUFREQ] remove rwsem lock from CPUFREQ_GOV_STOP call (second call site)"
has been added to the -mm tree.  Its filename is
     cpufreq-revert-remove-rwsem-lock-from-cpufreq_gov_stop-call-second-call-site.patch

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
Subject: cpufreq: revert "[CPUFREQ] remove rwsem lock from CPUFREQ_GOV_STOP call (second call site)"
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>

395913d0b1db37092ea3d9d69b832183b1dd84c5 ("[CPUFREQ] remove rwsem lock
from CPUFREQ_GOV_STOP call (second call site)") is not needed, because
there is no rwsem lock in cpufreq_ondemand and cpufreq_conservativ
anymore.  Lock should not be released until the work done.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=1594

Signed-off-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~cpufreq-revert-remove-rwsem-lock-from-cpufreq_gov_stop-call-second-call-site drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-revert-remove-rwsem-lock-from-cpufreq_gov_stop-call-second-call-site
+++ a/drivers/cpufreq/cpufreq.c
@@ -1758,17 +1758,8 @@ static int __cpufreq_set_policy(struct c
 			dprintk("governor switch\n");
 
 			/* end old governor */
-			if (data->governor) {
-				/*
-				 * Need to release the rwsem around governor
-				 * stop due to lock dependency between
-				 * cancel_delayed_work_sync and the read lock
-				 * taken in the delayed work handler.
-				 */
-				unlock_policy_rwsem_write(data->cpu);
+			if (data->governor)
 				__cpufreq_governor(data, CPUFREQ_GOV_STOP);
-				lock_policy_rwsem_write(data->cpu);
-			}
 
 			/* start new governor */
 			data->governor = policy->governor;
_

Patches currently in -mm which might be from andrej.gelenberg@udo.edu are

origin.patch
cpufreq-revert-remove-rwsem-lock-from-cpufreq_gov_stop-call-second-call-site.patch

