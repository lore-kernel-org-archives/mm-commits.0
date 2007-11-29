From: akpm@linux-foundation.org
Subject: + uml-keep-uml-kconfig-in-sync-with-x86.patch added to -mm tree
Date: Thu, 29 Nov 2007 14:51:12 -0800
Message-ID: <200711292251.lATMpC0A011317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49572 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762311AbXK2WvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 17:51:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: keep UML Kconfig in sync with x86
has been added to the -mm tree.  Its filename is
     uml-keep-uml-kconfig-in-sync-with-x86.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: keep UML Kconfig in sync with x86
From: Jeff Dike <jdike@addtoit.com>

Fix a UML build breakage introduced by commit
1032c0ba9da5c5b53173ad2dcf8b2a2da78f8b17 - it introduces X86_32, with many
things which UML needs depending on it.

This patch adds definitions of X86_32 and RWSEM_XCHGADD_ALGORITHM to
the UML/i386 Kconfig.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.i386 |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/um/Kconfig.i386~uml-keep-uml-kconfig-in-sync-with-x86 arch/um/Kconfig.i386
--- a/arch/um/Kconfig.i386~uml-keep-uml-kconfig-in-sync-with-x86
+++ a/arch/um/Kconfig.i386
@@ -8,6 +8,13 @@ config UML_X86
 	bool
 	default y
 
+config X86_32
+       bool
+       default y
+
+config RWSEM_XCHGADD_ALGORITHM
+	def_bool y
+
 config 64BIT
 	bool
 	default n
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-fix-no_hz-busy-loop.patch
leak-in-do_ubd_request.patch
uml-keep-uml-kconfig-in-sync-with-x86.patch
uml-after_sleep_interval-should-return-something.patch
uml-work-around-host-tcsetattr-bug.patch
git-kvm.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
