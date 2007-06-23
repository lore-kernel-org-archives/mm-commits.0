From: akpm@linux-foundation.org
Subject: - uml-kill-x86_64-stack_top_max.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:27:27 -0700
Message-ID: <200706231927.l5NJRRVf022063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753858AbXFWT1f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:27:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: kill x86_64 STACK_TOP_MAX
has been removed from the -mm tree.  Its filename was
     uml-kill-x86_64-stack_top_max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: kill x86_64 STACK_TOP_MAX
From: Jeff Dike <jdike@addtoit.com>

The x86_64 a.out.h got a definition of STACK_TOP_MAX, which interferes with
the UML version.  So, just undef it like STACK_TOP.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/a.out.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-um/a.out.h~uml-kill-x86_64-stack_top_max include/asm-um/a.out.h
--- a/include/asm-um/a.out.h~uml-kill-x86_64-stack_top_max
+++ a/include/asm-um/a.out.h
@@ -5,6 +5,7 @@
 #include "choose-mode.h"
 
 #undef STACK_TOP
+#undef STACK_TOP_MAX
 
 extern unsigned long stacksizelim;
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-add-asm-paravirth.patch
hostfs-convert-to-new-aops.patch
uml-fix-request-sector-update.patch
uml-use-get_free_pages-to-allocate-kernel-stacks.patch
uml-add-stack-usage-monitoring.patch
