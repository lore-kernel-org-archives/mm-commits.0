From: akpm@linux-foundation.org
Subject: + add-arm-description-to-documentation-kdump-kdumptxt.patch added to -mm tree
Date: Fri, 22 Aug 2014 15:27:03 -0700
Message-ID: <53f7c3b7.vMuA6I4iJ8uLeHoV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:58782 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaHVW1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Aug 2014 18:27:05 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2997760pab.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2014 15:27:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hukeping@huawei.com, hbabu@us.ibm.com, rob@landley.net, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/kdump/kdump.txt: add ARM description
has been added to the -mm tree.  Its filename is
     add-arm-description-to-documentation-kdump-kdumptxt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/add-arm-description-to-documentation-kdump-kdumptxt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/add-arm-description-to-documentation-kdump-kdumptxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

add-arm-description-to-documentation-kdump-kdumptxt.patch

