Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D82285040
	for <mm-commits@vger.kernel.org>; Thu,  2 Oct 2025 20:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759436473; cv=none; b=qMeeGXUKN76qnHyXQHfr9a3KBZ6n+H8oOBIRfCzIaYvgqgKpkqXA9G240BoCh9WJdjzq4xwBqYdPRuFYPUQBYA1p03pifqe1GheSiatMxRROD2vO+eDNXraESedL3H2rPcqoikgtReFgU9LWZ0tc17iV4A4OHtfRdxqdU2U4FU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759436473; c=relaxed/simple;
	bh=7wdLl7I5kfvIVPQBgOut/pnCqyBUZbmwaAGhhC3aKnY=;
	h=Date:To:From:Subject:Message-Id; b=Y/FZJdwN0GDxPvtSjhpb5JWGLxTURoN2gcNxICsY6QsIYPgHrXY5ZTWKLorVSA0ZL3T6izisrpzvuyAw/n9gWQgtpgS9V/EMS3jz9kVtDHIegXHpH9msrH5GDBhyYkNN1IQWIL42banMVSiPBKyAahSuAdeU3YoO1s7IvgjAgTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qRYdHv5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qRYdHv5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2293C4CEF4;
	Thu,  2 Oct 2025 20:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759436472;
	bh=7wdLl7I5kfvIVPQBgOut/pnCqyBUZbmwaAGhhC3aKnY=;
	h=Date:To:From:Subject:From;
	b=qRYdHv5EyqUc8QF09x6hvXutlvYA0FvC/Vdn6ik9BHXVsnRxTcP6MA2/aX4fmu5nq
	 GbvF40PMmG8aDowtv8sY0X72gdTYy7BsYtG5zibg5frt+9wtsXN/JPKSA6V4/2DtSx
	 aTbckBQyXJGY1REDUOcSJ9BwutR8kGthog3NYVe8=
Date: Thu, 02 Oct 2025 13:21:12 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,sj@kernel.org,peterx@redhat.com,david@redhat.com,chengming.zhou@linux.dev,axelrasmussen@google.com,acsjakub@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-redefine-vm_-flag-constants-with-bit.patch added to mm-new branch
Message-Id: <20251002202112.C2293C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: redefine VM_* flag constants with BIT()
has been added to the -mm mm-new branch.  Its filename is
     mm-redefine-vm_-flag-constants-with-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-redefine-vm_-flag-constants-with-bit.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jakub Acs <acsjakub@amazon.de>
Subject: mm: redefine VM_* flag constants with BIT()
Date: Thu, 2 Oct 2025 07:52:02 +0000

Make VM_* flag constant definitions consistent - unify all to use BIT()
macro.

We have previously changed VM_MERGEABLE in a separate bugfix.  This is a
follow-up to make all the VM_* flag constant definitions consistent, as
suggested by David in [1].

Link: https://lkml.kernel.org/r/20251002075202.11306-1-acsjakub@amazon.de
Link: https://lore.kernel.org/all/85f852f9-8577-4230-adc7-c52e7f479454@redhat.com/ [1]
Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   64 +++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

--- a/include/linux/mm.h~mm-redefine-vm_-flag-constants-with-bit
+++ a/include/linux/mm.h
@@ -273,56 +273,56 @@ extern unsigned int kobjsize(const void
  * vm_flags in vm_area_struct, see mm_types.h.
  * When changing, update also include/trace/events/mmflags.h
  */
-#define VM_NONE		0x00000000
+#define VM_NONE		0
 
-#define VM_READ		0x00000001	/* currently active flags */
-#define VM_WRITE	0x00000002
-#define VM_EXEC		0x00000004
-#define VM_SHARED	0x00000008
+#define VM_READ		BIT(0)		/* currently active flags */
+#define VM_WRITE	BIT(1)
+#define VM_EXEC		BIT(2)
+#define VM_SHARED	BIT(3)
 
 /* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
-#define VM_MAYREAD	0x00000010	/* limits for mprotect() etc */
-#define VM_MAYWRITE	0x00000020
-#define VM_MAYEXEC	0x00000040
-#define VM_MAYSHARE	0x00000080
+#define VM_MAYREAD	BIT(4)		/* limits for mprotect() etc */
+#define VM_MAYWRITE	BIT(5)
+#define VM_MAYEXEC	BIT(6)
+#define VM_MAYSHARE	BIT(7)
 
-#define VM_GROWSDOWN	0x00000100	/* general info on the segment */
+#define VM_GROWSDOWN	BIT(8)		/* general info on the segment */
 #ifdef CONFIG_MMU
-#define VM_UFFD_MISSING	0x00000200	/* missing pages tracking */
+#define VM_UFFD_MISSING	BIT(9)		/* missing pages tracking */
 #else /* CONFIG_MMU */
-#define VM_MAYOVERLAY	0x00000200	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
+#define VM_MAYOVERLAY	BIT(9)		/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
 #define VM_UFFD_MISSING	0
 #endif /* CONFIG_MMU */
-#define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
-#define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
+#define VM_PFNMAP	BIT(10)		/* Page-ranges managed without "struct page", just pure PFN */
+#define VM_UFFD_WP	BIT(12)		/* wrprotect pages tracking */
 
-#define VM_LOCKED	0x00002000
-#define VM_IO           0x00004000	/* Memory mapped I/O or similar */
+#define VM_LOCKED	BIT(13)
+#define VM_IO           BIT(14)		/* Memory mapped I/O or similar */
 
 					/* Used by sys_madvise() */
-#define VM_SEQ_READ	0x00008000	/* App will access data sequentially */
-#define VM_RAND_READ	0x00010000	/* App will not benefit from clustered reads */
+#define VM_SEQ_READ	BIT(15)		/* App will access data sequentially */
+#define VM_RAND_READ	BIT(16)		/* App will not benefit from clustered reads */
 
-#define VM_DONTCOPY	0x00020000      /* Do not copy this vma on fork */
-#define VM_DONTEXPAND	0x00040000	/* Cannot expand with mremap() */
-#define VM_LOCKONFAULT	0x00080000	/* Lock the pages covered when they are faulted in */
-#define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
-#define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
-#define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
-#define VM_SYNC		0x00800000	/* Synchronous page faults */
-#define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
-#define VM_WIPEONFORK	0x02000000	/* Wipe VMA contents in child. */
-#define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
+#define VM_DONTCOPY	BIT(17)		/* Do not copy this vma on fork */
+#define VM_DONTEXPAND	BIT(18)		/* Cannot expand with mremap() */
+#define VM_LOCKONFAULT	BIT(19)		/* Lock the pages covered when they are faulted in */
+#define VM_ACCOUNT	BIT(20)		/* Is a VM accounted object */
+#define VM_NORESERVE	BIT(21)		/* should the VM suppress accounting */
+#define VM_HUGETLB	BIT(22)		/* Huge TLB Page VM */
+#define VM_SYNC		BIT(23)		/* Synchronous page faults */
+#define VM_ARCH_1	BIT(24)		/* Architecture-specific flag */
+#define VM_WIPEONFORK	BIT(25)		/* Wipe VMA contents in child. */
+#define VM_DONTDUMP	BIT(26)		/* Do not include in the core dump */
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
-# define VM_SOFTDIRTY	0x08000000	/* Not soft dirty clean area */
+# define VM_SOFTDIRTY	BIT(27)		/* Not soft dirty clean area */
 #else
 # define VM_SOFTDIRTY	0
 #endif
 
-#define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
-#define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
-#define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
+#define VM_MIXEDMAP	BIT(28)		/* Can contain "struct page" and pure PFN pages */
+#define VM_HUGEPAGE	BIT(29)		/* MADV_HUGEPAGE marked this vma */
+#define VM_NOHUGEPAGE	BIT(30)		/* MADV_NOHUGEPAGE marked this vma */
 #define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
 
 #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
_

Patches currently in -mm which might be from acsjakub@amazon.de are

mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise.patch
mm-redefine-vm_-flag-constants-with-bit.patch

