From: akpm@linux-foundation.org
Subject: +
 include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix-2.patch added to -mm tree
Date: Tue, 27 Jun 2017 13:44:13 -0700
Message-ID: <5952c39d.URJ1D9KC4BKQAyM2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53950 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753511AbdF0Uo2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jun 2017 16:44:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, danielmicay@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fortify: avoid panic() in favor of BUG()
has been added to the -mm tree.  Its filename is
     include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix-2.patch

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
Subject: fortify: avoid panic() in favor of BUG()

Since detection of a given fortify failure is sufficient to stop the
memory corruption from happening, it doesn't make sense to unconditionally
bring down the entire system.  Instead, use BUG() which will stop the bad
thread of kernel execution (and only optionally panic the system).

Link: http://lkml.kernel.org/r/20170626235122.GA25261@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/string.c~include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix-2 lib/string.c
--- a/lib/string.c~include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix-2
+++ a/lib/string.c
@@ -981,6 +981,7 @@ EXPORT_SYMBOL(strreplace);
 
 void fortify_panic(const char *name)
 {
-	panic("detected buffer overflow in %s", name);
+	pr_emerg("detected buffer overflow in %s\n", name);
+	BUG();
 }
 EXPORT_SYMBOL(fortify_panic);
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
include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix-2.patch
sh-mark-end-of-bug-implementation-as-unreachable.patch

