From: akpm@linux-foundation.org
Subject: + mm-pcp-allow-restoring-percpu_pagelist_fraction-default.patch
 added to -mm tree
Date: Thu, 12 Jun 2014 11:59:16 -0700
Message-ID: <5399f884.3ZTrcyYhoyG2f3wc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbaFLS7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jun 2014 14:59:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, green@linuxhacker.ru, rientjes@google.com

Subject: + mm-pcp-allow-restoring-percpu_pagelist_fraction-default.patch added to -mm tree
To: rientjes@google.com,green@linuxhacker.ru,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Jun 2014 11:59:16 -0700


The patch titled
     Subject: mm, pcp: allow restoring percpu_pagelist_fraction default
has been added to the -mm tree.  Its filename is
     mm-pcp-allow-restoring-percpu_pagelist_fraction-default.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pcp-allow-restoring-percpu_pagelist_fraction-default.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pcp-allow-restoring-percpu_pagelist_fraction-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, pcp: allow restoring percpu_pagelist_fraction default

Oleg reports a division by zero error on zero-length write() to the
percpu_pagelist_fraction sysctl:

	divide error: 0000 [#1] SMP DEBUG_PAGEALLOC
	CPU: 1 PID: 9142 Comm: badarea_io Not tainted 3.15.0-rc2-vm-nfs+ #19
	Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
	task: ffff8800d5aeb6e0 ti: ffff8800d87a2000 task.ti: ffff8800d87a2000
	RIP: 0010:[<ffffffff81152664>]  [<ffffffff81152664>] percpu_pagelist_fraction_sysctl_handler+0x84/0x120
	RSP: 0018:ffff8800d87a3e78  EFLAGS: 00010246
	RAX: 0000000000000f89 RBX: ffff88011f7fd000 RCX: 0000000000000000
	RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000010
	RBP: ffff8800d87a3e98 R08: ffffffff81d002c8 R09: ffff8800d87a3f50
	R10: 000000000000000b R11: 0000000000000246 R12: 0000000000000060
	R13: ffffffff81c3c3e0 R14: ffffffff81cfddf8 R15: ffff8801193b0800
	FS:  00007f614f1e9740(0000) GS:ffff88011f440000(0000) knlGS:0000000000000000
	CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
	CR2: 00007f614f1fa000 CR3: 00000000d9291000 CR4: 00000000000006e0
	Stack:
	 0000000000000001 ffffffffffffffea ffffffff81c3c3e0 0000000000000000
	 ffff8800d87a3ee8 ffffffff8122b163 ffff8800d87a3f50 00007fff1564969c
	 0000000000000000 ffff8800d8098f00 00007fff1564969c ffff8800d87a3f50
	Call Trace:
	 [<ffffffff8122b163>] proc_sys_call_handler+0xb3/0xc0
	 [<ffffffff8122b184>] proc_sys_write+0x14/0x20
	 [<ffffffff811ba93a>] vfs_write+0xba/0x1e0
	 [<ffffffff811bb486>] SyS_write+0x46/0xb0
	 [<ffffffff816db7ff>] tracesys+0xe1/0xe6

However, if the percpu_pagelist_fraction sysctl is set by the user, it is
also impossible to restore it to the kernel default since the user cannot
write 0 to the sysctl.

This patch allows the user to write 0 to restore the default behavior.  It
still requires a fraction equal to or larger than 8, however, as stated by
the documentation for sanity.  If a value in the range [1, 7] is written,
the sysctl will return EINVAL.

This successfully solves the divide by zero issue at the same time.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Oleg Drokin <green@linuxhacker.ru>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    3 +-
 kernel/sysctl.c             |    3 --
 mm/page_alloc.c             |   40 +++++++++++++++++++++++-----------
 3 files changed, 31 insertions(+), 15 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-pcp-allow-restoring-percpu_pagelist_fraction-default Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-pcp-allow-restoring-percpu_pagelist_fraction-default
+++ a/Documentation/sysctl/vm.txt
@@ -702,7 +702,8 @@ The batch value of each per cpu pagelist
 set to pcp->high/4.  The upper limit of batch is (PAGE_SHIFT * 8)
 
 The initial value is zero.  Kernel does not use this value at boot time to set
-the high water marks for each per cpu page list.
+the high water marks for each per cpu page list.  If the user writes '0' to this
+sysctl, it will revert to this default behavior.
 
 ==============================================================
 
diff -puN kernel/sysctl.c~mm-pcp-allow-restoring-percpu_pagelist_fraction-default kernel/sysctl.c
--- a/kernel/sysctl.c~mm-pcp-allow-restoring-percpu_pagelist_fraction-default
+++ a/kernel/sysctl.c
@@ -136,7 +136,6 @@ static unsigned long dirty_bytes_min = 2
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
 static int minolduid;
-static int min_percpu_pagelist_fract = 8;
 
 static int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
@@ -1321,7 +1320,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(percpu_pagelist_fraction),
 		.mode		= 0644,
 		.proc_handler	= percpu_pagelist_fraction_sysctl_handler,
-		.extra1		= &min_percpu_pagelist_fract,
+		.extra1		= &zero,
 	},
 #ifdef CONFIG_MMU
 	{
diff -puN mm/page_alloc.c~mm-pcp-allow-restoring-percpu_pagelist_fraction-default mm/page_alloc.c
--- a/mm/page_alloc.c~mm-pcp-allow-restoring-percpu_pagelist_fraction-default
+++ a/mm/page_alloc.c
@@ -69,6 +69,7 @@
 
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
+#define MIN_PERCPU_PAGELIST_FRACTION	(8)
 
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
@@ -4145,7 +4146,7 @@ static void __meminit zone_init_free_lis
 	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY)
 #endif
 
-static int __meminit zone_batchsize(struct zone *zone)
+static int zone_batchsize(struct zone *zone)
 {
 #ifdef CONFIG_MMU
 	int batch;
@@ -4261,8 +4262,8 @@ static void pageset_set_high(struct per_
 	pageset_update(&p->pcp, high, batch);
 }
 
-static void __meminit pageset_set_high_and_batch(struct zone *zone,
-		struct per_cpu_pageset *pcp)
+static void pageset_set_high_and_batch(struct zone *zone,
+				       struct per_cpu_pageset *pcp)
 {
 	if (percpu_pagelist_fraction)
 		pageset_set_high(pcp,
@@ -5881,23 +5882,38 @@ int percpu_pagelist_fraction_sysctl_hand
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
-	unsigned int cpu;
+	int old_percpu_pagelist_fraction;
 	int ret;
 
+	mutex_lock(&pcp_batch_high_lock);
+	old_percpu_pagelist_fraction = percpu_pagelist_fraction;
+
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (!write || (ret < 0))
-		return ret;
+	if (!write || ret < 0)
+		goto out;
+
+	/* Sanity checking to avoid pcp imbalance */
+	if (percpu_pagelist_fraction &&
+	    percpu_pagelist_fraction < MIN_PERCPU_PAGELIST_FRACTION) {
+		percpu_pagelist_fraction = old_percpu_pagelist_fraction;
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* No change? */
+	if (percpu_pagelist_fraction == old_percpu_pagelist_fraction)
+		goto out;
 
-	mutex_lock(&pcp_batch_high_lock);
 	for_each_populated_zone(zone) {
-		unsigned long  high;
-		high = zone->managed_pages / percpu_pagelist_fraction;
+		unsigned int cpu;
+
 		for_each_possible_cpu(cpu)
-			pageset_set_high(per_cpu_ptr(zone->pageset, cpu),
-					 high);
+			pageset_set_high_and_batch(zone,
+					per_cpu_ptr(zone->pageset, cpu));
 	}
+out:
 	mutex_unlock(&pcp_batch_high_lock);
-	return 0;
+	return ret;
 }
 
 int hashdist = HASHDIST_DEFAULT;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-nommu-per-thread-vma-cache-fix.patch
mm-hotplug-probe-interface-is-available-on-several-platforms.patch
mm-pcp-allow-restoring-percpu_pagelist_fraction-default.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
linux-next.patch

