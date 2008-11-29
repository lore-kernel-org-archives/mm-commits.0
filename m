From: akpm@linux-foundation.org
Subject: + uml-fix-the-highmem-build-error.patch added to -mm tree
Date: Fri, 28 Nov 2008 22:45:12 -0800
Message-ID: <200811290645.mAT6jCl4030368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbYK2Gpb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 01:45:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wangcong@zeuux.org, jdike@addtoit.com, viro@zeniv.linux.org.uk


The patch titled
     uml: fix the highmem build error
has been added to the -mm tree.  Its filename is
     uml-fix-the-highmem-build-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix the highmem build error
From: WANG Cong <wangcong@zeuux.org>

Fix this error:

arch/um/kernel/mem.c: In function 'init_highmem':
arch/um/kernel/mem.c:177: error: 'pkmap_page_table' undeclared (first
use in this function)
arch/um/kernel/mem.c:177: error: (Each undeclared identifier is
reported only once
arch/um/kernel/mem.c:177: error: for each function it appears in.)

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/fixmap.h |    6 ++++++
 arch/x86/mm/highmem_32.c     |    1 +
 2 files changed, 7 insertions(+)

diff -puN arch/um/include/asm/fixmap.h~uml-fix-the-highmem-build-error arch/um/include/asm/fixmap.h
--- a/arch/um/include/asm/fixmap.h~uml-fix-the-highmem-build-error
+++ a/arch/um/include/asm/fixmap.h
@@ -41,6 +41,12 @@ enum fixed_addresses {
 	__end_of_fixed_addresses
 };
 
+#ifdef CONFIG_HIGHMEM
+extern pte_t *pkmap_page_table;
+extern pte_t *kmap_pte;
+extern pgprot_t kmap_prot;
+#endif
+
 extern void __set_fixmap (enum fixed_addresses idx,
 			  unsigned long phys, pgprot_t flags);
 
diff -puN arch/x86/mm/highmem_32.c~uml-fix-the-highmem-build-error arch/x86/mm/highmem_32.c
--- a/arch/x86/mm/highmem_32.c~uml-fix-the-highmem-build-error
+++ a/arch/x86/mm/highmem_32.c
@@ -1,3 +1,4 @@
+#include <asm/fixmap.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
 
_

Patches currently in -mm which might be from wangcong@zeuux.org are

linux-next.patch
scripts-improve-the-decodecode-script.patch
uml-fix-the-highmem-build-error.patch
ipc-clean-up-ipc-shmc.patch
ipc-do-not-goto-to-the-next-line.patch
ipc-ipc_sysctlc-move-the-definition-of-ipc_auto_callback.patch

