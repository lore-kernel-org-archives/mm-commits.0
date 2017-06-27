From: akpm@linux-foundation.org
Subject: + sh-mark-end-of-bug-implementation-as-unreachable.patch added to -mm tree
Date: Tue, 27 Jun 2017 13:03:23 -0700
Message-ID: <5952ba0b.rzEDEJZuFQjvEtLV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47712 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752646AbdF0UDY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jun 2017 16:03:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, dalias@libc.org, danielmicay@gmail.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: mark end of BUG() implementation as unreachable
has been added to the -mm tree.  Its filename is
     sh-mark-end-of-bug-implementation-as-unreachable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-mark-end-of-bug-implementation-as-unreachable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-mark-end-of-bug-implementation-as-unreachable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: sh: mark end of BUG() implementation as unreachable

When building the sh architecture, the compiler doesn't realize that
BUG() doesn't return, so it will complain about functions using BUG()
that are marked with the noreturn attribute:

   lib/string.c: In function 'fortify_panic':
>> lib/string.c:986:1: warning: 'noreturn' function does return
    }
    ^

Link: http://lkml.kernel.org/r/20170627192050.GA66784@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/bug.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/sh/include/asm/bug.h~sh-mark-end-of-bug-implementation-as-unreachable arch/sh/include/asm/bug.h
--- a/arch/sh/include/asm/bug.h~sh-mark-end-of-bug-implementation-as-unreachable
+++ a/arch/sh/include/asm/bug.h
@@ -48,6 +48,7 @@ do {							\
 		   "i" (__FILE__),			\
 		   "i" (__LINE__), "i" (0),		\
 		   "i" (sizeof(struct bug_entry)));	\
+	unreachable();					\
 } while (0)
 
 #define __WARN_FLAGS(flags)				\
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-allow-slab_nomerge-to-be-set-at-build-time.patch
binfmt_elf-use-elf_et_dyn_base-only-for-pie.patch
arm-reduce-elf_et_dyn_base.patch
arm64-move-elf_et_dyn_base-to-4gb-4mb.patch
powerpc-reduce-elf_et_dyn_base.patch
s390-reduce-elf_et_dyn_base.patch
binfmt_elf-safely-increment-argv-pointers.patch
ipc-drop-non-rcu-allocation.patch
ipc-sem-do-not-use-ipc_rcu_free.patch
ipc-shm-do-not-use-ipc_rcu_free.patch
ipc-msg-do-not-use-ipc_rcu_free.patch
ipc-util-drop-ipc_rcu_free.patch
ipc-sem-avoid-ipc_rcu_alloc.patch
ipc-shm-avoid-ipc_rcu_alloc.patch
ipc-msg-avoid-ipc_rcu_alloc.patch
ipc-util-drop-ipc_rcu_alloc.patch
ipc-move-atomic_set-to-where-it-is-needed.patch
ipc-shm-remove-special-shm_alloc-free.patch
ipc-msg-remove-special-msg_alloc-free.patch
ipc-sem-drop-__sem_free.patch
efi-avoid-fortify-checks-in-efi-stub.patch
kexec_file-adjust-declaration-of-kexec_purgatory.patch
ib-rxe-do-not-copy-extra-stack-memory-to-skb.patch
sh-mark-end-of-bug-implementation-as-unreachable.patch

