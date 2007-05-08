From: akpm@linux-foundation.org
Subject: - readahead-kconfig-options.patch removed from -mm tree
Date: Tue, 08 May 2007 01:13:15 -0700
Message-ID: <200705080813.l488DGGA018905@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934567AbXEHIOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:14:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: kconfig options
has been removed from the -mm tree.  Its filename was
     readahead-kconfig-options.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: kconfig options
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

This patchset introduces a set of adaptive read-ahead methods.
They enable the kernel to better support many important I/O applications.

MAIN FEATURES
=============

- Adaptive read-ahead buffer management
	- aggressive, thrashing safe read-ahead size
		- optimal memory utilisation while achieving good I/O throughput
		- unnecessary to hand tuning VM_MAX_READAHEAD
		- support slow/fast readers at the same time
		- support large number of concurrent readers
	- aggressive read-ahead on start-of-file
		- configurable recommended read-ahead size
		- safeguarded by dynamic estimated thrashing threshold
		- good for lots-of-small-files case
	- shrinkable look-ahead size
		- cut down up to 40% memory consumption on overloaded situation

- Detecting any form of (semi-)sequencial scan
        - parallel / interleaved sequential scans on one fd
        - sequential reads across file open/close lifetime
        - mixed sequential / random accesses
        - sparse / skimming sequential read

- Support more access patterns
        - backward prefetching

- Better special case handling
        - nfs daemon support: the raparams cache is no longer required
	- laptop mode support: defer look-ahead on drive spinned down
        - loopback file support: avoid double look-ahead

DESIGN STRATEGIES
=================

- Dual methods design
        - stateful method: the fast and default one
	- stateless method: the robust and failsafe one
	- if anything abnormal happens, the stateful method bails out, the
	  stateless method queries the page cache and possibly restart the
	  read-ahead process

- Robust feedback design
	- sense and handle important states so that the logic wont run away
	- detect danger of thrashing and prevent it in advance
        - extensive accounting and debugging traces

This patch:

Add kconfig options to enable/disable:
	- adaptive read-ahead logic
	- adaptive read-ahead debug traces and events accounting

The read-ahead introduction text is cited from the well written LWN article
"Adaptive file readahead" <http://lwn.net/Articles/155510/> :)

[akpm@osdl.org: `select' is evil.  Kill.]
Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig     |   57 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/readahead.c |    2 +
 2 files changed, 59 insertions(+)

diff -puN mm/Kconfig~readahead-kconfig-options mm/Kconfig
--- a/mm/Kconfig~readahead-kconfig-options
+++ a/mm/Kconfig
@@ -168,3 +168,60 @@ config NR_QUICK
 	depends on QUICKLIST
 	default "2" if SUPERH
 	default "1"
+
+#
+# Adaptive file readahead
+#
+config ADAPTIVE_READAHEAD
+	bool "Adaptive file readahead (EXPERIMENTAL)"
+	default n
+	depends on EXPERIMENTAL
+	help
+	  Readahead is a technique employed by the kernel in an attempt
+	  to improve file reading performance. If the kernel has reason
+	  to believe that a particular file is being read sequentially,
+	  it will attempt to read blocks from the file into memory before
+	  the application requests them. When readahead works, it speeds
+	  up the system's throughput, since the reading application does
+	  not have to wait for its requests. When readahead fails, instead,
+	  it generates useless I/O and occupies memory pages which are
+	  needed for some other purpose.
+
+	  The kernel already has a stock readahead logic that is well
+	  understood and well tuned. This option enables a more complex and
+	  feature rich one. It tries to be smart and memory efficient.
+	  However, due to the great diversity of real world applications, it
+	  might not fit everyone.
+
+	  Please refer to Documentation/sysctl/vm.txt for tunable parameters.
+
+	  It is known to work well for many desktops, file servers and
+	  postgresql databases. Say Y to try it out for yourself.
+
+config DEBUG_READAHEAD
+	bool "Readahead debug and accounting"
+	default n
+	depends on ADAPTIVE_READAHEAD
+	depends on DEBUG_FS
+	help
+	  This option injects extra code to dump detailed debug traces and do
+	  readahead events accounting.
+
+	  To actually get the data:
+
+	  mkdir /debug
+	  mount -t debug none /debug
+
+	  After that you can do the following:
+
+	  echo > /debug/readahead/events # reset the counters
+	  cat /debug/readahead/events    # check the counters
+
+	  echo 1 > /debug/readahead/debug_level # start events accounting
+	  echo 0 > /debug/readahead/debug_level # pause events accounting
+
+	  echo 2 > /debug/readahead/debug_level # show printk traces
+	  echo 3 > /debug/readahead/debug_level # show printk traces(verbose)
+	  echo 1 > /debug/readahead/debug_level # stop filling my kern.log
+
+	  Say N for production servers.
diff -puN mm/readahead.c~readahead-kconfig-options mm/readahead.c
--- a/mm/readahead.c~readahead-kconfig-options
+++ a/mm/readahead.c
@@ -5,6 +5,8 @@
  *
  * 09Apr2002	akpm@zip.com.au
  *		Initial version.
+ * 26May2006	Fengguang Wu <wfg@ustc.edu>
+ *		Adaptive read-ahead framework.
  */
 
 #include <linux/kernel.h>
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-kconfig-options.patch
radixtree-introduce-scan-hole-data-functions.patch
mm-introduce-probe_page.patch
mm-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-insert-cond_resched-calls.patch
readahead-minmax_ra_pages.patch
readahead-events-accounting.patch
readahead-rescue_pages.patch
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
