From: akpm@linux-foundation.org
Subject: [folded] cross-memory-attach-v4.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:39:55 -0700
Message-ID: <201110312339.p9VNdu5H032350__28489.4717661247$1320104442$gmane$org@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:41837 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1JaXkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cyeoh@au1.ibm.com, arnd@arndb.de, benh@kernel.crashing.org, dhowells@redhat.com, hpa@zytor.com, jmorris@namei.org, linux-arch@vger.kernel.org, linux-man@vger.kernel.org, mingo@elte.hu


The patch titled
     Subject: cross-memory-attach-v4
has been removed from the -mm tree.  Its filename was
     cross-memory-attach-v4.patch

This patch was dropped because it was folded into cross-memory-attach-v3.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Christopher Yeoh <cyeoh@au1.ibm.com>
Subject: cross-memory-attach-v4

> You might get some speed benefit by optimising for the small copies
> here.  Define a local on-stack array of N page*'s and point
> process_pages at that if the number of pages is <= N.  Saves a
> malloc/free and is more cache-friendly.  But only if the result is
> measurable!

I have done some benchmarking on this, and it gains about 5-7% on a
microbenchmark with 4kb size copies and about a 1% gain with a more
realistic (but modified for smaller copies) hpcc benchmark. The
performance gain disappears into the noise by about 64kb sized copies.
No measurable overhead for larger copies. So I think its worth including

Included below is the patch (based on v4) - for ease of review the first diff
is just against the latest version of CMA which has been posted here previously.
The second is the entire CMA patch.

Signed-off-by: Chris Yeoh <cyeoh@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: <linux-man@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/process_vm_access.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff -puN mm/process_vm_access.c~cross-memory-attach-v4 mm/process_vm_access.c
--- a/mm/process_vm_access.c~cross-memory-attach-v4
+++ a/mm/process_vm_access.c
@@ -221,6 +221,10 @@ static int process_vm_rw_single_vec(unsi
 	return rc;
 }
 
+/* Maximum number of entries for process pages array
+   which lives on stack */
+#define PVM_MAX_PP_ARRAY_COUNT 16
+
 /**
  * process_vm_rw_core - core of reading/writing pages from task specified
  * @pid: PID of process to read/write from/to
@@ -241,7 +245,8 @@ static ssize_t process_vm_rw_core(pid_t 
 				  unsigned long flags, int vm_write)
 {
 	struct task_struct *task;
-	struct page **process_pages = NULL;
+	struct page *pp_stack[PVM_MAX_PP_ARRAY_COUNT];
+	struct page **process_pages = pp_stack;
 	struct mm_struct *mm;
 	unsigned long i;
 	ssize_t rc = 0;
@@ -271,13 +276,16 @@ static ssize_t process_vm_rw_core(pid_t 
 	if (nr_pages == 0)
 		return 0;
 
-	/* For reliability don't try to kmalloc more than 2 pages worth */
-	process_pages = kmalloc(min_t(size_t, PVM_MAX_KMALLOC_PAGES,
-				      sizeof(struct pages *)*nr_pages),
-				GFP_KERNEL);
+	if (nr_pages > PVM_MAX_PP_ARRAY_COUNT) {
+		/* For reliability don't try to kmalloc more than
+		   2 pages worth */
+		process_pages = kmalloc(min_t(size_t, PVM_MAX_KMALLOC_PAGES,
+					      sizeof(struct pages *)*nr_pages),
+					GFP_KERNEL);
 
-	if (!process_pages)
-		return -ENOMEM;
+		if (!process_pages)
+			return -ENOMEM;
+	}
 
 	/* Get process information */
 	rcu_read_lock();
@@ -331,7 +339,8 @@ put_task_struct:
 	put_task_struct(task);
 
 free_proc_pages:
-	kfree(process_pages);
+	if (process_pages != pp_stack)
+		kfree(process_pages);
 	return rc;
 }
 
_

Patches currently in -mm which might be from cyeoh@au1.ibm.com are

cross-memory-attach-v3.patch

