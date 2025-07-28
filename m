Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298E62165E2
	for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2025 22:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753742492; cv=none; b=doxeILb86++vwO45mAUWnIX2Sh/1DrQWbiXkO+LQ3Kk1ww/xF8jgHbbd9dAt/qcHijzXJjaNnK7O6ayISMSt6Uff3kR8t2EflE5CZLw/12Gn8XLCwF65KFn7t5DIP9kYS9P5wp+Nssgk1JYjPS/UZle8A1W+5jl9NexO0mZazQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753742492; c=relaxed/simple;
	bh=2Tg8/3GIvTpd70tzhzOFOOEQqk2I1Ux0QYS7nOaPM/E=;
	h=Date:To:From:Subject:Message-Id; b=gg/lrCJJkqNDEYZic7ra73DSyMH5thiK3bg8PvPf99Wjsb2DAPcnwd2v96kHVu2g/oABBkf51GQA+f7TefMijyCxbVp5zqQx6qNqsYoWcUEguKL33f0LanKRs7IxqSZek/iAoiKxOq4kMfM31+vPC40LM0G/gBK7L5gr6pJB4bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PGPZSNOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PGPZSNOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B6CC4CEE7;
	Mon, 28 Jul 2025 22:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753742491;
	bh=2Tg8/3GIvTpd70tzhzOFOOEQqk2I1Ux0QYS7nOaPM/E=;
	h=Date:To:From:Subject:From;
	b=PGPZSNOusflIMWIvKP62erJhBsGFRlfWR1LFMztC4XUHuhJWFgC6jFZCaBAKBEzdX
	 CGS5DrYeV5XOtWc5fQl8IAL/OggGNySxjl9l60e5hWgemYQIRfQfbdSbM46wCrtl0Y
	 EjOyW4fOkKgOCVlvLPk/nAszBjz5YxVuhbC6l5O0=
Date: Mon, 28 Jul 2025 15:41:31 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,petr.pavlu@suse.com,peterz@infradead.org,mhiramat@kernel.org,da.gomez@samsung.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + execmem-add-fallback-for-failures-in-vmallocvm_allow_huge_vmap.patch added to mm-unstable branch
Message-Id: <20250728224131.C3B6CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: execmem: add fallback for failures in vmalloc(VM_ALLOW_HUGE_VMAP)
has been added to the -mm mm-unstable branch.  Its filename is
     execmem-add-fallback-for-failures-in-vmallocvm_allow_huge_vmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/execmem-add-fallback-for-failures-in-vmallocvm_allow_huge_vmap.patch

This patch will later appear in the mm-unstable branch at
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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: execmem: add fallback for failures in vmalloc(VM_ALLOW_HUGE_VMAP)
Date: Sun, 13 Jul 2025 10:17:27 +0300

When execmem populates ROX cache it uses vmalloc(VM_ALLOW_HUGE_VMAP). 
Although vmalloc falls back to allocating base pages if high order
allocation fails, it may happen that it still cannot allocate enough
memory.

Right now ROX cache is only used by modules and in majority of cases the
allocations happen at boot time when there's plenty of free memory, but
upcoming enabling ROX cache for ftrace and kprobes would mean that execmem
allocations can happen when the system is under memory pressure and a
failure to allocate large page worth of memory becomes more likely.

Fallback to regular vmalloc() if vmalloc(VM_ALLOW_HUGE_VMAP) fails.

Link: https://lkml.kernel.org/r/20250713071730.4117334-6-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/execmem.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/execmem.c~execmem-add-fallback-for-failures-in-vmallocvm_allow_huge_vmap
+++ a/mm/execmem.c
@@ -291,6 +291,11 @@ static int execmem_cache_populate(struct
 
 	alloc_size = round_up(size, PMD_SIZE);
 	p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
+	if (!p) {
+		alloc_size = size;
+		p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
+	}
+
 	if (!p)
 		return err;
 
@@ -462,7 +467,7 @@ void *execmem_alloc(enum execmem_type ty
 	bool use_cache = range->flags & EXECMEM_ROX_CACHE;
 	vm_flags_t vm_flags = VM_FLUSH_RESET_PERMS;
 	pgprot_t pgprot = range->pgprot;
-	void *p;
+	void *p = NULL;
 
 	size = PAGE_ALIGN(size);
 
_

Patches currently in -mm which might be from rppt@kernel.org are

execmem-drop-unused-execmem_update_copy.patch
execmem-introduce-execmem_alloc_rw.patch
execmem-rework-execmem_cache_free.patch
execmem-move-execmem_force_rw-and-execmem_restore_rox-before-use.patch
execmem-add-fallback-for-failures-in-vmallocvm_allow_huge_vmap.patch
execmem-drop-writable-parameter-from-execmem_fill_trapping_insns.patch
x86-kprobes-enable-execmem_rox_cache-for-kprobes-allocations.patch
x86-ftrace-enable-execmem_rox_cache-for-ftrace-allocations.patch
kho-add-test-for-kexec-handover.patch

