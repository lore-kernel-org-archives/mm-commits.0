From: akpm@linux-foundation.org
Subject: - uml-compile-error-fix.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:01 -0700
Message-ID: <200804162255.m3GMt1Jj011073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756895AbYDPWze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 18:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     uml: compile error fix
has been removed from the -mm tree.  Its filename was
     uml-compile-error-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: compile error fix
From: WANG Cong <xiyou.wangcong@gmail.com>

This patch fixes this error:

In file included from /home/wangcong/projects/linux-2.6/arch/um/kernel/smp.c:9:
include2/asm/tlb.h: In function `tlb_remove_page':
include2/asm/tlb.h:101: error: implicit declaration of function `page_cache_release'

And since including <linux/pagemap.h> in <linux/swap.h> will break sparc,
we add this #include in uml's own header.

Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/tlb.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-um/tlb.h~uml-compile-error-fix include/asm-um/tlb.h
--- a/include/asm-um/tlb.h~uml-compile-error-fix
+++ a/include/asm-um/tlb.h
@@ -1,6 +1,7 @@
 #ifndef __UM_TLB_H
 #define __UM_TLB_H
 
+#include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <asm/percpu.h>
 #include <asm/pgalloc.h>
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
git-hrt.patch
arch-um-kernel-um_archc-some-small-improvements.patch
arch-um-os-linux-start_upc-various-improvements.patch
uml-make-a-function-static.patch
uml-remove-a-useless-function.patch
uml-make-three-functions-static.patch
uml-make-several-things-static.patch
arch-um-os-linux-sys-i386-task_sizec-improve-a-bit.patch
remove-the-macro-get_personality.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch

