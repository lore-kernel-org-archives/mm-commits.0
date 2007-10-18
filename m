From: akpm@linux-foundation.org
Subject: - express-new-elf32-mechanisms-in-documentation.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:34 -0700
Message-ID: <200710180704.l9I74Ydl031562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36535 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932425AbXJRHlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:41:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, ebiederm@xmission.com, hbabu@us.ibm.com, rdunlap@xenotime.net, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Express new ELF32 mechanisms in documentation
has been removed from the -mm tree.  Its filename was
     express-new-elf32-mechanisms-in-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
extended-crashkernel-command-line.patch
extended-crashkernel-command-line-update.patch
extended-crashkernel-command-line-comment-fix.patch
extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-i386-update.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-x86_64-update.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
use-extended-crashkernel-command-line-on-ia64-update.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-ppc64-update.patch
use-extended-crashkernel-command-line-on-sh.patch
use-extended-crashkernel-command-line-on-sh-update.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
