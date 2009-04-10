From: akpm@linux-foundation.org
Subject: + memcg-remove-warning-when-config_debug_vm=n.patch added to -mm tree
Date: Thu, 09 Apr 2009 22:22:50 -0700
Message-ID: <200904100522.n3A5MoqW009688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076AbZDJFZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 01:25:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com


The patch titled
     memcg: remove warning when CONFIG_DEBUG_VM=n
has been added to the -mm tree.  Its filename is
     memcg-remove-warning-when-config_debug_vm=n.patch

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
Subject: memcg: remove warning when CONFIG_DEBUG_VM=n
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

mm/memcontrol.c:318: warning: `mem_cgroup_is_obsolete' defined but not used

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-remove-warning-when-config_debug_vm=n mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-warning-when-config_debug_vm=n
+++ a/mm/memcontrol.c
@@ -314,13 +314,14 @@ static struct mem_cgroup *try_get_mem_cg
 	return mem;
 }
 
+#ifdef CONFIG_DEBUG_VM
 static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
 {
 	if (!mem)
 		return true;
 	return css_is_removed(&mem->css);
 }
