From: akpm@linux-foundation.org
Subject: +
 mm-kconfig-correct-description-of-deferred_struct_page_init.patch added to
 -mm tree
Date: Mon, 01 Feb 2016 22:13:28 -0800
Message-ID: <56b04908.tZbOMkVAimbSFs1w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbcBBGN3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 01:13:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/Kconfig: correct description of DEFERRED_STRUCT_PAGE_INIT
has been added to the -mm tree.  Its filename is
     mm-kconfig-correct-description-of-deferred_struct_page_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kconfig-correct-description-of-deferred_struct_page_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kconfig-correct-description-of-deferred_struct_page_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/Kconfig: correct description of DEFERRED_STRUCT_PAGE_INIT

The description mentions kswapd threads, while the deferred struct page
initialization is actually done by one-off "pgdatinitX" threads.  Fix the
description so that potentially users are not confused about pgdatinit
threads using CPU after boot instead of kswapd.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
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

mm-kconfig-correct-description-of-deferred_struct_page_init.patch
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
mm-use-radix_tree_iter_retry-fix.patch

