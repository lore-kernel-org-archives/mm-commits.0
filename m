From: akpm@linux-foundation.org
Subject: [patch 087/114] include/linux/uaccess.h: remove expensive
 WARN_ON in pagefault_disabled_dec
Date: Mon, 08 May 2017 15:58:56 -0700
Message-ID: <20170508225856.YAIdAox5W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47340 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751205AbdEHW65 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:58:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Andi Kleen <ak@linux.intel.com>
Subject: include/linux/uaccess.h: remove expensive WARN_ON in pagefault_disabled_dec

pagefault_disabled_dec is frequently used inline, and it has a WARN_ON for
underflow that expands to about 6.5k of extra code.  The warning doesn't
seem to be that useful and worth so much code so remove it.

If it was needed could make it depending on some debug kernel option.

Saves ~6.5k in my kernel

   text    data     bss     dec     hex filename
9039417 5367568 11116544        25523529        1857549 vmlinux-before-pf
9032805 5367568 11116544        25516917        1855b75 vmlinux-pf

Link: http://lkml.kernel.org/r/20170315021431.13107-8-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uaccess.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/uaccess.h~remove-expensive-warn_on-in-pagefault_disabled_dec include/linux/uaccess.h
--- a/include/linux/uaccess.h~remove-expensive-warn_on-in-pagefault_disabled_dec
+++ a/include/linux/uaccess.h
@@ -203,7 +203,6 @@ static __always_inline void pagefault_di
 static __always_inline void pagefault_disabled_dec(void)
 {
 	current->pagefault_disabled--;
-	WARN_ON(current->pagefault_disabled < 0);
 }
 
 /*
_
