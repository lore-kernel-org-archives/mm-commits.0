From: akpm@linux-foundation.org
Subject: + cgroups-make-swap-accounting-default-behavior-configurable-update.patch added to -mm tree
Date: Thu, 18 Nov 2010 15:09:37 -0800
Message-ID: <201011182309.oAIN9bUC010653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757669Ab0KRXK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Nov 2010 18:10:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     cgroups-make-swap-accounting-default-behavior-configurable-update
has been added to the -mm tree.  Its filename is
     cgroups-make-swap-accounting-default-behavior-configurable-update.patch

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
Subject: cgroups-make-swap-accounting-default-behavior-configurable-update
From: Michal Hocko <mhocko@suse.cz>

Changes since v3:
* add 0|1 parameter values handling

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 ++++--
 mm/memcontrol.c                     |    8 ++++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-parameters.txt~cgroups-make-swap-accounting-default-behavior-configurable-update Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~cgroups-make-swap-accounting-default-behavior-configurable-update
+++ a/Documentation/kernel-parameters.txt
@@ -2385,8 +2385,10 @@ and is between 256 and 4096 characters. 
 			improve throughput, but will also increase the
 			amount of memory reserved for use by the client.
 
-	swapaccount	[KNL] Enable accounting of swap in memory resource
-			controller. (See Documentation/cgroups/memory.txt)
+	swapaccount[=0|1]
+			[KNL] Enable accounting of swap in memory resource
+			controller if no parameter or 1 is given or disable
+			it if 0 is given (See Documentation/cgroups/memory.txt)
 
 	swiotlb=	[IA-64] Number of I/O TLB slabs
 
diff -puN mm/memcontrol.c~cgroups-make-swap-accounting-default-behavior-configurable-update mm/memcontrol.c
--- a/mm/memcontrol.c~cgroups-make-swap-accounting-default-behavior-configurable-update
+++ a/mm/memcontrol.c
@@ -4929,14 +4929,18 @@ struct cgroup_subsys mem_cgroup_subsys =
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 static int __init enable_swap_account(char *s)
 {
-	really_do_swap_account = 1;
+	/* consider enabled if no parameter or 1 is given */
+	if (!s || !strcmp(s, "1"))
+		really_do_swap_account = 1;
+	else if (!strcmp(s, "0"))
+		really_do_swap_account = 0;
 	return 1;
 }
 __setup("swapaccount", enable_swap_account);
 
 static int __init disable_swap_account(char *s)
 {
-	really_do_swap_account = 0;
+	enable_swap_account("0");
 	return 1;
 }
 __setup("noswapaccount", disable_swap_account);
_

Patches currently in -mm which might be from mhocko@suse.cz are

cgroups-make-swap-accounting-default-behavior-configurable.patch
cgroups-make-swap-accounting-default-behavior-configurable-update.patch

