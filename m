From: akpm@linux-foundation.org
Subject: + uml-reconst-a-parameter.patch added to -mm tree
Date: Wed, 07 Nov 2007 11:10:23 -0800
Message-ID: <200711071910.lA7JAP6T023538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38388 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753427AbXKGTK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2007 14:10:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: reconst a parameter
has been added to the -mm tree.  Its filename is
     uml-reconst-a-parameter.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: reconst a parameter
From: Jeff Dike <jdike@addtoit.com>

The previous const-ing patch consted a string which shouldn't have
been, and I didn't notice the gcc warning.

ubd_setup can't take a const char * because its address is assigned to
something which expects a char *arg.  Many setups modify the string
they are given, they can't be const.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-reconst-a-parameter arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-reconst-a-parameter
+++ a/arch/um/drivers/ubd_kern.c
@@ -444,7 +444,7 @@ __uml_help(ubd_setup,
 "    cluster filesystem and inappropriate at almost all other times.\n\n"
 );
 
-static int udb_setup(const char *str)
+static int udb_setup(char *str)
 {
 	printk("udb%s specified on command line is almost certainly a ubd -> "
 	       "udb TYPO\n", str);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
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
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
