From: akpm@linux-foundation.org
Subject: [merged] init-mainc-improve-usability-in-case-of-init-binary-failure.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:05:35 -0800
Message-ID: <201003091905.o29J5Zhk031131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755865Ab0CITGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:06:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@lisas.de, mm-commits@vger.kernel.org


The patch titled
     init/main.c: improve usability in case of init binary failure
has been removed from the -mm tree.  Its filename was
     init-mainc-improve-usability-in-case-of-init-binary-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init/main.c: improve usability in case of init binary failure
From: Andreas Mohr <andi@lisas.de>

- new Documentation/init.txt file describing various forms of failure
  trying to load the init binary after kernel bootup

- extend the init/main.c init failure message to direct to
  Documentation/init.txt

Signed-off-by: Andreas Mohr <andi@lisas.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/init.txt |   49 +++++++++++++++++++++++++++++++++++++++
 init/main.c            |    3 +-
 2 files changed, 51 insertions(+), 1 deletion(-)

diff -puN /dev/null Documentation/init.txt
--- /dev/null
+++ a/Documentation/init.txt
@@ -0,0 +1,49 @@
+Explaining the dreaded "No init found." boot hang message
+=========================================================
+
+OK, so you've got this pretty unintuitive message (currently located
+in init/main.c) and are wondering what the H*** went wrong.
+Some high-level reasons for failure (listed roughly in order of execution)
+to load the init binary are:
+A) Unable to mount root FS
+B) init binary doesn't exist on rootfs
+C) broken console device
+D) binary exists but dependencies not available
+E) binary cannot be loaded
+
+Detailed explanations:
+0) Set "debug" kernel parameter (in bootloader config file or CONFIG_CMDLINE)
+   to get more detailed kernel messages.
+A) make sure you have the correct root FS type
+   (and root= kernel parameter points to the correct partition),
+   required drivers such as storage hardware (such as SCSI or USB!)
+   and filesystem (ext3, jffs2 etc.) are builtin (alternatively as modules,
+   to be pre-loaded by an initrd)
+C) Possibly a conflict in console= setup --> initial console unavailable.
+   E.g. some serial consoles are unreliable due to serial IRQ issues (e.g.
+   missing interrupt-based configuration).
+   Try using a different console= device or e.g. netconsole= .
+D) e.g. required library dependencies of the init binary such as
+   /lib/ld-linux.so.2 missing or broken. Use readelf -d <INIT>|grep NEEDED
+   to find out which libraries are required.
+E) make sure the binary's architecture matches your hardware.
+   E.g. i386 vs. x86_64 mismatch, or trying to load x86 on ARM hardware.
+   In case you tried loading a non-binary file here (shell script?),
+   you should make sure that the script specifies an interpreter in its shebang
+   header line (#!/...) that is fully working (including its library
+   dependencies). And before tackling scripts, better first test a simple
+   non-script binary such as /bin/sh and confirm its successful execution.
+   To find out more, add code to init/main.c to display kernel_execve()s
+   return values.
+
+Please extend this explanation whenever you find new failure causes
+(after all loading the init binary is a CRITICAL and hard transition step
+which needs to be made as painless as possible), then submit patch to LKML.
+Further TODOs:
+- Implement the various run_init_process() invocations via a struct array
+  which can then store the kernel_execve() result value and on failure
+  log it all by iterating over _all_ results (very important usability fix).
+- try to make the implementation itself more helpful in general,
+  e.g. by providing additional error messages at affected places.
+
+Andreas Mohr <andi at lisas period de>
diff -puN init/main.c~init-mainc-improve-usability-in-case-of-init-binary-failure init/main.c
--- a/init/main.c~init-mainc-improve-usability-in-case-of-init-binary-failure
+++ a/init/main.c
@@ -847,7 +847,8 @@ static noinline int init_post(void)
 	run_init_process("/bin/init");
 	run_init_process("/bin/sh");
 
-	panic("No init found.  Try passing init= option to kernel.");
+	panic("No init found.  Try passing init= option to kernel. "
+	      "See Linux Documentation/init.txt for guidance.");
 }
 
 static int __init kernel_init(void * unused)
_

Patches currently in -mm which might be from andi@lisas.de are

acerhdf-add-new-bios-versions.patch
usb-serial-ftdi-add-contec-vendor-and-product-id.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch

