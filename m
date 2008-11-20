From: akpm@linux-foundation.org
Subject: + memory-cgroup-hierarchy-feature-selector-v4-fix.patch added to -mm tree
Date: Thu, 20 Nov 2008 13:45:51 -0800
Message-ID: <200811202145.mAKLjpPL007690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755468AbYKTVqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 16:46:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     Memory cgroup fix hierarchy selector
has been added to the -mm tree.  Its filename is
     memory-cgroup-hierarchy-feature-selector-v4-fix.patch

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
Subject: Memory cgroup fix hierarchy selector
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Andrew and Li reviewed and found that we need to check for val being 1 or
0 for the root container as well.  use_hierarchy's type is changed to
bool.  We still continue to use the ease of write_X64 for writing to it
and then check if the values are sane.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memory-cgroup-hierarchy-feature-selector-v4-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memory-cgroup-hierarchy-feature-selector-v4-fix
+++ a/mm/memcontrol.c
@@ -152,7 +152,7 @@ struct mem_cgroup {
 	/*
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
-	unsigned long use_hierarchy;
+	bool use_hierarchy;
 
 	int		obsolete;
 	atomic_t	refcnt;
@@ -1567,8 +1567,8 @@ static int mem_cgroup_hierarchy_write(st
 	 * For the root cgroup, parent_mem is NULL, we allow value to be
 	 * set if there are no children.
 	 */
-	if (!parent_mem || (!parent_mem->use_hierarchy &&
-				(val == 1 || val == 0))) {
+	if ((!parent_mem || !parent_mem->use_hierarchy) &&
+				(val == 1 || val == 0)) {
 		if (list_empty(&cont->children))
 			mem->use_hierarchy = val;
 		else
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
linux-next.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-swap-cgroup-for-remembering-usage-fix-4.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch

