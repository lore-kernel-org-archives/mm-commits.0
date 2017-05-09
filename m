From: akpm@linux-foundation.org
Subject: [merged]
 remove-expensive-warn_on-in-pagefault_disabled_dec.patch removed from -mm
 tree
Date: Tue, 09 May 2017 11:03:42 -0700
Message-ID: <20170509180342.NUZ0OhCdY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34914 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753074AbdEISDn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:03:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/uaccess.h: remove expensive WARN_ON in pagefault_disabled_dec
has been removed from the -mm tree.  Its filename was
     remove-expensive-warn_on-in-pagefault_disabled_dec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from ak@linux.intel.com are


