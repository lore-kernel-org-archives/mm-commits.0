From: akpm@linux-foundation.org
Subject: + alpha-remove-mysterious-if-zero-ed-out-includes.patch added to -mm tree
Date: Tue, 10 Jul 2012 14:20:43 -0700
Message-ID: <20120710212044.356B55C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:59882 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab2GJVUq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 17:20:46 -0400
Received: by eeil10 with SMTP id l10so3411eei.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 14:20:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pebolle@tiscali.nl, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net


The patch titled
     Subject: alpha: remove mysterious if zero-ed out includes
has been added to the -mm tree.  Its filename is
     alpha-remove-mysterious-if-zero-ed-out-includes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Bolle <pebolle@tiscali.nl>
Subject: alpha: remove mysterious if zero-ed out includes

There's a small group of odd looking includes in smc37c669.c.  These
includes appear to be if zero-ed out ever since they were added to the
tree (in v2.1.89).  Their purpose is unclear to me.  Perhaps they were
used in someones build system.  Whatever their purpose was, nothing else
uses something comparable.  This entire if zero-ed out block might as well
be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/smc37c669.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN arch/alpha/kernel/smc37c669.c~alpha-remove-mysterious-if-zero-ed-out-includes arch/alpha/kernel/smc37c669.c
--- a/arch/alpha/kernel/smc37c669.c~alpha-remove-mysterious-if-zero-ed-out-includes
+++ a/arch/alpha/kernel/smc37c669.c
@@ -933,18 +933,6 @@ void SMC37c669_display_device_info( 
  *
  *--
  */
-#if 0
-/* $INCLUDE_OPTIONS$ */
-#include    "cp$inc:platform_io.h"
-/* $INCLUDE_OPTIONS_END$ */
-#include    "cp$src:common.h"
-#include    "cp$inc:prototypes.h"
-#include    "cp$src:kernel_def.h"
-#include    "cp$src:msg_def.h"
-#include    "cp$src:smcc669_def.h"
-/* Platform-specific includes */
-#include    "cp$src:platform.h"
-#endif
 
 #ifndef TRUE
 #define TRUE 1
_
Subject: Subject: alpha: remove mysterious if zero-ed out includes

Patches currently in -mm which might be from pebolle@tiscali.nl are

linux-next.patch
alpha-remove-mysterious-if-zero-ed-out-includes.patch

