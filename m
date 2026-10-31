Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793405979;
	b=BiOmqQJ00Oz8rQFbNBdHc1ZqwD2B2+ido3i7KvxD5hJ0ArMKBy2DbZKbl+FuLtGaKiZ8
	 oBpPJYLO/ezTEkiAtG8psUIupBQOXp5j4TpaDim/OI7vC0xLyz4X4l4sctoOdtTaqg7iM
	 4hGdnZBNJxEmX2Ghw41qHb+Onj2jCW/K20LFSsUCeHuk61tz7zCGmBPdt9DpRCiIV37YO
	 l0OuaoLR0I6rHjjwWzWoHilenraXu5vdM8GB3pTKd8tKPofPWp5z93bGzHr0+HjOEb8KI
	 Lm5VJZo7uMVCKSNhxgPGXG3Ot8aahS+sIGUptp4/1xbGqyCC2rrVapAaPXY0N2D22Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793405979;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=CoxRJCGgHAdWhtT+3yHf7zxhhnP4/DZnnHhAyVHTi3s=;
	b=etiG1IvzlVKg0NbRzXy/7DhphkUt+Ebu6ONlMbO30mKe3D2Dgr4E0autiGwqfe7y34cv
	 T7QDoG2QNqgY+5oTjY09iqtu0rGgERziH+oiN1ypul2CoWF/fcLqw/766vxytLZ1CP/fn
	 s4MDCMyTZw0rjIantUW/j/EEbFc/qnjQpl0dYEK50rht5VXs4IRiex5ftBg1iAFXP1YDn
	 znXb26Qig5Me2BR4aoFvCDcAElyHCrE1vSiaA6vQPAvWKGSHISURVm6wvKdb4hajy59nH
	 eM3v1A6RVSp05gR3XdnPR7ioNGda1kQn/fSTwSW3GQL9NtnEqt4xOnlNO5UefqW8iHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FE0q87lV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D58F606A31A
	for <mm-commits@vger.kernel.org>; Sat, 31 Oct 2026 00:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FE0q87lV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC98D1F000C1;
	Sat, 31 Oct 2026 00:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793405978;
	bh=CoxRJCGgHAdWhtT+3yHf7zxhhnP4/DZnnHhAyVHTi3s=;
	h=Date:To:From:Subject;
	b=FE0q87lVj8/YQqj2CYNJgv2AINUue9QypOVqmTOrGl8MWKXDGZPL0LxLq0daaAu0U
	 vCXe/9KzRbgs1ktjqoUz90RK1nt6g56tauVWCVRI7JtfLfNjGMuGtAYXsFNdZObxa9
	 VQuwKF7gOzvaSVUJ6ydgpgzM5eCn9uGSMdP1s/Lg=
Date: Fri, 30 Oct 2026 17:19:38 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,pavel@kernel.org,
	lenb@kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,
	david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hibernation-make-hibernation-unavailable-when-debug_pagealloc-is-on.patch added to mm-nonmm-unstable branch
Message-Id: <20261031001938.BC98D1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: hibernation: make hibernation unavailable when debug_pagealloc is on
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hibernation-make-hibernation-unavailable-when-debug_pagealloc-is-on.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hibernation-make-hibernation-unavailable-when-debug_pagealloc-is-on.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: hibernation: make hibernation unavailable when debug_pagealloc is on
Date: Sat, 26 Sep 2026 12:26:34 +0300

Back in 2008 when commit 8a235efad548a ("Hibernation: Handle
DEBUG_PAGEALLOC on x86") enabled coexistence of hibernation and
DEBUG_PAGEALLOC, the world was simpler, the combination was only supported
on x86 and a non-present page in the direct map meant that the page was
free and debug_pagealloc removed its mapping.

Nowadays there are more architectures with inconsistent views of how the
direct map should be managed, there are more debug mechanisms in MM that
can either drop a page from the direct map (e.g. KFENCE) or require that a
page must be mapped immediately after resume (e.g. init_on_free).

The latter constraint is particularly nasty, because enabling
debug_pagealloc and PAGE_POISON at the same time simply breaks resume:

  BUG: unable to handle page fault for address: ffff888000100000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD 4f0c067 P4D 4f0c067 PUD 4f0d067 PMD 4f0e067 PTE 800fffffffeff020
  Oops: Oops: 0002 [#1] SMP DEBUG_PAGEALLOC NOPTI
  CPU: 0 UID: 0 PID: 477 Comm: bash Not tainted 7.3.0-rc3-00090-g4a613f1d9124 #1 PREEMPT(full)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
  RIP: 0010:__kernel_poison_pages+0x45/0x70
  Code: 89 fa 48 c1 e6 06 48 01 fe 48 89 d1 48 2b 0d 9a ed 87 01 48 83 c2 40 48 c1 f9 06 48 c1 e1 0c 48 03 0d 97 ed 87 01 48 8d 79 08 <48> 89 01 48 83 e7 f8 48 89 81 f8 0f 00 00 48 29 f9 81 c1 00 10 00
  RSP: 0018:ffffc900017dfd78 EFLAGS: 00010086
  RAX: aaaaaaaaaaaaaaaa RBX: 0000000000000000 RCX: ffff888000100000
  RDX: ffffea0000004040 RSI: ffffea0000004040 RDI: ffff888000100008
  RBP: 0000000000000000 R08: ffff888130fcada0 R09: 00000000723e0de4
  R10: 0000000096ad9215 R11: 00000000db907bcf R12: 0000000000000005
  R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000
  FS:  00007f8f2243e780(0000) GS:ffff8882e8e13000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff888000100000 CR3: 0000000140679000 CR4: 0000000000750ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   clear_or_poison_free_pages+0xd1/0xe0
   hibernation_snapshot+0x548/0x5a0
   hibernate.cold+0xcb/0x321
   state_store+0xc3/0xd0
   kernfs_fop_write_iter+0x163/0x240
   vfs_write+0x21f/0x550
   ksys_write+0x70/0xf0
   do_syscall_64+0xb1/0x590
   ? __irq_exit_rcu+0x40/0x110
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7f8f224d0687
  Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
  RSP: 002b:00007ffe7bbe0910 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
  RAX: ffffffffffffffda RBX: 00007f8f2243e780 RCX: 00007f8f224d0687
  RDX: 0000000000000005 RSI: 000055e3e53135d0 RDI: 0000000000000001
  RBP: 000055e3e53135d0 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000005
  R13: 00007f8f226295c0 R14: 00007f8f22626e80 R15: 0000000000000000
   </TASK>
  Modules linked in:
  CR2: ffff888000100000

It's possible to build a complex infrastructure involving a new page flag
and/or page_type to allow robust hibernation and restore with
debug_pagealloc enabled.

This infrastructure requires a proper detection whether it is safe to
temporarily remap a page to include it in the hibernation snapshot because
relying on kernel_page_present() is too permissive and may include pages
that were deliberately removed from the direct map for security reasons.

This complexity does not seem justified to deal with an esoteric use case
of hibernating a system that runs with debug_pagealloc enabled.

Make hibernation unavailable when debug_pagealloc is enabled and simplify
hibernate_{map,unmap}_page() that don't need to deal with debug_pagealloc
anymore.

Link: https://lore.kernel.org/20260926-hibernation-v2-5-235f69f3ab2a@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@kernel.org>
---

 kernel/power/hibernate.c |    1 +
 kernel/power/snapshot.c  |   31 +++++--------------------------
 2 files changed, 6 insertions(+), 26 deletions(-)

--- a/kernel/power/hibernate.c~hibernation-make-hibernation-unavailable-when-debug_pagealloc-is-on
+++ a/kernel/power/hibernate.c
@@ -116,6 +116,7 @@ bool hibernation_available(void)
 	return nohibernate == 0 &&
 		!security_locked_down(LOCKDOWN_HIBERNATION) &&
 		!secretmem_active() && !cxl_mem_active() &&
+		!debug_pagealloc_enabled() &&
 		arch_hibernation_available();
 }
 
--- a/kernel/power/snapshot.c~hibernation-make-hibernation-unavailable-when-debug_pagealloc-is-on
+++ a/kernel/power/snapshot.c
@@ -85,12 +85,7 @@ static inline int hibernate_map_page(str
 	if (is_kfence_address(page_address(page)))
 		return kfence_force_mapping(page) ? 0 : -EFAULT;
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
-		return set_direct_map_default_noflush(page, 1);
-	} else {
-		debug_pagealloc_map_pages(page, 1);
-		return 0;
-	}
+	return 0;
 }
 
 static inline int hibernate_unmap_page(struct page *page)
@@ -98,17 +93,6 @@ static inline int hibernate_unmap_page(s
 	if (is_kfence_address(page_address(page)))
 		return kfence_reset_mapping(page) ? 0 : -EFAULT;
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
-		unsigned long addr = (unsigned long)page_address(page);
-		int ret  = set_direct_map_invalid_noflush(page, 1);
-
-		if (ret)
-			return ret;
-
-		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
-	} else {
-		debug_pagealloc_unmap_pages(page, 1);
-	}
 	return 0;
 }
 
@@ -1446,10 +1430,10 @@ static inline bool do_copy_page(long *ds
 /*
  * safe_copy_page - Copy a page in a safe way.
  *
- * Check if the page we are going to copy is marked as present in the kernel
- * page tables. This always is the case if CONFIG_DEBUG_PAGEALLOC or
- * CONFIG_ARCH_HAS_SET_DIRECT_MAP is not set. In that case kernel_page_present()
- * always returns 'true'.
+ * Page could be not present in the kernel page tables. Try to map it before
+ * copiyng and unmap back as needed.
+ * If the kernel page table update fails, bail out with an error.
+ *
  * Sets @zeros_only to true if the page was entirely composed of zeros.
  *
  * Returns 0 on success, a negative error code on failure.
@@ -1458,11 +1442,6 @@ static int safe_copy_page(void *dst, str
 {
 	int err;
 
-	if (kernel_page_present(s_page)) {
-		*zeros_only = do_copy_page(dst, page_address(s_page));
-		return 0;
-	}
-
 	err = hibernate_map_page(s_page);
 	if (err)
 		return err;
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-cma-accept-memory-of-multi-range-cma-areas.patch
mm-cma-accept-memory-of-cma-areas-reserved-at-a-fixed-address.patch
hibernation-make-swsusp_page-helpers-static.patch
hibernation-ensure-secretmem-pages-dont-reach-a-snapshot.patch
hibernate-handle-potential-errors-in-hibernate_mapunmap_page.patch
hibernation-kfence-explicitly-map-unmap-kfence-pages.patch
hibernation-make-hibernation-unavailable-when-debug_pagealloc-is-on.patch

