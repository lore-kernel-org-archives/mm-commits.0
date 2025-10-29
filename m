Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BDA2DF13B
	for <mm-commits@vger.kernel.org>; Wed, 29 Oct 2025 21:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761774903; cv=none; b=c1DDMsjjWYRQLMuU4ctIAQO1MQ9+md3kVr4m03zs2w4vy96OmjHMw/PmViQv0DceYWCXzw2VJ3R0lVMaa+p6aGBUp+OHSUzV23KB7MzdYzjG9xXoosxm2ArJwHzjISh/K5jd/HiBFzwEJ/DKhUNaB1KdU3Q1XyeXNIhMcy9I364=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761774903; c=relaxed/simple;
	bh=VcabaLVBDBhfan97ai6NE9Wk1armu9+oryCM9KA/lOM=;
	h=Date:To:From:Subject:Message-Id; b=e5PEmOJjZ1x2mQBVWSQB+1+Yxa+8A0y2686eH1AHNJUX+bBDwfTPaxkfAPnLbCDwimfUOhDOQjkHm8QoSIAjrXZSl1Kvv+KwMkN/MmL4jtxxr6AgMfbk+5HvMmvCMbbs+WzF1y8h8I1AHxfOvnjlRfhY0eK0y/4ywq/5h0kNsr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mucStRyj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mucStRyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C6BC4CEF7;
	Wed, 29 Oct 2025 21:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761774903;
	bh=VcabaLVBDBhfan97ai6NE9Wk1armu9+oryCM9KA/lOM=;
	h=Date:To:From:Subject:From;
	b=mucStRyjqgVmHszk1KXqYKNuMLyZ059TKReI8pYCsqH0yFxwazws6x47JF2Mo+9+7
	 DrIuiALbiNKYQaVX03j7QVpnUBmI1JzB3VTPUqEWcYeUYtXmzcD5x7GkTxuKRV4/cb
	 BXNyDo7u0wwWqSPo/pqqxEn3mXdbnoUyAaeX3R+E=
Date: Wed, 29 Oct 2025 14:55:02 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,rdunlap@infradead.org,osandov@osandov.com,lorenzo.stoakes@oracle.com,david@redhat.com,linux@israelbatista.dev.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-memory-block-states-mem_-macros-to-enum.patch added to mm-new branch
Message-Id: <20251029215503.12C6BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert memory block states (MEM_*) macros to enum
has been added to the -mm mm-new branch.  Its filename is
     mm-convert-memory-block-states-mem_-macros-to-enum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-memory-block-states-mem_-macros-to-enum.patch

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
From: Israel Batista <linux@israelbatista.dev.br>
Subject: mm: convert memory block states (MEM_*) macros to enum
Date: Wed, 29 Oct 2025 19:56:28 +0000 (UTC)

Patch series "mm: Convert memory block states (MEM_*) macros to enums", v2.

The MEM_* constants indicating the state of a memory block are currently
defined as macros, meaning their definitions will be omitted from the
debuginfo on most kernel builds.  This makes it harder for debuggers to
correctly map the block state at runtime, which can be quite useful when
analysing errors related to memory hot plugging and unplugging with tools
such as drgn.

Converting the constants to an enum ensures the correct information is
emitted by the compiler and available for the debugger, without needing to
hard-code them into the debugger and track their changes.

This patch series aims to replace the current macros with a newly created
enum named memory_block_state, while also taking advantage of the compile
time guarantees that we get when using enums.

The first patch does the conversion of the macros to an enum, while the
2nd and 3rd patches use this enum to clean up some type declarations and
make sure that only valid values are used.


This patch (of 3):

Converting the MEM_* constants from macros to an enum ensures that their
values will be correctly emitted in the debug symbols, making it easier to
trace the meaning of each value when debugging with tools such as drgn,
without the need to hard-code the values.

Since the values are mutually exclusive and they are not exposed directly
to userspace, I also dropped the misleading pattern (1<<X) that made it
look like they were combinable flags.

Link: https://lkml.kernel.org/r/20251029195617.2210700-1-linux@israelbatista.dev.br
Link: https://lkml.kernel.org/r/20251029195617.2210700-2-linux@israelbatista.dev.br
Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Omar Sandoval <osandov@osandov.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/include/linux/memory.h~mm-convert-memory-block-states-mem_-macros-to-enum
+++ a/include/linux/memory.h
@@ -64,6 +64,18 @@ struct memory_group {
 	};
 };
 
+enum memory_block_state {
+	/* These states are exposed to userspace as text strings in sysfs */
+	MEM_ONLINE,		/* exposed to userspace */
+	MEM_GOING_OFFLINE,	/* exposed to userspace */
+	MEM_OFFLINE,		/* exposed to userspace */
+	MEM_GOING_ONLINE,
+	MEM_CANCEL_ONLINE,
+	MEM_CANCEL_OFFLINE,
+	MEM_PREPARE_ONLINE,
+	MEM_FINISH_OFFLINE,
+};
+
 struct memory_block {
 	unsigned long start_section_nr;
 	unsigned long state;		/* serialized by the dev->lock */
@@ -89,16 +101,6 @@ int arch_get_memory_phys_device(unsigned
 unsigned long memory_block_size_bytes(void);
 int set_memory_block_size_order(unsigned int order);
 
-/* These states are exposed to userspace as text strings in sysfs */
-#define	MEM_ONLINE		(1<<0) /* exposed to userspace */
-#define	MEM_GOING_OFFLINE	(1<<1) /* exposed to userspace */
-#define	MEM_OFFLINE		(1<<2) /* exposed to userspace */
-#define	MEM_GOING_ONLINE	(1<<3)
-#define	MEM_CANCEL_ONLINE	(1<<4)
-#define	MEM_CANCEL_OFFLINE	(1<<5)
-#define	MEM_PREPARE_ONLINE	(1<<6)
-#define	MEM_FINISH_OFFLINE	(1<<7)
-
 struct memory_notify {
 	/*
 	 * The altmap_start_pfn and altmap_nr_pages fields are designated for
_

Patches currently in -mm which might be from linux@israelbatista.dev.br are

mm-convert-memory-block-states-mem_-macros-to-enum.patch
mm-change-type-of-state-in-struct-memory_block.patch
mm-change-type-of-parameter-for-memory_notify.patch

