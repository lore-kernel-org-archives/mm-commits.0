From: akpm@linux-foundation.org
Subject: [folded-merged]
 debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 14:24:08 -0800
Message-ID: <52869f08.B5Ygf+zQAgOAtNRt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3KOWYJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 17:24:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, fengguang.wu@intel.com, dave@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: [folded-merged] debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,dave@linux.vnet.ibm.com,fengguang.wu@intel.com,hannes@cmpxchg.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 14:24:08 -0800


The patch titled
     Subject: debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support-fix
has been removed from the -mm tree.  Its filename was
     debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

This patch was dropped because it was folded into debugging-keep-track-of-page-owners.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support-fix

stomp sparse gfp_t warnings

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 +-
 mm/page_alloc.c          |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/mm_types.h~debugging-keep-track-of-page-owners-fix-2-fix-fix-fix include/linux/mm_types.h
--- a/include/linux/mm_types.h~debugging-keep-track-of-page-owners-fix-2-fix-fix-fix
+++ a/include/linux/mm_types.h
@@ -197,7 +197,7 @@ struct page {
 #endif
 #ifdef CONFIG_PAGE_OWNER
 	int order;
-	unsigned int gfp_mask;
+	gfp_t gfp_mask;
 	struct stack_trace trace;
 	unsigned long trace_entries[8];
 #endif
diff -puN mm/page_alloc.c~debugging-keep-track-of-page-owners-fix-2-fix-fix-fix mm/page_alloc.c
--- a/mm/page_alloc.c~debugging-keep-track-of-page-owners-fix-2-fix-fix-fix
+++ a/mm/page_alloc.c
@@ -2314,8 +2314,8 @@ __perform_reclaim(gfp_t gfp_mask, unsign
 	return progress;
 }
 
-static void set_page_owner(struct page *page, unsigned int order,
-			unsigned int gfp_mask)
+static void
+set_page_owner(struct page *page, unsigned int order, gfp_t gfp_mask)
 {
 #ifdef CONFIG_PAGE_OWNER
 	struct stack_trace *trace = &page->trace;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

