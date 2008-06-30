From: akpm@linux-foundation.org
Subject: + mn10300-export-certain-arch-symbols-required-to-build-allmodconfig.patch added to -mm tree
Date: Mon, 30 Jun 2008 16:21:59 -0700
Message-ID: <200806302322.m5UNLx7v030787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573AbYF3XWe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 19:22:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, bunk@stusta.de


The patch titled
     mn10300: export certain arch symbols required to build allmodconfig
has been added to the -mm tree.  Its filename is
     mn10300-export-certain-arch-symbols-required-to-build-allmodconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: export certain arch symbols required to build allmodconfig
From: David Howells <dhowells@redhat.com>

Export kernel_thread() and empty_zero_page so that allmodconfig can be
built for MN10300.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/mn10300_ksyms.c |    3 +++
 arch/mn10300/kernel/process.c       |    1 +
 2 files changed, 4 insertions(+)

diff -puN arch/mn10300/kernel/mn10300_ksyms.c~mn10300-export-certain-arch-symbols-required-to-build-allmodconfig arch/mn10300/kernel/mn10300_ksyms.c
--- a/arch/mn10300/kernel/mn10300_ksyms.c~mn10300-export-certain-arch-symbols-required-to-build-allmodconfig
+++ a/arch/mn10300/kernel/mn10300_ksyms.c
@@ -10,8 +10,11 @@
  */
 #include <linux/module.h>
 #include <asm/uaccess.h>
+#include <asm/pgtable.h>
 
 
+EXPORT_SYMBOL(empty_zero_page);
+
 EXPORT_SYMBOL(change_bit);
 EXPORT_SYMBOL(test_and_change_bit);
 
diff -puN arch/mn10300/kernel/process.c~mn10300-export-certain-arch-symbols-required-to-build-allmodconfig arch/mn10300/kernel/process.c
--- a/arch/mn10300/kernel/process.c~mn10300-export-certain-arch-symbols-required-to-build-allmodconfig
+++ a/arch/mn10300/kernel/process.c
@@ -153,6 +153,7 @@ int kernel_thread(int (*fn)(void *), voi
 	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0,
 		       NULL, NULL);
 }
+EXPORT_SYMBOL(kernel_thread);
 
 /*
  * free current thread data structures etc..
_

Patches currently in -mm which might be from dhowells@redhat.com are

mn10300-export-certain-arch-symbols-required-to-build-allmodconfig.patch
mn10300-provide-__ucmpdi2-for-mn10300.patch
git-unionfs.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

