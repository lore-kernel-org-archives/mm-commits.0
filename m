From: akpm@linux-foundation.org
Subject: + score-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
 added to -mm tree
Date: Fri, 29 Aug 2014 12:59:39 -0700
Message-ID: <5400dbab.pvz/u0686c89nzQI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaH2T7k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 15:59:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, lennox.wu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: score: use Kbuild logic to include <asm-generic/sections.h>
has been added to the -mm tree.  Its filename is
     score-use-kbuild-logic-to-include-asm-generic-sectionsh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/score-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/score-use-kbuild-logic-to-include-asm-generic-sectionsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: score: use Kbuild logic to include <asm-generic/sections.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/include/asm/Kbuild     |    1 +
 arch/score/include/asm/sections.h |    6 ------
 2 files changed, 1 insertion(+), 6 deletions(-)

diff -puN arch/score/include/asm/Kbuild~score-use-kbuild-logic-to-include-asm-generic-sectionsh arch/score/include/asm/Kbuild
--- a/arch/score/include/asm/Kbuild~score-use-kbuild-logic-to-include-asm-generic-sectionsh
+++ a/arch/score/include/asm/Kbuild
@@ -9,5 +9,6 @@ generic-y += hash.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += scatterlist.h
+generic-y += sections.h
 generic-y += trace_clock.h
 generic-y += xor.h
diff -puN arch/score/include/asm/sections.h~score-use-kbuild-logic-to-include-asm-generic-sectionsh /dev/null
--- a/arch/score/include/asm/sections.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_SECTIONS_H
-#define _ASM_SCORE_SECTIONS_H
-
-#include <asm-generic/sections.h>
