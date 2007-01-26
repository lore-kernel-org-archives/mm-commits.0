From: akpm@osdl.org
Subject: - kdump-documentation-update-for-2620-ia64-portion.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:51:50 -0800
Message-ID: <200701260751.l0Q7poLE010762@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50508 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030818AbXAZHv5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:51:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, nanhai.zou@intel.com, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Kdump documentation update: ia64 portion
has been removed from the -mm tree.  Its filename was
     kdump-documentation-update-for-2620-ia64-portion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Kdump documentation update: ia64 portion
From: Horms <horms@verge.net.au>

this patch fills in the portions for ia64 kexec.

Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: "Zou, Nanhai" <nanhai.zou@intel.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kdump/kdump.txt |   36 +++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff -puN Documentation/kdump/kdump.txt~kdump-documentation-update-for-2620-ia64-portion Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~kdump-documentation-update-for-2620-ia64-portion
+++ a/Documentation/kdump/kdump.txt
@@ -17,7 +17,7 @@ You can use common Linux commands, such 
 memory image to a dump file on the local disk, or across the network to
 a remote system.
 
-Kdump and kexec are currently supported on the x86, x86_64, ppc64 and IA64
+Kdump and kexec are currently supported on the x86, x86_64, ppc64 and ia64
 architectures.
 
 When the system kernel boots, it reserves a small section of memory for
@@ -229,7 +229,23 @@ Dump-capture kernel config options (Arch
 
 Dump-capture kernel config options (Arch Dependent, ia64)
 ----------------------------------------------------------
-(To be filled)
+
+- No specific options are required to create a dump-capture kernel
+  for ia64, other than those specified in the arch idependent section
+  above. This means that it is possible to use the system kernel
+  as a dump-capture kernel if desired.
+
+  The crashkernel region can be automatically placed by the system
+  kernel at run time. This is done by specifying the base address as 0,
+  or omitting it all together.
+
+  crashkernel=256M@0
+  or
+  crashkernel=256M
+
+  If the start address is specified, note that the start address of the
+  kernel will be aligned to 64Mb, so if the start address is not then
+  any space below the alignment point will be wasted.
 
 
 Boot into System Kernel
@@ -248,6 +264,10 @@ Boot into System Kernel
 
    On ppc64, use "crashkernel=128M@32M".
 
+   On ia64, 256M@256M is a generous value that typically works.
+   The region may be automatically placed on ia64, see the
+   dump-capture kernel config option notes above.
+
 Load the Dump-capture Kernel
 ============================
 
@@ -266,7 +286,8 @@ For x86_64:
 For ppc64:
 	- Use vmlinux
 For ia64:
-	(To be filled)
+	- Use vmlinux or vmlinuz.gz
+
 
 If you are using a uncompressed vmlinux image then use following command
 to load dump-capture kernel.
@@ -282,18 +303,19 @@ to load dump-capture kernel.
    --initrd=<initrd-for-dump-capture-kernel> \
    --append="root=<root-dev> <arch-specific-options>"
 
+Please note, that --args-linux does not need to be specified for ia64.
+It is planned to make this a no-op on that architecture, but for now
+it should be omitted
+
 Following are the arch specific command line options to be used while
 loading dump-capture kernel.
 
-For i386 and x86_64:
+For i386, x86_64 and ia64:
 	"init 1 irqpoll maxcpus=1"
 
 For ppc64:
 	"init 1 maxcpus=1 noirqdistrib"
 
-For IA64
-	(To be filled)
-
 
 Notes on loading the dump-capture kernel:
 
_

Patches currently in -mm which might be from horms@verge.net.au are
