From: akpm@linux-foundation.org
Subject: + mm-add-comments-to-explain-mm_struct-fields.patch added to -mm tree
Date: Tue, 23 Aug 2011 13:25:59 -0700
Message-ID: <201108232026.p7NKQ0ta004601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756136Ab1HWU0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 16:26:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cl@linux.com


The patch titled
     mm: add comments to explain mm_struct fields
has been added to the -mm tree.  Its filename is
     mm-add-comments-to-explain-mm_struct-fields.patch

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
Subject: mm: add comments to explain mm_struct fields
From: Christoph Lameter <cl@linux.com>

Add comments to explain the page statistics field in the mm_struct.

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN include/linux/mm_types.h~mm-add-comments-to-explain-mm_struct-fields include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-add-comments-to-explain-mm_struct-fields
+++ a/include/linux/mm_types.h
@@ -281,8 +281,15 @@ struct mm_struct {
 	unsigned long hiwater_rss;	/* High-watermark of RSS usage */
 	unsigned long hiwater_vm;	/* High-water virtual memory usage */
 
-	unsigned long total_vm, locked_vm, pinned_vm, shared_vm, exec_vm;
-	unsigned long stack_vm, reserved_vm, def_flags, nr_ptes;
+	unsigned long total_vm;		/* Total pages mapped */
+	unsigned long locked_vm		/* Pages that have PG_mlocked set */
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

mm-distinguish-between-mlocked-and-pinned-pages.patch
mm-add-comments-to-explain-mm_struct-fields.patch

