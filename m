From: akpm@linux-foundation.org
Subject: + kallsyms-fix-potential-overflow-in-binary-search.patch added to -mm tree
Date: Tue, 13 May 2008 13:37:45 -0700
Message-ID: <200805132037.m4DKbjOi030967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759354AbYEMUiJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 16:38:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vegard.nossum@gmail.com, jjb@google.com


The patch titled
     kallsyms: fix potential overflow in binary search
has been added to the -mm tree.  Its filename is
     kallsyms-fix-potential-overflow-in-binary-search.patch

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

revert-acpica-fixes-for-unload-and-ddbhandles.patch
kallsyms-fix-potential-overflow-in-binary-search.patch

