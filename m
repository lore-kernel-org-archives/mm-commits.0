From: akpm@linux-foundation.org
Subject: + uml-compile-error-fix.patch added to -mm tree
Date: Mon, 14 Apr 2008 12:52:05 -0700
Message-ID: <200804141952.m3EJq5MR023981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757506AbYDNTwN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 15:52:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org


The patch titled
     uml: compile error fix
has been added to the -mm tree.  Its filename is
     uml-compile-error-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

uml-compile-error-fix.patch
git-hrt.patch
arch-um-kernel-um_archc-some-small-improvements.patch
arch-um-os-linux-start_upc-various-improvements.patch
remove-the-macro-get_personality.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch

