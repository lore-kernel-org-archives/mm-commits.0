From: akpm@linux-foundation.org
Subject: + xtensa-use-generic-fbh.patch added to -mm tree
Date: Wed, 24 May 2017 14:42:11 -0700
Message-ID: <5925fe33.kNpe4ZlxYjL0nQAc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45550 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033069AbdEXVmM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 17:42:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, jcmvbkbc@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: use generic fb.h
has been added to the -mm tree.  Its filename is
     xtensa-use-generic-fbh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xtensa-use-generic-fbh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xtensa-use-generic-fbh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: xtensa: use generic fb.h

The arch uses a verbatim copy of the asm-generic version and does not add
any own implementations to the header, so use asm-generic/fb.h instead of
duplicating code.

Link: http://lkml.kernel.org/r/20170517083545.2115-1-tklauser@distanz.ch
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/Kbuild |    1 +
 arch/xtensa/include/asm/fb.h   |   12 ------------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff -puN arch/xtensa/include/asm/Kbuild~xtensa-use-generic-fbh arch/xtensa/include/asm/Kbuild
--- a/arch/xtensa/include/asm/Kbuild~xtensa-use-generic-fbh
+++ a/arch/xtensa/include/asm/Kbuild
@@ -7,6 +7,7 @@ generic-y += emergency-restart.h
 generic-y += errno.h
 generic-y += exec.h
 generic-y += extable.h
+generic-y += fb.h
 generic-y += fcntl.h
 generic-y += hardirq.h
 generic-y += ioctl.h
diff -puN arch/xtensa/include/asm/fb.h~xtensa-use-generic-fbh /dev/null
--- a/arch/xtensa/include/asm/fb.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASM_FB_H_
-#define _ASM_FB_H_
-#include <linux/fb.h>
-
-#define fb_pgprotect(...) do {} while (0)
-
-static inline int fb_is_primary_device(struct fb_info *info)
-{
-	return 0;
-}
