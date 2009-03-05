From: akpm@linux-foundation.org
Subject: + xtensa-enforce-slab-alignment-to-maximum-register-width.patch added to -mm tree
Date: Thu, 05 Mar 2009 14:05:50 -0800
Message-ID: <200903052205.n25M5o95006406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544AbZCEWGm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 17:06:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: os@emlix.com, chris@zankel.net, jw@emlix.com, penberg@cs.helsinki.fi


The patch titled
     xtensa: enforce slab alignment to maximum register width
has been added to the -mm tree.  Its filename is
     xtensa-enforce-slab-alignment-to-maximum-register-width.patch

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
Subject: xtensa: enforce slab alignment to maximum register width
From: Oskar Schirmer <os@emlix.com>

XCHAL_DATA_WIDTH is the maximum register width, slab caches should be
aligned to this.

Theoretical fix as all variants have had an XCHAL_DATA_WIDTH of 4
(wordsize) for now.  But the S6000 variant will raise this to 16.

Signed-off-by: Oskar Schirmer <os@emlix.com>
Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Chris Zankel <chris@zankel.net>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/processor.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/xtensa/include/asm/processor.h~xtensa-enforce-slab-alignment-to-maximum-register-width arch/xtensa/include/asm/processor.h
--- a/arch/xtensa/include/asm/processor.h~xtensa-enforce-slab-alignment-to-maximum-register-width
+++ a/arch/xtensa/include/asm/processor.h
@@ -25,6 +25,8 @@
 # error Linux requires the Xtensa Windowed Registers Option.
 #endif
 
+#define ARCH_SLAB_MINALIGN	XCHAL_DATA_WIDTH
+
 /*
  * User space process size: 1 GB.
  * Windowed call ABI requires caller and callee to be located within the same
_

Patches currently in -mm which might be from os@emlix.com are

xtensa-enforce-slab-alignment-to-maximum-register-width.patch
flat-fix-data-sections-alignment.patch

