From: akpm@linux-foundation.org
Subject: +
 completion-avoid-unnecessary-stack-allocation-for-completion_initializer_onstack.patch added to -mm tree
Date: Wed, 23 Aug 2017 15:04:44 -0700
Message-ID: <599dfbfc.Ad2FPlHfagyVAcD5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdHWWEq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2017 18:04:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boqun.feng@gmail.com, arnd@arndb.de, byungchul.park@lge.com, dan.j.williams@intel.com, mingo@kernel.org, npiggin@gmail.com, peterz@infradead.org, rjw@rjwysocki.net, tglx@linutronix.de, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/completion.h: avoid unnecessary stack allocation for COMPLETION_INITIALIZER_ONSTACK()
has been added to the -mm tree.  Its filename is
     completion-avoid-unnecessary-stack-allocation-for-completion_initializer_onstack.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/completion-avoid-unnecessary-stack-allocation-for-completion_initializer_onstack.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/completion-avoid-unnecessary-stack-allocation-for-completion_initializer_onstack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Boqun Feng <boqun.feng@gmail.com>
Subject: include/linux/completion.h: avoid unnecessary stack allocation for COMPLETION_INITIALIZER_ONSTACK()

In theory, COMPLETION_INITIALIZER_ONSTACK() should never affect the
stack allocation of the caller. However, on some compilers, a temporary
structure was allocated for the return value of
COMPLETION_INITIALIZER_ONSTACK(), for example in write_journal() with
LOCKDEP_COMPLETIONS=y(gcc is 7.1.1):

	io_comp.comp = COMPLETION_INITIALIZER_ONSTACK(io_comp.comp);
	    2462:       e8 00 00 00 00          callq  2467 <write_journal+0x47>
	    2467:       48 8d 85 80 fd ff ff    lea    -0x280(%rbp),%rax
	    246e:       48 c7 c6 00 00 00 00    mov    $0x0,%rsi
	    2475:       48 c7 c2 00 00 00 00    mov    $0x0,%rdx
		x->done = 0;
	    247c:       c7 85 90 fd ff ff 00    movl   $0x0,-0x270(%rbp)
	    2483:       00 00 00
		init_waitqueue_head(&x->wait);
	    2486:       48 8d 78 18             lea    0x18(%rax),%rdi
	    248a:       e8 00 00 00 00          callq  248f <write_journal+0x6f>
		if (commit_start + commit_sections <= ic->journal_sections) {
	    248f:       41 8b 87 a8 00 00 00    mov    0xa8(%r15),%eax
		io_comp.comp = COMPLETION_INITIALIZER_ONSTACK(io_comp.comp);
	    2496:       48 8d bd e8 f9 ff ff    lea    -0x618(%rbp),%rdi
	    249d:       48 8d b5 90 fd ff ff    lea    -0x270(%rbp),%rsi
	    24a4:       b9 17 00 00 00          mov    $0x17,%ecx
	    24a9:       f3 48 a5                rep movsq %ds:(%rsi),%es:(%rdi)
		if (commit_start + commit_sections <= ic->journal_sections) {
	    24ac:       41 39 c6                cmp    %eax,%r14d
		io_comp.comp = COMPLETION_INITIALIZER_ONSTACK(io_comp.comp);
	    24af:       48 8d bd 90 fd ff ff    lea    -0x270(%rbp),%rdi
	    24b6:       48 8d b5 e8 f9 ff ff    lea    -0x618(%rbp),%rsi
	    24bd:       b9 17 00 00 00          mov    $0x17,%ecx
	    24c2:       f3 48 a5                rep movsq %ds:(%rsi),%es:(%rdi)

We can obviously see the temporary structure allocated, and the compiler
also does two meaningless memcpy with "rep movsq".

And according to:

	https://gcc.gnu.org/onlinedocs/gcc/Statement-Exprs.html#Statement-Exprs

The return value of a statement expression is returned by value, so the
temporary variable is created in COMPLETION_INITIALIZER_ONSTACK(), and
that's why the temporary structures are allocted.

To fix this, make the brace block in COMPLETION_INITIALIZER_ONSTACK()
return a pointer and dereference it outside the block rather than return
the whole structure, in this way, we are able to teach the compiler not
to do the unnecessary stack allocation.

This could also reduce the stack size even if !LOCKDEP, for example in
write_journal(), compiled with gcc 7.1.1, the result of command:

	 objdump -d drivers/md/dm-integrity.o | ./scripts/checkstack.pl x86

before:

	0x0000246a write_journal [dm-integrity.o]:              696

after:

	0x00002b7a write_journal [dm-integrity.o]:              296

Link: http://lkml.kernel.org/r/20170823152542.5150-3-boqun.feng@gmail.com
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Byungchul Park <byungchul.park@lge.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/completion.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/completion.h~completion-avoid-unnecessary-stack-allocation-for-completion_initializer_onstack include/linux/completion.h
--- a/include/linux/completion.h~completion-avoid-unnecessary-stack-allocation-for-completion_initializer_onstack
+++ a/include/linux/completion.h
@@ -74,7 +74,7 @@ static inline void complete_release_comm
 #endif
 
 #define COMPLETION_INITIALIZER_ONSTACK(work) \
-	({ init_completion(&work); work; })
+	(*({ init_completion(&work); &work; }))
 
 /**
  * DECLARE_COMPLETION - declare and initialize a completion structure
_

Patches currently in -mm which might be from boqun.feng@gmail.com are

nfit-use-init_completion-in-acpi_nfit_flush_probe.patch
completion-avoid-unnecessary-stack-allocation-for-completion_initializer_onstack.patch

