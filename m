From: akpm@linux-foundation.org
Subject: [merged] pagemap-document-kpf_ksm-and-show-it-in-page-types.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:05:03 -0700
Message-ID: <200910092205.n99M53kM020637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934670AbZJIWF4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:05:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, chrisw@redhat.com, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pagemap: document KPF_KSM and show it in page-types
has been removed from the -mm tree.  Its filename was
     pagemap-document-kpf_ksm-and-show-it-in-page-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap: document KPF_KSM and show it in page-types
From: Wu Fengguang <fengguang.wu@intel.com>

It indicates to the system admin that processes mapping such pages may be
eating less physical memory than the reported numbers by legacy tools.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Acked-by: Chris Wright <chrisw@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/vm/page-types.c~pagemap-document-kpf_ksm-and-show-it-in-page-types Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~pagemap-document-kpf_ksm-and-show-it-in-page-types
+++ a/Documentation/vm/page-types.c
@@ -71,6 +71,7 @@
 #define KPF_UNEVICTABLE		18
 #define KPF_HWPOISON		19
 #define KPF_NOPAGE		20
+#define KPF_KSM			21
 
 /* [32-] kernel hacking assistances */
 #define KPF_RESERVED		32
@@ -119,6 +120,7 @@ static char *page_flag_names[] = {
 	[KPF_UNEVICTABLE]	= "u:unevictable",
 	[KPF_HWPOISON]		= "X:hwpoison",
 	[KPF_NOPAGE]		= "n:nopage",
+	[KPF_KSM]		= "x:ksm",
 
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
diff -puN Documentation/vm/pagemap.txt~pagemap-document-kpf_ksm-and-show-it-in-page-types Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~pagemap-document-kpf_ksm-and-show-it-in-page-types
+++ a/Documentation/vm/pagemap.txt
@@ -59,6 +59,7 @@ There are three components to pagemap:
     18. UNEVICTABLE
     19. HWPOISON
     20. NOPAGE
+    21. KSM
 
 Short descriptions to the page flags:
 
@@ -93,6 +94,9 @@ Short descriptions to the page flags:
 20. NOPAGE
     no page frame exists at the requested address
 
+21. KSM
+    identical memory pages dynamically shared between one or more processes
+
     [IO related page flags]
  1. ERROR     IO error occurred
  3. UPTODATE  page has up-to-date data
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
dev-mem-remove-redundant-test-on-len.patch
dev-mem-introduce-size_inside_page.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
dev-mem-make-size_inside_page-logic-straight.patch
dev-mem-remove-the-written-variable-in-write_kmem.patch
dev-mem-remove-the-written-variable-in-write_kmem-fix.patch
dev-mem-remove-redundant-parameter-from-do_write_kmem.patch

