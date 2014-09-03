From: akpm@linux-foundation.org
Subject: [merged]
 add-arm-description-to-documentation-kdump-kdumptxt.patch removed from -mm
 tree
Date: Wed, 03 Sep 2014 10:57:57 -0700
Message-ID: <540756a5.1FKeMKAkPy4gtsYf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbaICR56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hukeping@huawei.com, hbabu@us.ibm.com, rob@landley.net, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/kdump/kdump.txt: add ARM description
has been removed from the -mm tree.  Its filename was
     add-arm-description-to-documentation-kdump-kdumptxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: HuKeping <hukeping@huawei.com>
Subject: Documentation/kdump/kdump.txt: add ARM description

Add arm specific parts to kdump kernel documentation.

Signed-off-by: Hu Keping <hukeping@huawei.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |   36 +++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff -puN Documentation/kdump/kdump.txt~add-arm-description-to-documentation-kdump-kdumptxt Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~add-arm-description-to-documentation-kdump-kdumptxt
+++ a/Documentation/kdump/kdump.txt
@@ -18,7 +18,7 @@ memory image to a dump file on the local
 a remote system.
 
 Kdump and kexec are currently supported on the x86, x86_64, ppc64, ia64,
-and s390x architectures.
+s390x and arm architectures.
 
 When the system kernel boots, it reserves a small section of memory for
 the dump-capture kernel. This ensures that ongoing Direct Memory Access
@@ -112,7 +112,7 @@ There are two possible methods of using
 2) Or use the system kernel binary itself as dump-capture kernel and there is
    no need to build a separate dump-capture kernel. This is possible
    only with the architectures which support a relocatable kernel. As
-   of today, i386, x86_64, ppc64 and ia64 architectures support relocatable
+   of today, i386, x86_64, ppc64, ia64 and arm architectures support relocatable
    kernel.
 
 Building a relocatable kernel is advantageous from the point of view that
@@ -241,6 +241,13 @@ Dump-capture kernel config options (Arch
   kernel will be aligned to 64Mb, so if the start address is not then
   any space below the alignment point will be wasted.
 
+Dump-capture kernel config options (Arch Dependent, arm)
+----------------------------------------------------------
+
+-   To use a relocatable kernel,
+    Enable "AUTO_ZRELADDR" support under "Boot" options:
+
+    AUTO_ZRELADDR=y
 
 Extended crashkernel syntax
 ===========================
@@ -256,6 +263,10 @@ The syntax is:
     crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
     range=start-[end]
 
+Please note, on arm, the offset is required.
+    crashkernel=<range1>:<size1>[,<range2>:<size2>,...]@offset
+    range=start-[end]
+
     'start' is inclusive and 'end' is exclusive.
 
 For example:
@@ -296,6 +307,12 @@ Boot into System Kernel
    on the memory consumption of the kdump system. In general this is not
    dependent on the memory size of the production system.
 
+   On arm, use "crashkernel=Y@X". Note that the start address of the kernel
+   will be aligned to 128MiB (0x08000000), so if the start address is not then
+   any space below the alignment point may be overwritten by the dump-capture kernel,
+   which means it is possible that the vmcore is not that precise as expected.
+
+
 Load the Dump-capture Kernel
 ============================
 
@@ -315,7 +332,8 @@ For ia64:
 	- Use vmlinux or vmlinuz.gz
 For s390x:
 	- Use image or bzImage
-
+For arm:
+	- Use zImage
 
 If you are using a uncompressed vmlinux image then use following command
 to load dump-capture kernel.
@@ -331,6 +349,15 @@ to load dump-capture kernel.
    --initrd=<initrd-for-dump-capture-kernel> \
    --append="root=<root-dev> <arch-specific-options>"
 
+If you are using a compressed zImage, then use following command
+to load dump-capture kernel.
+
+   kexec --type zImage -p <dump-capture-kernel-bzImage> \
+   --initrd=<initrd-for-dump-capture-kernel> \
+   --dtb=<dtb-for-dump-capture-kernel> \
+   --append="root=<root-dev> <arch-specific-options>"
+
+
 Please note, that --args-linux does not need to be specified for ia64.
 It is planned to make this a no-op on that architecture, but for now
 it should be omitted
@@ -347,6 +374,9 @@ For ppc64:
 For s390x:
 	"1 maxcpus=1 cgroup_disable=memory"
 
+For arm:
+	"1 maxcpus=1 reset_devices"
+
 Notes on loading the dump-capture kernel:
 
 * By default, the ELF headers are stored in ELF64 format to support
_

Patches currently in -mm which might be from hukeping@huawei.com are


