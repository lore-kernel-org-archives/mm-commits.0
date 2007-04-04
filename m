From: akpm@linux-foundation.org
Subject: + kernel-paramsc-fix-lying-comment-for-param_array.patch added to -mm tree
Date: Tue, 03 Apr 2007 17:10:53 -0700
Message-ID: <200704040010.l340Ar00007312@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49709 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946048AbXDDALM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 20:11:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wesarg@informatik.uni-halle.de


The patch titled
     kernel/params.c: fix lying comment for param_array()
has been added to the -mm tree.  Its filename is
     kernel-paramsc-fix-lying-comment-for-param_array.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/params.c: fix lying comment for param_array()
From: Bert Wesarg <wesarg@informatik.uni-halle.de>

This fixes the comment for the function param_array. Which lies that it
only *temporarily* mangle the input string @val.

Signed-off-by: Bert Wesarg <wesarg@informatik.uni-halle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/params.c~kernel-paramsc-fix-lying-comment-for-param_array kernel/params.c
--- a/kernel/params.c~kernel-paramsc-fix-lying-comment-for-param_array
+++ a/kernel/params.c
@@ -269,7 +269,7 @@ int param_get_invbool(char *buffer, stru
 	return param_get_bool(buffer, &dummy);
 }
 
-/* We cheat here and temporarily mangle the string. */
+/* We break the rule and mangle the string. */
 static int param_array(const char *name,
 		       const char *val,
 		       unsigned int min, unsigned int max,
_

Patches currently in -mm which might be from wesarg@informatik.uni-halle.de are

kernel-paramsc-fix-lying-comment-for-param_array.patch
