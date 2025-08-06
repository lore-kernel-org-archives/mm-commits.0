Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AC11A238F
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 02:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754447551; cv=none; b=ao3qzx2f2XRiyfUFtYXXJr+LcnixPBOj3prTCVFgAuuWdpRSoPy5LN/ORHswJmBqw4tWoIAGO3sXcCjhH+fJumQ0lPl3JDvW50l12aux4coR9gWP9tuDTMoYvv+Sfyg/wXzgnggDVOwRHPfylrTqln4tVePjXbyi+g73ZeP0WmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754447551; c=relaxed/simple;
	bh=dFSGD5HlKNUhh5h+ylYwdy41zUZxvR9v1JlUN8X7X9A=;
	h=Date:To:From:Subject:Message-Id; b=rnYuUX11bM4tvB91+UEquk35Ke3a9grAoPeXhu36qaCi39EU8XbfyRqVE38CEtBZbyMGnjwSO8w2LcLCZriRLOBm9RjcQmdJp0XbwTdbx4TxBDdnwFCj4nPwDyvzQ8pQLtxflRnJww+KqqwqjT7mGuDhLA7bqjaYpAufPQ84JVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hFih09my; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hFih09my"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DFFC4CEF0;
	Wed,  6 Aug 2025 02:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754447551;
	bh=dFSGD5HlKNUhh5h+ylYwdy41zUZxvR9v1JlUN8X7X9A=;
	h=Date:To:From:Subject:From;
	b=hFih09mychkxplcsh5YybJ7N3SXVLwb2vzVctqxI3TihwHCDErJaHk7tTRBF7HJP+
	 1/zqgQ3hBxU9Ha/O+Xe8YPLqvbLz/+LKsNtbES3ORmN9TWhLPZYh31dwOQxq40iCqZ
	 o88jSri2BXOom5f7+IwB2H8UBv1mySMc228l11Xo=
Date: Tue, 05 Aug 2025 19:32:30 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-add-conditional-checks-in-functions-to-return-directly-if-kasan-is-disabled.patch added to mm-new branch
Message-Id: <20250806023231.31DFFC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kasan: add conditional checks in functions to return directly if kasan is disabled
has been added to the -mm mm-new branch.  Its filename is
     mm-kasan-add-conditional-checks-in-functions-to-return-directly-if-kasan-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-add-conditional-checks-in-functions-to-return-directly-if-kasan-is-disabled.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/kasan: add conditional checks in functions to return directly if kasan is disabled
Date: Tue, 5 Aug 2025 14:23:30 +0800

Patch series "mm/kasan: make kasan=on|off work for all three modes".

Currently only hw_tags mode of kasan can be enabled or disabled with
kernel parameter kasan=on|off for built kernel. For kasan generic and
sw_tags mode, there's no way to disable them once kernel is built. 
This is not convenient sometime, e.g in system kdump is configured.
When the 1st kernel has KASAN enabled and crash triggered to switch to
kdump kernel, the generic or sw_tags mode will cost much extra memory
for kasan shadow while in fact it's meaningless to have kasan in kdump
kernel.

So this patchset moves the kasan=on|off out of hw_tags scope and into
common code to make it visible in generic and sw_tags mode too. Then we
can add kasan=off in kdump kernel to reduce the unneeded meomry cost for
kasan.

Test:
=====
I only took test on x86_64 for generic mode, and on arm64 for
generic, sw_tags and hw_tags mode. All of them works well.

However when I tested sw_tags on a HPE apollo arm64 machine, it always
breaks kernel with a KASAN bug. Even w/o this patchset applied, the bug 
can always be seen too.

"BUG: KASAN: invalid-access in pcpu_alloc_noprof+0x42c/0x9a8"

I haven't got root cause of the bug, will report the bug later in
another thread.


This patch (of 4):

The current code only does the check if kasan is disabled for hw_tags
mode.  Here add the conditional checks for functional functions of generic
mode and sw_tags mode.

This is prepared for later adding kernel parameter kasan=on|off for all
kasan modes.

Link: https://lkml.kernel.org/r/20250805062333.121553-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20250805062333.121553-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c    |   20 ++++++++++++++++++--
 mm/kasan/init.c       |    6 ++++++
 mm/kasan/quarantine.c |    3 +++
 mm/kasan/shadow.c     |   23 ++++++++++++++++++++++-
 mm/kasan/sw_tags.c    |    3 +++
 5 files changed, 52 insertions(+), 3 deletions(-)

--- a/mm/kasan/generic.c~mm-kasan-add-conditional-checks-in-functions-to-return-directly-if-kasan-is-disabled
+++ a/mm/kasan/generic.c
@@ -165,6 +165,9 @@ static __always_inline bool check_region
 						size_t size, bool write,
 						unsigned long ret_ip)
 {
+	if (!kasan_enabled())
+		return true;
+
 	if (!kasan_arch_is_ready())
 		return true;
 
@@ -203,12 +206,13 @@ bool kasan_byte_accessible(const void *a
 
 void kasan_cache_shrink(struct kmem_cache *cache)
 {
-	kasan_quarantine_remove_cache(cache);
+	if (kasan_enabled())
+		kasan_quarantine_remove_cache(cache);
 }
 
 void kasan_cache_shutdown(struct kmem_cache *cache)
 {
-	if (!__kmem_cache_empty(cache))
+	if (kasan_enabled() && !__kmem_cache_empty(cache))
 		kasan_quarantine_remove_cache(cache);
 }
 
@@ -228,6 +232,9 @@ void __asan_register_globals(void *ptr,
 	int i;
 	struct kasan_global *globals = ptr;
 
+	if (!kasan_enabled())
+		return;
+
 	for (i = 0; i < size; i++)
 		register_global(&globals[i]);
 }
@@ -358,6 +365,9 @@ void kasan_cache_create(struct kmem_cach
 	unsigned int rem_free_meta_size;
 	unsigned int orig_alloc_meta_offset;
 
+	if (!kasan_enabled())
+		return;
+
 	if (!kasan_requires_meta())
 		return;
 
@@ -510,6 +520,9 @@ size_t kasan_metadata_size(struct kmem_c
 {
 	struct kasan_cache *info = &cache->kasan_info;
 
+	if (!kasan_enabled())
+		return 0;
+
 	if (!kasan_requires_meta())
 		return 0;
 
@@ -535,6 +548,9 @@ void kasan_record_aux_stack(void *addr)
 	struct kasan_alloc_meta *alloc_meta;
 	void *object;
 
+	if (!kasan_enabled())
+		return;
+
 	if (is_kfence_address(addr) || !slab)
 		return;
 
--- a/mm/kasan/init.c~mm-kasan-add-conditional-checks-in-functions-to-return-directly-if-kasan-is-disabled
+++ a/mm/kasan/init.c
@@ -449,6 +449,9 @@ void kasan_remove_zero_shadow(void *star
 	unsigned long addr, end, next;
 	pgd_t *pgd;
 
+	if (!kasan_enabled())
+		return;
+
 	addr = (unsigned long)kasan_mem_to_shadow(start);
 	end = addr + (size >> KASAN_SHADOW_SCALE_SHIFT);
 
@@ -484,6 +487,9 @@ int kasan_add_zero_shadow(void *start, u
 	int ret;
 	void *shadow_start, *shadow_end;
 
+	if (!kasan_enabled())
+		return 0;
+
 	shadow_start = kasan_mem_to_shadow(start);
 	shadow_end = shadow_start + (size >> KASAN_SHADOW_SCALE_SHIFT);
 
--- a/mm/kasan/quarantine.c~mm-kasan-add-conditional-checks-in-functions-to-return-directly-if-kasan-is-disabled
+++ a/mm/kasan/quarantine.c
@@ -405,6 +405,9 @@ static int __init kasan_cpu_quarantine_i
 {
 	int ret = 0;
 
+	if (!kasan_enabled())
+		return 0;
+
 	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "mm/kasan:online",
 				kasan_cpu_online, kasan_cpu_offline);
 	if (ret < 0)
--- a/mm/kasan/shadow.c~mm-kasan-add-conditional-checks-in-functions-to-return-directly-if-kasan-is-disabled
+++ a/mm/kasan/shadow.c
@@ -125,6 +125,9 @@ void kasan_poison(const void *addr, size
 {
 	void *shadow_start, *shadow_end;
 
+	if (!kasan_enabled())
+		return;
+
 	if (!kasan_arch_is_ready())
 		return;
 
@@ -150,6 +153,9 @@ EXPORT_SYMBOL_GPL(kasan_poison);
 #ifdef CONFIG_KASAN_GENERIC
 void kasan_poison_last_granule(const void *addr, size_t size)
 {
+	if (!kasan_enabled())
+		return;
+
 	if (!kasan_arch_is_ready())
 		return;
 
@@ -164,6 +170,8 @@ void kasan_unpoison(const void *addr, si
 {
 	u8 tag = get_tag(addr);
 
+	if (!kasan_enabled())
+		return;
 	/*
 	 * Perform shadow offset calculation based on untagged address, as
 	 * some of the callers (e.g. kasan_unpoison_new_object) pass tagged
@@ -277,7 +285,8 @@ static int __meminit kasan_mem_notifier(
 
 static int __init kasan_memhotplug_init(void)
 {
-	hotplug_memory_notifier(kasan_mem_notifier, DEFAULT_CALLBACK_PRI);
+	if (kasan_enabled())
+		hotplug_memory_notifier(kasan_mem_notifier, DEFAULT_CALLBACK_PRI);
 
 	return 0;
 }
@@ -390,6 +399,9 @@ int kasan_populate_vmalloc(unsigned long
 	unsigned long shadow_start, shadow_end;
 	int ret;
 
+	if (!kasan_enabled())
+		return 0;
+
 	if (!kasan_arch_is_ready())
 		return 0;
 
@@ -560,6 +572,9 @@ void kasan_release_vmalloc(unsigned long
 	unsigned long region_start, region_end;
 	unsigned long size;
 
+	if (!kasan_enabled())
+		return;
+
 	if (!kasan_arch_is_ready())
 		return;
 
@@ -655,6 +670,9 @@ int kasan_alloc_module_shadow(void *addr
 	size_t shadow_size;
 	unsigned long shadow_start;
 
+	if (!kasan_enabled())
+		return 0;
+
 	shadow_start = (unsigned long)kasan_mem_to_shadow(addr);
 	scaled_size = (size + KASAN_GRANULE_SIZE - 1) >>
 				KASAN_SHADOW_SCALE_SHIFT;
@@ -691,6 +709,9 @@ int kasan_alloc_module_shadow(void *addr
 
 void kasan_free_module_shadow(const struct vm_struct *vm)
 {
+	if (!kasan_enabled())
+		return;
+
 	if (IS_ENABLED(CONFIG_UML))
 		return;
 
--- a/mm/kasan/sw_tags.c~mm-kasan-add-conditional-checks-in-functions-to-return-directly-if-kasan-is-disabled
+++ a/mm/kasan/sw_tags.c
@@ -78,6 +78,9 @@ bool kasan_check_range(const void *addr,
 	u8 *shadow_first, *shadow_last, *shadow;
 	void *untagged_addr;
 
+	if (!kasan_enabled())
+		return true;
+
 	if (unlikely(size == 0))
 		return true;
 
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-kasan-add-conditional-checks-in-functions-to-return-directly-if-kasan-is-disabled.patch
mm-kasan-move-kasan=-code-to-common-place.patch
mm-kasan-dont-initialize-kasan-if-its-disabled.patch
mm-kasan-make-kasan=onoff-take-effect-for-all-three-modes.patch

