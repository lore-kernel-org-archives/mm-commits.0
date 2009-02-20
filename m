From: akpm@linux-foundation.org
Subject: + mm-fix-lazy-vmap-purging-use-after-free-error.patch added to -mm tree
Date: Fri, 20 Feb 2009 09:53:37 -0800
Message-ID: <200902201753.n1KHrb5M021223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388AbZBTRyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Feb 2009 12:54:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vegard.nossum@gmail.com, mingo@elte.hu, npiggin@suse.de, paulmck@linux.vnet.ibm.com, penberg@cs.helsinki.fi, stable@kernel.org


The patch titled
     mm: fix lazy vmap purging (use-after-free error)
has been added to the -mm tree.  Its filename is
     mm-fix-lazy-vmap-purging-use-after-free-error.patch

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
Subject: mm: fix lazy vmap purging (use-after-free error)
From: Vegard Nossum <vegard.nossum@gmail.com>

From f90fae887ed82bc9369e9f95960e175fef3e5d97 Mon Sep 17 00:00:00 2001
Date: Fri, 20 Feb 2009 14:35:09 +0100
Subject: [PATCH] mm: fix lazy vmap purging (use-after-free error)

I just got this new warning from kmemcheck:

    WARNING: kmemcheck: Caught 32-bit read from freed memory (c7806a60)
    a06a80c7ecde70c1a04080c700000000a06709c1000000000000000000000000
     f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f
     ^

    Pid: 0, comm: swapper Not tainted (2.6.29-rc4 #230)
    EIP: 0060:[<c1096df7>] EFLAGS: 00000286 CPU: 0
    EIP is at __purge_vmap_area_lazy+0x117/0x140
    EAX: 00070f43 EBX: c7806a40 ECX: c1677080 EDX: 00027b66
    ESI: 00002001 EDI: c170df0c EBP: c170df00 ESP: c178830c
     DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
    CR0: 80050033 CR2: c7806b14 CR3: 01775000 CR4: 00000690
    DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
    DR6: 00004000 DR7: 00000000
     [<c1096f3e>] free_unmap_vmap_area_noflush+0x6e/0x70
     [<c1096f6a>] remove_vm_area+0x2a/0x70
     [<c1097025>] __vunmap+0x45/0xe0
     [<c10970de>] vunmap+0x1e/0x30
     [<c1008ba5>] text_poke+0x95/0x150
     [<c1008ca9>] alternatives_smp_unlock+0x49/0x60
     [<c171ef47>] alternative_instructions+0x11b/0x124
     [<c171f991>] check_bugs+0xbd/0xdc
     [<c17148c5>] start_kernel+0x2ed/0x360
     [<c171409e>] __init_begin+0x9e/0xa9
     [<ffffffff>] 0xffffffff

It happened here:

    $ addr2line -e vmlinux -i c1096df7
    mm/vmalloc.c:540

Code:

	list_for_each_entry(va, &valist, purge_list)
		__free_vmap_area(va);

It's this instruction:

    mov    0x20(%ebx),%edx

Which corresponds to a dereference of va->purge_list.next:

    (gdb) p ((struct vmap_area *) 0)->purge_list.next
    Cannot access memory at address 0x20

It seems that we should use "safe" list traversal here, as the element
is freed inside the loop. Please verify that this is the right fix.

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-fix-lazy-vmap-purging-use-after-free-error mm/vmalloc.c
--- a/mm/vmalloc.c~mm-fix-lazy-vmap-purging-use-after-free-error
+++ a/mm/vmalloc.c
@@ -506,6 +506,7 @@ static void __purge_vmap_area_lazy(unsig
 	static DEFINE_SPINLOCK(purge_lock);
 	LIST_HEAD(valist);
 	struct vmap_area *va;
+	struct vmap_area *n_va;
 	int nr = 0;
 
 	/*
@@ -545,7 +546,7 @@ static void __purge_vmap_area_lazy(unsig
 
 	if (nr) {
 		spin_lock(&vmap_area_lock);
-		list_for_each_entry(va, &valist, purge_list)
+		list_for_each_entry_safe(va, n_va, &valist, purge_list)
 			__free_vmap_area(va);
 		spin_unlock(&vmap_area_lock);
 	}
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

linux-next.patch
mm-fix-lazy-vmap-purging-use-after-free-error.patch

