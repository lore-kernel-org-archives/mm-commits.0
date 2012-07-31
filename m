From: akpm@linux-foundation.org
Subject: [merged] alpha-remove-mysterious-if-zero-ed-out-includes.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:48:06 -0700
Message-ID: <20120731184806.CA8191E0074@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab2GaSsH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:48:07 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:48:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pebolle@tiscali.nl, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: remove mysterious if zero-ed out includes
has been removed from the -mm tree.  Its filename was
     alpha-remove-mysterious-if-zero-ed-out-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from pebolle@tiscali.nl are

origin.patch
linux-next.patch

