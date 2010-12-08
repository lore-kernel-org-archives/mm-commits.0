From: akpm@linux-foundation.org
Subject: + x86-rwsem-more-precise-rwsem_is_contended-implementation.patch added to -mm tree
Date: Wed, 08 Dec 2010 15:42:45 -0800
Message-ID: <201012082342.oB8NgkKa016607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754208Ab0LHXnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2010 18:43:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, hpa@zytor.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, npiggin@kernel.dk, peterz@infradead.org, riel@redhat.com, tglx@linutronix.de


The patch titled
     x86 rwsem: more precise rwsem_is_contended() implementation
has been added to the -mm tree.  Its filename is
     x86-rwsem-more-precise-rwsem_is_contended-implementation.patch

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
Subject: x86 rwsem: more precise rwsem_is_contended() implementation
From: Michel Lespinasse <walken@google.com>

We would like rwsem_is_contended() to return true only once a contending
writer has had a chance to insert itself onto the rwsem wait queue.  To
that end, we need to differenciate between active and queued writers.

A new property is introduced: RWSEM_ACTIVE_WRITE_BIAS is set to be 'more
negative' than RWSEM_WAITING_BIAS.  RWSEM_WAITING_MASK designates a bit in
the rwsem count that will be set only when RWSEM_WAITING_BIAS is in
effect.

The basic properties that have been true so far also still hold:
- RWSEM_ACTIVE_READ_BIAS  & RWSEM_ACTIVE_MASK == 1
- RWSEM_ACTIVE_WRITE_BIAS & RWSEM_ACTIVE_MASK == 1
- RWSEM_WAITING_BIAS      & RWSEM_ACTIVE_MASK == 0
- RWSEM_ACTIVE_WRITE_BIAS < 0 and RWSEM_WAITING_BIAS < 0

In addition, the rwsem count will be < RWSEM_WAITING_BIAS only if there
are any active writers (though we don't make use of this property so far).

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/rwsem.h |   32 +++++++++++++++++++-------------
 arch/x86/lib/rwsem_64.S      |    4 ++--
 arch/x86/lib/semaphore_32.S  |    4 ++--
 3 files changed, 23 insertions(+), 17 deletions(-)

diff -puN arch/x86/include/asm/rwsem.h~x86-rwsem-more-precise-rwsem_is_contended-implementation arch/x86/include/asm/rwsem.h
--- a/arch/x86/include/asm/rwsem.h~x86-rwsem-more-precise-rwsem_is_contended-implementation
+++ a/arch/x86/include/asm/rwsem.h
@@ -16,11 +16,10 @@
  * if there are writers (and maybe) readers waiting (in which case it goes to
  * sleep).
  *
- * The value of WAITING_BIAS supports up to 32766 waiting processes. This can
- * be extended to 65534 by manually checking the whole MSW rather than relying
- * on the S flag.
+ * The WRITE_BIAS value supports up to 32767 processes simultaneously
+ * trying to acquire a write lock.
  *
- * The value of ACTIVE_BIAS supports up to 65535 active processes.
+ * The value of ACTIVE_MASK supports up to 32767 active processes.
  *
  * This should be totally fair - if anything is waiting, a process that wants a
  * lock will go to the back of the queue. When the currently active lock is
@@ -62,17 +61,23 @@ extern asmregparm struct rw_semaphore *
  * for 64 bits.
  */
 
+
 #ifdef CONFIG_X86_64
-# define RWSEM_ACTIVE_MASK		0xffffffffL
+# define RWSEM_UNLOCKED_VALUE		0x0000000000000000L
+# define RWSEM_ACTIVE_MASK		0x000000007fffffffL
+# define RWSEM_ACTIVE_READ_BIAS		0x0000000000000001L
+# define RWSEM_ACTIVE_WRITE_BIAS	0xffffffff00000001L
+# define RWSEM_WAITING_BIAS		0xffffffff80000000L
+# define RWSEM_WAITING_MASK		0x0000000080000000L
 #else
-# define RWSEM_ACTIVE_MASK		0x0000ffffL
+# define RWSEM_UNLOCKED_VALUE		0x00000000L
+# define RWSEM_ACTIVE_MASK		0x00007fffL
+# define RWSEM_ACTIVE_READ_BIAS		0x00000001L
+# define RWSEM_ACTIVE_WRITE_BIAS	0xffff0001L
+# define RWSEM_WAITING_BIAS		0xffff8000L
+# define RWSEM_WAITING_MASK		0x00008000L
 #endif
 
-#define RWSEM_UNLOCKED_VALUE		0x00000000L
-#define RWSEM_ACTIVE_BIAS		0x00000001L
-#define RWSEM_WAITING_BIAS		(-RWSEM_ACTIVE_MASK-1)
-#define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
-#define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
 typedef signed long rwsem_count_t;
 
@@ -240,7 +245,8 @@ static inline void __downgrade_write(str
 		     "1:\n\t"
 		     "# ending __downgrade_write\n"
 		     : "+m" (sem->count)
-		     : "a" (sem), "er" (-RWSEM_WAITING_BIAS)
+		     : "a" (sem),
+		       "er" (RWSEM_ACTIVE_READ_BIAS - RWSEM_ACTIVE_WRITE_BIAS)
 		     : "memory", "cc");
 }
 
@@ -277,7 +283,7 @@ static inline int rwsem_is_locked(struct
 
 static inline int rwsem_is_contended(struct rw_semaphore *sem)
 {
-	return (sem->count < 0);
+	return (sem->count & RWSEM_WAITING_MASK) != 0;
 }
 
 #endif /* __KERNEL__ */
diff -puN arch/x86/lib/rwsem_64.S~x86-rwsem-more-precise-rwsem_is_contended-implementation arch/x86/lib/rwsem_64.S
--- a/arch/x86/lib/rwsem_64.S~x86-rwsem-more-precise-rwsem_is_contended-implementation
+++ a/arch/x86/lib/rwsem_64.S
@@ -60,8 +60,8 @@ ENTRY(call_rwsem_down_write_failed)
 	ENDPROC(call_rwsem_down_write_failed)
 
 ENTRY(call_rwsem_wake)
-	decl %edx	/* do nothing if still outstanding active readers */
-	jnz 1f
+	cmpl $0x80000001, %edx
+	jne 1f	/* do nothing unless there are waiters and no active threads */
 	save_common_regs
 	movq %rax,%rdi
 	call rwsem_wake
diff -puN arch/x86/lib/semaphore_32.S~x86-rwsem-more-precise-rwsem_is_contended-implementation arch/x86/lib/semaphore_32.S
--- a/arch/x86/lib/semaphore_32.S~x86-rwsem-more-precise-rwsem_is_contended-implementation
+++ a/arch/x86/lib/semaphore_32.S
@@ -103,8 +103,8 @@ ENTRY(call_rwsem_down_write_failed)
 
 ENTRY(call_rwsem_wake)
 	CFI_STARTPROC
-	decw %dx    /* do nothing if still outstanding active readers */
-	jnz 1f
+	cmpw $0x8001, %dx
+	jne 1f	/* do nothing unless there are waiters and no active threads */
 	push %ecx
 	CFI_ADJUST_CFA_OFFSET 4
 	CFI_REL_OFFSET ecx,0
_

Patches currently in -mm which might be from walken@google.com are

do_wp_page-remove-the-reuse-flag.patch
do_wp_page-clarify-dirty_page-handling.patch
mlock-avoid-dirtying-pages-and-triggering-writeback.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
mm-add-foll_mlock-follow_page-flag.patch
mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch
rwsem-implement-rwsem_is_contended.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
x86-rwsem-more-precise-rwsem_is_contended-implementation.patch

