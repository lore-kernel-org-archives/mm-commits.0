From: akpm@linux-foundation.org
Subject: + uml-fix-warning-vmlinux-memcpy-exported-twice.patch added to -mm tree
Date: Tue, 10 Mar 2009 15:14:35 -0700
Message-ID: <200903102214.n2AMEZCx011305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754189AbZCJWQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 18:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharrosh@panasas.com, jdike@addtoit.com, xiyou.wangcong@gmail.com


The patch titled
     uml: fix WARNING: vmlinux: 'memcpy' exported twice
has been added to the -mm tree.  Its filename is
     uml-fix-warning-vmlinux-memcpy-exported-twice.patch

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
Subject: uml: fix WARNING: vmlinux: 'memcpy' exported twice


Fix the following warning on x86_64:

LD vmlinux.o
MODPOST vmlinux.o
WARNING: vmlinux: 'memcpy' exported twice. Previous export was in vmlinux

For x86_64, this symbol is already exported from arch/um/sys-x86_64/ksyms.c.

Reported-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Tested-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/user_syms.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/um/os-Linux/user_syms.c~uml-fix-warning-vmlinux-memcpy-exported-twice arch/um/os-Linux/user_syms.c
--- a/arch/um/os-Linux/user_syms.c~uml-fix-warning-vmlinux-memcpy-exported-twice
+++ a/arch/um/os-Linux/user_syms.c
@@ -14,7 +14,6 @@
 #undef memset
 
 extern size_t strlen(const char *);
-extern void *memcpy(void *, const void *, size_t);
 extern void *memmove(void *, const void *, size_t);
 extern void *memset(void *, int, size_t);
 extern int printf(const char *, ...);
@@ -24,7 +23,11 @@ extern int printf(const char *, ...);
 EXPORT_SYMBOL(strstr);
 #endif
 
+#ifndef __x86_64__
+extern void *memcpy(void *, const void *, size_t);
 EXPORT_SYMBOL(memcpy);
+#endif
+
 EXPORT_SYMBOL(memmove);
 EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(printf);
_

Patches currently in -mm which might be from bharrosh@panasas.com are

linux-next.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
uml-fix-warning-vmlinux-memcpy-exported-twice.patch

