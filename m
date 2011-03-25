From: akpm@linux-foundation.org
Subject: [merged] cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:24 -0700
Message-ID: <201103250725.p2P7PImn026011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933937Ab1CYHZZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: remove unneeded NODEMASK_ALLOC() in cpuset_sprintf_memlist()
has been removed from the -mm tree.  Its filename was
     cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: remove unneeded NODEMASK_ALLOC() in cpuset_sprintf_memlist()
From: Li Zefan <lizf@cn.fujitsu.com>

It's not necessary to copy cpuset->mems_allowed to a buffer allocated by
NODEMASK_ALLOC().  Just pass it to nodelist_scnprintf().

As spotted by Paul, a side effect is we fix a bug that the function can
return -ENOMEM but the caller doesn't expect negative return value. 
Therefore change the return value of cpuset_sprintf_cpulist() and
cpuset_sprintf_memlist() from int to size_t.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff -puN kernel/cpuset.c~cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist
+++ a/kernel/cpuset.c
@@ -1610,34 +1610,26 @@ out:
  * across a page fault.
  */
 
-static int cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
+static size_t cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
 {
-	int ret;
+	size_t count;
 
 	mutex_lock(&callback_mutex);
-	ret = cpulist_scnprintf(page, PAGE_SIZE, cs->cpus_allowed);
+	count = cpulist_scnprintf(page, PAGE_SIZE, cs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
-	return ret;
+	return count;
 }
 
-static int cpuset_sprintf_memlist(char *page, struct cpuset *cs)
+static size_t cpuset_sprintf_memlist(char *page, struct cpuset *cs)
 {
-	NODEMASK_ALLOC(nodemask_t, mask, GFP_KERNEL);
-	int retval;
-
-	if (mask == NULL)
-		return -ENOMEM;
+	size_t count;
 
 	mutex_lock(&callback_mutex);
-	*mask = cs->mems_allowed;
+	count = nodelist_scnprintf(page, PAGE_SIZE, cs->mems_allowed);
 	mutex_unlock(&callback_mutex);
 
-	retval = nodelist_scnprintf(page, PAGE_SIZE, *mask);
-
-	NODEMASK_FREE(mask);
