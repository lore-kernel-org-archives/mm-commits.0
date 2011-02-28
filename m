From: akpm@linux-foundation.org
Subject: + cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2.patch added to -mm tree
Date: Mon, 28 Feb 2011 15:23:45 -0800
Message-ID: <201102282323.p1SNNjLi003700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753631Ab1B1XYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 18:24:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com


The patch titled
     cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2
has been added to the -mm tree.  Its filename is
     cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2.patch

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
@@ -1607,26 +1607,26 @@ static int cpuset_write_resmask(struct c
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
mm-notifier_from_errno-cleanup.patch
cgroup-remove-the-ns_cgroup.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-fix.patch
cpuset-hold-callback_mutex-in-cpuset_clone.patch

