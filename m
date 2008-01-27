From: akpm@linux-foundation.org
Subject: + jbdh-hide-kernel-only-code.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:15:08 -0800
Message-ID: <200801270515.m0R5F5BO031034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbYA0FPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:15:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de


The patch titled
     jbd.h: hide kernel only code
has been added to the -mm tree.  Its filename is
     jbdh-hide-kernel-only-code.patch

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
Subject: jbd.h: hide kernel only code
From: Olaf Hering <olaf@aepfle.de>

Move a few kernel-only things into __KERNEL__.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jbd.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/jbd.h~jbdh-hide-kernel-only-code include/linux/jbd.h
--- a/include/linux/jbd.h~jbdh-hide-kernel-only-code
+++ a/include/linux/jbd.h
@@ -33,7 +33,6 @@
 #include <linux/lockdep.h>
 
 #include <asm/semaphore.h>
-#endif
 
 #define journal_oom_retry 1
 
@@ -84,7 +83,6 @@ static inline void jbd_free(void *ptr, s
 
 #define JFS_MIN_JOURNAL_BLOCKS 1024
 
-#ifdef __KERNEL__
 
 /**
  * typedef handle_t - The handle_t type represents a single atomic update being performed by some process.
_

Patches currently in -mm which might be from olaf@aepfle.de are

slab-fix-bootstrap-on-memoryless-node.patch
fix-slab-kmem_list3-for-booting-on-machines-with-memoryless-nodes-full-revert-of-04231b3002ac53f8a64a7bd142fde3fa4b6808c6.patch
git-net.patch
jbdh-hide-kernel-only-code.patch
keep-track-of-network-interface-renaming.patch
