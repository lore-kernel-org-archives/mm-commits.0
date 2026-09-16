Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30284E06E1;
	Wed, 16 Sep 2026 20:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789592413; cv=none; b=I4aOZlV/TYQEJ/c0sCPdZt1+0IcbcxU7/W8eunjIkVTiDO/2CyvBM6iMLCcCIqgy+DdRQ0SUBVgH5YWGFsrq4lT6xEWW8H2BJIeQE9s5TheQb+H3D9YA4qFxcaClyiH3cUFKhMeh2fXLVdb1zW2CXdYCDe+iZaphg3n40cpwlcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789592413; c=relaxed/simple;
	bh=QzA+KBr/uIcAC8kLbo5Ay7GDGttYSV8buA8FcdHeVQ0=;
	h=Date:To:From:Subject:Message-Id; b=OiHR88j1dsB81lBuVyyuKjVBGfHqPMT9d5TWS+RaT8z4pmLS15rRV51bouvmlMnYH/ZpMF2JQSSIT+vS88d2GcI8WMqxQEdEHr4ZhqF7M1jjVecw5w//DO0BWidvtJczqY/1AYzHCcFzY0gAK4NWbRkjrCjovTe7bcMZtH9q0rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zaBK33CL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zaBK33CL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE111F000FF;
	Wed, 16 Sep 2026 20:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789592397;
	bh=dbpskzbIoTd5IgRyVcqGXoJDpMKNH4vuWYhLV20/QOU=;
	h=Date:To:From:Subject;
	b=zaBK33CLHVz1dbnKb/QMYF993VmqH0ZZDED6LzBTv6VntRppIsbvZzahTmqZI2AL8
	 k6Ukq25+ZIFvMPSGpX52m25512KJnCL3PJBq1n1aNd451GhWVAec/7Ar0X5fuWV+Ce
	 1SfCm00WECTqFwcKBBvrKqYhDwkSJtXSKI+0YJME=
Date: Wed, 16 Sep 2026 13:59:56 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,stable@vger.kernel.org,ljs@kernel.org,huangshaobo3@xiaomi.com,glider@google.com,dvyukov@google.com,david@kernel.org,andreyknvl@gmail.com,ryabinin.a.a@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-unpoison-task-stack-below-watermark-only-in-generic-mode.patch added to mm-hotfixes-unstable branch
Message-Id: <20260916205957.1EE111F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: unpoison task stack below watermark only in generic mode
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-unpoison-task-stack-below-watermark-only-in-generic-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-unpoison-task-stack-below-watermark-only-in-generic-mode.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: kasan: unpoison task stack below watermark only in generic mode
Date: Wed, 16 Sep 2026 19:51:13 +0200

CPU resume and BPF exception handling can discard stack frames without
running their compiler-generated epilogues.  Generic KASAN needs
kasan_unpoison_task_stack_below() to clear the redzones left behind by
those frames before the stack is reused.

CONFIG_KASAN_STACK also enables this helper for SW_TAGS.  The helper
derives the stack base from an untagged stack pointer, so kasan_unpoison()
writes KASAN_TAG_KERNEL (0xff) into the shadow for [base, watermark).  For
a vmapped task stack, vm_area->addr still carries the original random
allocation tag.  This creates a tag mismatch at the stack base even if
that memory has never held an instrumented stack object.

When the task exits and its stack is not cached, thread_stack_free_rcu()
passes vm_area->addr to vfree().  In RCU callback context this reaches
vfree_atomic(), whose llist_add() writes to the allocation base through
the tagged pointer and triggers a false KASAN invalid-access report:

  BUG: KASAN: invalid-access in vfree_atomic+0x90/0x150
  Write of size 8 at addr c2ffffc0a8f70000 by task rcuop/7/75
  Pointer tag: [c2], memory tag: [ff]
  Call trace:
   __hwasan_store8_noabort+0xe8/0xf8
   vfree_atomic+0x90/0x150
   vfree+0x220/0x298
   thread_stack_free_rcu+0x3c/0x4c
   rcu_do_batch+0x308/0xaf0
   rcu_nocb_cb_kthread+0x33c/0x708

The deferred-free path started using the tagged vm_area->addr in commit
449e0b4ed5a1 ("fork: clean-up naming of vm_stack/vm_struct variables in
vmap stacks code").  Previously it freed the untagged pointer derived from
tsk->stack, so the write was never tag-checked.

SW_TAGS does not need the blanket shadow reset to make subsequent stack
accesses valid: untagged kernel pointers have the match-all 0xff tag, and
the compiler initializes the shadow tags of instrumented stack objects
before use.

Return early unless CONFIG_KASAN_GENERIC is enabled.  Keep the mode check
in the common helper so it covers both resume and bpf_throw().

Link: https://lore.kernel.org/20260916175113.1327454-1-ryabinin.a.a@gmail.com
Fixes: 449e0b4ed5a1 ("fork: clean-up naming of vm_stack/vm_struct variables in vmap stacks code")
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Shaobo Huang <huangshaobo3@xiaomi.com>
Closes: https://lore.kernel.org/all/20260806123020.90869-1-huangshaobo3@xiaomi.com/
Assisted-by: LLM
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
---

 mm/kasan/common.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/mm/kasan/common.c~kasan-unpoison-task-stack-below-watermark-only-in-generic-mode
+++ a/mm/kasan/common.c
@@ -114,12 +114,23 @@ void kasan_unpoison_task_stack(struct ta
 /* Unpoison the stack for the current task beyond a watermark sp value. */
 asmlinkage void kasan_unpoison_task_stack_below(const void *watermark)
 {
+	void *base;
+
+	/*
+	 * Only the generic mode needs this. In the tag-based mode the
+	 * compiler fully initializes the shadow of stack variables on
+	 * function entry, so stale tags left below the watermark are
+	 * harmless.
+	 */
+	if (!IS_ENABLED(CONFIG_KASAN_GENERIC))
+		return;
+
 	/*
 	 * Calculate the task stack base address.  Avoid using 'current'
 	 * because this function is called by early resume code which hasn't
 	 * yet set up the percpu register (%gs).
 	 */
-	void *base = (void *)((unsigned long)watermark & ~(THREAD_SIZE - 1));
+	base = (void *)((unsigned long)watermark & ~(THREAD_SIZE - 1));
 
 	kasan_unpoison(base, watermark - base, false);
 }
_

Patches currently in -mm which might be from ryabinin.a.a@gmail.com are

kasan-unpoison-task-stack-below-watermark-only-in-generic-mode.patch

