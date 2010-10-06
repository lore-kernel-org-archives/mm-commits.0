From: akpm@linux-foundation.org
Subject: + memblock-fix-big-size-with-find_region.patch added to -mm tree
Date: Wed, 06 Oct 2010 14:06:31 -0700
Message-ID: <201010062106.o96L6Vq5022086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014Ab0JFVHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Oct 2010 17:07:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, benh@kernel.crashing.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     memblock: fix big size with find_region()
has been added to the -mm tree.  Its filename is
     memblock-fix-big-size-with-find_region.patch

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
Subject: memblock: fix big size with find_region()
From: Yinghai Lu <yinghai@kernel.org>

When trying to find a huge range for crashkernel we get

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/mm/memblock.c:248 memblock_x86_reserve_range+0x40/0x7a()
[    0.000000] Hardware name: Sun Fire x4800
[    0.000000] memblock_x86_reserve_range: wrong range [0xffffffff37000000, 0x137000000)
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.36-rc5-tip-yh-01876-g1cac214-dirty #59
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff82816f7e>] ? memblock_x86_reserve_range+0x40/0x7a
[    0.000000]  [<ffffffff81078c2d>] warn_slowpath_common+0x85/0x9e
[    0.000000]  [<ffffffff81078d38>] warn_slowpath_fmt+0x6e/0x70
[    0.000000]  [<ffffffff8281e77c>] ? memblock_find_region+0x40/0x78
[    0.000000]  [<ffffffff8281eb1f>] ? memblock_find_base+0x9a/0xb9
[    0.000000]  [<ffffffff82816f7e>] memblock_x86_reserve_range+0x40/0x7a
[    0.000000]  [<ffffffff8280452c>] setup_arch+0x99d/0xb2a
[    0.000000]  [<ffffffff810a3e02>] ? trace_hardirqs_off+0xd/0xf
[    0.000000]  [<ffffffff81cec7d8>] ? _raw_spin_unlock_irqrestore+0x3d/0x4c
[    0.000000]  [<ffffffff827ffcec>] start_kernel+0xde/0x3f1
[    0.000000]  [<ffffffff827ff2d4>] x86_64_start_reservations+0xa0/0xa4
[    0.000000]  [<ffffffff827ff3de>] x86_64_start_kernel+0x106/0x10d
[    0.000000] ---[ end trace a7919e7f17c0a725 ]---
[    0.000000] Reserving 8192MB of memory at 17592186041200MB for crashkernel (System RAM: 526336MB)

Because memblock_find_region() can not handle size > end, base will be set
to huge num.

Try to check size with end.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/memblock.c~memblock-fix-big-size-with-find_region mm/memblock.c
--- a/mm/memblock.c~memblock-fix-big-size-with-find_region
+++ a/mm/memblock.c
@@ -105,13 +105,18 @@ static phys_addr_t __init memblock_find_
 	phys_addr_t base, res_base;
 	long j;
 
+	/* In case, huge size is requested */
+	if (end < size)
+		return MEMBLOCK_ERROR;
+
+	base = memblock_align_down((end - size), align);
+
 	/* Prevent allocations returning 0 as it's also used to
 	 * indicate an allocation failure
 	 */
 	if (start == 0)
 		start = PAGE_SIZE;
 
-	base = memblock_align_down((end - size), align);
 	while (start <= base) {
 		j = memblock_overlaps_region(&memblock.reserved, base, size);
 		if (j < 0)
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
linux-next.patch
memblock-fix-big-size-with-find_region.patch

