From: akpm@linux-foundation.org
Subject: + um-fix-irq-flag-handling-naming.patch added to -mm tree
Date: Mon, 25 Oct 2010 12:29:50 -0700
Message-ID: <201010251929.o9PJTobQ012059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759554Ab0JYTaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 15:30:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, dhowells@redhat.com, jdike@addtoit.com


The patch titled
     um: fix IRQ flag handling naming
has been added to the -mm tree.  Its filename is
     um-fix-irq-flag-handling-naming.patch

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
Subject: um: fix IRQ flag handling naming
From: Richard Weinberger <richard@nod.at>

Commit df9ee292 ("Fix IRQ flag handling naming") changed the IRQ flag
handling naming scheme and broke UML:

In file included from /usr/src/25/arch/um/include/asm/fixmap.h:5,
                 from /usr/src/25/arch/um/include/shared/um_uaccess.h:10,
                 from /usr/src/25/arch/um/include/asm/uaccess.h:41,
                 from /usr/src/25/arch/um/include/asm/thread_info.h:13,
                 from include/linux/thread_info.h:56,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from init/main.c:13:
/usr/src/25/arch/um/include/asm/system.h:11:1: warning: "local_save_flags" redefined

This patch brings the new scheme to UML and makes it work again.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: David Howells <dhowells@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/system.h |   49 +++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff -puN arch/um/include/asm/system.h~um-fix-irq-flag-handling-naming arch/um/include/asm/system.h
--- a/arch/um/include/asm/system.h~um-fix-irq-flag-handling-naming
+++ a/arch/um/include/asm/system.h
@@ -8,23 +8,38 @@ extern int set_signals(int enable);
 extern void block_signals(void);
 extern void unblock_signals(void);
 
-#define local_save_flags(flags) do { typecheck(unsigned long, flags); \
-				     (flags) = get_signals(); } while(0)
-#define local_irq_restore(flags) do { typecheck(unsigned long, flags); \
-				      set_signals(flags); } while(0)
-
-#define local_irq_save(flags) do { local_save_flags(flags); \
-                                   local_irq_disable(); } while(0)
-
-#define local_irq_enable() unblock_signals()
-#define local_irq_disable() block_signals()
-
-#define irqs_disabled()                 \
-({                                      \
-        unsigned long flags;            \
-        local_save_flags(flags);        \
-        (flags == 0);                   \
-})
+static inline unsigned long arch_local_save_flags(void)
+{
+	return get_signals();
+}
+
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	set_signals(flags);
+}
+
+static inline void arch_local_irq_enable(void)
+{
+	unblock_signals();
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	block_signals();
+}
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags;
+	flags = arch_local_save_flags();
+	arch_local_irq_disable();
+	return flags;
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_local_save_flags() == 0;
+}
 
 extern void *_switch_to(void *prev, void *next, void *last);
 #define switch_to(prev, next, last) prev = _switch_to(prev, next, last)
_

Patches currently in -mm which might be from richard@nod.at are

um-fix-global-timer-issue-when-using-config_no_hz.patch
um-remove-page_size-alignment-in-linker-script-causing-kernel-segfault.patch
hostfs-fix-uml-crash-remove-f_spare-from-hostfs.patch
um-fix-irq-flag-handling-naming.patch
um-migrate-from-__do_irq-to-generic_handle_irq.patch
hostfs-trivial-code-cleanup.patch

