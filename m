From: akpm@linux-foundation.org
Subject: [patch 21/96] random: do not ignore early device
 randomness
Date: Wed, 12 Jul 2017 14:34:04 -0700
Message-ID: <20170712213404.Vp910VqTY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53334 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754439AbdGLVeF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:34:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, gregkh@linuxfoundation.org, jeyu@redhat.com, keescook@chromium.org, lokeshvutla@ti.com, mingo@kernel.org, mm-commits@vger.kernel.org, npiggin@gmail.com, prarit@redhat.com, rostedt@goodmis.org, takahiro.akashi@linaro.org, tj@kernel.org, torvalds@linux-foundation.org, tytso@mit.edu, viresh.kumar@linaro.org

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
@@ -518,6 +518,7 @@ asmlinkage __visible void __init start_k
 	/*
 	 * Set up the initial canary ASAP:
 	 */
+	add_latent_entropy();
 	boot_init_stack_canary();
 
 	cgroup_init_early();
_
