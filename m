Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793405970;
	b=f+0cPfm9bWNcdSTDbMK3Q5Ecs+8IOPR+PxWkTgcnGfXihbYU1fVzG+2Vt/1dM/NBkCCl
	 RKTKQrOXjB7pGvFdWt53rgzs7W3muBpltPOs1/Q2acX3+rrNcWXewvmzjJmMxpEyuZgOW
	 pztL5LjIeCHj0d77K+JAqfVJskZIPMUsFlo1zV6HRSTN/SvH9FMbdObRhqVkWic2bH5IJ
	 wHb8cv2SlhOkF9r2RHJ3Iqj59ndfysj+dOoHjkAPmSr7TOQ21FvQshPZ1u6nFiZg5tq3/
	 0jojI5ApNqiTz8h4CXIpbd3OdchNBgRXkywIKOOCVRQoJgydD8S7c9B78c6kKzieIhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793405970;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=vCBEqmJmB4yHixwdW7j1F/u+RmZ9CtmI45VNfNm/9OQ=;
	b=RXy1Zh2C5+kx0InnNMQqk9nGtAvPKXPW79zu3cjeWLijfgzCS+B3AX14wurJQFkdl7xc
	 ObkAfvOZ/ZQQbreVryGV5p6NqVVxC9f0NHy1VSJBxk3IAFwkO+HgSMts3HJa5h+AV1yaS
	 gOSs8pxuhRNJyStSsnzLcz33eqKwMzPwGt9yXS/524jtaWCB2A2yj8uf5+T6UVrwwa/9Q
	 kzQWRbEpR89AR36py7iMs5xpZ8HDGbGjMLmCgQXU7vSX3DboOtL6/PvCXSylXBrjbhefs
	 1bh8Gul29V40uN6pagpSDISfk78MNvWNGE2DDWf6OfvSpGX5OEdUfiR/rtBaORu1hew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iFoWKWoB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FD4606A31C
	for <mm-commits@vger.kernel.org>; Sat, 31 Oct 2026 00:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iFoWKWoB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9821F000C1;
	Sat, 31 Oct 2026 00:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793405969;
	bh=vCBEqmJmB4yHixwdW7j1F/u+RmZ9CtmI45VNfNm/9OQ=;
	h=Date:To:From:Subject;
	b=iFoWKWoBHKNJ5iyoIKGx4j3Wmdhkjtg77TYlT9v0tutwBpB9gHLyr/v/WCdf/gMkz
	 e1RX/X2ndRq7Xep+AobvLy23bbgZZrZjiUt+gr+6lnQ5pVE51zP8Ubn9tElszfh60u
	 K3hdGluvZeHBKAaxaR0yXo6YCckOjU9tie/LPf8w=
Date: Fri, 30 Oct 2026 17:19:29 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,pavel@kernel.org,
	lenb@kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,
	david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hibernation-make-swsusp_page-helpers-static.patch added to mm-nonmm-unstable branch
Message-Id: <20261031001929.6E9821F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: hibernation: make swsusp_page helpers static
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hibernation-make-swsusp_page-helpers-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hibernation-make-swsusp_page-helpers-static.patch

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
Subject: hibernation: make swsusp_page helpers static
Date: Sat, 26 Sep 2026 12:26:30 +0300

Patch series "hibernation: make safe_copy_page more robust and remove
debug_pagealloc support", v2.

When hibernation creates a memory image, it uses set_direct_map() APIs to
temporarily map pages that are marked as not present in the kernel page
tables.

Initially, this was intended to support debug_pagealloc along with
hibernation on x86.

With the increasing desire to use set_direct_map APIs for hardening
features and with their inconsistent implementations across architectures,
using kernel_page_present() + set_direct_map_valid_noflush() to save
non-present pages in the hibernation image is not very safe, to say the
least.

Worse, some combinations of debug features, such as debug_pagealloc and
PAGE_POISON cause a crash during restore.

Keeping debug_pagealloc compatible with hibernation requires a complex
infrastructure for tracking free unmapped pages with a page flag/page type,
verifying that it is actually a free page that hibernate_map_page() tries
to remap and making sure there are no stale or failed page table updates.
With init_on_{alloc,free} and/or PAGE_POISON on top, this also requires the
ability to map and initialize these free pages on restore.

This complexity does not seem justified for a somewhat niche debugging
scenario.

Instead of a complex fix to support hibernation with debug_pagealloc, make
sure that copy_data_pages() and its helpers properly handle errors that may
happen during page table updates, explicitly enable saving of KFENCE pages
and disallow hibernation when debug_pagealloc is enabled.


This patch (of 5):

Since commit 31a1b9d7fe768 ("mm: page_alloc: move mark_free_page() into
snapshot.c") several helpers that set, clear and query free and forbidden
page status are only used inside kernel/power/snapshot.c

Make them static and add necessary forward declarations near the existing
declarations of similar helpers.

Link: https://lore.kernel.org/20260926-hibernation-v2-0-235f69f3ab2a@kernel.org
Link: https://lore.kernel.org/20260926-hibernation-v2-1-235f69f3ab2a@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@kernel.org>
---

 include/linux/suspend.h |    6 ------
 kernel/power/snapshot.c |   15 +++++++++------
 2 files changed, 9 insertions(+), 12 deletions(-)

--- a/include/linux/suspend.h~hibernation-make-swsusp_page-helpers-static
+++ a/include/linux/suspend.h
@@ -381,9 +381,6 @@ struct platform_hibernation_ops {
 #ifdef CONFIG_HIBERNATION
 /* kernel/power/snapshot.c */
 extern void register_nosave_region(unsigned long b, unsigned long e);
-extern int swsusp_page_is_forbidden(struct page *);
-extern void swsusp_set_page_free(struct page *);
-extern void swsusp_unset_page_free(struct page *);
 extern unsigned long get_safe_page(gfp_t gfp_mask);
 extern asmlinkage int swsusp_arch_suspend(void);
 extern asmlinkage int swsusp_arch_resume(void);
@@ -405,9 +402,6 @@ bool arch_hibernation_available(void);
 
 #else /* CONFIG_HIBERNATION */
 static inline void register_nosave_region(unsigned long b, unsigned long e) {}
-static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
-static inline void swsusp_set_page_free(struct page *p) {}
-static inline void swsusp_unset_page_free(struct page *p) {}
 
 static inline void hibernation_set_ops(const struct platform_hibernation_ops *ops) {}
 static inline int hibernate(void) { return -ENOSYS; }
--- a/kernel/power/snapshot.c~hibernation-make-swsusp_page-helpers-static
+++ a/kernel/power/snapshot.c
@@ -112,9 +112,12 @@ static inline void hibernate_unmap_page(
 	}
 }
 
-static int swsusp_page_is_free(struct page *);
-static void swsusp_set_page_forbidden(struct page *);
-static void swsusp_unset_page_forbidden(struct page *);
+static int swsusp_page_is_free(struct page *page);
+static void swsusp_set_page_free(struct page *page);
+static void swsusp_unset_page_free(struct page *page);
+static int swsusp_page_is_forbidden(struct page *page);
+static void swsusp_set_page_forbidden(struct page *page);
+static void swsusp_unset_page_forbidden(struct page *page);
 
 /*
  * Number of bytes to reserve for memory allocations made by device drivers
@@ -1036,7 +1039,7 @@ static struct memory_bitmap *free_pages_
  * corresponding bits in forbidden_pages_map and free_pages_map simultaneously
  */
 
-void swsusp_set_page_free(struct page *page)
+static void swsusp_set_page_free(struct page *page)
 {
 	if (free_pages_map)
 		memory_bm_set_bit(free_pages_map, page_to_pfn(page));
@@ -1048,7 +1051,7 @@ static int swsusp_page_is_free(struct pa
 		memory_bm_test_bit(free_pages_map, page_to_pfn(page)) : 0;
 }
 
-void swsusp_unset_page_free(struct page *page)
+static void swsusp_unset_page_free(struct page *page)
 {
 	if (free_pages_map)
 		memory_bm_clear_bit(free_pages_map, page_to_pfn(page));
@@ -1060,7 +1063,7 @@ static void swsusp_set_page_forbidden(st
 		memory_bm_set_bit(forbidden_pages_map, page_to_pfn(page));
 }
 
-int swsusp_page_is_forbidden(struct page *page)
+static int swsusp_page_is_forbidden(struct page *page)
 {
 	return forbidden_pages_map ?
 		memory_bm_test_bit(forbidden_pages_map, page_to_pfn(page)) : 0;
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-cma-accept-memory-of-multi-range-cma-areas.patch
mm-cma-accept-memory-of-cma-areas-reserved-at-a-fixed-address.patch
hibernation-make-swsusp_page-helpers-static.patch
hibernation-ensure-secretmem-pages-dont-reach-a-snapshot.patch
hibernate-handle-potential-errors-in-hibernate_mapunmap_page.patch
hibernation-kfence-explicitly-map-unmap-kfence-pages.patch
hibernation-make-hibernation-unavailable-when-debug_pagealloc-is-on.patch

