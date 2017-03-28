From: akpm@linux-foundation.org
Subject: +
 powerpc-fadump-update-documentation-about-crashkernel-parameter-reuse.patch added to -mm tree
Date: Tue, 28 Mar 2017 16:21:39 -0700
Message-ID: <58daf003.XOD3u5+ZEiV9J8bb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51700 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932088AbdC1XVl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 19:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hbathini@linux.vnet.ibm.com, dyoung@redhat.com, ebiederm@xmission.com, fenghua.yu@intel.com, mahesh@linux.vnet.ibm.com, mpe@ellerman.id.au, tony.luck@intel.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/fadump: update documentation about crashkernel parameter reuse
has been added to the -mm tree.  Its filename is
     powerpc-fadump-update-documentation-about-crashkernel-parameter-reuse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-fadump-update-documentation-about-crashkernel-parameter-reuse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-fadump-update-documentation-about-crashkernel-parameter-reuse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

crash-move-crashkernel-parsing-and-vmcore-related-code-under-config_crash_core.patch
ia64-reuse-append_elf_note-and-final_note-functions.patch
powerpc-fadump-remove-dependency-with-config_kexec.patch
powerpc-fadump-reuse-crashkernel-parameter-for-fadump-memory-reservation.patch
powerpc-fadump-update-documentation-about-crashkernel-parameter-reuse.patch

