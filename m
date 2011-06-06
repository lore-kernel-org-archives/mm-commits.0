From: akpm@linux-foundation.org
Subject: + asm-generic-systemh-drop-useless-__kernel__.patch added to -mm tree
Date: Mon, 06 Jun 2011 13:52:30 -0700
Message-ID: <201106062052.p56KqUHP021650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757297Ab1FFUwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2011 16:52:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, arnd@arndb.de


The patch titled
     asm-generic/system.h: drop useless __KERNEL__
has been added to the -mm tree.  Its filename is
     asm-generic-systemh-drop-useless-__kernel__.patch

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
Subject: asm-generic/system.h: drop useless __KERNEL__
From: Mike Frysinger <vapier@gentoo.org>

This header isn't exported to user-space, and even if it was, the
__KERNEL__ check covers the entire file, so we'd get a useless stub in the
first place.  So punt it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/system.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/asm-generic/system.h~asm-generic-systemh-drop-useless-__kernel__ include/asm-generic/system.h
--- a/include/asm-generic/system.h~asm-generic-systemh-drop-useless-__kernel__
+++ a/include/asm-generic/system.h
@@ -14,7 +14,6 @@
 #ifndef __ASM_GENERIC_SYSTEM_H
 #define __ASM_GENERIC_SYSTEM_H
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
@@ -139,5 +138,4 @@ unsigned long __xchg(unsigned long x, vo
 
 #endif /* !__ASSEMBLY__ */
 
-#endif /* __KERNEL__ */
 #endif /* __ASM_GENERIC_SYSTEM_H */
_

Patches currently in -mm which might be from vapier@gentoo.org are

backlight-new-driver-for-the-adp8870-backlight-devices.patch
backlight-new-driver-for-the-adp8870-backlight-devices-v2.patch
backlight-add-backlight-type-fix.patch
mm-nommuc-fix-remap_pfn_range.patch
linux-next.patch
asm-generic-systemh-drop-useless-__kernel__.patch

