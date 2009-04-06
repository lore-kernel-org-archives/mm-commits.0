From: akpm@linux-foundation.org
Subject: + frv-fix-compile-breakage.patch added to -mm tree
Date: Mon, 06 Apr 2009 08:26:30 -0700
Message-ID: <200904061526.n36FQU07020435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754008AbZDFPpx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 11:45:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, dhowells@redhat.com


The patch titled
     frv: fix compile breakage
has been added to the -mm tree.  Its filename is
     frv-fix-compile-breakage.patch

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
Subject: frv: fix compile breakage
From: Adrian Bunk <bunk@kernel.org>

Fix the follwing build error caused by commit
7ca43e7564679604d86e9ed834e7bbcffd8a4a3f (mm: use debug_kmap_atomic):

...
  AS      arch/frv/mm/tlb-miss.o
...
In file included from
arch/frv/mm/tlb-miss.S:13:
...
Assembler messages:
include/asm-generic/ioctl.h:73:
Error: unrecognized instruction `extern unsigned int __invalid_size_argument_for_IO...'
...

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mm/tlb-miss.S |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/frv/mm/tlb-miss.S~frv-fix-compile-breakage arch/frv/mm/tlb-miss.S
--- a/arch/frv/mm/tlb-miss.S~frv-fix-compile-breakage
+++ a/arch/frv/mm/tlb-miss.S
@@ -13,7 +13,6 @@
 #include <linux/linkage.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/highmem.h>
 #include <asm/spr-regs.h>
 
 	.section	.text.tlbmiss
_

Patches currently in -mm which might be from bunk@kernel.org are

frv-fix-compile-breakage.patch
linux-next.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
reiser4.patch

