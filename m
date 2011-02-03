From: akpm@linux-foundation.org
Subject: [merged] memsw-handle-swapaccount-kernel-parameter-correctly.patch removed from -mm tree
Date: Thu, 03 Feb 2011 11:45:54 -0800
Message-ID: <201102031945.p13JjsWT020954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756453Ab1BCTqH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 14:46:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     memsw: handle swapaccount kernel parameter correctly
has been removed from the -mm tree.  Its filename was
     memsw-handle-swapaccount-kernel-parameter-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memsw: handle swapaccount kernel parameter correctly
From: Michal Hocko <mhocko@suse.cz>

__setup based kernel command line parameters handlers which are handled in
obsolete_checksetup are provided with the parameter value including =
(more precisely everything right after the parameter name).

This means that the current implementation of swapaccount[=1|0] doesn't
work at all because if there is a value for the parameter then we are
testing for "0" resp.  "1" but we are getting "=0" resp.  "=1" and if
there is no parameter value we are getting an empty string rather than
NULL.

The original noswapccount parameter, which doesn't care about the value,
works correctly.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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

origin.patch
memsw-remove-noswapaccount-kernel-parameter.patch

