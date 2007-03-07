From: akpm@linux-foundation.org
Subject: - uml-add-a-debugging-message.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:46 -0800
Message-ID: <200703070421.l274Lkir018930@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47059 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161327AbXCGEVt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: add a debugging message
has been removed from the -mm tree.  Its filename was
     uml-add-a-debugging-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: add a debugging message
From: Jeff Dike <jdike@addtoit.com>

Add a debugging message in the case that mapping a stub fails.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/skas/process.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/um/os-Linux/skas/process.c~uml-add-a-debugging-message arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-add-a-debugging-message
+++ a/arch/um/os-Linux/skas/process.c
@@ -419,9 +419,12 @@ void map_stub_pages(int fd, unsigned lon
 					  .offset  = code_offset
 	} } });
 	n = os_write_file(fd, &mmop, sizeof(mmop));
-	if(n != sizeof(mmop))
+	if(n != sizeof(mmop)){
+		printk("mmap args - addr = 0x%lx, fd = %d, offset = %llx\n",
+		       code, code_fd, (unsigned long long) code_offset);
 		panic("map_stub_pages : /proc/mm map for code failed, "
 		      "err = %d\n", -n);
+	}
 
 	if ( stack ) {
 		__u64 map_offset;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-fix-double-free.patch
uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
uml-fix-a-memory-leak-in-the-multicast-driver.patch
uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
uml-mark-both-consoles-as-con_anytime.patch
uml-fix-confusion-irq-early-reenabling.patch
uml-activate_fd-return-enomem-only-when-appropriate.patch
uml-fix-errno-usage.patch
div64_64-common-code.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
uml-fix-prototypes.patch
