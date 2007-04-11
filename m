From: akpm@linux-foundation.org
Subject: + alpha-fix-bootp-image-creation.patch added to -mm tree
Date: Wed, 11 Apr 2007 12:57:57 -0700
Message-ID: <200704111957.l3BJvwvf012980@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58427 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030314AbXDKT6I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 15:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, jay.estabrook@hp.com, rth@twiddle.net


The patch titled
     ALPHA: fix BOOTP image creation
has been added to the -mm tree.  Its filename is
     alpha-fix-bootp-image-creation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ALPHA: fix BOOTP image creation
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Files:

arch/alpha/boot/bootpz.c

	Create a dummy "__kmalloc()" to satisfy the loader; never called.

arch/alpha/boot/tools/objstrip.c

	Remove an include that is now (2.6.x) unnecessary.

Signed-off-by: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/boot/bootpz.c         |    6 ++++++
 arch/alpha/boot/tools/objstrip.c |    1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/alpha/boot/bootpz.c~alpha-fix-bootp-image-creation arch/alpha/boot/bootpz.c
--- a/arch/alpha/boot/bootpz.c~alpha-fix-bootp-image-creation
+++ a/arch/alpha/boot/bootpz.c
@@ -467,3 +467,9 @@ start_kernel(void)
 #endif
 	runkernel();
 }
+
+ /* dummy function, should never be called. */
+void *__kmalloc(size_t size, gfp_t flags)
+{
+	return (void *)NULL;
+}
diff -puN arch/alpha/boot/tools/objstrip.c~alpha-fix-bootp-image-creation arch/alpha/boot/tools/objstrip.c
--- a/arch/alpha/boot/tools/objstrip.c~alpha-fix-bootp-image-creation
+++ a/arch/alpha/boot/tools/objstrip.c
@@ -25,7 +25,6 @@
 #include <linux/a.out.h>
 #include <linux/coff.h>
 #include <linux/param.h>
-#include <linux/string.h>
 #ifdef __ELF__
 # include <linux/elf.h>
 #endif
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

account-for-module-percpu-space-separately-from-kernel.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
alpha-fix-bootp-image-creation.patch
alpha-prctl-macros.patch
alpha-fixes-for-specific-machine-types.patch
alpha-more-fixes-for-specific-machine-types.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
lutimesat-extend-do_utimes-with-flags.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
local_t-alpha-extension.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
make-sure-nobodys-leaking-resources.patch
