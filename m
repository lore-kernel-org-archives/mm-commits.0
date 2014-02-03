From: akpm@linux-foundation.org
Subject: +
 arch-x86-mm-numa_32c-fix-the-initialization-of-physnode_map.patch added to
 -mm tree
Date: Mon, 03 Feb 2014 14:47:39 -0800
Message-ID: <52f01c8b.ExcxiTlno1BIC/r9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaBCWrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 17:47:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ptesarik@suse.cz

Subject: + arch-x86-mm-numa_32c-fix-the-initialization-of-physnode_map.patch added to -mm tree
To: ptesarik@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 14:47:39 -0800


The patch titled
     Subject: arch/x86/mm/numa_32.c: fix the initialization of physnode_map
has been added to the -mm tree.  Its filename is
     arch-x86-mm-numa_32c-fix-the-initialization-of-physnode_map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-x86-mm-numa_32c-fix-the-initialization-of-physnode_map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-mm-numa_32c-fix-the-initialization-of-physnode_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Tesarik <ptesarik@suse.cz>
Subject: arch/x86/mm/numa_32.c: fix the initialization of physnode_map

With DISCONTIGMEM, the mapping between a pfn and its owning node is
initialized using data provided by the BIOS.  However, the initialization
may fail if the extents are not aligned to section boundary (64M).

The symptom of this bug is an early boot failure in pfn_to_page(), as it
tries to access NODE_DATA(__nid) using index from an unitialized element
of the physnode_map[] array.

While the bug is always present, it is more likely to be hit in kdump
kernels on large machines, because:

1. The memory map for a kdump kernel is specified as exactmap, and
   exactmap is more likely to be unaligned.

2. Large reservations are more likely to span across a 64M boundary.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa_32.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/mm/numa_32.c~arch-x86-mm-numa_32c-fix-the-initialization-of-physnode_map arch/x86/mm/numa_32.c
--- a/arch/x86/mm/numa_32.c~arch-x86-mm-numa_32c-fix-the-initialization-of-physnode_map
+++ a/arch/x86/mm/numa_32.c
@@ -52,6 +52,8 @@ void memory_present(int nid, unsigned lo
 			nid, start, end);
 	printk(KERN_DEBUG "  Setting physnode_map array to node %d for pfns:\n", nid);
 	printk(KERN_DEBUG "  ");
+	pfn = round_down(pfn, PAGES_PER_SECTION);
+	end = round_up(end, PAGES_PER_SECTION);
 	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
 		physnode_map[pfn / PAGES_PER_SECTION] = nid;
 		printk(KERN_CONT "%lx ", pfn);
_

Patches currently in -mm which might be from ptesarik@suse.cz are

arch-x86-mm-numa_32c-fix-the-initialization-of-physnode_map.patch
linux-next.patch

