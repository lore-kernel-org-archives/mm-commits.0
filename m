From: akpm@linux-foundation.org
Subject: + move-mm_struct-and-vm_area_struct-fix.patch added to -mm tree
Date: Tue, 14 Aug 2007 12:46:26 -0700
Message-ID: <200708141946.l7EJkVog017956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38276 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763769AbXHNTq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aurelien@aurel32.net, schwidefsky@de.ibm.com


The patch titled
     move-mm_struct-and-vm_area_struct fix
has been added to the -mm tree.  Its filename is
     move-mm_struct-and-vm_area_struct-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-kvm.patch
mips-detect-bcm947xx-cpus.patch
mips-bcm947xx-support.patch
rfc-add-bcm947xx-to-kconfig.patch
mips-add-bcm947xx-to-makefile.patch
git-wireless.patch
move-mm_struct-and-vm_area_struct-fix.patch
