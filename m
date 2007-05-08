From: akpm@linux-foundation.org
Subject: + uml-mark-a-tt-only-function.patch added to -mm tree
Date: Tue, 08 May 2007 14:36:37 -0700
Message-ID: <200705082136.l48Lablg002372@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032398AbXEHVgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: mark a tt-only function
has been added to the -mm tree.  Its filename is
     uml-mark-a-tt-only-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: mark a tt-only function
From: Jeff Dike <jdike@addtoit.com>

Mark another function as tt-mode only.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/process.c |    2 ++
 1 files changed, 2 insertions(+)

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
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
uml-fix-build-breakage.patch
uml-mark-a-tt-only-function.patch
fix-linuxdoc-comment.patch
