From: akpm@linux-foundation.org
Subject: - readahead-sysctl-parameters.patch removed from -mm tree
Date: Tue, 08 May 2007 01:13:51 -0700
Message-ID: <200705080813.l488DqOG018936@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934615AbXEHIOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:14:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: sysctl parameters
has been removed from the -mm tree.  Its filename was
     readahead-sysctl-parameters.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: sysctl parameters


Add new sysctl entries in /proc/sys/vm:

- readahead_ratio = 50
	i.e. set read-ahead size to <= readahead_ratio% thrashing threshold
- readahead_hit_rate = 0
	i.e. read-ahead hit ratio >= 1/readahead_hit_rate is deemed ok

readahead_ratio also provides a way to select read-ahead logic at runtime:

	condition			    action
==========================================================================
readahead_ratio == 0		disable read-ahead
readahead_ratio == 1		select the (old) stock read-ahead logic
readahead_ratio >= 2		select the (new) adaptive read-ahead logic

readahead_hit_rate controls the features provided by context based read-ahead:

	condition			    enabled function
==========================================================================
readahead_hit_rate == 0		handle only known good cases
				i.e. nfsd read and seek/cache hit recovery
readahead_hit_rate == 1		also detect interleaved sequential reads
readahead_hit_rate >= 2		further handle sparse access patterns

[akpm@osdl.org: build fix]
[akpm@osdl.org: Don't add new sysctl numbers]
Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   45 ++++++++++++++++++++++++++++++++++
 include/linux/mm.h          |   11 ++++++++
 kernel/sysctl.c             |   27 ++++++++++++++++++++
 mm/readahead.c              |   19 ++++++++++++++
 4 files changed, 102 insertions(+)

diff -puN Documentation/sysctl/vm.txt~readahead-sysctl-parameters Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~readahead-sysctl-parameters
+++ a/Documentation/sysctl/vm.txt
@@ -33,6 +33,8 @@ Currently, these files are in /proc/sys/
 - panic_on_oom
 - swap_prefetch
 - stat_interval
+- readahead_ratio
+- readahead_hit_rate
 
 ==============================================================
 
@@ -248,3 +250,46 @@ determines the frequency of these consol
 
 The default value is 1 second.
 
+==============================================================
+
+readahead_ratio
+
+This limits readahead size to percent of the thrashing threshold.
+The thrashing threshold is dynamically estimated from the _history_ read
+speed and system load, to deduce the _future_ readahead request size.
+
+Set it to a smaller value if you have not enough memory for all the
+concurrent readers, or the I/O loads fluctuate a lot. But if there's
+plenty of memory(>>2MB per reader), a bigger value may help performance.
+
+readahead_ratio also selects the readahead logic:
+	VALUE	CODE PATH
+	-------------------------------------------
+	    0	read as is, no extra readahead
+	    1	select the stock readahead logic
+	2-100	select the adaptive readahead logic
+
+The default value is 50.  Reasonable values would be [50, 100].
+
+==============================================================
+
+readahead_hit_rate
+
+This is the allowed sparseness(readahead-pages:accessed-pages) of the
+context based readahead. If the previous readahead has bad hit rate,
+the kernel will be reluctant to do the next readahead.
+
+The context based readahead logic can catch some semi-sequential patterns,
+i.e. interleaved/intermixed reading. They are subtle and therefore missed by
+the state based logic. However the logic can be overzealous and may hurt the
+performance of pure random reads.
+
+Possible values can be:
+0	only handle some known good cases, i.e. nfsd reads
+1	detect semi-sequential read patterns, found in some postgresql
+	applications and video streaming services
+2-8	detect sparse access patterns
+
+The larger value, the more capabilities, with more possible overheads.
+
+The default value is 1.
diff -puN include/linux/mm.h~readahead-sysctl-parameters include/linux/mm.h
--- a/include/linux/mm.h~readahead-sysctl-parameters
+++ a/include/linux/mm.h
@@ -1164,6 +1164,17 @@ void handle_ra_miss(struct address_space
 		    struct file_ra_state *ra, pgoff_t offset);
 unsigned long max_sane_readahead(unsigned long nr);
 
+#ifdef CONFIG_ADAPTIVE_READAHEAD
+extern int readahead_ratio;
+#else
+#define readahead_ratio 1
+#endif /* CONFIG_ADAPTIVE_READAHEAD */
+
+static inline int prefer_adaptive_readahead(void)
+{
+	return readahead_ratio != 1;
+}
+
 /* Do stack extension */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
 #ifdef CONFIG_IA64
diff -puN kernel/sysctl.c~readahead-sysctl-parameters kernel/sysctl.c
--- a/kernel/sysctl.c~readahead-sysctl-parameters
+++ a/kernel/sysctl.c
@@ -80,6 +80,11 @@ extern int compat_log;
 extern int maps_protect;
 extern int sysctl_stat_interval;
 
+#if defined(CONFIG_ADAPTIVE_READAHEAD)
+extern int readahead_ratio;
+extern int readahead_hit_rate;
+#endif
+
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
 static int minolduid;
@@ -901,6 +906,28 @@ static ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_ADAPTIVE_READAHEAD
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "readahead_ratio",
+		.data		= &readahead_ratio,
+		.maxlen		= sizeof(readahead_ratio),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "readahead_hit_rate",
+		.data		= &readahead_hit_rate,
+		.maxlen		= sizeof(readahead_hit_rate),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+#endif
 	{ .ctl_name = 0 }
 };
 
diff -puN mm/readahead.c~readahead-sysctl-parameters mm/readahead.c
--- a/mm/readahead.c~readahead-sysctl-parameters
+++ a/mm/readahead.c
@@ -32,6 +32,25 @@ EXPORT_SYMBOL(default_unplug_io_fn);
 #define MIN_RA_PAGES	DIV_ROUND_UP(VM_MIN_READAHEAD*1024, PAGE_CACHE_SIZE)
 
 /*
+ * Adaptive read-ahead parameters.
+ */
+
+/* In laptop mode, poll delayed look-ahead on every ## pages read. */
+#define LAPTOP_POLL_INTERVAL 16
+
+/* Set look-ahead size to 1/# of the thrashing-threshold. */
+#define LOOKAHEAD_RATIO 8
+
+#ifdef CONFIG_ADAPTIVE_READAHEAD
+/* Set read-ahead size to ##% of the thrashing-threshold. */
+int readahead_ratio = 50;
+EXPORT_SYMBOL_GPL(readahead_ratio);
+
+/* Readahead as long as cache hit ratio keeps above 1/##. */
+int readahead_hit_rate = 1;
+#endif /* CONFIG_ADAPTIVE_READAHEAD */
+
+/*
  * Detailed classification of read-ahead behaviors.
  */
 #define RA_CLASS_SHIFT 4
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-sysctl-parameters.patch
readahead-min-max-sizes.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method.patch
readahead-state-based-method-check-node-id.patch
readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch
readahead-state-based-method-cancel-lookahead-gracefully.patch
readahead-context-based-method.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-thrashing-recovery-method-check-unbalanced-aging.patch
readahead-thrashing-recovery-method-refill-holes.patch
readahead-call-scheme.patch
readahead-call-scheme-cleanup.patch
readahead-call-scheme-catch-thrashing-on-lookahead-time.patch
readahead-call-scheme-doc-fixes-for-readahead.patch
readahead-laptop-mode.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
readahead-remove-parameter-ra_max-from-adjust_rala.patch
readahead-state-based-method-protect-against-tiny-size.patch
readahead-rename-state_based_readahead-to-clock_based_readahead.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
