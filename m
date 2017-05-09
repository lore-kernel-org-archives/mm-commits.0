From: akpm@linux-foundation.org
Subject: [merged]
 powerpc-fadump-update-documentation-about-crashkernel-parameter-reuse.patch
 removed from -mm tree
Date: Tue, 09 May 2017 11:01:53 -0700
Message-ID: <20170509180153.fXJfmmg4i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34484 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754377AbdEISBy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:01:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dyoung@redhat.com, ebiederm@xmission.com, fenghua.yu@intel.com, hbathini@linux.vnet.ibm.com, mahesh@linux.vnet.ibm.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, tony.luck@intel.com, vgoyal@redhat.com


The patch titled
     Subject: powerpc/fadump: update documentation about crashkernel parameter reuse
has been removed from the -mm tree.  Its filename was
     powerpc-fadump-update-documentation-about-crashkernel-parameter-reuse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hari Bathini <hbathini@linux.vnet.ibm.com>
Subject: powerpc/fadump: update documentation about crashkernel parameter reuse

As we are reusing crashkernel parameter instead of fadump_reserve_mem
parameter to specify the memory to reserve for fadump's crash kernel,
update the documentation accordingly.

Link: http://lkml.kernel.org/r/149035347559.6881.14224829694291758581.stgit@hbathini.in.ibm.com
Signed-off-by: Hari Bathini <hbathini@linux.vnet.ibm.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/powerpc/firmware-assisted-dump.txt |   23 ++++++++-----
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN Documentation/powerpc/firmware-assisted-dump.txt~powerpc-fadump-update-documentation-about-crashkernel-parameter-reuse Documentation/powerpc/firmware-assisted-dump.txt
--- a/Documentation/powerpc/firmware-assisted-dump.txt~powerpc-fadump-update-documentation-about-crashkernel-parameter-reuse
+++ a/Documentation/powerpc/firmware-assisted-dump.txt
@@ -55,10 +55,14 @@ as follows:
          booted with restricted memory. By default, the boot memory
          size will be the larger of 5% of system RAM or 256MB.
          Alternatively, user can also specify boot memory size
-         through boot parameter 'fadump_reserve_mem=' which will
-         override the default calculated size. Use this option
-         if default boot memory size is not sufficient for second
-         kernel to boot successfully.
+         through boot parameter 'crashkernel=' which will override
+         the default calculated size. Use this option if default
+         boot memory size is not sufficient for second kernel to
+         boot successfully. For syntax of crashkernel= parameter,
+         refer to Documentation/kdump/kdump.txt. If any offset is
+         provided in crashkernel= parameter, it will be ignored
+         as fadump reserves memory at end of RAM for boot memory
+         dump preservation in case of a crash.
 
 -- After the low memory (boot memory) area has been saved, the
    firmware will reset PCI and other hardware state.  It will
@@ -158,13 +162,16 @@ How to enable firmware-assisted dump (fa
 
 1. Set config option CONFIG_FA_DUMP=y and build kernel.
 2. Boot into linux kernel with 'fadump=on' kernel cmdline option.
-3. Optionally, user can also set 'fadump_reserve_mem=' kernel cmdline
+3. Optionally, user can also set 'crashkernel=' kernel cmdline
    to specify size of the memory to reserve for boot memory dump
    preservation.
 
-NOTE: If firmware-assisted dump fails to reserve memory then it will
-   fallback to existing kdump mechanism if 'crashkernel=' option
-   is set at kernel cmdline.
+NOTE: 1. 'fadump_reserve_mem=' parameter has been deprecated. Instead
+         use 'crashkernel=' to specify size of the memory to reserve
+         for boot memory dump preservation.
+      2. If firmware-assisted dump fails to reserve memory then it
+         will fallback to existing kdump mechanism if 'crashkernel='
+         option is set at kernel cmdline.
 
 Sysfs/debugfs files:
 ------------
_

Patches currently in -mm which might be from hbathini@linux.vnet.ibm.com are


