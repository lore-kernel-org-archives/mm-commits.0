From: akpm@linux-foundation.org
Subject: + x86-rwsem-stay-on-fast-path-when-count0-in-__up_write.patch added to -mm tree
Date: Thu, 03 Jun 2010 11:42:15 -0700
Message-ID: <201006031842.o53IgF8x009034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755013Ab0FCSms (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jun 2010 14:42:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, hpa@zytor.com, mikew@google.com, mingo@elte.hu, suleiman@google.com, tglx@linutronix.de, yinghan@google.com


The patch titled
     x86 rwsem: stay on fast path when count>0 in __up_write()
has been added to the -mm tree.  Its filename is
     x86-rwsem-stay-on-fast-path-when-count0-in-__up_write.patch

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
Subject: x86 rwsem: stay on fast path when count>0 in __up_write()
From: Michel Lespinasse <walken@google.com>

When count>0 there is no need to take the call_rwsem_wake path.  If we did
take that path, it would just return without doing anything due to the
active count not being zero.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/rwsem.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/rwsem.h~x86-rwsem-stay-on-fast-path-when-count0-in-__up_write arch/x86/include/asm/rwsem.h
--- a/arch/x86/include/asm/rwsem.h~x86-rwsem-stay-on-fast-path-when-count0-in-__up_write
+++ a/arch/x86/include/asm/rwsem.h
@@ -216,9 +216,8 @@ static inline void __up_write(struct rw_
 	rwsem_count_t tmp;
 	asm volatile("# beginning __up_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
-		     /* tries to transition
-			0xffff0001 -> 0x00000000 */
-		     "  jz       1f\n"
+		     /* substracts 0xffff0001, returns the old value */
+		     "  jns        1f\n\t"
 		     "  call call_rwsem_wake\n"
 		     "1:\n\t"
 		     "# ending __up_write\n"
_

Patches currently in -mm which might be from walken@google.com are

x86-rwsem-stay-on-fast-path-when-count0-in-__up_write.patch
x86-rwsem-minor-cleanups.patch
rwsem-fully-separate-code-pathes-to-wake-writers-vs-readers.patch
rwsem-lighter-active-count-checks-when-waking-up-readers.patch
rwsem-let-rwsem_waiting_bias-represent-any-number-of-waiting-threads.patch
rwsem-wake-queued-readers-when-writer-blocks-on-active-read-lock.patch
rwsem-smaller-wrappers-around-rwsem_down_failed_common.patch

