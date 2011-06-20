From: akpm@linux-foundation.org
Subject: + lib-lcmc-quiet-sparse-noise.patch added to -mm tree
Date: Mon, 20 Jun 2011 15:15:20 -0700
Message-ID: <201106202215.p5KMFK57025570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755806Ab1FTWPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 18:15:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com


The patch titled
     lib/lcm.c: quiet sparse noise
has been added to the -mm tree.  Its filename is
     lib-lcmc-quiet-sparse-noise.patch

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
Subject: lib/lcm.c: quiet sparse noise
From: H Hartley Sweeten <hartleys@visionengravers.com>

The symbol 'lcm' is exported to the kernel (EXPORT_SYMBOL_GPL).
Pick up it's definition in <linux/lcm.h> to quiet the sparse noise:

  warning: symbol 'lcm' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lcm.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/lcm.c~lib-lcmc-quiet-sparse-noise lib/lcm.c
--- a/lib/lcm.c~lib-lcmc-quiet-sparse-noise
+++ a/lib/lcm.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/gcd.h>
 #include <linux/module.h>
+#include <linux/lcm.h>
 
 /* Lowest common multiple */
 unsigned long lcm(unsigned long a, unsigned long b)
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
lib-lcmc-quiet-sparse-noise.patch

