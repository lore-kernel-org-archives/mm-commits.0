From: akpm@linux-foundation.org
Subject: + remove-expensive-warn_on-in-pagefault_disabled_dec.patch added
 to -mm tree
Date: Wed, 15 Mar 2017 14:49:25 -0700
Message-ID: <58c9b6e5.9JUToZhdgyxDexlL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753777AbdCOVt1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2017 17:49:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/uaccess.h: remove expensive WARN_ON in pagefault_disabled_dec
has been added to the -mm tree.  Its filename is
     remove-expensive-warn_on-in-pagefault_disabled_dec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/remove-expensive-warn_on-in-pagefault_disabled_dec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/remove-expensive-warn_on-in-pagefault_disabled_dec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -12,7 +12,6 @@ static __always_inline void pagefault_di
 static __always_inline void pagefault_disabled_dec(void)
 {
 	current->pagefault_disabled--;
-	WARN_ON(current->pagefault_disabled < 0);
 }
 
 /*
_

Patches currently in -mm which might be from ak@linux.intel.com are

trace-move-trace_seq_overflowed-out-of-line.patch
sched-out-of-line-__update_load_avg.patch
kref-remove-warn_on-for-null-release-functions.patch
out-of-line-dma_alloc-free_attrs.patch
megasas-remove-expensive-inline-from-megasas_return_cmd.patch
remove-expensive-warn_on-in-pagefault_disabled_dec.patch

