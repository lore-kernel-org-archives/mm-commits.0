From: akpm@linux-foundation.org
Subject: - arch-cris-arch-v10-vmlinuxldss-fix-boot-problem.patch removed from -mm tree
Date: Tue, 15 Jan 2008 12:33:50 -0800
Message-ID: <200801152033.m0FKXVIL001838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54819 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYAOUeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 15:34:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuwana@nyanyan.to, jesper.nilsson@axis.com, ryu@nyanyan.to, mm-commits@vger.kernel.org


The patch titled
     arch/cris/arch-v10/vmlinux.lds.S fix boot problem
has been removed from the -mm tree.  Its filename was
     arch-cris-arch-v10-vmlinuxldss-fix-boot-problem.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/cris/arch-v10/vmlinux.lds.S fix boot problem
From: Yuusei KUWANA <kuwana@nyanyan.to>

arch/cris/arch-v10/vmlinux.lds.S
 fix boot problem
* too old initcall style. replace INITCALLS macro
* __init_begin, __init_end move for free_initmem()

Note: with this patch kernel boot and mount root,
but after init done,  kernel panic at do_signal() ...

Signed-off-by: Yuusei KUWANA <ryu@nyanyan.to>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/vmlinux.lds.S |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN arch/cris/arch-v10/vmlinux.lds.S~arch-cris-arch-v10-vmlinuxldss-fix-boot-problem arch/cris/arch-v10/vmlinux.lds.S
--- a/arch/cris/arch-v10/vmlinux.lds.S~arch-cris-arch-v10-vmlinuxldss-fix-boot-problem
+++ a/arch/cris/arch-v10/vmlinux.lds.S
@@ -53,26 +53,22 @@ SECTIONS
   	.data.init_task : { *(.data.init_task) }
 
   	. = ALIGN(8192);              /* Init code and data */
-  	__init_begin = .;
 	.init.text : { 
 		   _sinittext = .;
 		   *(.init.text)
 		   _einittext = .;
 	}
+  	__init_begin = .;
   	.init.data : { *(.init.data) }
+  	__init_end = .;
+
   	. = ALIGN(16);
   	__setup_start = .;
   	.init.setup : { *(.init.setup) }
   	__setup_end = .;
   	.initcall.init : {
 		__initcall_start = .;
-		*(.initcall1.init);
-		*(.initcall2.init);
-		*(.initcall3.init);
-		*(.initcall4.init);
-		*(.initcall5.init);
-		*(.initcall6.init);
-		*(.initcall7.init);
+			INITCALLS
 		__initcall_end = .;	
 	}
 
@@ -97,7 +93,6 @@ SECTIONS
 #endif
 	
 	__vmlinux_end = .;            /* last address of the physical file */
-  	__init_end = .;
 
 	__data_end = . ;              /* Move to _edata ? */
 	__bss_start = .;              /* BSS */
_

Patches currently in -mm which might be from kuwana@nyanyan.to are

arch-cris-arch-v10-vmlinuxldss-fix-boot-problem.patch
