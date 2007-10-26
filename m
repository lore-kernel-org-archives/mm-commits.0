From: akpm@linux-foundation.org
Subject: - fix-sched_domain-sysctl-registration-again.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:48:26 -0700
Message-ID: <200710261848.l9QImQPC009138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763210AbXJZSsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:48:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miltonm@bga.com, mingo@elte.hu, nickpiggin@yahoo.com.au, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sched: fix sched_domain sysctl registration again
has been removed from the -mm tree.  Its filename was
     fix-sched_domain-sysctl-registration-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: fix sched_domain sysctl registration again
From: Milton Miller <miltonm@bga.com>

commit 029190c515f15f512ac85de8fc686d4dbd0ae731 (cpuset sched_load_balance
flag) was not tested SCHED_DEBUG enabled as committed as it dereferences
NULL when used and it reordered the sysctl registration to cause it to
never show any domains or their tunables.

Fixes:

1) restore arch_init_sched_domains ordering
	we can't walk the domains before we build them

	presently we register cpus with empty directories (no domain
	directories or files).

2) make unregister_sched_domain_sysctl do nothing when already unregistered
	detach_destroy_domains is now called one set of cpus at a time
	unregister_syctl dereferences NULL if called with a null.

	While the the function would always dereference null if called
	twice, in the previous code it was always called once and then
	was followed a register.  So only the hidden bug of the
	sysctl_root_table not being allocated followed by an attempt to
	free it would have shown the error.

3) always call unregister and register in partition_sched_domains
	The code is "smart" about unregistering only needed domains.
	Since we aren't guaranteed any calls to unregister, always
	unregister.   Without calling register on the way out we
	will not have a table or any sysctl tree.

4) warn if register is called without unregistering
	The previous table memory is lost, leaving pointers to the
	later freed memory in sysctl and leaking the memory of the
	tables.

Signed-off-by: Milton Miller <miltonm@bga.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff -puN kernel/sched.c~fix-sched_domain-sysctl-registration-again kernel/sched.c
--- a/kernel/sched.c~fix-sched_domain-sysctl-registration-again
+++ a/kernel/sched.c
@@ -5461,11 +5461,12 @@ static void register_sched_domain_sysctl
 	struct ctl_table *entry = sd_alloc_ctl_entry(cpu_num + 1);
 	char buf[32];
 
+	WARN_ON(sd_ctl_dir[0].child);
+	sd_ctl_dir[0].child = entry;
+
 	if (entry == NULL)
 		return;
 
-	sd_ctl_dir[0].child = entry;
-
 	for_each_online_cpu(i) {
 		snprintf(buf, 32, "cpu%d", i);
 		entry->procname = kstrdup(buf, GFP_KERNEL);
@@ -5473,14 +5474,19 @@ static void register_sched_domain_sysctl
 		entry->child = sd_alloc_ctl_cpu_table(i);
 		entry++;
 	}
+
+	WARN_ON(sd_sysctl_header);
 	sd_sysctl_header = register_sysctl_table(sd_ctl_root);
 }
 
+/* may be called multiple times per register */
 static void unregister_sched_domain_sysctl(void)
 {
-	unregister_sysctl_table(sd_sysctl_header);
+	if (sd_sysctl_header)
+		unregister_sysctl_table(sd_sysctl_header);
 	sd_sysctl_header = NULL;
-	sd_free_ctl_entry(&sd_ctl_dir[0].child);
+	if (sd_ctl_dir[0].child)
+		sd_free_ctl_entry(&sd_ctl_dir[0].child);
 }
 #else
 static void register_sched_domain_sysctl(void)
@@ -6424,13 +6430,17 @@ static cpumask_t fallback_doms;
  */
 static int arch_init_sched_domains(const cpumask_t *cpu_map)
 {
+	int err;
+
 	ndoms_cur = 1;
 	doms_cur = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
 	if (!doms_cur)
 		doms_cur = &fallback_doms;
 	cpus_andnot(*doms_cur, *cpu_map, cpu_isolated_map);
+	err = build_sched_domains(doms_cur);
 	register_sched_domain_sysctl();
-	return build_sched_domains(doms_cur);
+
+	return err;
 }
 
 static void arch_destroy_sched_domains(const cpumask_t *cpu_map)
@@ -6479,6 +6489,9 @@ void partition_sched_domains(int ndoms_n
 {
 	int i, j;
 
+	/* always unregister in case we don't destroy any domains */
+	unregister_sched_domain_sysctl();
+
 	if (doms_new == NULL) {
 		ndoms_new = 1;
 		doms_new = &fallback_doms;
@@ -6514,6 +6527,8 @@ match2:
 		kfree(doms_cur);
 	doms_cur = doms_new;
 	ndoms_cur = ndoms_new;
+
+	register_sched_domain_sysctl();
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
_

Patches currently in -mm which might be from miltonm@bga.com are

origin.patch
