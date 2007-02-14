From: akpm@linux-foundation.org
Subject: + ppc64-kdump-documentation-update-for-2620.patch added to -mm tree
Date: Wed, 14 Feb 2007 15:11:39 -0800
Message-ID: <200702142311.l1ENBdQi012339@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50436 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964814AbXBNXLu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 18:11:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au, mohan@in.ibm.com, paulus@samba.org, vgoyal@in.ibm.com


The patch titled
     PPC64 Kdump documentation update
has been added to the -mm tree.  Its filename is
     ppc64-kdump-documentation-update-for-2620.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PPC64 Kdump documentation update
From: Simon Horman <horms@verge.net.au>

Patch from Mohan Kumar M to add the ppc64 portions of the kdump
documentation.

http://thread.gmane.org/gmane.linux.kernel/481689/focus=3375

Cc: Mohan Kumar M <mohan@in.ibm.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff -puN Documentation/kdump/kdump.txt~ppc64-kdump-documentation-update-for-2620 Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~ppc64-kdump-documentation-update-for-2620
+++ a/Documentation/kdump/kdump.txt
@@ -30,6 +30,10 @@ On x86 machines, the first 640 KB of phy
 regardless of where the kernel loads. Therefore, kexec backs up this
 region just before rebooting into the dump-capture kernel.
 
+Similarly on PPC64 machines first 32KB of physical memory is needed for
+booting regardless of where the kernel is loaded and to support 64K page
+size kexec backs up the first 64KB memory.
+
 All of the necessary information about the system kernel's core image is
 encoded in the ELF format, and stored in a reserved area of memory
 before a crash. The physical address of the start of the ELF header is
@@ -224,7 +228,7 @@ Dump-capture kernel config options (Arch
 Dump-capture kernel config options (Arch Dependent, ppc64)
 ----------------------------------------------------------
 
--  Make and install the kernel and its modules. DO NOT add this kernel
+*  Make and install the kernel and its modules. DO NOT add this kernel
    to the boot loader configuration files.
 
 Dump-capture kernel config options (Arch Dependent, ia64)
@@ -251,8 +255,8 @@ Dump-capture kernel config options (Arch
 Boot into System Kernel
 =======================
 
-1) Make and install the kernel and its modules. Update the boot loader
-   (such as grub, yaboot, or lilo) configuration files as necessary.
+1) Update the boot loader (such as grub, yaboot, or lilo) configuration
+   files as necessary.
 
 2) Boot the system kernel with the boot parameter "crashkernel=Y@X",
    where Y specifies how much memory to reserve for the dump-capture kernel
@@ -356,10 +360,11 @@ If die() is called, and it happens to be
 is called inside interrupt context or die() is called and panic_on_oops is set,
 the system will boot into the dump-capture kernel.
 
-On powererpc systems when a soft-reset is generated, die() is called by all cpus and the system will boot into the dump-capture kernel.
+On powererpc systems when a soft-reset is generated, die() is called by all cpus
+and the system will boot into the dump-capture kernel.
 
 For testing purposes, you can trigger a crash by using "ALT-SysRq-c",
-"echo c > /proc/sysrq-trigger or write a module to force the panic.
+"echo c > /proc/sysrq-trigger" or write a module to force the panic.
 
 Write Out the Dump File
 =======================
@@ -410,12 +415,9 @@ format. Crash is available on Dave Ander
 To Do
 =====
 
-1) Provide a kernel pages filtering mechanism, so core file size is not
-   extreme on systems with huge memory banks.
-
-2) Relocatable kernel can help in maintaining multiple kernels for
-   crash_dump, and the same kernel as the system kernel can be used to
-   capture the dump.
+1) Provide relocatable kernels for all architectures to help in maintaining
+   multiple kernels for crash_dump, and the same kernel as the system kernel
+   can be used to capture the dump.
 
 
 Contact
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch
git-ia64.patch
ia64-point-saved_max_pfn-to-the-max_pfn-of-the-entire-system.patch
update-osdl-linux-foundation-maintainer-addresses.patch
ppc64-kdump-documentation-update-for-2620.patch
