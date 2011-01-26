From: akpm@linux-foundation.org
Subject: + memsw-handle-swapaccount-kernel-parameter-correctly.patch added to -mm tree
Date: Wed, 26 Jan 2011 14:06:56 -0800
Message-ID: <201101262206.p0QM6uGk007433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754220Ab1AZWHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 17:07:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, stable@kernel.org


The patch titled
     memsw: handle swapaccount kernel parameter correctly
has been added to the -mm tree.  Its filename is
     memsw-handle-swapaccount-kernel-parameter-correctly.patch

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
Subject: memsw: handle swapaccount kernel parameter correctly
From: Michal Hocko <mhocko@suse.cz>

__setup based kernel command line parameters handled in
obsolete_checksetup provides the parameter value including = (more
precisely everything right after the parameter name) so we have to check
for =0 resp.  =1 here.  If no value is given then we get an empty string
rather then NULL.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memsw-handle-swapaccount-kernel-parameter-correctly mm/memcontrol.c
--- a/mm/memcontrol.c~memsw-handle-swapaccount-kernel-parameter-correctly
+++ a/mm/memcontrol.c
@@ -5024,9 +5024,9 @@ struct cgroup_subsys mem_cgroup_subsys =
 static int __init enable_swap_account(char *s)
 {
 	/* consider enabled if no parameter or 1 is given */
-	if (!s || !strcmp(s, "1"))
+	if (!(*s) || !strcmp(s, "=1"))
 		really_do_swap_account = 1;
-	else if (!strcmp(s, "0"))
+	else if (!strcmp(s, "=0"))
 		really_do_swap_account = 0;
 	return 1;
 }
@@ -5034,7 +5034,7 @@ __setup("swapaccount", enable_swap_accou
 
 static int __init disable_swap_account(char *s)
 {
-	enable_swap_account("0");
+	enable_swap_account("=0");
 	return 1;
 }
 __setup("noswapaccount", disable_swap_account);
_

Patches currently in -mm which might be from mhocko@suse.cz are

memsw-handle-swapaccount-kernel-parameter-correctly.patch

