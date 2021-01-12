Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51CBC433DB
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 04:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88A772250E
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 04:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbhALEpL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Jan 2021 23:45:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbhALEpL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 Jan 2021 23:45:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFCB0221FE;
        Tue, 12 Jan 2021 04:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610426670;
        bh=0a5qFY+piFgjgN34NTX7TduVx5rNUDeiVu5yXkvU0xQ=;
        h=Date:From:To:Subject:From;
        b=Nv4BWVKOryhMHMBnNsnd025XswQT39GXEFR1/MpN7WePdQjnWsw6ORlmyHopjS+bw
         GUbPpeo5DjQ1lfTWfKttQSE8+pEHYKlWkLYiBe5OwklZIZLpbXGfWCTJ3WZiZounMR
         +wnLv6sq/Ou0GXWDu3u7X3wBUV+GOT8deJKq+5Vs=
Date:   Mon, 11 Jan 2021 20:44:29 -0800
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, joern@purestorage.com, mm-commits@vger.kernel.org
Subject:  + mm-add-kernel-electric-fence-infrastructure-fix-4.patch
 added to -mm tree
Message-ID: <20210112044429.MTNAMZNnF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: add option to use KFENCE without static keys
has been added to the -mm tree.  Its filename is
     mm-add-kernel-electric-fence-infrastructure-fix-4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-kernel-electric-fence-=
infrastructure-fix-4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-kernel-electric-fence-=
infrastructure-fix-4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Marco Elver <elver@google.com>
Subject: kfence: add option to use KFENCE without static keys

For certain usecases, specifically where the sample interval is always
set to a very low value such as 1ms, it can make sense to use a dynamic
branch instead of static branches due to the overhead of toggling a
static branch.

Therefore, add a new Kconfig option to remove the static branches and
instead check kfence_allocation_gate if a KFENCE allocation should be
set up.

Link: https://lkml.kernel.org/r/20210111091544.3287013-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Suggested-by: J=C3=B6rn Engel <joern@purestorage.com>
Reviewed-by: J=C3=B6rn Engel <joern@purestorage.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfence.h |   11 ++++++++++-
 lib/Kconfig.kfence     |   12 +++++++++++-
 mm/kfence/core.c       |   30 +++++++++++++++++-------------
 3 files changed, 38 insertions(+), 15 deletions(-)

--- a/include/linux/kfence.h~mm-add-kernel-electric-fence-infrastructure-fi=
x-4
+++ a/include/linux/kfence.h
@@ -4,7 +4,6 @@
 #define _LINUX_KFENCE_H
=20
 #include <linux/mm.h>
-#include <linux/static_key.h>
 #include <linux/types.h>
=20
 #ifdef CONFIG_KFENCE
@@ -17,7 +16,13 @@
 #define KFENCE_POOL_SIZE ((CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 * PAGE_SIZE)
 extern char *__kfence_pool;
=20
+#ifdef CONFIG_KFENCE_STATIC_KEYS
+#include <linux/static_key.h>
 DECLARE_STATIC_KEY_FALSE(kfence_allocation_key);
+#else
+#include <linux/atomic.h>
+extern atomic_t kfence_allocation_gate;
+#endif
=20
 /**
  * is_kfence_address() - check if an address belongs to KFENCE pool
@@ -104,7 +109,11 @@ void *__kfence_alloc(struct kmem_cache *
  */
 static __always_inline void *kfence_alloc(struct kmem_cache *s, size_t siz=
e, gfp_t flags)
 {
+#ifdef CONFIG_KFENCE_STATIC_KEYS
 	if (static_branch_unlikely(&kfence_allocation_key))
+#else
+	if (unlikely(!atomic_read(&kfence_allocation_gate)))
+#endif
 		return __kfence_alloc(s, size, flags);
 	return NULL;
 }
--- a/lib/Kconfig.kfence~mm-add-kernel-electric-fence-infrastructure-fix-4
+++ a/lib/Kconfig.kfence
@@ -6,7 +6,6 @@ config HAVE_ARCH_KFENCE
 menuconfig KFENCE
 	bool "KFENCE: low-overhead sampling-based memory safety error detector"
 	depends on HAVE_ARCH_KFENCE && !KASAN && (SLAB || SLUB)
-	depends on JUMP_LABEL # To ensure performance, require jump labels
 	select STACKTRACE
 	help
 	  KFENCE is a low-overhead sampling-based detector of heap out-of-bounds
@@ -23,6 +22,17 @@ menuconfig KFENCE
=20
 if KFENCE
=20
+config KFENCE_STATIC_KEYS
+	bool "Use static keys to set up allocations"
+	default y
+	depends on JUMP_LABEL # To ensure performance, require jump labels
+	help
+	  Use static keys (static branches) to set up KFENCE allocations. Using
+	  static keys is normally recommended, because it avoids a dynamic
+	  branch in the allocator's fast path. However, with very low sample
+	  intervals, or on systems that do not support jump labels, a dynamic
+	  branch may still be an acceptable performance trade-off.
+
 config KFENCE_SAMPLE_INTERVAL
 	int "Default sample interval in milliseconds"
 	default 100
--- a/mm/kfence/core.c~mm-add-kernel-electric-fence-infrastructure-fix-4
+++ a/mm/kfence/core.c
@@ -88,11 +88,13 @@ struct kfence_metadata kfence_metadata[C
 static struct list_head kfence_freelist =3D LIST_HEAD_INIT(kfence_freelist=
);
 static DEFINE_RAW_SPINLOCK(kfence_freelist_lock); /* Lock protecting freel=
ist. */
=20
+#ifdef CONFIG_KFENCE_STATIC_KEYS
 /* The static key to set up a KFENCE allocation. */
 DEFINE_STATIC_KEY_FALSE(kfence_allocation_key);
+#endif
=20
 /* Gates the allocation, ensuring only one succeeds in a given period. */
-static atomic_t allocation_gate =3D ATOMIC_INIT(1);
+atomic_t kfence_allocation_gate =3D ATOMIC_INIT(1);
=20
 /* Statistics counters for debugfs. */
 enum kfence_counter_id {
@@ -579,29 +581,31 @@ late_initcall(kfence_debugfs_init);
 static struct delayed_work kfence_timer;
 static void toggle_allocation_gate(struct work_struct *work)
 {
-	unsigned long end_wait;
-
 	if (!READ_ONCE(kfence_enabled))
 		return;
=20
 	/* Enable static key, and await allocation to happen. */
-	atomic_set(&allocation_gate, 0);
+	atomic_set(&kfence_allocation_gate, 0);
+#ifdef CONFIG_KFENCE_STATIC_KEYS
 	static_branch_enable(&kfence_allocation_key);
 	/*
 	 * Await an allocation. Timeout after 1 second, in case the kernel stops
 	 * doing allocations, to avoid stalling this worker task for too long.
 	 */
-	end_wait =3D jiffies + HZ;
-	do {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (atomic_read(&allocation_gate) !=3D 0)
-			break;
-		schedule_timeout(1);
-	} while (time_before(jiffies, end_wait));
-	__set_current_state(TASK_RUNNING);
+	{
+		unsigned long end_wait =3D jiffies + HZ;
=20
+		do {
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			if (atomic_read(&kfence_allocation_gate) !=3D 0)
+				break;
+			schedule_timeout(1);
+		} while (time_before(jiffies, end_wait));
+		__set_current_state(TASK_RUNNING);
+	}
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
+#endif
 	schedule_delayed_work(&kfence_timer, msecs_to_jiffies(kfence_sample_inter=
val));
 }
 static DECLARE_DELAYED_WORK(kfence_timer, toggle_allocation_gate);
@@ -707,7 +711,7 @@ void *__kfence_alloc(struct kmem_cache *
 	 * sense to continue writing to it and pay the associated contention
 	 * cost, in case we have a large number of concurrent allocations.
 	 */
-	if (atomic_read(&allocation_gate) || atomic_inc_return(&allocation_gate) =
> 1)
+	if (atomic_read(&kfence_allocation_gate) || atomic_inc_return(&kfence_all=
ocation_gate) > 1)
 		return NULL;
=20
 	if (!READ_ONCE(kfence_enabled))
_

Patches currently in -mm which might be from elver@google.com are

mm-add-kernel-electric-fence-infrastructure-fix.patch
mm-add-kernel-electric-fence-infrastructure-fix-2.patch
mm-add-kernel-electric-fence-infrastructure-fix-3.patch
mm-add-kernel-electric-fence-infrastructure-fix-4.patch
arm64-kfence-enable-kfence-for-arm64.patch
kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
kfence-documentation-add-kfence-documentation.patch
kfence-add-test-suite.patch
kfence-add-test-suite-fix.patch
kfence-add-test-suite-fix-2.patch
maintainers-add-entry-for-kfence.patch

