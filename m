Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBC1443E24
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784140185; cv=none; b=TE1CcEraOoZ49ORtUfgVZs970Dlb6X8HHXe68nZxF+Td4i0kNScak9fNDQHsbGsQhv7VP05wB2CAEM7FZ/UJuKNRGKCV5AvsolgHjf/3soEeh5cYtwI79PFVF2B6MnnX8AiNRZnY4EkRq7liLL5upQ4q7HraBi5uVYsJOl1pE4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784140185; c=relaxed/simple;
	bh=ZasH/q8pawVVfi3V1P6C2+EpBqSDUS/xEC/fBnMszCg=;
	h=Date:To:From:Subject:Message-Id; b=d/9WTw2nJrSbJgLKJ7yhx+hpXojL3mU/HpQosAulC4bOKjutWxQms4fBXfED/q5INOFs2R8H1u8M3+oocyr8WXB5edsSM5EYXckK7ASSEmiWOfIazYhazXgH7EXMyCBv2kvwETDtNW27gTZ4Fm4ogfDvvK05g0Zq+dxW8zRE03Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oqzA56JY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oqzA56JY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBF71F000E9;
	Wed, 15 Jul 2026 18:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784140169;
	bh=GNKAaPYPLrf1tV+piJMAuffGkr4Qi3FsxBbWZOkfvXg=;
	h=Date:To:From:Subject;
	b=oqzA56JYpzQUBkpU2WczIUFsRSUSG4eacCtxaxsnXX8XJBrdOv32zNaCJB2c2guQg
	 73edyZhxMHoXl8qf3uODasQsSpHhU+H02ZfSw9gT7JKSiZO0l31ea3YGoyu5Q0DGjm
	 TiohIxQANpPBNxVdQXGdO/3qx1zb+68WVGwJ5o4Q=
Date: Wed, 15 Jul 2026 11:29:28 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,thomas.weissschuh@linutronix.de,rdunlap@infradead.org,pfalcato@suse.de,peterz@infradead.org,ojeda@kernel.org,nathan@kernel.org,ljs@kernel.org,linux.amoon@gmail.com,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,gary@garyguo.net,dianders@chromium.org,corbet@lwn.net,aliceryhl@google.com,leon.hwang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-fix-mseal-documentation-for-32-bit-kernels.patch added to mm-new branch
Message-Id: <20260715182929.7CBF71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mseal: fix mseal documentation for 32-bit kernels
has been added to the -mm mm-new branch.  Its filename is
     mm-mseal-fix-mseal-documentation-for-32-bit-kernels.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mseal-fix-mseal-documentation-for-32-bit-kernels.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Leon Hwang <leon.hwang@linux.dev>
Subject: mm/mseal: fix mseal documentation for 32-bit kernels
Date: Wed, 15 Jul 2026 21:12:58 +0800

mseal.o is built only for 64-bit kernels, so 32-bit kernels fall back to
sys_ni_syscall() and return -ENOSYS rather than -EPERM.

Drop architecture description in mseal.rst, since the arch feature doc has
the latest state of mseal for each architecture.

Fix the CONFIG_MSEAL_SYSTEM_MAPPINGS typo in init/Kconfig.

Drop the whole comment of do_mseal() to avoid stale info in the
comment, as we have the doc in mseal.rst.

Link: https://lore.kernel.org/20260715131258.55499-1-leon.hwang@linux.dev
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Acked-by: Lance Yang <lance.yang@linux.dev>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Anand Moon <linux.amoon@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leon Hwang <leon.hwang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/userspace-api/mseal.rst |   14 ++----
 init/Kconfig                          |    2 
 mm/mseal.c                            |   52 ------------------------
 3 files changed, 7 insertions(+), 61 deletions(-)

--- a/Documentation/userspace-api/mseal.rst~mm-mseal-fix-mseal-documentation-for-32-bit-kernels
+++ a/Documentation/userspace-api/mseal.rst
@@ -50,8 +50,8 @@ mseal syscall signature
          * The start address (``addr``) is not allocated.
          * The end address (``addr`` + ``len``) is not allocated.
          * A gap (unallocated memory) between start and end address.
-      - **-EPERM**:
-         * sealing is supported only on 64-bit CPUs, 32-bit is not supported.
+      - **-ENOSYS**:
+         * The kernel does not implement ``mseal()``.
 
    **Note about error return**:
       - For above error cases, users can expect the given memory range is
@@ -62,7 +62,8 @@ mseal syscall signature
         memory range could happen. However, those cases should be rare.
 
    **Architecture support**:
-      mseal only works on 64-bit CPUs, not 32-bit CPUs.
+      mseal is built only for 64-bit kernels. 32-bit kernels return
+      ``-ENOSYS``.
 
    **Idempotent**:
       users can call mseal multiple times. mseal on an already sealed memory
@@ -131,11 +132,11 @@ Use cases
 - Chrome browser: protect some security sensitive data structures.
 
 - System mappings:
-  The system mappings are created by the kernel and includes vdso, vvar,
+  The system mappings are created by the kernel and include vdso, vvar,
   vvar_vclock, vectors (arm compat-mode), sigpage (arm compat-mode), uprobes.
 
   Those system mappings are readonly only or execute only, memory sealing can
-  protect them from ever changing to writable or unmmap/remapped as different
+  protect them from ever changing to writable or unmapped/remapped as different
   attributes. This is useful to mitigate memory corruption issues where a
   corrupted pointer is passed to a memory management system.
 
@@ -143,9 +144,6 @@ Use cases
   the CONFIG_MSEAL_SYSTEM_MAPPINGS seals all system mappings of this
   architecture.
 
-  The following architectures currently support this feature: x86-64, arm64,
-  loongarch and s390.
-
   WARNING: This feature breaks programs which rely on relocating
   or unmapping system mappings. Known broken software at the time
   of writing includes CHECKPOINT_RESTORE, UML, gVisor, rr. Therefore
--- a/init/Kconfig~mm-mseal-fix-mseal-documentation-for-32-bit-kernels
+++ a/init/Kconfig
@@ -2120,7 +2120,7 @@ config ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPIN
 	  from a kernel perspective.
 
 	  After the architecture enables this, a distribution can set
-	  CONFIG_MSEAL_SYSTEM_MAPPING to manage access to the feature.
+	  CONFIG_MSEAL_SYSTEM_MAPPINGS to manage access to the feature.
 
 	  For complete descriptions of memory sealing, please see
 	  Documentation/userspace-api/mseal.rst
--- a/mm/mseal.c~mm-mseal-fix-mseal-documentation-for-32-bit-kernels
+++ a/mm/mseal.c
@@ -88,58 +88,6 @@ static int mseal_apply(struct mm_struct
 	return 0;
 }
 
-/*
- * mseal(2) seals the VM's meta data from
- * selected syscalls.
- *
- * addr/len: VM address range.
- *
- *  The address range by addr/len must meet:
- *   start (addr) must be in a valid VMA.
- *   end (addr + len) must be in a valid VMA.
- *   no gap (unallocated memory) between start and end.
- *   start (addr) must be page aligned.
- *
- *  len: len will be page aligned implicitly.
- *
- *   Below VMA operations are blocked after sealing.
- *   1> Unmapping, moving to another location, and shrinking
- *	the size, via munmap() and mremap(), can leave an empty
- *	space, therefore can be replaced with a VMA with a new
- *	set of attributes.
- *   2> Moving or expanding a different vma into the current location,
- *	via mremap().
- *   3> Modifying a VMA via mmap(MAP_FIXED).
- *   4> Size expansion, via mremap(), does not appear to pose any
- *	specific risks to sealed VMAs. It is included anyway because
- *	the use case is unclear. In any case, users can rely on
- *	merging to expand a sealed VMA.
- *   5> mprotect and pkey_mprotect.
- *   6> Some destructive madvice() behavior (e.g. MADV_DONTNEED)
- *      for anonymous memory, when users don't have write permission to the
- *	memory. Those behaviors can alter region contents by discarding pages,
- *	effectively a memset(0) for anonymous memory.
- *
- *  flags: reserved.
- *
- * return values:
- *  zero: success.
- *  -EINVAL:
- *   invalid input flags.
- *   start address is not page aligned.
- *   Address range (start + len) overflow.
- *  -ENOMEM:
- *   addr is not a valid address (not allocated).
- *   end (start + len) is not a valid address.
- *   a gap (unallocated memory) between start and end.
- *  -EPERM:
- *  - In 32 bit architecture, sealing is not supported.
- * Note:
- *  user can call mseal(2) multiple times, adding a seal on an
- *  already sealed memory is a no-action (no error).
- *
- *  unseal() is not supported.
- */
 int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 {
 	size_t len;
_

Patches currently in -mm which might be from leon.hwang@linux.dev are

mm-mseal-fix-mseal-documentation-for-32-bit-kernels.patch

