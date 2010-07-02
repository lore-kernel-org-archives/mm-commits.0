From: akpm@linux-foundation.org
Subject: + x86-rwsem-stay-on-fast-path-when-count0-in-__up_write-fix.patch added to -mm tree
Date: Fri, 02 Jul 2010 13:49:24 -0700
Message-ID: <201007022049.o62KnOGa026127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573Ab0GBUtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 16:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com


The patch titled
     x86-rwsem-stay-on-fast-path-when-count0-in-__up_write-fix
has been added to the -mm tree.  Its filename is
     x86-rwsem-stay-on-fast-path-when-count0-in-__up_write-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-rwsem-stay-on-fast-path-when-count0-in-__up_write-fix
From: Michel Lespinasse <walken@google.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/rwsem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/include/asm/rwsem.h~x86-rwsem-stay-on-fast-path-when-count0-in-__up_write-fix arch/x86/include/asm/rwsem.h
--- a/arch/x86/include/asm/rwsem.h~x86-rwsem-stay-on-fast-path-when-count0-in-__up_write-fix
+++ a/arch/x86/include/asm/rwsem.h
@@ -216,7 +216,7 @@ static inline void __up_write(struct rw_
 	rwsem_count_t tmp;
 	asm volatile("# beginning __up_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
-		     /* substracts 0xffff0001, returns the old value */
+		     /* subtracts 0xffff0001, returns the old value */
 		     "  jns        1f\n\t"
 		     "  call call_rwsem_wake\n"
 		     "1:\n\t"
_

Patches currently in -mm which might be from walken@google.com are

x86-rwsem-stay-on-fast-path-when-count0-in-__up_write.patch
x86-rwsem-stay-on-fast-path-when-count0-in-__up_write-fix.patch
x86-rwsem-minor-cleanups.patch
rwsem-fully-separate-code-pathes-to-wake-writers-vs-readers.patch
rwsem-lighter-active-count-checks-when-waking-up-readers.patch
rwsem-let-rwsem_waiting_bias-represent-any-number-of-waiting-threads.patch
rwsem-wake-queued-readers-when-writer-blocks-on-active-read-lock.patch
rwsem-smaller-wrappers-around-rwsem_down_failed_common.patch

