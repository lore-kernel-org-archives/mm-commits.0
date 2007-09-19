From: akpm@linux-foundation.org
Subject: + some-proc-entries-are-missed-in-sched_domain-sys_ctl-debug.patch added to -mm tree
Date: Tue, 18 Sep 2007 21:58:23 -0700
Message-ID: <200709190458.l8J4wNP9007694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60011 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbXISE7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Sep 2007 00:59:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nanhai.zou@intel.com, mingo@elte.hu


The patch titled
     some proc entries are missed in sched_domain sys_ctl debug code
has been added to the -mm tree.  Its filename is
     some-proc-entries-are-missed-in-sched_domain-sys_ctl-debug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -5312,7 +5312,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(14);
+	struct ctl_table *table = sd_alloc_ctl_entry(12);
 
 	set_table_entry(&table[0], "min_interval", &sd->min_interval,
 		sizeof(long), 0644, proc_doulongvec_minmax);
@@ -5332,10 +5332,10 @@ sd_alloc_ctl_domain_table(struct sched_d
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

some-proc-entries-are-missed-in-sched_domain-sys_ctl-debug.patch
