From: akpm@linux-foundation.org
Subject: - x86-fix-clearcopy_user_page-declarations-in-pageh.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:31:20 -0700
Message-ID: <200803212031.m2LKVKv3009064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761313AbYCUUbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:31:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, jeremy.fitzhardinge@citrix.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: fix {clear,copy}_user_page() declarations in page.h
has been removed from the -mm tree.  Its filename was
     x86-fix-clearcopy_user_page-declarations-in-pageh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix {clear,copy}_user_page() declarations in page.h
From: Chuck Lever <chuck.lever@oracle.com>

Clean up: eliminate some compiler noise on x86 when building with strict
warnings enabled, introduced by commit 345b904c.

In file included from include2/asm/thread_info_64.h:12,
                 from include2/asm/thread_info.h:4,
                 from
/home/cel/src/linux/nfs-2.6/include/linux/thread_info.h:35,
                 from
/home/cel/src/linux/nfs-2.6/include/linux/preempt.h:9,
                 from
/home/cel/src/linux/nfs-2.6/include/linux/spinlock.h:49,
                 from /home/cel/src/linux/nfs-2.6/include/linux/mmzone.h:7,
                 from /home/cel/src/linux/nfs-2.6/include/linux/gfp.h:4,
                 from /home/cel/src/linux/nfs-2.6/include/linux/slab.h:14,
                 from /home/cel/src/linux/nfs-2.6/fs/nfsd/nfs4acl.c:40:
include2/asm/page.h:55: warning: `inline' is not at beginning of
declaration
include2/asm/page.h:61: warning: `inline' is not at beginning of
declaration

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/page.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-x86/page.h~x86-fix-clearcopy_user_page-declarations-in-pageh include/asm-x86/page.h
--- a/include/asm-x86/page.h~x86-fix-clearcopy_user_page-declarations-in-pageh
+++ a/include/asm-x86/page.h
@@ -52,13 +52,13 @@ extern int page_is_ram(unsigned long pag
 
 struct page;
 
-static void inline clear_user_page(void *page, unsigned long vaddr,
+static inline void clear_user_page(void *page, unsigned long vaddr,
 				struct page *pg)
 {
 	clear_page(page);
 }
 
-static void inline copy_user_page(void *to, void *from, unsigned long vaddr,
+static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 				struct page *topage)
 {
 	copy_page(to, from);
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

origin.patch
git-nfsd.patch

