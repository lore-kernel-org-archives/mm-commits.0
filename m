Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A291B2556E
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 02:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739846838; cv=none; b=VpEwyvvcgzJU/TBdZxaB6YfdulWmHFLcv6gLv695iSiADB0EAAUZl7Sx99MllRXX4y9niRvptJl5+xQGgP6dAoohGY8wEAYDxByVn720wmZgx+3EQoE88VRl/CCoTftLTXtcWE3dafvsP0rU2qd+gUgXEgYS3byVX6prXlv2vrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739846838; c=relaxed/simple;
	bh=eZI88JBvpiknMytDNGPujjjDSiKQfCHdfueCqrMCdaQ=;
	h=Date:To:From:Subject:Message-Id; b=PQrUN1JHyqcpYZelyS1w9yNUNORnOTHGzVvankrm23cEk54MbN5wE6nIGEK+rRXlbCH8lq1ErRnOMomHNZngkUoo/uQWGDxRRvM8jCCqXv68KyC4ErvKZ3rQmylXZhYcb6b0LXql09SRVbT1KSZS0GkXwLN3hZPmfzCFAI0ORdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EvvOlrgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EvvOlrgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C686CC4CED1;
	Tue, 18 Feb 2025 02:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739846836;
	bh=eZI88JBvpiknMytDNGPujjjDSiKQfCHdfueCqrMCdaQ=;
	h=Date:To:From:Subject:From;
	b=EvvOlrgEIrsiZsB3xRsHBNY4yxq5P9GJ6UMQc06wXmYDnpNs+Di4u6HLlJH6EvQvV
	 VOIvexsAywvSvnxK4uT6Gb1zVkXtldLqWcO3sxC9ECIyjuhKLSiIUSPEDuPaniDlRs
	 oeUylK/KfNyzpNq1ff2f72neMUIbcgMn/eMuYrTk=
Date: Mon, 17 Feb 2025 18:47:16 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,rostedt@goodmis.org,npache@redhat.com,glider@google.com,dvyukov@google.com,bigeasy@linutronix.de,andreyknvl@gmail.com,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-dont-call-find_vm_area-in-a-preempt_rt-kernel.patch added to mm-hotfixes-unstable branch
Message-Id: <20250218024716.C686CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: don't call find_vm_area() in a PREEMPT_RT kernel
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-dont-call-find_vm_area-in-a-preempt_rt-kernel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-dont-call-find_vm_area-in-a-preempt_rt-kernel.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: kasan: don't call find_vm_area() in a PREEMPT_RT kernel
Date: Mon, 17 Feb 2025 15:44:02 -0500

The following bug report was found when running a PREEMPT_RT debug kernel.

 BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
 in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 140605, name: kunit_try_catch
 preempt_count: 1, expected: 0

 Call trace:
  rt_spin_lock+0x70/0x140
  find_vmap_area+0x84/0x168
  find_vm_area+0x1c/0x50
  print_address_description.constprop.0+0x2a0/0x320
  print_report+0x108/0x1f8
  kasan_report+0x90/0xc8

Since commit e30a0361b851 ("kasan: make report_lock a raw spinlock"),
report_lock was changed to raw_spinlock_t to fix another similar
PREEMPT_RT problem.  That alone isn't enough to cover other corner cases.

print_address_description() is always invoked under the report_lock.  The
context under this lock is always atomic even on PREEMPT_RT. 
find_vm_area() acquires vmap_node::busy.lock which is a spinlock_t,
becoming a sleeping lock on PREEMPT_RT and must not be acquired in atomic
context.

Don't invoke find_vm_area() on PREEMPT_RT and just print the address. 
Non-PREEMPT_RT builds remain unchanged.  Add a DEFINE_WAIT_OVERRIDE_MAP()
macro to tell lockdep that this lock nesting is allowed because the
PREEMPT_RT part (which is invalid) has been taken care of.  This macro was
first introduced in commit 0cce06ba859a ("debugobjects,locking: Annotate
debug_object_fill_pool() wait type violation").

Link: https://lkml.kernel.org/r/20250217204402.60533-1-longman@redhat.com
Fixes: e30a0361b851 ("kasan: make report_lock a raw spinlock")
Signed-off-by: Waiman Long <longman@redhat.com>
Suggested-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mariano Pache <npache@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

--- a/mm/kasan/report.c~kasan-dont-call-find_vm_area-in-a-preempt_rt-kernel
+++ a/mm/kasan/report.c
@@ -370,6 +370,36 @@ static inline bool init_task_stack_addr(
 			sizeof(init_thread_union.stack));
 }
 
+/*
+ * This function is invoked with report_lock (a raw_spinlock) held. A
+ * PREEMPT_RT kernel cannot call find_vm_area() as it will acquire a sleeping
+ * rt_spinlock.
+ *
+ * For !RT kernel, the PROVE_RAW_LOCK_NESTING config option will print a
+ * lockdep warning for this raw_spinlock -> spinlock dependency. This config
+ * option is enabled by default to ensure better test coverage to expose this
+ * kind of RT kernel problem. This lockdep splat, however, can be suppressed
+ * by using DEFINE_WAIT_OVERRIDE_MAP() if it serves a useful purpose and the
+ * invalid PREEMPT_RT case has been taken care of.
+ */
+static inline struct vm_struct *kasan_find_vm_area(void *addr)
+{
+	static DEFINE_WAIT_OVERRIDE_MAP(vmalloc_map, LD_WAIT_SLEEP);
+	struct vm_struct *va;
+
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		return NULL;
+
+	/*
+	 * Suppress lockdep warning and fetch vmalloc area of the
+	 * offending address.
+	 */
+	lock_map_acquire_try(&vmalloc_map);
+	va = find_vm_area(addr);
+	lock_map_release(&vmalloc_map);
+	return va;
+}
+
 static void print_address_description(void *addr, u8 tag,
 				      struct kasan_report_info *info)
 {
@@ -399,7 +429,7 @@ static void print_address_description(vo
 	}
 
 	if (is_vmalloc_addr(addr)) {
-		struct vm_struct *va = find_vm_area(addr);
+		struct vm_struct *va = kasan_find_vm_area(addr);
 
 		if (va) {
 			pr_err("The buggy address belongs to the virtual mapping at\n"
@@ -409,6 +439,8 @@ static void print_address_description(vo
 			pr_err("\n");
 
 			page = vmalloc_to_page(addr);
+		} else {
+			pr_err("The buggy address %px belongs to a vmalloc virtual mapping\n", addr);
 		}
 	}
 
_

Patches currently in -mm which might be from longman@redhat.com are

kasan-dont-call-find_vm_area-in-a-preempt_rt-kernel.patch

