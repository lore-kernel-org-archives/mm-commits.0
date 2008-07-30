From: akpm@linux-foundation.org
Subject: - print_ip_sym-use-%ps.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:49 -0700
Message-ID: <200807301914.m6UJEnO5010934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487AbYG3TPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:15:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     print_ip_sym(): use %pS
has been removed from the -mm tree.  Its filename was
     print_ip_sym-use-%ps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
git-infiniband.patch

