From: akpm@linux-foundation.org
Subject: + uml-arch-um-include-inith-needs-a-definition-of-__used.patch added to -mm tree
Date: Thu, 15 Nov 2007 16:12:19 -0800
Message-ID: <200711160012.lAG0CJJI023142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55572 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762859AbXKPAMW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 19:12:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: arch/um/include/init.h needs a definition of __used
has been added to the -mm tree.  Its filename is
     uml-arch-um-include-inith-needs-a-definition-of-__used.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: arch/um/include/init.h needs a definition of __used
From: Jeff Dike <jdike@addtoit.com>

init.h started breaking now for some reason.  It turns out that there wasn't a
definition of __used.  Fixed this by copying the relevant stuff from
compiler.h in the userspace case, and including compiler.h in the kernel case.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/init.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN arch/um/include/init.h~uml-arch-um-include-inith-needs-a-definition-of-__used arch/um/include/init.h
--- a/arch/um/include/init.h~uml-arch-um-include-inith-needs-a-definition-of-__used
+++ a/arch/um/include/init.h
@@ -40,6 +40,15 @@
 typedef int (*initcall_t)(void);
 typedef void (*exitcall_t)(void);
 
+#ifndef __KERNEL__
+#if __GNUC_MINOR__ >= 3
+# define __used			__attribute__((__used__))
+#else
+# define __used			__attribute__((__unused__))
+#endif
+#else
+#include <linux/compiler.h>
+#endif
 /* These are for everybody (although not all archs will actually
    discard it in modules) */
 #define __init		__attribute__ ((__section__ (".init.text")))
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
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
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
