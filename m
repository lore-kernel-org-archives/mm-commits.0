From: akpm@linux-foundation.org
Subject: + random-do-not-ignore-early-device-randomness.patch added to -mm tree
Date: Tue, 27 Jun 2017 13:55:35 -0700
Message-ID: <5952c647.vPEqYBwOivWkxtTi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54684 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753628AbdF0Uzq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jun 2017 16:55:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, arnd@arndb.de, gregkh@linuxfoundation.org, jeyu@redhat.com, lokeshvutla@ti.com, mingo@kernel.org, npiggin@gmail.com, prarit@redhat.com, rostedt@goodmis.org, takahiro.akashi@linaro.org, tj@kernel.org, tytso@mit.edu, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: random: do not ignore early device randomness
has been added to the -mm tree.  Its filename is
     random-do-not-ignore-early-device-randomness.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/random-do-not-ignore-early-device-randomness.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/random-do-not-ignore-early-device-randomness.patch

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
Subject: random: do not ignore early device randomness

The add_device_randomness() function would ignore incoming bytes if the
crng wasn't ready.  This additionally makes sure to make an early enough
call to add_latent_entropy() to influence the initial stack canary, which
is especially important on non-x86 systems where it stays the same through
the life of the boot.

Link: http://lkml.kernel.org/r/20170626233038.GA48751@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    5 +++++
 init/main.c           |    1 +
 2 files changed, 6 insertions(+)

diff -puN drivers/char/random.c~random-do-not-ignore-early-device-randomness drivers/char/random.c
--- a/drivers/char/random.c~random-do-not-ignore-early-device-randomness
+++ a/drivers/char/random.c
@@ -987,6 +987,11 @@ void add_device_randomness(const void *b
 	unsigned long time = random_get_entropy() ^ jiffies;
 	unsigned long flags;
 
+	if (!crng_ready()) {
+		crng_fast_load(buf, size);
+		return;
+	}
+
 	trace_add_device_randomness(size, _RET_IP_);
 	spin_lock_irqsave(&input_pool.lock, flags);
 	_mix_pool_bytes(&input_pool, buf, size);
diff -puN init/main.c~random-do-not-ignore-early-device-randomness init/main.c
--- a/init/main.c~random-do-not-ignore-early-device-randomness
+++ a/init/main.c
@@ -497,6 +497,7 @@ asmlinkage __visible void __init start_k
 	/*
 	 * Set up the initial canary ASAP:
 	 */
+	add_latent_entropy();
 	boot_init_stack_canary();
 
 	cgroup_init_early();
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-allow-slab_nomerge-to-be-set-at-build-time.patch
binfmt_elf-use-elf_et_dyn_base-only-for-pie.patch
arm-reduce-elf_et_dyn_base.patch
arm64-move-elf_et_dyn_base-to-4gb-4mb.patch
powerpc-reduce-elf_et_dyn_base.patch
s390-reduce-elf_et_dyn_base.patch
binfmt_elf-safely-increment-argv-pointers.patch
random-do-not-ignore-early-device-randomness.patch
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

