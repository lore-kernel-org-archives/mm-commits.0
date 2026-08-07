Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC223B0AEA
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 19:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786129519; cv=none; b=Bbl+n/Oz5csDrqOu72HsdqwAW3olOwyQ9ia6ysGra9nRtbtHr/AHQEGpkSL/8KoLJu4nU8+foCCQP2j1iEIFYU0tAeeASbApnpPmWhtChkbZzsuuSYDgmbwI1UtnRMHh+WdooK96oHjjQ1Gibx9i/uI0HLiSyupkELQ84TgLfis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786129519; c=relaxed/simple;
	bh=N6DW5aSFJ4DgNPwQncvM4pc5/Kq3FDfK0LngdTydQGM=;
	h=Date:To:From:Subject:Message-Id; b=en5xxRok9vMEbKeV/rnIt3XfRgT5Vwsz6S2Z9I9IA6KsWqkjGhI9snUJ2xCCq4qGt1TLnWMMIJjsF1Yag2GbBZZp+o3j/GyTiCP4m/bhRMmG9TX5i5gGCjChUjb5X0PxPfF0mBSIxV8lKfhijx0TRK0el/5H13D+0ERqCZ12WzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z+e8qrnX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z+e8qrnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FED91F00A3A;
	Fri,  7 Aug 2026 19:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786129518;
	bh=oRjEmI0G9O32QKLpxAzk+E/2uT4uaD6NH72p4PGr+lM=;
	h=Date:To:From:Subject;
	b=z+e8qrnXb3bHNepniURGdxaBlHqwa7bpIG3ulzQaeFzaJQ2/fslED0OnadTUhDIHF
	 sMkDMSMpewzgqLirp7lvo1uG4d1Cn5yxhvOkoSVBZgfvIAVG3muGc2nqXTJgAQ7Xcy
	 +svnG6UY8bOOv9QkfTR4sYLKRzjniHL3OLbJkTyM=
Date: Fri, 07 Aug 2026 12:05:17 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,david@kernel.org,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-vm_fault_result_trace-compatible-with-sparse.patch added to mm-new branch
Message-Id: <20260807190518.0FED91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: Make VM_FAULT_RESULT_TRACE compatible with sparse
has been added to the -mm mm-new branch.  Its filename is
     mm-make-vm_fault_result_trace-compatible-with-sparse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-vm_fault_result_trace-compatible-with-sparse.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Bart Van Assche <bvanassche@acm.org>
Subject: mm: Make VM_FAULT_RESULT_TRACE compatible with sparse
Date: Fri, 7 Aug 2026 10:13:10 -0700

Fix the following sparse warnings that appear while building f2fs:

./include/trace/events/f2fs.h:1469:1: warning: incorrect type in initiali=
zer (different base types)
./include/trace/events/f2fs.h:1469:1:    expected unsigned long mask
./include/trace/events/f2fs.h:1469:1:    got restricted vm_fault_t

Link: https://lore.kernel.org/e56c9e2aead04f79192c3110de80d846e41e3791.1786122711.git.bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/include/linux/mm_types.h~mm-make-vm_fault_result_trace-compatible-with-sparse
+++ a/include/linux/mm_types.h
@@ -1718,20 +1718,20 @@ enum vm_fault_reason {
 			VM_FAULT_SIGSEGV | VM_FAULT_HWPOISON |	\
 			VM_FAULT_HWPOISON_LARGE | VM_FAULT_FALLBACK)
 
-#define VM_FAULT_RESULT_TRACE \
-	{ VM_FAULT_OOM,                 "OOM" },	\
-	{ VM_FAULT_SIGBUS,              "SIGBUS" },	\
-	{ VM_FAULT_MAJOR,               "MAJOR" },	\
-	{ VM_FAULT_HWPOISON,            "HWPOISON" },	\
-	{ VM_FAULT_HWPOISON_LARGE,      "HWPOISON_LARGE" },	\
-	{ VM_FAULT_SIGSEGV,             "SIGSEGV" },	\
-	{ VM_FAULT_NOPAGE,              "NOPAGE" },	\
-	{ VM_FAULT_LOCKED,              "LOCKED" },	\
-	{ VM_FAULT_RETRY,               "RETRY" },	\
-	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
-	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
-	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
-	{ VM_FAULT_COMPLETED,           "COMPLETED" }
+#define VM_FAULT_RESULT_TRACE						\
+	{ (__force u32)VM_FAULT_OOM,                 "OOM" },		\
+	{ (__force u32)VM_FAULT_SIGBUS,              "SIGBUS" },	\
+	{ (__force u32)VM_FAULT_MAJOR,               "MAJOR" },		\
+	{ (__force u32)VM_FAULT_HWPOISON,            "HWPOISON" },	\
+	{ (__force u32)VM_FAULT_HWPOISON_LARGE,      "HWPOISON_LARGE" }, \
+	{ (__force u32)VM_FAULT_SIGSEGV,             "SIGSEGV" },	\
+	{ (__force u32)VM_FAULT_NOPAGE,              "NOPAGE" },	\
+	{ (__force u32)VM_FAULT_LOCKED,              "LOCKED" },	\
+	{ (__force u32)VM_FAULT_RETRY,               "RETRY" },		\
+	{ (__force u32)VM_FAULT_FALLBACK,            "FALLBACK" },	\
+	{ (__force u32)VM_FAULT_DONE_COW,            "DONE_COW" },	\
+	{ (__force u32)VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
+	{ (__force u32)VM_FAULT_COMPLETED,           "COMPLETED" }
 
 struct vm_special_mapping {
 	const char *name;	/* The name, e.g. "[vdso]". */
_

Patches currently in -mm which might be from bvanassche@acm.org are

mm-make-vm_fault_result_trace-compatible-with-sparse.patch

