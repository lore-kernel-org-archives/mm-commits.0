From: akpm@linux-foundation.org
Subject: + mm-increase-the-default-mlock-limit-from-32k-to-64k.patch added to -mm tree
Date: Mon, 20 Oct 2008 14:31:40 -0700
Message-ID: <200810202131.m9KLVe8R020985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035AbYJTVbq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 17:31:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: garloff@suse.de, npiggin@suse.de


The patch titled
     mm: increase the default mlock limit from 32k to 64k
has been added to the -mm tree.  Its filename is
     mm-increase-the-default-mlock-limit-from-32k-to-64k.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: increase the default mlock limit from 32k to 64k
From: Kurt Garloff <garloff@suse.de>

By default, non-privileged tasks can only mlock() a small amount of
memory to avoid a DoS attack by ordinary users.  The Linux kernel
defaulted to 32k (on a 4k page size system) to accommodate the needs of
gpg.

However, newer gpg2 needs 64k in various circumstances and otherwise
fails miserably, see bnc#329675.

Change the default to 64k, and make it more agnostic to PAGE_SIZE.

Signed-off-by: Kurt Garloff <garloff@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/resource.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/resource.h~mm-increase-the-default-mlock-limit-from-32k-to-64k include/linux/resource.h
--- a/include/linux/resource.h~mm-increase-the-default-mlock-limit-from-32k-to-64k
+++ a/include/linux/resource.h
@@ -59,10 +59,10 @@ struct rlimit {
 #define _STK_LIM	(8*1024*1024)
 
 /*
- * GPG wants 32kB of mlocked memory, to make sure pass phrases
+ * GPG2 wants 64kB of mlocked memory, to make sure pass phrases
  * and other sensitive information are never written to disk.
  */
-#define MLOCK_LIMIT	(8 * PAGE_SIZE)
+#define MLOCK_LIMIT	((PAGE_SIZE > 64*1024) ? PAGE_SIZE : 64*1024)
 
 /*
  * Due to binary compatibility, the actual resource numbers
_

Patches currently in -mm which might be from garloff@suse.de are

mm-increase-the-default-mlock-limit-from-32k-to-64k.patch

