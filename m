From: akpm@linux-foundation.org
Subject: + memsw-remove-noswapaccount-kernel-parameter.patch added to -mm tree
Date: Fri, 28 Jan 2011 14:39:36 -0800
Message-ID: <201101282239.p0SMdaCn031547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702Ab1A1Wjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Jan 2011 17:39:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, balbir@linux.vnet.ibm.com, kamezawa.hiroyuki@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memsw: remove noswapaccount kernel parameter
has been added to the -mm tree.  Its filename is
     memsw-remove-noswapaccount-kernel-parameter.patch

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
Subject: memsw: remove noswapaccount kernel parameter
From: Michal Hocko <mhocko@suse.cz>

The noswapaccount parameter has been deprecated since 2.6.38 without any
complaints from users so we can remove it.  swapaccount=0|1 can be used
instead.

As we are removing the parameter we can also clean up swapaccount because
it doesn't have to accept an empty string anymore (to match noswapaccount)
and so we can push = into __setup macro rather than checking "=1" resp. 
"=0" strings

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 ---
 mm/memcontrol.c                     |   13 +++----------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff -puN Documentation/kernel-parameters.txt~memsw-remove-noswapaccount-kernel-parameter Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~memsw-remove-noswapaccount-kernel-parameter
+++ a/Documentation/kernel-parameters.txt
@@ -1746,9 +1746,6 @@ and is between 256 and 4096 characters. 
 
 	nosoftlockup	[KNL] Disable the soft-lockup detector.
 
-	noswapaccount	[KNL] Disable accounting of swap in memory resource
-			controller. (See Documentation/cgroups/memory.txt)
-
 	nosync		[HW,M68K] Disables sync negotiation for all devices.
 
 	notsc		[BUGS=X86-32] Disable Time Stamp Counter
diff -puN mm/memcontrol.c~memsw-remove-noswapaccount-kernel-parameter mm/memcontrol.c
--- a/mm/memcontrol.c~memsw-remove-noswapaccount-kernel-parameter
+++ a/mm/memcontrol.c
@@ -5024,19 +5024,12 @@ struct cgroup_subsys mem_cgroup_subsys =
 static int __init enable_swap_account(char *s)
 {
 	/* consider enabled if no parameter or 1 is given */
-	if (!(*s) || !strcmp(s, "=1"))
+	if (!strcmp(s, "1"))
 		really_do_swap_account = 1;
-	else if (!strcmp(s, "=0"))
+	else if (!strcmp(s, "0"))
 		really_do_swap_account = 0;
 	return 1;
 }
-__setup("swapaccount", enable_swap_account);
+__setup("swapaccount=", enable_swap_account);
 
-static int __init disable_swap_account(char *s)
-{
-	printk_once("noswapaccount is deprecated and will be removed in 2.6.40. Use swapaccount=0 instead\n");
-	enable_swap_account("=0");
-	return 1;
-}
-__setup("noswapaccount", disable_swap_account);
 #endif
_

Patches currently in -mm which might be from mhocko@suse.cz are

memsw-handle-swapaccount-kernel-parameter-correctly.patch
memsw-deprecate-noswapaccount-kernel-parameter-and-schedule-it-for-removal.patch
memsw-remove-noswapaccount-kernel-parameter.patch

