From: akpm@linux-foundation.org
Subject: - uml-out-of-tmpfs-space-error-clarification.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:42 -0700
Message-ID: <200705080007.l4807gNF009309@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967410AbXEHAIE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:08:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: out of tmpfs space error clarification
has been removed from the -mm tree.  Its filename was
     uml-out-of-tmpfs-space-error-clarification.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: out of tmpfs space error clarification
From: Jeff Dike <jdike@addtoit.com>

It turns out that the message complaining about a lack of tmpfs space
on the host can be misunderstood as referring to the UML.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/trap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/kernel/trap.c~uml-out-of-tmpfs-space-error-clarification arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~uml-out-of-tmpfs-space-error-clarification
+++ a/arch/um/kernel/trap.c
@@ -229,8 +229,8 @@ void relay_signal(int sig, union uml_pt_
 
 	if(!UPT_IS_USER(regs)){
 		if(sig == SIGBUS)
-			printk("Bus error - the /dev/shm or /tmp mount likely "
-			       "just ran out of space\n");
+			printk("Bus error - the host /dev/shm or /tmp mount "
+			       "likely just ran out of space\n");
 		panic("Kernel mode signal %d", sig);
 	}
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
