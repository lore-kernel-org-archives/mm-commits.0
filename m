From: akpm@linux-foundation.org
Subject: [merged] mm-add-comments-to-explain-mm_struct-fields.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:08:46 -0700
Message-ID: <201111012108.pA1L8kga011663@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:28670 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab1KAVIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:08:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add comments to explain mm_struct fields
has been removed from the -mm tree.  Its filename was
     mm-add-comments-to-explain-mm_struct-fields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: mm: add comments to explain mm_struct fields

Add comments to explain the page statistics field in the mm_struct.

[akpm@linux-foundation.org: add missing ;]
Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN include/linux/mm_types.h~mm-add-comments-to-explain-mm_struct-fields include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-add-comments-to-explain-mm_struct-fields
+++ a/include/linux/mm_types.h
@@ -304,8 +304,15 @@ struct mm_struct {
 	unsigned long hiwater_rss;	/* High-watermark of RSS usage */
 	unsigned long hiwater_vm;	/* High-water virtual memory usage */
 
-	unsigned long total_vm, locked_vm, pinned_vm, shared_vm, exec_vm;
-	unsigned long stack_vm, reserved_vm, def_flags, nr_ptes;
+	unsigned long total_vm;		/* Total pages mapped */
+	unsigned long locked_vm;	/* Pages that have PG_mlocked set */
+	unsigned long pinned_vm;	/* Refcount permanently increased */
+	unsigned long shared_vm;	/* Shared pages (files) */
+	unsigned long exec_vm;		/* VM_EXEC & ~VM_WRITE */
+	unsigned long stack_vm;		/* VM_GROWSUP/DOWN */
+	unsigned long reserved_vm;	/* VM_RESERVED|VM_IO pages */
+	unsigned long def_flags;
+	unsigned long nr_ptes;		/* Page table pages */
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long start_brk, brk, start_stack;
 	unsigned long arg_start, arg_end, env_start, env_end;
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch
memcg-fix-race-condition-in-memcg_check_events-with-this_cpu-usage.patch

