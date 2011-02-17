From: akpm@linux-foundation.org
Subject: + cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch added to -mm tree
Date: Thu, 17 Feb 2011 14:47:45 -0800
Message-ID: <201102172247.p1HMljGt020468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372Ab1BQWsW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Feb 2011 17:48:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com


The patch titled
     cpuset: remove unneeded NODEMASK_ALLOC() in cpuset_sprintf_memlist()
has been added to the -mm tree.  Its filename is
     cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch

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
Subject: cpuset: remove unneeded NODEMASK_ALLOC() in cpuset_sprintf_memlist()
From: Li Zefan <lizf@cn.fujitsu.com>

It's not necessary to copy cpuset->mems_allowed to a buffer allocated by
NODEMASK_ALLOC().  Just pass it to nodelist_scnprintf().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN kernel/cpuset.c~cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist
+++ a/kernel/cpuset.c
@@ -1620,20 +1620,12 @@ static int cpuset_sprintf_cpulist(char *
 
 static int cpuset_sprintf_memlist(char *page, struct cpuset *cs)
 {
-	NODEMASK_ALLOC(nodemask_t, mask, GFP_KERNEL);
 	int retval;
 
-	if (mask == NULL)
-		return -ENOMEM;
-
 	mutex_lock(&callback_mutex);
-	*mask = cs->mems_allowed;
+	retval = nodelist_scnprintf(page, PAGE_SIZE, cs->mems_allowed);
 	mutex_unlock(&callback_mutex);
 
-	retval = nodelist_scnprintf(page, PAGE_SIZE, *mask);
-
-	NODEMASK_FREE(mask);
