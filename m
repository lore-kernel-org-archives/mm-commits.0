From: akpm@linux-foundation.org
Subject: + mm-fix-sparsemem-configuration.patch added to -mm tree
Date: Tue, 13 Oct 2009 19:49:59 -0700
Message-ID: <200910140249.n9E2nxOg006623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761586AbZJNCul (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 22:50:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmk+lkml@arm.linux.org.uk, rmk+kernel@arm.linux.org.uk


The patch titled
     mm: fix sparsemem configuration
has been added to the -mm tree.  Its filename is
     mm-fix-sparsemem-configuration.patch

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
Subject: mm: fix sparsemem configuration
From: Russell King <rmk+lkml@arm.linux.org.uk>

Currently, sparsemem is only available if EXPERIMENTAL is enabled. 
However, it hasn't ever been marked experimental.

It's been about four years since sparsemem was merged, and we have
platforms which depend on it; allow architectures to decide whether
sparsemem should be the default memory model.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~mm-fix-sparsemem-configuration mm/Kconfig
--- a/mm/Kconfig~mm-fix-sparsemem-configuration
+++ a/mm/Kconfig
@@ -67,7 +67,7 @@ config DISCONTIGMEM
 
 config SPARSEMEM
 	def_bool y
-	depends on SPARSEMEM_MANUAL
+	depends on (!SELECT_MEMORY_MODEL && ARCH_SPARSEMEM_ENABLE) || SPARSEMEM_MANUAL
 
 config FLATMEM
 	def_bool y
_

Patches currently in -mm which might be from rmk+lkml@arm.linux.org.uk are

mm-fix-sparsemem-configuration.patch

