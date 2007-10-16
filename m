From: akpm@linux-foundation.org
Subject: - move-mm_struct-and-vm_area_struct-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:06:09 -0700
Message-ID: <200710160406.l9G469n3007930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37797 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547AbXJPEGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:06:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aurelien@aurel32.net, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     move-mm_struct-and-vm_area_struct fix
has been removed from the -mm tree.  Its filename was
     move-mm_struct-and-vm_area_struct-fix.patch

This patch was dropped because it was folded into move-mm_struct-and-vm_area_struct.patch

------------------------------------------------------
Subject: move-mm_struct-and-vm_area_struct fix
From: Aurelien Jarno <aurelien@aurel32.net>

  CC      arch/mips/kernel/asm-offsets.s
In file included from include/linux/sched.h:58,
                 from arch/mips/kernel/asm-offsets.c:13:
include/linux/mm_types.h:115: error: expected specifier-qualifier-list before 'pgprot_t'
include/linux/mm_types.h:169: warning: 'struct file' declared inside parameter list
include/linux/mm_types.h:169: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/mm_types.h:175: error: expected specifier-qualifier-list before 'pgd_t'

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/linux/mm_types.h~move-mm_struct-and-vm_area_struct-fix include/linux/mm_types.h
--- a/include/linux/mm_types.h~move-mm_struct-and-vm_area_struct-fix
+++ a/include/linux/mm_types.h
@@ -10,6 +10,7 @@
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
 #include <linux/completion.h>
+#include <asm/page.h>
 #include <asm/mmu.h>
 
 struct address_space;
_

Patches currently in -mm which might be from aurelien@aurel32.net are

origin.patch
move-mm_struct-and-vm_area_struct.patch
move-mm_struct-and-vm_area_struct-fix.patch
