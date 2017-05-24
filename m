From: akpm@linux-foundation.org
Subject: + frv-use-generic-fbh.patch added to -mm tree
Date: Wed, 24 May 2017 14:41:18 -0700
Message-ID: <5925fdfe.yG+mlJ1Zn+lkQCYV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45544 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161066AbdEXVlT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 17:41:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: use generic fb.h
has been added to the -mm tree.  Its filename is
     frv-use-generic-fbh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frv-use-generic-fbh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/frv-use-generic-fbh.patch

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
Subject: frv: use generic fb.h

The arch uses a verbatim copy of the asm-generic version and does not add
any own implementations to the header, so use asm-generic/fb.h instead of
duplicating code.

Link: http://lkml.kernel.org/r/20170517083307.1697-1-tklauser@distanz.ch
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/Kbuild |    1 +
 arch/frv/include/asm/fb.h   |   12 ------------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff -puN arch/frv/include/asm/Kbuild~frv-use-generic-fbh arch/frv/include/asm/Kbuild
--- a/arch/frv/include/asm/Kbuild~frv-use-generic-fbh
+++ a/arch/frv/include/asm/Kbuild
@@ -3,6 +3,7 @@ generic-y += clkdev.h
 generic-y += device.h
 generic-y += exec.h
 generic-y += extable.h
+generic-y += fb.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += mm-arch-hooks.h
diff -puN arch/frv/include/asm/fb.h~frv-use-generic-fbh /dev/null
--- a/arch/frv/include/asm/fb.h
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
