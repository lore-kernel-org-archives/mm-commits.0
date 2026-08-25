Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F30340298
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622874; cv=none; b=VhEbFKjCbhG4PsRl1uxsBNPqHfc9LgWBNmXBafOnmSr6nXw5BIOPctoLAvjw8M6kwUCjRUNQuHMPTXpwtRgqkslhZmper3RBRCvlNCmU+QnpV9vaFwmGnW+87YUJW3w7oh0RzWvBJddoUwM+ZvCUwqF75tvTCan522R5ftq24Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622874; c=relaxed/simple;
	bh=HlCondEkF2oBXQwdQKxiuBgWfMhVa4dvpxQmi30EAgY=;
	h=Date:To:From:Subject:Message-Id; b=HMWtFj64RWHExAnHmEn1n5DYR2lTi+u8oz30jbQVVdbRCUqqdC1hFCUiR/Mz5g2LqMhuCMYG+lFHdTqyeB4ojlBzlht7DUYtQteod/hJJ8UIo0oDp6X6/ShvsaE7+LWvOEvR2X1DO1dwfyrSYusyXZx2dQjsPCz6uG/4GgEZLNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hZKvd706; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hZKvd706"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2463C1F00A3D;
	Tue, 25 Aug 2026 01:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622872;
	bh=0W98r/MhKrMLqAGkWFEzTSQHcyJhBmaNh2aR4l0742s=;
	h=Date:To:From:Subject;
	b=hZKvd706WW7tWHaMf6XT4woTA4wTDi17NseIIlewaGVJvBqpZ2fa3d/Vvd9ty9VBe
	 il5xgTUokSPyB1WCgzW5s2cCGsIch73w2qNZlPzuYPKc7xSYmLABk0BSTWZdjnHT+/
	 tvRNh35UmqSaVU+10rO2Oo89b48dmDDkUYhd8yhA=
Date: Mon, 24 Aug 2026 18:54:31 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,david@kernel.org,anshuman.kahndual@arm.com,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-vm_fault_result_trace-compatible-with-sparse.patch removed from -mm tree
Message-Id: <20260825015432.2463C1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make VM_FAULT_RESULT_TRACE compatible with sparse
has been removed from the -mm tree.  Its filename was
     mm-make-vm_fault_result_trace-compatible-with-sparse.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bart Van Assche <bvanassche@acm.org>
Subject: mm: make VM_FAULT_RESULT_TRACE compatible with sparse
Date: Fri, 7 Aug 2026 10:13:10 -0700

Fix the following sparse warnings that appear while building f2fs:

./include/trace/events/f2fs.h:1469:1: warning: incorrect type in initializer (different base types)
./include/trace/events/f2fs.h:1469:1:    expected unsigned long mask
./include/trace/events/f2fs.h:1469:1:    got restricted vm_fault_t

Link: https://lore.kernel.org/e56c9e2aead04f79192c3110de80d846e41e3791.1786122711.git.bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.kahndual@arm.com>
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


