From: akpm@linux-foundation.org
Subject: + m68k-arch-m68k-kernel-sun3-heads-needs-linux-inith.patch added to -mm tree
Date: Tue, 28 Apr 2009 15:22:02 -0700
Message-ID: <200904282222.n3SMM2vE016174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbZD1WXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 18:23:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org


The patch titled
     m68k: arch/m68k/kernel/sun3-head.S needs <linux/init.h>
has been added to the -mm tree.  Its filename is
     m68k-arch-m68k-kernel-sun3-heads-needs-linux-inith.patch

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
Subject: m68k: arch/m68k/kernel/sun3-head.S needs <linux/init.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>

| arch/m68k/kernel/sun3-head.S: Assembler messages:
| arch/m68k/kernel/sun3-head.S:32: Error: Unknown operator -- statement `__head' ignored

Introduced by commit 6f335cab0431d5df4995bcd4fd952d4c746d5a86 ("m68k:
convert to use __HEAD and HEAD_TEXT macros."), which started using __HEAD
without adding the appropriate include.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/sun3-head.S |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/m68k/kernel/sun3-head.S~m68k-arch-m68k-kernel-sun3-heads-needs-linux-inith arch/m68k/kernel/sun3-head.S
--- a/arch/m68k/kernel/sun3-head.S~m68k-arch-m68k-kernel-sun3-heads-needs-linux-inith
+++ a/arch/m68k/kernel/sun3-head.S
@@ -1,4 +1,5 @@
 #include <linux/linkage.h>
+#include <linux/init.h>
 
 #include <asm/entry.h>
 #include <asm/page.h>
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
time-create-arch_gettimeoffset-infrastructure-for-use-in-the-generic-timekeeping-core.patch
m68k-arch-m68k-kernel-sun3-heads-needs-linux-inith.patch
m68k-count-can-reach-51-not-50.patch
kmap_types-make-most-arches-use-generic-header-file.patch
flat-fix-data-sections-alignment.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch

