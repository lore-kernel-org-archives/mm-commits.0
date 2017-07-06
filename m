From: akpm@linux-foundation.org
Subject: [patch 005/108] mn10300: use generic fb.h
Date: Thu, 06 Jul 2017 15:35:37 -0700
Message-ID: <20170706223537.5rWmtbcGB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34352 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752683AbdGFWfi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:35:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, mm-commits@vger.kernel.org, tklauser@distanz.ch, torvalds@linux-foundation.org

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
