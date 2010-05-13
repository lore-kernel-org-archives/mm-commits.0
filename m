From: akpm@linux-foundation.org
Subject: + lib-atomic64_test-fix-missing-include-of-linux-kernelh.patch added to -mm tree
Date: Thu, 13 May 2010 12:19:12 -0700
Message-ID: <201005131919.o4DJJCKa015077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932473Ab0EMTUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 15:20:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterhuewe@gmx.de, hpa@zytor.com, luca@luca-barbieri.com


The patch titled
     lib/atomic64_test: fix missing include of linux/kernel.h
has been added to the -mm tree.  Its filename is
     lib-atomic64_test-fix-missing-include-of-linux-kernelh.patch

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
Subject: lib/atomic64_test: fix missing include of linux/kernel.h
From: Peter Huewe <peterhuewe@gmx.de>

Fix a build-failure
(http://kisskb.ellerman.id.au/kisskb/buildresult/2601239/) by adding the
missing include file (linux/kernel.h) for printk and KERN_INFO.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Cc: Luca Barbieri <luca@luca-barbieri.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/atomic64_test.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/atomic64_test.c~lib-atomic64_test-fix-missing-include-of-linux-kernelh lib/atomic64_test.c
--- a/lib/atomic64_test.c~lib-atomic64_test-fix-missing-include-of-linux-kernelh
+++ a/lib/atomic64_test.c
@@ -9,6 +9,7 @@
  * (at your option) any later version.
  */
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <asm/atomic.h>
 
 #define INIT(c) do { atomic64_set(&v, c); r = c; } while (0)
_

Patches currently in -mm which might be from peterhuewe@gmx.de are

lib-atomic64_test-fix-missing-include-of-linux-kernelh.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch

