Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794536017;
	b=J/U6xTvVLFzC/wHH0QaeEIuBwzJiO+tD7PoHAhgMyqqylUi2KF3P/cmaukdBGeyOqP0w
	 QjssMM4KAkWqLgkhHtaiieUe4JNO+tIx0ZNl1AwCmrdTva9l+Xh8Ho9lgKk06G9+0stNW
	 tRWD2RG//4aXoZiOtUWliu+9bkwjPjg5JlpWUq1OR5LZ7WqjeZ0Eac6DtrMIMWq6/qSJq
	 yB7YaYWqSdElS93/PQpKY6+kFabfPx0tWyqp0JcqnayPm6PPCWiwM3fxrQU+xJ7XHom7z
	 pru4Y96ljBpwNF6/xTDkLoSNIbaBOOgPs+l38RPTLMDC7M/y/tj+jmaYitGc9SmdEYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794536017;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=oBY3y5RjDIBrX1m3hjvOdmHrn7ZpwcQ38YV+JtQgn4c=;
	b=ApCRIQBxNJ32WJZWgY57yeLgCJDXW+/McwHcrz+ZfchP73MPLQeQBlPzpVvQW2dsoxK+
	 l+xcRJlZH+ekp/XtdMBL7cR4X0b03lDhEfUQJGXo1sZ8W9XPxwuPhUY0bS1trhWpCxD/C
	 cxcNI183eJacF7LlvXnEVXiaT1+gSCPcgCLMWsvYEyi0O93SPIB4fsA73UhwTxwO++sJm
	 Olm/5DM5tofEUzeAwF52kgPXe6KHFySwZS6TXTlezfphT7q3PuHc343EwwfGnLRJVhNmD
	 ArdJ4UDc3u0IxV7K0mSfppBunHKiJaeTTeiq+g6lWNB1J1gRqMGHFX5sKZwJdVAcc/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vjE1uLCA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6CE606A31C
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 02:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vjE1uLCA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B9B1F000C4;
	Fri, 13 Nov 2026 02:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794536017;
	bh=oBY3y5RjDIBrX1m3hjvOdmHrn7ZpwcQ38YV+JtQgn4c=;
	h=Date:To:From:Subject;
	b=vjE1uLCAGkbgbapyzWEw7Nw33zDyScuW6quFqzRwmqUVBSOSXfS0UKdoIAFh0w18h
	 SCxvb43AGDv0no1vZwJOrehv68+smUuO4W51YsQThV335P1jOvLFQsOIFYviY9Mk9M
	 81QuDlaJKKKbdNAeXZJ0fy5ec7wLBxnayw8jaWlc=
Date: Thu, 12 Nov 2026 18:13:36 -0800
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,
	akinobu.mita@gmail.com,ekffu200098@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-inject-use-a-shared-initialization-helper-for-the-random-state.patch added to mm-nonmm-unstable branch
Message-Id: <20261113021337.54B9B1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fault-inject: use a shared initialization helper for the random state
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-inject-use-a-shared-initialization-helper-for-the-random-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-inject-use-a-shared-initialization-helper-for-the-random-state.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: fault-inject: use a shared initialization helper for the random state
Date: Thu, 12 Nov 2026 23:46:34 +0900

fault_rnd_state can be seeded from setup_fault_attr(),
fault_create_debugfs_attr() and fault_config_init(), and each of them uses
its own guard.  Configuring fault injection in more than one way leads to
useless reseeding.

To prevent this, use a shared initialization helper fault_random_init()
in all three places. So fault_rnd_state is seeded only once per boot.

Link: https://lore.kernel.org/20261112144636.840042-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
---

 lib/fault-inject.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/lib/fault-inject.c~fault-inject-use-a-shared-initialization-helper-for-the-random-state
+++ a/lib/fault-inject.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/once_lite.h>
 #include <linux/prandom.h>
 #include <linux/debugfs.h>
 #include <linux/sched.h>
@@ -13,12 +12,25 @@
 #include <linux/interrupt.h>
 #include <linux/stacktrace.h>
 #include <linux/fault-inject.h>
+#include <linux/spinlock.h>
 
 /*
  * The should_fail() functions use prandom instead of the normal Linux RNG
  * since they don't need cryptographically secure random numbers.
  */
 static DEFINE_PER_CPU(struct rnd_state, fault_rnd_state);
+static DEFINE_SPINLOCK(fault_rnd_lock);
+static bool fault_rnd_initialized;
+
+static void fault_random_init(void)
+{
+	spin_lock(&fault_rnd_lock);
+	if (!fault_rnd_initialized) {
+		prandom_seed_full_state(&fault_rnd_state);
+		fault_rnd_initialized = true;
+	}
+	spin_unlock(&fault_rnd_lock);
+}
 
 static u32 fault_prandom_u32_below_100(void)
 {
@@ -51,12 +63,7 @@ int setup_fault_attr(struct fault_attr *
 		return 0;
 	}
 
-	/*
-	 * __setup handlers run before slab and workqueues are initialized,
-	 * but prandom_init_once() calls kmalloc() and schedule_work(). So use
-	 * DO_ONCE_LITE() instead.
-	 */
-	DO_ONCE_LITE(prandom_seed_full_state, &fault_rnd_state);
+	fault_random_init();
 
 	attr->probability = probability;
 	attr->interval = interval;
@@ -246,7 +253,7 @@ struct dentry *fault_create_debugfs_attr
 	if (IS_ERR(dir))
 		return dir;
 
-	prandom_init_once(&fault_rnd_state);
+	fault_random_init();
 
 	debugfs_create_ul("probability", mode, dir, &attr->probability);
 	debugfs_create_ul("interval", mode, dir, &attr->interval);
@@ -462,7 +469,7 @@ static const struct config_item_type fau
 
 void fault_config_init(struct fault_config *config, const char *name)
 {
-	prandom_init_once(&fault_rnd_state);
+	fault_random_init();
 
 	config_group_init_type_name(&config->group, name, &fault_config_type);
 }
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch
mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed.patch
mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed.patch
fault-inject-fix-boot-failure-with-fault-injection-boot-parameters.patch
fault-inject-use-a-shared-initialization-helper-for-the-random-state.patch

