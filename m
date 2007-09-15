From: akpm@linux-foundation.org
Subject: + express-new-elf32-mechanisms-in-documentation.patch added to -mm tree
Date: Sat, 15 Sep 2007 01:18:42 -0700
Message-ID: <200709150818.l8F8Ig3P025008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50124 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbXIOIS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Sep 2007 04:18:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ebiederm@xmission.com, hbabu@us.ibm.com, rdunlap@xenotime.net, vgoyal@in.ibm.com


The patch titled
     Express new ELF32 mechanisms in documentation
has been added to the -mm tree.  Its filename is
     express-new-elf32-mechanisms-in-documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Express new ELF32 mechanisms in documentation
From: Bernhard Walle <bwalle@suse.de>

This patch reflects the
http://git.kernel.org/?p=linux/kernel/git/horms/kexec-tools-testing.git;a=commit;h=b9c3648e690ad0dad12389659673206213a09760
change in kexec-tools-testing also now in the kernel documentation.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN Documentation/kdump/kdump.txt~express-new-elf32-mechanisms-in-documentation Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~express-new-elf32-mechanisms-in-documentation
+++ a/Documentation/kdump/kdump.txt
@@ -301,11 +301,13 @@ For ppc64:
 Notes on loading the dump-capture kernel:
 
 * By default, the ELF headers are stored in ELF64 format to support
-  systems with more than 4GB memory. The --elf32-core-headers option can
-  be used to force the generation of ELF32 headers. This is necessary
-  because GDB currently cannot open vmcore files with ELF64 headers on
-  32-bit systems. ELF32 headers can be used on non-PAE systems (that is,
-  less than 4GB of memory).
+  systems with more than 4GB memory. On i386, kexec automatically checks if
+  the physical RAM size exceeds the 4 GB limit and if not, uses ELF32.
+  So, on non-PAE systems, ELF32 is always used.
+
+  The --elf32-core-headers option can be used to force the generation of ELF32
+  headers. This is necessary because GDB currently cannot open vmcore files
+  with ELF64 headers on 32-bit systems.
 
 * The "irqpoll" boot parameter reduces driver initialization failures
   due to shared interrupts in the dump-capture kernel.
_

Patches currently in -mm which might be from bwalle@suse.de are

add-vmcoreinfo.patch
express-relocatability-of-kernel-on-x86_64-in-documentation.patch
express-relocatability-of-kernel-on-x86_64-in.patch
express-new-elf32-mechanisms-in-documentation.patch
add-reset_devices-to-the-recommended-parameters.patch
