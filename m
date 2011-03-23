From: akpm@linux-foundation.org
Subject: [folded] cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:21:46 -0700
Message-ID: <201103232321.p2NNLk3G004458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932972Ab1CWXWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:22:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2
has been removed from the -mm tree.  Its filename was
     cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2.patch

This patch was dropped because it was folded into cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2
From: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN kernel/cpuset.c~cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2 kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2
+++ a/kernel/cpuset.c
@@ -1610,26 +1610,26 @@ out:
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
-	int retval;
+	size_t count;
 
 	mutex_lock(&callback_mutex);
-	retval = nodelist_scnprintf(page, PAGE_SIZE, cs->mems_allowed);
+	count = nodelist_scnprintf(page, PAGE_SIZE, cs->mems_allowed);
 	mutex_unlock(&callback_mutex);
 
-	return retval;
+	return count;
 }
 
 static ssize_t cpuset_common_file_read(struct cgroup *cont,
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-v2.patch
cpuset-hold-callback_mutex-in-cpuset_clone.patch

