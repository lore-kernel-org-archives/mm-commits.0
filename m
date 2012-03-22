From: akpm@linux-foundation.org
Subject: [merged] numa_emulation-fix-cpumask_of_node.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:20 -0700
Message-ID: <20120322201920.8D282A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:58907 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030636Ab2CVUTW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:22 -0400
Received: by mail-ey0-f202.google.com with SMTP id q10so134201eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andi@firstfloor.org, hpa@zytor.com, jweiner@redhat.com, mingo@elte.hu, rientjes@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: numa_emulation: fix cpumask_of_node()
has been removed from the -mm tree.  Its filename was
     numa_emulation-fix-cpumask_of_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: numa_emulation: fix cpumask_of_node()

Without this fix the cpumask_of_node() for a fake=numa=2 is:

cpumask 0 ff
cpumask 1 ff

with the fix it's correct and it's set to:

cpumask 0 55
cpumask 1 aa

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa_emulation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/numa_emulation.c~numa_emulation-fix-cpumask_of_node arch/x86/mm/numa_emulation.c
--- a/arch/x86/mm/numa_emulation.c~numa_emulation-fix-cpumask_of_node
+++ a/arch/x86/mm/numa_emulation.c
@@ -60,7 +60,7 @@ static int __init emu_setup_memblk(struc
 	eb->nid = nid;
 
 	if (emu_nid_to_phys[nid] == NUMA_NO_NODE)
-		emu_nid_to_phys[nid] = pb->nid;
+		emu_nid_to_phys[nid] = nid;
 
 	pb->start += size;
 	if (pb->start >= pb->end) {
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
linux-next.patch

