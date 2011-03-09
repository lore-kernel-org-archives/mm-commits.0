From: akpm@linux-foundation.org
Subject: + sysctl-add-some-missing-input-constraint-checks.patch added to -mm tree
Date: Tue, 08 Mar 2011 16:51:46 -0800
Message-ID: <201103090051.p290pkcu005004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756687Ab1CIAwv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Mar 2011 19:52:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pholasek@redhat.com, adobriyan@gmail.com, fengguang.wu@intel.com, hidave.darkstar@gmail.com, rientjes@google.com


The patch titled
     sysctl: add some missing input constraint checks
has been added to the -mm tree.  Its filename is
     sysctl-add-some-missing-input-constraint-checks.patch

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
Subject: sysctl: add some missing input constraint checks
From: Petr Holasek <pholasek@redhat.com>

Add boundaries of allowed input ranges for: dirty_expire_centisecs,
drop_caches, overcommit_memory, page-cluster and panic_on_oom.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
Acked-by: Dave Young <hidave.darkstar@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/drop_caches.c |    6 +++++-
 kernel/sysctl.c  |   17 +++++++++++++----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff -puN fs/drop_caches.c~sysctl-add-some-missing-input-constraint-checks fs/drop_caches.c
--- a/fs/drop_caches.c~sysctl-add-some-missing-input-constraint-checks
+++ a/fs/drop_caches.c
@@ -45,7 +45,11 @@ static void drop_slab(void)
 int drop_caches_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
-	proc_dointvec_minmax(table, write, buffer, length, ppos);
+	int ret;
+
+	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (ret)
+		return ret;
 	if (write) {
 		if (sysctl_drop_caches & 1)
 			iterate_supers(drop_pagecache_sb, NULL);
diff -puN kernel/sysctl.c~sysctl-add-some-missing-input-constraint-checks kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-add-some-missing-input-constraint-checks
+++ a/kernel/sysctl.c
@@ -117,6 +117,7 @@ static int neg_one = -1;
 static int zero;
 static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
+static int __maybe_unused three = 3;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
 #ifdef CONFIG_PRINTK
@@ -963,14 +964,18 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_overcommit_memory,
 		.maxlen		= sizeof(sysctl_overcommit_memory),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &two,
 	},
 	{
 		.procname	= "panic_on_oom",
 		.data		= &sysctl_panic_on_oom,
 		.maxlen		= sizeof(sysctl_panic_on_oom),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &two,
 	},
 	{
 		.procname	= "oom_kill_allocating_task",
@@ -998,7 +1003,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &page_cluster,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
 	},
 	{
 		.procname	= "dirty_background_ratio",
@@ -1046,7 +1052,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &dirty_expire_interval,
 		.maxlen		= sizeof(dirty_expire_interval),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
 	},
 	{
 		.procname	= "nr_pdflush_threads",
@@ -1122,6 +1129,8 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= drop_caches_sysctl_handler,
+		.extra1		= &one,
+		.extra2		= &three,
 	},
 #ifdef CONFIG_COMPACTION
 	{
_

Patches currently in -mm which might be from pholasek@redhat.com are

hugetlbfs-correct-handling-of-negative-input-to-proc-sys-vm-nr_hugepages.patch
sysctl-add-some-missing-input-constraint-checks.patch

