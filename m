From: akpm@linux-foundation.org
Subject: - mlock-revert-mainline-handling-of-mlock-error-return.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:33:27 -0700
Message-ID: <200810202033.m9KKXRXZ010631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753687AbYJTUgj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:36:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mlock: revert mainline handling of mlock error return
has been removed from the -mm tree.  Its filename was
     mlock-revert-mainline-handling-of-mlock-error-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock: revert mainline handling of mlock error return
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

This change is intended to make mlock() error returns correct. 
make_page_present() is a lower level function used by more than mlock(). 
Subsequent patch[es] will add this error return fixup in an mlock specific
path.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff -puN mm/memory.c~mlock-revert-mainline-handling-of-mlock-error-return mm/memory.c
--- a/mm/memory.c~mlock-revert-mainline-handling-of-mlock-error-return
+++ a/mm/memory.c
@@ -2819,19 +2819,9 @@ int make_pages_present(unsigned long add
 	len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;
 	ret = get_user_pages(current, current->mm, addr,
 			len, write, 0, NULL, NULL);
-	if (ret < 0) {
-		/*
-		   SUS require strange return value to mlock
-		    - invalid addr generate to ENOMEM.
-		    - out of memory should generate EAGAIN.
-		*/
-		if (ret == -EFAULT)
-			ret = -ENOMEM;
-		else if (ret == -ENOMEM)
-			ret = -EAGAIN;
+	if (ret < 0)
 		return ret;
-	}
-	return ret == len ? 0 : -ENOMEM;
+	return ret == len ? 0 : -1;
 }
 
 #if !defined(__HAVE_ARCH_GATE_AREA)
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch

