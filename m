From: akpm@linux-foundation.org
Subject: + xtensa-fix-memscan.patch added to -mm tree
Date: Tue, 24 Jan 2012 14:36:56 -0800
Message-ID: <20120124223656.8A6F5A0291@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:36335 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab2AXWg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2012 17:36:57 -0500
Received: by qcsd17 with SMTP id d17so376551qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2012 14:36:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, chris@zankel.net


The patch titled
     Subject: xtensa: fix memscan()
has been added to the -mm tree.  Its filename is
     xtensa-fix-memscan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: xtensa: fix memscan()

Defining memscan() as memchr() is wrong, because the return values of
memscan() and memchr() are different when the character is not found.  So
use the generic memscan() implementation to fix this.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/string.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/xtensa/include/asm/string.h~xtensa-fix-memscan arch/xtensa/include/asm/string.h
--- a/arch/xtensa/include/asm/string.h~xtensa-fix-memscan
+++ a/arch/xtensa/include/asm/string.h
@@ -118,7 +118,4 @@ extern void *memmove(void *__dest, __con
 /* Don't build bcopy at all ...  */
 #define __HAVE_ARCH_BCOPY
 
-#define __HAVE_ARCH_MEMSCAN
-#define memscan memchr
