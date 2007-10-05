From: akpm@linux-foundation.org
Subject: - some-proc-entries-are-missed-in-sched_domain-sys_ctl-debug.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:58:09 -0700
Message-ID: <200710051958.l95Jw93f022524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51966 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763283AbXJEUBQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nanhai.zou@intel.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     some proc entries are missed in sched_domain sys_ctl debug code
has been removed from the -mm tree.  Its filename was
     some-proc-entries-are-missed-in-sched_domain-sys_ctl-debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: some proc entries are missed in sched_domain sys_ctl debug code
From: Zou Nan hai <nanhai.zou@intel.com>

cache_nice_tries and flags entry do not appear in proc fs sched_domain
directory, because ctl_table entry is skipped.

This patch fix the issue.

Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/sched.c~some-proc-entries-are-missed-in-sched_domain-sys_ctl-debug kernel/sched.c
--- a/kernel/sched.c~some-proc-entries-are-missed-in-sched_domain-sys_ctl-debug
+++ a/kernel/sched.c
@@ -5280,7 +5280,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(14);
+	struct ctl_table *table = sd_alloc_ctl_entry(12);
 
 	set_table_entry(&table[0], "min_interval", &sd->min_interval,
 		sizeof(long), 0644, proc_doulongvec_minmax);
@@ -5300,10 +5300,10 @@ sd_alloc_ctl_domain_table(struct sched_d
 		sizeof(int), 0644, proc_dointvec_minmax);
 	set_table_entry(&table[8], "imbalance_pct", &sd->imbalance_pct,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[10], "cache_nice_tries",
+	set_table_entry(&table[9], "cache_nice_tries",
 		&sd->cache_nice_tries,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[12], "flags", &sd->flags,
+	set_table_entry(&table[10], "flags", &sd->flags,
 		sizeof(int), 0644, proc_dointvec_minmax);
 
 	return table;
_

Patches currently in -mm which might be from nanhai.zou@intel.com are

git-sched.patch
