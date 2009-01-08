From: akpm@linux-foundation.org
Subject: - cpuset-remove-on-stack-cpumask_t-in-cpuset_sprintf_cpulist.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:50:08 -0800
Message-ID: <200901082250.n08Mo8Tm029361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763113AbZAHW7B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:59:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, mingo@elte.hu, rusty@rustcorp.com.au, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: remove on stack cpumask_t in cpuset_sprintf_cpulist()
has been removed from the -mm tree.  Its filename was
     cpuset-remove-on-stack-cpumask_t-in-cpuset_sprintf_cpulist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: remove on stack cpumask_t in cpuset_sprintf_cpulist()
From: Li Zefan <lizf@cn.fujitsu.com>

This patchset converts cpuset to use new cpumask API, and thus
remove on stack cpumask_t to reduce stack usage.

Before:
 # cat kernel/cpuset.c include/linux/cpuset.h | grep -c cpumask_t
 21
After:
 # cat kernel/cpuset.c include/linux/cpuset.h | grep -c cpumask_t
 0


This patch:

Impact: reduce stack usage

It's safe to call cpulist_scnprintf inside callback_mutex, and thus we can
just remove the cpumask_t and no need to allocate a cpumask_var_t.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Mike Travis <travis@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/cpuset.c~cpuset-remove-on-stack-cpumask_t-in-cpuset_sprintf_cpulist kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-remove-on-stack-cpumask_t-in-cpuset_sprintf_cpulist
+++ a/kernel/cpuset.c
@@ -1486,13 +1486,13 @@ static int cpuset_write_resmask(struct c
 
 static int cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
 {
-	cpumask_t mask;
+	int ret;
 
 	mutex_lock(&callback_mutex);
-	mask = cs->cpus_allowed;
+	ret = cpulist_scnprintf(page, PAGE_SIZE, &cs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
-	return cpulist_scnprintf(page, PAGE_SIZE, &mask);
+	return ret;
 }
 
 static int cpuset_sprintf_memlist(char *page, struct cpuset *cs)
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch

