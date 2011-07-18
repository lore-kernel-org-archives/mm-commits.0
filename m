From: akpm@linux-foundation.org
Subject: + xtensa-fix-a-build-error-in-arch-xtensa-include-asm-uaccessh.patch added to -mm tree
Date: Mon, 18 Jul 2011 13:36:47 -0700
Message-ID: <201107182036.p6IKalj9026406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752Ab1GRUgt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Jul 2011 16:36:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, chris@zankel.net


The patch titled
     xtensa: fix a build error in arch/xtensa/include/asm/uaccess.h
has been added to the -mm tree.  Its filename is
     xtensa-fix-a-build-error-in-arch-xtensa-include-asm-uaccessh.patch

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
Subject: xtensa: fix a build error in arch/xtensa/include/asm/uaccess.h
From: WANG Cong <xiyou.wangcong@gmail.com>

Fix the following build error:

src/arch/xtensa/include/asm/uaccess.h:403: error: implicit declaration
of function 'prefetch': 1 errors in 1 logs
        v3.0-rc6/xtensa/xtensa-defconfig
src/arch/xtensa/include/asm/uaccess.h:412: error: implicit declaration
of function 'prefetchw': 1 errors in 1 logs
        v3.0-rc6/xtensa/xtensa-defconfig

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/uaccess.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/xtensa/include/asm/uaccess.h~xtensa-fix-a-build-error-in-arch-xtensa-include-asm-uaccessh arch/xtensa/include/asm/uaccess.h
--- a/arch/xtensa/include/asm/uaccess.h~xtensa-fix-a-build-error-in-arch-xtensa-include-asm-uaccessh
+++ a/arch/xtensa/include/asm/uaccess.h
@@ -17,6 +17,7 @@
 #define _XTENSA_UACCESS_H
 
 #include <linux/errno.h>
+#include <linux/prefetch.h>
 
 #define VERIFY_READ    0
 #define VERIFY_WRITE   1
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

xtensa-fix-a-build-error-in-arch-xtensa-include-asm-uaccessh.patch
linux-next.patch
cris-fix-a-build-error-in-kernel-forkc.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
cris-fix-a-build-error-in-sync_serial_open.patch
cris-fix-the-prototype-of-sync_serial_ioctl.patch
cris-add-missing-declaration-of-kgdb_init-and-breakpoint.patch
mm-remove-the-leftovers-of-noswapaccount.patch
cris-fix-some-build-warnings-in-pinmuxc.patch
kernel-configsc-include-module_-when-config_ikconfig_proc=n.patch
gcov-disable-constructors-for-uml.patch
include-linux-dma-mappingh-remove-dma_xxbit_mask-macros.patch
kexec-remove-kmsg_dump_kexec.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

