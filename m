Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6131A6813;
	Tue,  1 Sep 2026 04:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788236163; cv=none; b=g+SQdNp5gKQUZX9XXszIZuxE6tq2jWxW7YKnWZQdRIYeMU8XpZWh78gkwcNaBEjtHwFCwkAesOnOyH2RGKZp1LCqeR8Bom5RT2MxvZKXdwLIpX5L4efqywf2/f0vdCHJbP+mI/y2w4n2XszVeq/Jx415EMELeJZ2lBkoDr1VqYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788236163; c=relaxed/simple;
	bh=Nr3l65j+yMsckMZwTYky1wx1WToEu1iqF1wLz+MjE60=;
	h=Date:To:From:Subject:Message-Id; b=puWkZoWOa4dgyRjpsEDAePFxYUIIS9PDZUWcsFZTHZytgIKGsmhu8NvzI5dma/Xbxe6hJhq08U9AhVFhYFo+w3wWIG8me11bG6YfR5Cyc+OQE8tU87pn31QDyNwlnJbhP+1bV4MTJ3bJaksnGs5NEJu6aPkEcqwZfxMI6rtIxNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e1xL4/S6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e1xL4/S6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F9B1F000E9;
	Tue,  1 Sep 2026 04:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788236161;
	bh=tDOJpA4F+kiYZM6pgRbyRLBw8HcmPlzv+ppYrxuLoHA=;
	h=Date:To:From:Subject;
	b=e1xL4/S6dML6Hl8tJ3L+/xBurjC3cxwLw51RKw/BjcSIVaiPyUXINLioslxXJA/2i
	 h81zlunyZ+nz8GCDkkTGvNycYHpTZTDnav9gj5tbNFF/RqGx1Ry4JG0aNG53X20hJc
	 lS6r8NCDlaheOQJ6JuhcnQaUXXNOmTe+5yJUQFjI=
Date: Mon, 31 Aug 2026 21:16:00 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,peterz@infradead.org,mingo@redhat.com,kees@kernel.org,include@grrlz.net,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-honor-task_structs-declared-alignment.patch added to mm-nonmm-unstable branch
Message-Id: <20260901041601.51F9B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: honor task_struct's declared alignment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-honor-task_structs-declared-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-honor-task_structs-declared-alignment.patch

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
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: fork: honor task_struct's declared alignment
Date: Fri, 10 Jul 2026 14:39:57 +0200

Since commit cb7ca40a3882 ("x86/fpu: Make task_struct::thread constant
size"), struct task_struct is declared __attribute__((aligned(64))) on all
architectures.

But fork_init() still sets the task_struct slab cache's alignment to

	align = max(L1_CACHE_BYTES, ARCH_MIN_TASKALIGN)

which is smaller than 64 on architectures whose cache lines are below 64
bytes: e.g.  32 on ARMv5.

In practice plain SLUB happens to hand out 64-byte-aligned objects anyway.
With CONFIG_SLUB_DEBUG_ON the red-zone padding shifts objects to the
requested alignment.

With CONFIG_UBSAN_ALIGNMENT=y a boot on QEMU versatilepb (ARM926EJ-S,
v7.2-rc2, gcc 13.3) floods the console with reports like:

  UBSAN: misaligned-access in include/linux/sched.h:2087:9
  member access within misaligned address c295d7e0 for type 'struct task_struct'
  which requires 64 byte alignment
  CPU: 0 UID: 0 PID: 15 Comm: pr/ttyAMA-1 Not tainted 7.2.0-rc2 #1 VOLUNTARY

Set the slab alignment to at least the type's declared alignment.

Link: https://lore.kernel.org/20260710123957.31774-1-kmehltretter@gmail.com
Fixes: cb7ca40a3882 ("x86/fpu: Make task_struct::thread constant size")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Assisted-by: Claude:claude-fable-5
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/fork.c~fork-honor-task_structs-declared-alignment
+++ a/kernel/fork.c
@@ -858,7 +858,8 @@ void __init fork_init(void)
 #ifndef ARCH_MIN_TASKALIGN
 #define ARCH_MIN_TASKALIGN	0
 #endif
-	int align = max_t(int, L1_CACHE_BYTES, ARCH_MIN_TASKALIGN);
+	int align = max3(L1_CACHE_BYTES, ARCH_MIN_TASKALIGN,
+			 __alignof__(struct task_struct));
 	unsigned long useroffset, usersize;
 
 	/* create a slab on which task_structs can be allocated */
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

klist-avoid-accesses-after-waking-klist_remove.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch
fork-honor-task_structs-declared-alignment.patch

