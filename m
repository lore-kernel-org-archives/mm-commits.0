From: akpm@linux-foundation.org
Subject: + uml-kill-x86_64-stack_top_max.patch added to -mm tree
Date: Tue, 12 Jun 2007 14:06:13 -0700
Message-ID: <200706122106.l5CL6D7j021186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37991 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265AbXFLVGW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 17:06:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: kill x86_64 STACK_TOP_MAX
has been added to the -mm tree.  Its filename is
     uml-kill-x86_64-stack_top_max.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: kill x86_64 STACK_TOP_MAX
From: Jeff Dike <jdike@addtoit.com>

The x86_64 a.out.h got a definition of STACK_TOP_MAX, which interferes with
the UML version.  So, just undef it like STACK_TOP.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/a.out.h |    1 +
 1 files changed, 1 insertion(+)

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

origin.patch
uml-remove-page_size-from-libc-code.patch
uml-kill-x86_64-stack_top_max.patch
hostfs-convert-to-new-aops.patch
uml-fix-request-sector-update.patch
