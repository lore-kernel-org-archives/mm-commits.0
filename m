Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA15D366548;
	Wed,  1 Apr 2026 02:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775011404; cv=none; b=EABjrZWrzeEQyCCNIf8tH4Mcv9cG35mKHuaNSOXczSNL0nC9Fop94g+Q0RBYDnOutPaC6bRPwPFjJ8ZHVx89Rf3ScqV5/U0fX2XIBQn1vNfJo+WjU9Z6pSwFV7idXYqTps8hJlTwzzcTPeBkj2A/Hdzz7EiRwrG6tDc9UkssbTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775011404; c=relaxed/simple;
	bh=ZsrxAY69fyePntbeKe/7w9sdUNvgZp3/+ixFCguShzE=;
	h=Date:To:From:Subject:Message-Id; b=FnpmVhKTpQ56soQ62ZSrUfRG9vZIdERs75Gk+3xvEc3hcGFSv8kLKdL1VUNX960/LZiixmGnmC+r7Ev+pcazw7OaProfTOm5ev5LTQotTVb+s/694BazhihGMDFEPbEE4kIGOuL5omx/ebQQ7kjhNhk8ItRWhgISewfzUlOS8Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UCiTb6GP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UCiTb6GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73F8C2BCB2;
	Wed,  1 Apr 2026 02:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775011404;
	bh=ZsrxAY69fyePntbeKe/7w9sdUNvgZp3/+ixFCguShzE=;
	h=Date:To:From:Subject:From;
	b=UCiTb6GP/nfMmWbPULT1QIR0YXo0CWTAGqn0TaFbzeL23rZYpG1lSBaXK0FHOBYSE
	 bbN72dEp3AqmJs74je5Wh3V3Qe61ELF8inzEMmAP/bVUG1vYg0B0E0zHEtIH9oHCHQ
	 f1YtGGxcpGE+RwSi59EEvvEAv4XPQ+ahqULpbGE8=
Date: Tue, 31 Mar 2026 19:43:23 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,kent.overstreet@linux.dev,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-alloc_tag-clear-codetag-for-pages-allocated-before-page_ext-initialization.patch added to mm-unstable branch
Message-Id: <20260401024323.E73F8C2BCB2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/alloc_tag: clear codetag for pages allocated before page_ext initialization
has been added to the -mm mm-unstable branch.  Its filename is
     mm-alloc_tag-clear-codetag-for-pages-allocated-before-page_ext-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-alloc_tag-clear-codetag-for-pages-allocated-before-page_ext-initialization.patch

This patch will later appear in the mm-unstable branch at
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
From: Hao Ge <hao.ge@linux.dev>
Subject: mm/alloc_tag: clear codetag for pages allocated before page_ext initialization
Date: Tue, 31 Mar 2026 16:13:12 +0800

Due to initialization ordering, page_ext is allocated and initialized
relatively late during boot.  Some pages have already been allocated and
freed before page_ext becomes available, leaving their codetag
uninitialized.

A clear example is in init_section_page_ext(): alloc_page_ext() calls
kmemleak_alloc().  If the slab cache has no free objects, it falls back to
the buddy allocator to allocate memory.  However, at this point page_ext
is not yet fully initialized, so these newly allocated pages have no
codetag set.  These pages may later be reclaimed by KASAN, which causes
the warning to trigger when they are freed because their codetag ref is
still empty.

Use a global array to track pages allocated before page_ext is fully
initialized.  The array size is fixed at 8192 entries, and will emit a
warning if this limit is exceeded.  When page_ext initialization
completes, set their codetag to empty to avoid warnings when they are
freed later.

This warning is only observed with CONFIG_MEM_ALLOC_PROFILING_DEBUG=Y and
mem_profiling_compressed disabled:

[    9.582133] ------------[ cut here ]------------
[    9.582137] alloc_tag was not set
[    9.582139] WARNING: ./include/linux/alloc_tag.h:164 at __pgalloc_tag_sub+0x40f/0x550, CPU#5: systemd/1
[    9.582190] CPU: 5 UID: 0 PID: 1 Comm: systemd Not tainted 7.0.0-rc4 #1 PREEMPT(lazy)
[    9.582192] Hardware name: Red Hat KVM, BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[    9.582194] RIP: 0010:__pgalloc_tag_sub+0x40f/0x550
[    9.582196] Code: 00 00 4c 29 e5 48 8b 05 1f 88 56 05 48 8d 4c ad 00 48 8d 2c c8 e9 87 fd ff ff 0f 0b 0f 0b e9 f3 fe ff ff 48 8d 3d 61 2f ed 03 <67> 48 0f b9 3a e9 b3 fd ff ff 0f 0b eb e4 e8 5e cd 14 02 4c 89 c7
[    9.582197] RSP: 0018:ffffc9000001f940 EFLAGS: 00010246
[    9.582200] RAX: dffffc0000000000 RBX: 1ffff92000003f2b RCX: 1ffff110200d806c
[    9.582201] RDX: ffff8881006c0360 RSI: 0000000000000004 RDI: ffffffff9bc7b460
[    9.582202] RBP: 0000000000000000 R08: 0000000000000000 R09: fffffbfff3a62324
[    9.582203] R10: ffffffff9d311923 R11: 0000000000000000 R12: ffffea0004001b00
[    9.582204] R13: 0000000000002000 R14: ffffea0000000000 R15: ffff8881006c0360
[    9.582206] FS:  00007ffbbcf2d940(0000) GS:ffff888450479000(0000) knlGS:0000000000000000
[    9.582208] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    9.582210] CR2: 000055ee3aa260d0 CR3: 0000000148b67005 CR4: 0000000000770ef0
[    9.582211] PKRU: 55555554
[    9.582212] Call Trace:
[    9.582213]  <TASK>
[    9.582214]  ? __pfx___pgalloc_tag_sub+0x10/0x10
[    9.582216]  ? check_bytes_and_report+0x68/0x140
[    9.582219]  __free_frozen_pages+0x2e4/0x1150
[    9.582221]  ? __free_slab+0xc2/0x2b0
[    9.582224]  qlist_free_all+0x4c/0xf0
[    9.582227]  kasan_quarantine_reduce+0x15d/0x180
[    9.582229]  __kasan_slab_alloc+0x69/0x90
[    9.582232]  kmem_cache_alloc_noprof+0x14a/0x500
[    9.582234]  do_getname+0x96/0x310
[    9.582237]  do_readlinkat+0x91/0x2f0
[    9.582239]  ? __pfx_do_readlinkat+0x10/0x10
[    9.582240]  ? get_random_bytes_user+0x1df/0x2c0
[    9.582244]  __x64_sys_readlinkat+0x96/0x100
[    9.582246]  do_syscall_64+0xce/0x650
[    9.582250]  ? __x64_sys_getrandom+0x13a/0x1e0
[    9.582252]  ? __pfx___x64_sys_getrandom+0x10/0x10
[    9.582254]  ? do_syscall_64+0x114/0x650
[    9.582255]  ? ksys_read+0xfc/0x1d0
[    9.582258]  ? __pfx_ksys_read+0x10/0x10
[    9.582260]  ? do_syscall_64+0x114/0x650
[    9.582262]  ? do_syscall_64+0x114/0x650
[    9.582264]  ? __pfx_fput_close_sync+0x10/0x10
[    9.582266]  ? file_close_fd_locked+0x178/0x2a0
[    9.582268]  ? __x64_sys_faccessat2+0x96/0x100
[    9.582269]  ? __x64_sys_close+0x7d/0xd0
[    9.582271]  ? do_syscall_64+0x114/0x650
[    9.582273]  ? do_syscall_64+0x114/0x650
[    9.582275]  ? clear_bhb_loop+0x50/0xa0
[    9.582277]  ? clear_bhb_loop+0x50/0xa0
[    9.582279]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    9.582280] RIP: 0033:0x7ffbbda345ee
[    9.582282] Code: 0f 1f 40 00 48 8b 15 29 38 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff c3 0f 1f 40 00 f3 0f 1e fa 49 89 ca b8 0b 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d fa 37 0d 00 f7 d8 64 89 01 48
[    9.582284] RSP: 002b:00007ffe2ad8de58 EFLAGS: 00000202 ORIG_RAX: 000000000000010b
[    9.582286] RAX: ffffffffffffffda RBX: 000055ee3aa25570 RCX: 00007ffbbda345ee
[    9.582287] RDX: 000055ee3aa25570 RSI: 00007ffe2ad8dee0 RDI: 00000000ffffff9c
[    9.582288] RBP: 0000000000001000 R08: 0000000000000003 R09: 0000000000001001
[    9.582289] R10: 0000000000001000 R11: 0000000000000202 R12: 0000000000000033
[    9.582290] R13: 00007ffe2ad8dee0 R14: 00000000ffffff9c R15: 00007ffe2ad8deb0
[    9.582292]  </TASK>
[    9.582293] ---[ end trace 0000000000000000 ]---

Link: https://lkml.kernel.org/r/20260331081312.123719-1-hao.ge@linux.dev
Fixes: dcfe378c81f72 ("lib: introduce support for page allocation tagging")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h   |    2 
 include/linux/pgalloc_tag.h |    2 
 lib/alloc_tag.c             |  109 ++++++++++++++++++++++++++++++++++
 mm/page_alloc.c             |   10 ++-
 4 files changed, 121 insertions(+), 2 deletions(-)

--- a/include/linux/alloc_tag.h~mm-alloc_tag-clear-codetag-for-pages-allocated-before-page_ext-initialization
+++ a/include/linux/alloc_tag.h
@@ -163,9 +163,11 @@ static inline void alloc_tag_sub_check(u
 {
 	WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
 }
+void alloc_tag_add_early_pfn(unsigned long pfn);
 #else
 static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag) {}
 static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
+static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
 #endif
 
 /* Caller should verify both ref and tag to be valid */
--- a/include/linux/pgalloc_tag.h~mm-alloc_tag-clear-codetag-for-pages-allocated-before-page_ext-initialization
+++ a/include/linux/pgalloc_tag.h
@@ -181,7 +181,7 @@ static inline struct alloc_tag *__pgallo
 
 	if (get_page_tag_ref(page, &ref, &handle)) {
 		alloc_tag_sub_check(&ref);
-		if (ref.ct)
+		if (ref.ct && !is_codetag_empty(&ref))
 			tag = ct_to_alloc_tag(ref.ct);
 		put_page_tag_ref(handle);
 	}
--- a/lib/alloc_tag.c~mm-alloc_tag-clear-codetag-for-pages-allocated-before-page_ext-initialization
+++ a/lib/alloc_tag.c
@@ -6,7 +6,9 @@
 #include <linux/kallsyms.h>
 #include <linux/module.h>
 #include <linux/page_ext.h>
+#include <linux/pgalloc_tag.h>
 #include <linux/proc_fs.h>
+#include <linux/rcupdate.h>
 #include <linux/seq_buf.h>
 #include <linux/seq_file.h>
 #include <linux/string_choices.h>
@@ -758,8 +760,115 @@ static __init bool need_page_alloc_taggi
 	return mem_profiling_support;
 }
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+/*
+ * Track page allocations before page_ext is initialized.
+ * Some pages are allocated before page_ext becomes available, leaving
+ * their codetag uninitialized. Track these early PFNs so we can clear
+ * their codetag refs later to avoid warnings when they are freed.
+ *
+ * Early allocations include:
+ *   - Base allocations independent of CPU count
+ *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_init,
+ *     such as trace ring buffers, scheduler per-cpu data)
+ *
+ * For simplicity, we fix the size to 8192.
+ * If insufficient, a warning will be triggered to alert the user.
+ *
+ * TODO: Replace fixed-size array with dynamic allocation using
+ * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
+ */
+#define EARLY_ALLOC_PFN_MAX		8192
+
+static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
+static atomic_t early_pfn_count __initdata = ATOMIC_INIT(0);
+
+static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
+{
+	int old_idx, new_idx;
+
+	do {
+		old_idx = atomic_read(&early_pfn_count);
+		if (old_idx >= EARLY_ALLOC_PFN_MAX) {
+			pr_warn_once("Early page allocations before page_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
+				      EARLY_ALLOC_PFN_MAX);
+			return;
+		}
+		new_idx = old_idx + 1;
+	} while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx));
+
+	early_pfns[old_idx] = pfn;
+}
+
+typedef void alloc_tag_add_func(unsigned long pfn);
+static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
+	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
+
+void alloc_tag_add_early_pfn(unsigned long pfn)
+{
+	alloc_tag_add_func *alloc_tag_add;
+
+	if (static_key_enabled(&mem_profiling_compressed))
+		return;
+
+	rcu_read_lock();
+	alloc_tag_add = rcu_dereference(alloc_tag_add_early_pfn_ptr);
+	if (alloc_tag_add)
+		alloc_tag_add(pfn);
+	rcu_read_unlock();
+}
+
+static void __init clear_early_alloc_pfn_tag_refs(void)
+{
+	unsigned int i;
+
+	if (static_key_enabled(&mem_profiling_compressed))
+		return;
+
+	rcu_assign_pointer(alloc_tag_add_early_pfn_ptr, NULL);
+	/* Make sure we are not racing with __alloc_tag_add_early_pfn() */
+	synchronize_rcu();
+
+	for (i = 0; i < atomic_read(&early_pfn_count); i++) {
+		unsigned long pfn = early_pfns[i];
+
+		if (pfn_valid(pfn)) {
+			struct page *page = pfn_to_page(pfn);
+			union pgtag_ref_handle handle;
+			union codetag_ref ref;
+
+			if (get_page_tag_ref(page, &ref, &handle)) {
+				/*
+				 * An early-allocated page could be freed and reallocated
+				 * after its page_ext is initialized but before we clear it.
+				 * In that case, it already has a valid tag set.
+				 * We should not overwrite that valid tag with CODETAG_EMPTY.
+				 *
+				 * Note: there is still a small race window between checking
+				 * ref.ct and calling set_codetag_empty(). We accept this
+				 * race as it's unlikely and the extra complexity of atomic
+				 * cmpxchg is not worth it for this debug-only code path.
+				 */
+				if (ref.ct) {
+					put_page_tag_ref(handle);
+					continue;
+				}
+
+				set_codetag_empty(&ref);
+				update_page_tag_ref(handle, &ref);
+				put_page_tag_ref(handle);
+			}
+		}
+
+	}
+}
+#else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
+static inline void __init clear_early_alloc_pfn_tag_refs(void) {}
+#endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
+
 static __init void init_page_alloc_tagging(void)
 {
+	clear_early_alloc_pfn_tag_refs();
 }
 
 struct page_ext_operations page_alloc_tagging_ops = {
--- a/mm/page_alloc.c~mm-alloc_tag-clear-codetag-for-pages-allocated-before-page_ext-initialization
+++ a/mm/page_alloc.c
@@ -1252,10 +1252,18 @@ void __pgalloc_tag_add(struct page *page
 	union pgtag_ref_handle handle;
 	union codetag_ref ref;
 
-	if (get_page_tag_ref(page, &ref, &handle)) {
+	if (likely(get_page_tag_ref(page, &ref, &handle))) {
 		alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
 		update_page_tag_ref(handle, &ref);
 		put_page_tag_ref(handle);
+	} else {
+		/*
+		 * page_ext is not available yet, record the pfn so we can
+		 * clear the tag ref later when page_ext is initialized.
+		 */
+		alloc_tag_add_early_pfn(page_to_pfn(page));
+		if (task->alloc_tag)
+			alloc_tag_set_inaccurate(task->alloc_tag);
 	}
 }
 
_

Patches currently in -mm which might be from hao.ge@linux.dev are

mm-alloc_tag-clear-codetag-for-pages-allocated-before-page_ext-initialization.patch

