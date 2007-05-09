From: akpm@linux-foundation.org
Subject: - uml-mark-a-tt-only-function.patch removed from -mm tree
Date: Wed, 09 May 2007 14:49:33 -0700
Message-ID: <200705092149.l49LnXTI002703@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755898AbXEIVtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:49:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: mark a tt-only function
has been removed from the -mm tree.  Its filename was
     uml-mark-a-tt-only-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: mark a tt-only function
From: Jeff Dike <jdike@addtoit.com>

Mark another function as tt-mode only.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/process.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/um/os-Linux/process.c~uml-mark-a-tt-only-function arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-mark-a-tt-only-function
+++ a/arch/um/os-Linux/process.c
@@ -239,6 +239,7 @@ out:
 	return ok;
 }
 
+#ifdef UML_CONFIG_MODE_TT
 void init_new_thread_stack(void *sig_stack, void (*usr1_handler)(int))
 {
 	int flags = 0, pages;
@@ -260,6 +261,7 @@ void init_new_thread_stack(void *sig_sta
 			      "errno = %d\n", errno);
 	}
 }
+#endif
 
 void init_new_thread_signals(void)
 {
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
