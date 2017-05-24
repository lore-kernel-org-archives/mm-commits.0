From: akpm@linux-foundation.org
Subject: + mn10300-use-generic-fbh.patch added to -mm tree
Date: Wed, 24 May 2017 14:40:37 -0700
Message-ID: <5925fdd5.DJsYoSDvHFrEsQh3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45422 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035933AbdEXVkn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 17:40:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: use generic fb.h
has been added to the -mm tree.  Its filename is
     mn10300-use-generic-fbh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mn10300-use-generic-fbh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mn10300-use-generic-fbh.patch

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
Subject: mn10300: use generic fb.h

The arch uses a verbatim copy of the asm-generic version and does not add
any own implementations to the header, so use asm-generic/fb.h instead of
duplicating code.

Link: http://lkml.kernel.org/r/20170517083348.1815-1-tklauser@distanz.ch
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/Kbuild |    1 +
 arch/mn10300/include/asm/fb.h   |   23 -----------------------
 2 files changed, 1 insertion(+), 23 deletions(-)

diff -puN arch/mn10300/include/asm/Kbuild~mn10300-use-generic-fbh arch/mn10300/include/asm/Kbuild
--- a/arch/mn10300/include/asm/Kbuild~mn10300-use-generic-fbh
+++ a/arch/mn10300/include/asm/Kbuild
@@ -4,6 +4,7 @@ generic-y += clkdev.h
 generic-y += device.h
 generic-y += exec.h
 generic-y += extable.h
+generic-y += fb.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += mm-arch-hooks.h
diff -puN arch/mn10300/include/asm/fb.h~mn10300-use-generic-fbh /dev/null
--- a/arch/mn10300/include/asm/fb.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/* MN10300 Frame buffer stuff
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_FB_H
-#define _ASM_FB_H
-
-#include <linux/fb.h>
-
-#define fb_pgprotect(...) do {} while (0)
-
-static inline int fb_is_primary_device(struct fb_info *info)
-{
-	return 0;
-}
