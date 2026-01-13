Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621E1241690;
	Tue, 13 Jan 2026 22:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768342190; cv=none; b=Sk9aToMB9TNXN1uLpWFvPDXvNsoyUDCI5m6Qqg9Fuzz7vmYRBjlEGuaC0zI6biluYJIYusHk6SBLrpChsVnjDQ/4kymCixJneDhTXJJdX39qIoLcyfpwdD7jlXQveTRQV9QSkG7pewMjXptVlCJvkTwrraDAHuMFlQY7yQiwEGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768342190; c=relaxed/simple;
	bh=JKEQnRvqNdRhxWql/FDqpNJ4Qe6uhSqvKT6N9ZzrLlM=;
	h=Date:To:From:Subject:Message-Id; b=BrYU7igXNX3z9tCK9YrSjMMJsaQb1gkrmnzoTfEzpxO7RjJg1Ca5DU+8ErcmtUBiPK5gXT0HBhNs3jXlO9NaYZSfGusDpkWcoM4xlxSi76arwrL5D2qcgx/jcjdIi+s7v7yC2R4eV/t9Gbl7o61Wln0FAP8aJ/6ZOYcXeI6HhtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VUD2wmke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VUD2wmke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82D9C16AAE;
	Tue, 13 Jan 2026 22:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768342190;
	bh=JKEQnRvqNdRhxWql/FDqpNJ4Qe6uhSqvKT6N9ZzrLlM=;
	h=Date:To:From:Subject:From;
	b=VUD2wmkeoSOgcGBSmLH90C8lQT29Ip5IzBRI60W6FqXYhu7/6/FQjy3EhlJ/ewkJm
	 DtkIGOkYgeGBqUbJb1xRcyZlr0yRm0oJJbcu0S2KG/QGxGwHKvLEHteS0l+s7yuoP1
	 rHZiA1iHQv3e70HK+CzbZlsGLMKKWpJATo5jbE4k=
Date: Tue, 13 Jan 2026 14:09:49 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,stable@vger.kernel.org,maze@google.com,joonki.min@samsung-slsi.corp-partner.google.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,ryabinin.a.a@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-fix-kasan-poisoning-in-vrealloc.patch added to mm-hotfixes-unstable branch
Message-Id: <20260113220949.E82D9C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kasan: fix KASAN poisoning in vrealloc()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kasan-fix-kasan-poisoning-in-vrealloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-fix-kasan-poisoning-in-vrealloc.patch

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
Subject: mm/kasan: fix KASAN poisoning in vrealloc()
Date: Tue, 13 Jan 2026 20:15:15 +0100

A KASAN warning can be triggered when vrealloc() changes the requested
size to a value that is not aligned to KASAN_GRANULE_SIZE.

    ------------[ cut here ]------------
    WARNING: CPU: 2 PID: 1 at mm/kasan/shadow.c:174 kasan_unpoison+0x40/0x48
    ...
    pc : kasan_unpoison+0x40/0x48
    lr : __kasan_unpoison_vmalloc+0x40/0x68
    Call trace:
     kasan_unpoison+0x40/0x48 (P)
     vrealloc_node_align_noprof+0x200/0x320
     bpf_patch_insn_data+0x90/0x2f0
     convert_ctx_accesses+0x8c0/0x1158
     bpf_check+0x1488/0x1900
     bpf_prog_load+0xd20/0x1258
     __sys_bpf+0x96c/0xdf0
     __arm64_sys_bpf+0x50/0xa0
     invoke_syscall+0x90/0x160

Introduce a dedicated kasan_vrealloc() helper that centralizes KASAN
handling for vmalloc reallocations.  The helper accounts for KASAN granule
alignment when growing or shrinking an allocation and ensures that partial
granules are handled correctly.

Use this helper from vrealloc_node_align_noprof() to fix poisoning logic.

Link: https://lkml.kernel.org/r/20260113191516.31015-1-ryabinin.a.a@gmail.com
Fixes: d699440f58ce ("mm: fix vrealloc()'s KASAN poisoning logic")
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Reported-by: Maciej Żenczykowski <maze@google.com>
Reported-by: <joonki.min@samsung-slsi.corp-partner.google.com>
Closes: https://lkml.kernel.org/r/CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    6 ++++++
 mm/kasan/shadow.c     |   24 ++++++++++++++++++++++++
 mm/vmalloc.c          |    7 ++-----
 3 files changed, 32 insertions(+), 5 deletions(-)

--- a/include/linux/kasan.h~mm-kasan-fix-kasan-poisoning-in-vrealloc
+++ a/include/linux/kasan.h
@@ -641,6 +641,9 @@ kasan_unpoison_vmap_areas(struct vm_stru
 		__kasan_unpoison_vmap_areas(vms, nr_vms, flags);
 }
 
+void kasan_vrealloc(const void *start, unsigned long old_size,
+		unsigned long new_size);
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 static inline void kasan_populate_early_vm_area_shadow(void *start,
@@ -670,6 +673,9 @@ kasan_unpoison_vmap_areas(struct vm_stru
 			  kasan_vmalloc_flags_t flags)
 { }
 
+static inline void kasan_vrealloc(const void *start, unsigned long old_size,
+				unsigned long new_size) { }
+
 #endif /* CONFIG_KASAN_VMALLOC */
 
 #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
--- a/mm/kasan/shadow.c~mm-kasan-fix-kasan-poisoning-in-vrealloc
+++ a/mm/kasan/shadow.c
@@ -651,6 +651,30 @@ void __kasan_poison_vmalloc(const void *
 	kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
 }
 
+void kasan_vrealloc(const void *addr, unsigned long old_size,
+		unsigned long new_size)
+{
+	if (!kasan_enabled())
+		return;
+
+	if (new_size < old_size) {
+		kasan_poison_last_granule(addr, new_size);
+
+		new_size = round_up(new_size, KASAN_GRANULE_SIZE);
+		old_size = round_up(old_size, KASAN_GRANULE_SIZE);
+		if (new_size < old_size)
+			__kasan_poison_vmalloc(addr + new_size,
+					old_size - new_size);
+	} else if (new_size > old_size) {
+		old_size = round_down(old_size, KASAN_GRANULE_SIZE);
+		__kasan_unpoison_vmalloc(addr + old_size,
+					new_size - old_size,
+					KASAN_VMALLOC_PROT_NORMAL |
+					KASAN_VMALLOC_VM_ALLOC |
+					KASAN_VMALLOC_KEEP_TAG);
+	}
+}
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
--- a/mm/vmalloc.c~mm-kasan-fix-kasan-poisoning-in-vrealloc
+++ a/mm/vmalloc.c
@@ -4322,7 +4322,7 @@ void *vrealloc_node_align_noprof(const v
 		if (want_init_on_free() || want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
 		vm->requested_size = size;
-		kasan_poison_vmalloc(p + size, old_size - size);
+		kasan_vrealloc(p, old_size, size);
 		return (void *)p;
 	}
 
@@ -4330,16 +4330,13 @@ void *vrealloc_node_align_noprof(const v
 	 * We already have the bytes available in the allocation; use them.
 	 */
 	if (size <= alloced_size) {
-		kasan_unpoison_vmalloc(p + old_size, size - old_size,
-				       KASAN_VMALLOC_PROT_NORMAL |
-				       KASAN_VMALLOC_VM_ALLOC |
-				       KASAN_VMALLOC_KEEP_TAG);
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during
 		 * realloc shrink time.
 		 */
 		vm->requested_size = size;
+		kasan_vrealloc(p, old_size, size);
 		return (void *)p;
 	}
 
_

Patches currently in -mm which might be from ryabinin.a.a@gmail.com are

mm-kasan-fix-kasan-poisoning-in-vrealloc.patch

