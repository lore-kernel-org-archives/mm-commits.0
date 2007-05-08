From: akpm@linux-foundation.org
Subject: - uml-speed-up-exec.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:37 -0700
Message-ID: <200705080006.l4806buL009209@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967476AbXEHALW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:11:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: speed up exec
has been removed from the -mm tree.  Its filename was
     uml-speed-up-exec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: speed up exec
From: Jeff Dike <jdike@addtoit.com>

flush_thread doesn't need to do a full page table walk in order to clear the
address space.  It knows what the end result needs to be, so it can call unmap
directly.

This results in a 10-20% speedup in an exec from bash.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/skas/exec.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN arch/um/kernel/skas/exec.c~uml-speed-up-exec arch/um/kernel/skas/exec.c
--- a/arch/um/kernel/skas/exec.c~uml-speed-up-exec
+++ a/arch/um/kernel/skas/exec.c
@@ -17,7 +17,17 @@
 
 void flush_thread_skas(void)
 {
-	force_flush_all();
+	void *data = NULL;
+	unsigned long end = proc_mm ? task_size : CONFIG_STUB_START;
+	int ret;
+
+	ret = unmap(&current->mm->context.skas.id, 0, end, 1, &data);
+	if(ret){
+		printk("flush_thread_skas - clearing address space failed, "
+		       "err = %d\n", ret);
+		force_sig(SIGKILL, current);
+	}
+
 	switch_mm_skas(&current->mm->context.skas.id);
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
