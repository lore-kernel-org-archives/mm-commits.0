From: akpm@linux-foundation.org
Subject: + print_ip_sym-use-%ps.patch added to -mm tree
Date: Mon, 28 Jul 2008 23:55:37 -0700
Message-ID: <200807290655.m6T6tbvB019788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048AbYG2Gzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 02:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vegard.nossum@gmail.com


The patch titled
     print_ip_sym(): use %pS
has been added to the -mm tree.  Its filename is
     print_ip_sym-use-%ps.patch

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
Subject: print_ip_sym(): use %pS
From: Vegard Nossum <vegard.nossum@gmail.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kallsyms.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/kallsyms.h~print_ip_sym-use-%ps include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~print_ip_sym-use-%ps
+++ a/include/linux/kallsyms.h
@@ -108,8 +108,7 @@ static inline void print_fn_descriptor_s
 
 static inline void print_ip_sym(unsigned long ip)
 {
-	printk("[<%p>]", (void *) ip);
-	print_symbol(" %s\n", ip);
+	printk("[<%p>] %pS\n", (void *) ip, (void *) ip);
 }
 
 #endif /*_LINUX_KALLSYMS_H*/
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
print_ip_sym-use-%ps.patch
linux-next.patch
parisc-fix-incomplete-header-guard.patch

