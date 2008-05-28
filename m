From: akpm@linux-foundation.org
Subject: + ipc-restore-msgpool-original-value.patch added to -mm tree
Date: Wed, 28 May 2008 15:46:23 -0700
Message-ID: <200805282246.m4SMkNnM004184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580AbYE1Wr1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 18:47:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, manfred@colorfullife.com, mtk.manpages@googlemail.com, peifferp@gmail.com


The patch titled
     ipc: restore MSGPOOL original value
has been added to the -mm tree.  Its filename is
     ipc-restore-msgpool-original-value.patch

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
Subject: ipc: restore MSGPOOL original value
From: Nadia.Derbey@bull.net

When posting:

	[PATCH 1/8] Scaling msgmni to the amount of lowmem

(see http://article.gmane.org/gmane.linux.kernel/637849/) I changed the
MSGPOOL value to make it fit what is said in the man pages (i.e.  a size
in bytes).

But Michael Kerrisk rightly complained that this change could affect the
ABI.  So I'm posting this patch to make MSGPOOL expressed back in Kbytes. 
Michael, on his side, has fixed the man page.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/msg.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/msg.h~restore-msgpool-original-value include/linux/msg.h
--- a/include/linux/msg.h~restore-msgpool-original-value
+++ a/include/linux/msg.h
@@ -64,11 +64,11 @@ struct msginfo {
 #define MSGMNB 16384   /* <= INT_MAX */   /* default max size of a message queue */
 
 /* unused */
-#define MSGPOOL (MSGMNI * MSGMNB) /* size in bytes of message pool */
+#define MSGPOOL (MSGMNI * MSGMNB / 1024) /* size in kbytes of message pool */
 #define MSGTQL  MSGMNB            /* number of system message headers */
 #define MSGMAP  MSGMNB            /* number of entries in message map */
 #define MSGSSZ  16                /* message segment size */
-#define __MSGSEG (MSGPOOL / MSGSSZ) /* max no. of segments */
+#define __MSGSEG ((MSGPOOL * 1024) / MSGSSZ) /* max no. of segments */
 #define MSGSEG (__MSGSEG <= 0xffff ? __MSGSEG : 0xffff)
 
 #ifdef __KERNEL__
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

ipc-restore-msgpool-original-value.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch

