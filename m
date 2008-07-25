From: akpm@linux-foundation.org
Subject: - kallsyms-fix-potential-overflow-in-binary-search.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:29 -0700
Message-ID: <200807252254.m6PMsT1k002825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415AbYGYWyg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:54:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, jjb@google.com, mm-commits@vger.kernel.org


The patch titled
     kallsyms: fix potential overflow in binary search
has been removed from the -mm tree.  Its filename was
     kallsyms-fix-potential-overflow-in-binary-search.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kallsyms: fix potential overflow in binary search
From: Vegard Nossum <vegard.nossum@gmail.com>

This will probably never trigger... but it won't hurt to be careful.

http://googleresearch.blogspot.com/2006/06/extra-extra-read-all-about-it-nearly.html

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Joshua Bloch <jjb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kallsyms.c~kallsyms-fix-potential-overflow-in-binary-search kernel/kallsyms.c
--- a/kernel/kallsyms.c~kallsyms-fix-potential-overflow-in-binary-search
+++ a/kernel/kallsyms.c
@@ -176,7 +176,7 @@ static unsigned long get_symbol_pos(unsi
 	high = kallsyms_num_syms;
 
 	while (high - low > 1) {
-		mid = (low + high) / 2;
+		mid = low + (high - low) / 2;
 		if (kallsyms_addresses[mid] <= addr)
 			low = mid;
 		else
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
linux-next.patch
parisc-fix-incomplete-header-guard.patch

