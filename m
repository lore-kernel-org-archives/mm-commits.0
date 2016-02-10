From: akpm@linux-foundation.org
Subject: [merged]
 mm-kconfig-correct-description-of-deferred_struct_page_init.patch removed
 from -mm tree
Date: Wed, 10 Feb 2016 11:35:32 -0800
Message-ID: <56bb9104.BVyQKrm7iUD8JyO1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbcBJTfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:35:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/Kconfig: correct description of DEFERRED_STRUCT_PAGE_INIT
has been removed from the -mm tree.  Its filename was
     mm-kconfig-correct-description-of-deferred_struct_page_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/Kconfig: correct description of DEFERRED_STRUCT_PAGE_INIT

The description mentions kswapd threads, while the deferred struct page
initialization is actually done by one-off "pgdatinitX" threads.  Fix the
description so that potentially users are not confused about pgdatinit
threads using CPU after boot instead of kswapd.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/Kconfig~mm-kconfig-correct-description-of-deferred_struct_page_init mm/Kconfig
--- a/mm/Kconfig~mm-kconfig-correct-description-of-deferred_struct_page_init
+++ a/mm/Kconfig
@@ -624,7 +624,7 @@ config ARCH_SUPPORTS_DEFERRED_STRUCT_PAG
 	bool
 
 config DEFERRED_STRUCT_PAGE_INIT
-	bool "Defer initialisation of struct pages to kswapd"
+	bool "Defer initialisation of struct pages to kthreads"
 	default n
 	depends on ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
 	depends on MEMORY_HOTPLUG
@@ -633,9 +633,10 @@ config DEFERRED_STRUCT_PAGE_INIT
 	  single thread. On very large machines this can take a considerable
 	  amount of time. If this option is set, large machines will bring up
 	  a subset of memmap at boot and then initialise the rest in parallel
-	  when kswapd starts. This has a potential performance impact on
-	  processes running early in the lifetime of the systemm until kswapd
-	  finishes the initialisation.
+	  by starting one-off "pgdatinitX" kernel thread for each node X. This
+	  has a potential performance impact on processes running early in the
+	  lifetime of the system until these kthreads finish the
+	  initialisation.
 
 config IDLE_PAGE_TRACKING
 	bool "Enable idle page tracking"
_

Patches currently in -mm which might be from vbabka@suse.cz are

tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch
mm-tracing-make-show_gfp_flags-up-to-date.patch
tools-perf-make-gfp_compact_table-up-to-date.patch
mm-tracing-unify-mm-flags-handling-in-tracepoints-and-printk.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-printk-introduce-new-format-string-for-flags-fix.patch
mm-debug-replace-dump_flags-with-the-new-printk-formats.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch
mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
mm-compaction-introduce-kcompactd.patch
mm-memory-hotplug-small-cleanup-in-online_pages.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch
mm-compaction-adapt-isolation_suitable-flushing-to-kcompactd.patch
mm-use-radix_tree_iter_retry-fix.patch

