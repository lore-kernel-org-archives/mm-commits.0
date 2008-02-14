From: akpm@linux-foundation.org
Subject: + x86-fix-clearcopy_user_page-declarations-in-pageh.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:30:59 -0800
Message-ID: <200802142130.m1ELUxjg003888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40589 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763881AbYBNVcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:32:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuck.lever@oracle.com, jeremy.fitzhardinge@citrix.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: fix {clear,copy}_user_page() declarations in page.h
has been added to the -mm tree.  Its filename is
     x86-fix-clearcopy_user_page-declarations-in-pageh.patch

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
@@ -53,13 +53,13 @@ extern int devmem_is_allowed(unsigned lo
 
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

x86-fix-clearcopy_user_page-declarations-in-pageh.patch
