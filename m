Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E93723D2AB
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343276; cv=none; b=P0ZxT1cuEWa0PxGgATKqk9L0+h+WLhqMtTpgeKk2VPTgjdKEjAhZ+qrrS5e8rxw8u9tkZRdkSlBhg/mjQF7iMOgxbrbZsv4KtlfXxaXlvh87Ysxe3mYhn8icgmGvaipZyJdERcoVzhKLEs02xltAiB8ODbvAwKJOLpg9sUdf1X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343276; c=relaxed/simple;
	bh=y1tI7A06uUHH2EsinG8xV+AecIfninYg0GgAtqndvBM=;
	h=Date:To:From:Subject:Message-Id; b=thpw+Tz3aiopUcT0+rrTZEkLlnYn9Wy1xOJQ75ewxXHzT+heUYKdLCGiEDuNwsw54ZfU6t0nIHtmGnJlfJgh4O41uVFiZnQPR1LkcuGakE44neN7Tks1+d7jhnVXPrzKi2W1VcjW95obvKox10pQeHksw7KDgYuBatQYiC0iqFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sjzhjTHx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sjzhjTHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5444C19423;
	Mon, 17 Nov 2025 01:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343275;
	bh=y1tI7A06uUHH2EsinG8xV+AecIfninYg0GgAtqndvBM=;
	h=Date:To:From:Subject:From;
	b=sjzhjTHx/jHV07J9K0xRSO6aFSazLRZvOTK6zhmf/Nw4rYVrV5tMInNLEhq3hypIv
	 thClToxi233YKZvFSUlN1YDKFMYZI/2O4yRskx6FO8WO9x8Gt2bwNEz5GsulIU0kVu
	 nrCRCx+DFRQQgTQb4RryRmUPP+q0YC5cFj5MSzn4=
Date: Sun, 16 Nov 2025 17:34:35 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,rdunlap@infradead.org,osandov@osandov.com,lorenzo.stoakes@oracle.com,david@redhat.com,linux@israelbatista.dev.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-memory-block-states-mem_-macros-to-enum.patch removed from -mm tree
Message-Id: <20251117013435.C5444C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert memory block states (MEM_*) macros to enum
has been removed from the -mm tree.  Its filename was
     mm-convert-memory-block-states-mem_-macros-to-enum.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Omar Sandoval <osandov@osandov.com>
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


