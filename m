From: akpm@linux-foundation.org
Subject: + x86-rwsem-minor-cleanups.patch added to -mm tree
Date: Thu, 03 Jun 2010 11:42:17 -0700
Message-ID: <201006031842.o53IgHL0009037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755013Ab0FCSmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jun 2010 14:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, hpa@zytor.com, mikew@google.com, mingo@elte.hu, suleiman@google.com, tglx@linutronix.de, yinghan@google.com


The patch titled
     x86 rwsem: minor cleanups
has been added to the -mm tree.  Its filename is
     x86-rwsem-minor-cleanups.patch

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
Subject: x86 rwsem: minor cleanups
From: Michel Lespinasse <walken@google.com>

Clarified few comments and made initialization of %edx/%rdx more uniform
accross __down_write_nested, __up_read and __up_write functions.

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

 arch/x86/include/asm/rwsem.h |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN arch/x86/include/asm/rwsem.h~x86-rwsem-minor-cleanups arch/x86/include/asm/rwsem.h
--- a/arch/x86/include/asm/rwsem.h~x86-rwsem-minor-cleanups
+++ a/arch/x86/include/asm/rwsem.h
@@ -118,7 +118,7 @@ static inline void __down_read(struct rw
 {
 	asm volatile("# beginning down_read\n\t"
 		     LOCK_PREFIX _ASM_INC "(%1)\n\t"
-		     /* adds 0x00000001, returns the old value */
+		     /* adds 0x00000001 */
 		     "  jns        1f\n"
 		     "  call call_rwsem_down_read_failed\n"
 		     "1:\n\t"
@@ -156,11 +156,9 @@ static inline int __down_read_trylock(st
 static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	rwsem_count_t tmp;
-
-	tmp = RWSEM_ACTIVE_WRITE_BIAS;
 	asm volatile("# beginning down_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
-		     /* subtract 0x0000ffff, returns the old value */
+		     /* adds 0xffff0001, returns the old value */
 		     "  test      %1,%1\n\t"
 		     /* was the count 0 before? */
 		     "  jz        1f\n"
@@ -168,7 +166,7 @@ static inline void __down_write_nested(s
 		     "1:\n"
 		     "# ending down_write"
 		     : "+m" (sem->count), "=d" (tmp)
-		     : "a" (sem), "1" (tmp)
+		     : "a" (sem), "1" (RWSEM_ACTIVE_WRITE_BIAS)
 		     : "memory", "cc");
 }
 
@@ -195,16 +193,16 @@ static inline int __down_write_trylock(s
  */
 static inline void __up_read(struct rw_semaphore *sem)
 {
-	rwsem_count_t tmp = -RWSEM_ACTIVE_READ_BIAS;
+	rwsem_count_t tmp;
 	asm volatile("# beginning __up_read\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 1, returns the old value */
 		     "  jns        1f\n\t"
-		     "  call call_rwsem_wake\n"
+		     "  call call_rwsem_wake\n" /* expects old value in %edx */
 		     "1:\n"
 		     "# ending __up_read\n"
 		     : "+m" (sem->count), "=d" (tmp)
-		     : "a" (sem), "1" (tmp)
+		     : "a" (sem), "1" (-RWSEM_ACTIVE_READ_BIAS)
 		     : "memory", "cc");
 }
 
@@ -218,7 +216,7 @@ static inline void __up_write(struct rw_
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* substracts 0xffff0001, returns the old value */
 		     "  jns        1f\n\t"
-		     "  call call_rwsem_wake\n"
+		     "  call call_rwsem_wake\n" /* expects old value in %edx */
 		     "1:\n\t"
 		     "# ending __up_write\n"
 		     : "+m" (sem->count), "=d" (tmp)
_

Patches currently in -mm which might be from walken@google.com are

x86-rwsem-stay-on-fast-path-when-count0-in-__up_write.patch
x86-rwsem-minor-cleanups.patch
rwsem-fully-separate-code-pathes-to-wake-writers-vs-readers.patch
rwsem-lighter-active-count-checks-when-waking-up-readers.patch
rwsem-let-rwsem_waiting_bias-represent-any-number-of-waiting-threads.patch
rwsem-wake-queued-readers-when-writer-blocks-on-active-read-lock.patch
rwsem-smaller-wrappers-around-rwsem_down_failed_common.patch

