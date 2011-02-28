From: akpm@linux-foundation.org
Subject: + cpuset-add-a-missing-unlock-in-cpuset_write_resmask.patch added to -mm tree
Date: Mon, 28 Feb 2011 15:57:59 -0800
Message-ID: <201102282357.p1SNvxav005453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754758Ab1B1X6f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 18:58:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com, stable@kernel.org


The patch titled
     cpuset: add a missing unlock in cpuset_write_resmask()
has been added to the -mm tree.  Its filename is
     cpuset-add-a-missing-unlock-in-cpuset_write_resmask.patch

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
Subject: cpuset: add a missing unlock in cpuset_write_resmask()
From: Li Zefan <lizf@cn.fujitsu.com>

Don't forget to release cgroup_mutex if alloc_trial_cpuset() fails.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/cpuset.c~cpuset-add-a-missing-unlock-in-cpuset_write_resmask kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-add-a-missing-unlock-in-cpuset_write_resmask
+++ a/kernel/cpuset.c
@@ -1575,8 +1575,10 @@ static int cpuset_write_resmask(struct c
 		return -ENODEV;
 
 	trialcs = alloc_trial_cpuset(cs);
-	if (!trialcs)
+	if (!trialcs) {
+		cgroup_unlock();
 		return -ENOMEM;
+	}
 
 	switch (cft->private) {
 	case FILE_CPULIST:
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
cpuset-add-a-missing-unlock-in-cpuset_write_resmask.patch
cpuset-add-a-missing-unlock-in-cpuset_write_resmask-fix.patch
mm-notifier_from_errno-cleanup.patch
cgroup-remove-the-ns_cgroup.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-v2.patch
cpuset-hold-callback_mutex-in-cpuset_clone.patch

