From: akpm@linux-foundation.org
Subject: + express-relocatability-of-kernel-on-x86_64-in-documentation.patch added to -mm tree
Date: Sat, 15 Sep 2007 01:18:38 -0700
Message-ID: <200709150818.l8F8IcQl025002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48969 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153AbXIOISt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Sep 2007 04:18:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ebiederm@xmission.com, hbabu@us.ibm.com, rdunlap@xenotime.net, vgoyal@in.ibm.com


The patch titled
     Express relocatability of kernel on x86_64 in documentation
has been added to the -mm tree.  Its filename is
     express-relocatability-of-kernel-on-x86_64-in-documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Express relocatability of kernel on x86_64 in documentation
From: Bernhard Walle <bwalle@suse.de>

This patch adapts the Documentation/kdump/kdump.txt file to express the fact
that the x86_64 kernel is now also relocatable.  This makes i386 and x86_64
now behave the same, simplifying the documentation.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |   35 +++++---------------------------
 1 file changed, 6 insertions(+), 29 deletions(-)

diff -puN Documentation/kdump/kdump.txt~express-relocatability-of-kernel-on-x86_64-in-documentation Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~express-relocatability-of-kernel-on-x86_64-in-documentation
+++ a/Documentation/kdump/kdump.txt
@@ -159,16 +159,17 @@ Dump-capture kernel config options (Arch
    CONFIG_PROC_VMCORE=y
    (CONFIG_PROC_VMCORE is set by default when CONFIG_CRASH_DUMP is selected.)
 
-Dump-capture kernel config options (Arch Dependent, i386)
---------------------------------------------------------
-1) On x86, enable high memory support under "Processor type and
+Dump-capture kernel config options (Arch Dependent, i386 and x86_64)
+--------------------------------------------------------------------
+
+1) On i386, enable high memory support under "Processor type and
    features":
 
    CONFIG_HIGHMEM64G=y
    or
    CONFIG_HIGHMEM4G
 
-2) On x86 and x86_64, disable symmetric multi-processing support
+2) On i386 and x86_64, disable symmetric multi-processing support
    under "Processor type and features":
 
    CONFIG_SMP=n
@@ -203,28 +204,6 @@ Dump-capture kernel config options (Arch
 5) Make and install the kernel and its modules. DO NOT add this kernel
    to the boot loader configuration files.
 
-Dump-capture kernel config options (Arch Dependent, x86_64)
-----------------------------------------------------------
-1) On x86 and x86_64, disable symmetric multi-processing support
-   under "Processor type and features":
-
-   CONFIG_SMP=n
-
-   (If CONFIG_SMP=y, then specify maxcpus=1 on the kernel command line
-   when loading the dump-capture kernel, see section "Load the Dump-capture
-   Kernel".)
-
-2) Use a suitable value for "Physical address where the kernel is
-   loaded" (under "Processor type and features"). This only appears when
-   "kernel crash dumps" is enabled. By default this value is 0x1000000
-   (16MB). It should be the same as X in the "crashkernel=Y@X" boot
-   parameter.
-
-   For x86_64, normally "CONFIG_PHYSICAL_START=0x1000000".
-
-3) Make and install the kernel and its modules. DO NOT add this kernel
-   to the boot loader configuration files.
-
 Dump-capture kernel config options (Arch Dependent, ppc64)
 ----------------------------------------------------------
 
@@ -282,11 +261,9 @@ Based on the architecture and type of im
 can choose to load the uncompressed vmlinux or compressed bzImage/vmlinuz
 of dump-capture kernel. Following is the summary.
 
-For i386:
+For i386 and x86_64:
 	- Use vmlinux if kernel is not relocatable.
 	- Use bzImage/vmlinuz if kernel is relocatable.
-For x86_64:
-	- Use vmlinux
 For ppc64:
 	- Use vmlinux
 For ia64:
_

Patches currently in -mm which might be from bwalle@suse.de are

add-vmcoreinfo.patch
express-relocatability-of-kernel-on-x86_64-in-documentation.patch
express-relocatability-of-kernel-on-x86_64-in.patch
express-new-elf32-mechanisms-in-documentation.patch
add-reset_devices-to-the-recommended-parameters.patch
