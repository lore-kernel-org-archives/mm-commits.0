From: akpm@linux-foundation.org
Subject: [patch 027/111] fs/proc/task_mmu.c: suppress compilation warnings with W=1
Date: Tue, 02 Aug 2016 14:03:25 -0700
Message-ID: <57a10a9d.tjIMzoz9dEADSK+q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbcHBVRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu, valdis.kletnieks@vt.edu

From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: fs/proc/task_mmu.c: suppress compilation warnings with W=1

Suppress a bunch of warnings of the form:

fs/proc/task_mmu.c: In function 'show_smap_vma_flags':
fs/proc/task_mmu.c:635:22: warning: initialized field overwritten [-Wt override-init]
   [ilog2(VM_READ)] = "rd",
                      ^~~~
fs/proc/task_mmu.c:635:22: note: (near initialization for 'mnemonics[0]')

They happen because of the way we intentionally build the table, so
silence the warning when building with 'make W=1'.

Link: http://lkml.kernel.org/r/8727.1470022083@turing-police.cc.vt.edu
Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/Makefile~suppress-warnings-when-compiling-fs-proc-task_mmuc-with-w=1 fs/proc/Makefile
--- a/fs/proc/Makefile~suppress-warnings-when-compiling-fs-proc-task_mmuc-with-w=1
+++ a/fs/proc/Makefile
@@ -4,6 +4,7 @@
 
 obj-y   += proc.o
 
+CFLAGS_task_mmu.o	+= -Wno-override-init
 proc-y			:= nommu.o task_nommu.o
 proc-$(CONFIG_MMU)	:= task_mmu.o
 
_
