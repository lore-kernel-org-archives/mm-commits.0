From: akpm@linux-foundation.org
Subject: + toshibah-hide-a-function-prototypes-behind-__kernel__-macro.patch added to -mm tree
Date: Wed, 01 Dec 2010 14:55:02 -0800
Message-ID: <201012012255.oB1Mt269016573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052Ab0LAWzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2010 17:55:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: virtuoso@slind.org, jonathan@buzzard.org.uk


The patch titled
     toshiba.h: hide a function prototypes behind __KERNEL__ macro
has been added to the -mm tree.  Its filename is
     toshibah-hide-a-function-prototypes-behind-__kernel__-macro.patch

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
Subject: toshiba.h: hide a function prototypes behind __KERNEL__ macro
From: Alexander Shishkin <virtuoso@slind.org>

Currently, tosh_smm() prototype is present in a header file exported to
userland.  This patch fixes it.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Cc: Jonathan Buzzard <jonathan@buzzard.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/toshiba.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/toshiba.h~toshibah-hide-a-function-prototypes-behind-__kernel__-macro include/linux/toshiba.h
--- a/include/linux/toshiba.h~toshibah-hide-a-function-prototypes-behind-__kernel__-macro
+++ a/include/linux/toshiba.h
@@ -33,6 +33,8 @@ typedef struct {
 	unsigned int edi __attribute__ ((packed));
 } SMMRegisters;
 
+#ifdef __KERNEL__
 int tosh_smm(SMMRegisters *regs);
+#endif /* __KERNEL__ */
 
 #endif
_

Patches currently in -mm which might be from virtuoso@slind.org are

headers_check-better-search-for-functions-in-headers.patch
headers_check-better-search-for-functions-in-headers-fix.patch
headers_check-better-search-for-functions-in-headers-fix-checkpatch-fixes.patch
scsi-fix-a-header-to-include-linux-typesh.patch
toshibah-hide-a-function-prototypes-behind-__kernel__-macro.patch

