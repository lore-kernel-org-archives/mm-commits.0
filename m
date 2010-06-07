From: akpm@linux-foundation.org
Subject: + kernel-range-remove-unused-definition-of-array_size.patch added to -mm tree
Date: Mon, 07 Jun 2010 15:49:26 -0700
Message-ID: <201006072249.o57MnQDd032543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752472Ab0FGWtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jun 2010 18:49:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, hpa@zytor.com, yinghai@kernel.org


The patch titled
     kernel/range: remove unused definition of ARRAY_SIZE()
has been added to the -mm tree.  Its filename is
     kernel-range-remove-unused-definition-of-array_size.patch

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
Subject: kernel/range: remove unused definition of ARRAY_SIZE()
From: Geert Uytterhoeven <geert@linux-m68k.org>

Remove duplicate definition of ARRAY_SIZE(), which was never used anyway.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/range.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN kernel/range.c~kernel-range-remove-unused-definition-of-array_size kernel/range.c
--- a/kernel/range.c~kernel-range-remove-unused-definition-of-array_size
+++ a/kernel/range.c
@@ -7,10 +7,6 @@
 
 #include <linux/range.h>
 
-#ifndef ARRAY_SIZE
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-#endif
