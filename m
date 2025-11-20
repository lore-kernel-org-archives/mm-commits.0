Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBC6376BEE
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 15:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763653273; cv=none; b=Wsdqx1M0xDaBpC35fDFCzt7pvlqjxPZbUkDE9p/5ELmXbHbiKpvUPPqi+0RIH+8vzUBr66yVs87cxijE2mcyj+NAwBeiq7rfHdifxcfZNHfW26+IP9wGeW9+saPooGEJZT/mKihz48RfLE+bWevCi+7rErXKOTwYB+e+4r3n9Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763653273; c=relaxed/simple;
	bh=ZHFFTcP3YrO1+8/4QNkGhyeskQ4xYgb0waPmOq4EaVA=;
	h=Date:To:From:Subject:Message-Id; b=EBrVAOvmQhEK48nt5HFOYGp9xUAu2OSnsg+uOrYmoWFhtnc36WEHd/lT+kb7K7lHvD1oDA2M/TNS1rwf5/4XQgXglKeoOyf1Qbn2PoQ0+xKWLOU2q+DJQI/egrzozNxMUtljcVjIyVy048r2ttTFhPfLEZoBnXwBuZMsGGeJ7JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UzAgkVAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UzAgkVAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1B8C4CEF1;
	Thu, 20 Nov 2025 15:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763653272;
	bh=ZHFFTcP3YrO1+8/4QNkGhyeskQ4xYgb0waPmOq4EaVA=;
	h=Date:To:From:Subject:From;
	b=UzAgkVAmSY2A90CepxOlweaVebUBCfxu374zABk51en4VyI58ZrK+C2twffQBW9IR
	 kJAnXwmzut+Esgvm01mnpoRTHyOFKdcOPuVGYLivEqCdIkWARkpg3oaP1XNzf32/On
	 /TpK5OZN51PCYA+Cd/q+FC4wPk5PfpqhrbEH9ByM=
Date: Thu, 20 Nov 2025 07:41:11 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,changyuanl@google.com,catalin.marinas@arm.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-introduce-kmemleak_no_scan_phys-helper.patch added to mm-nonmm-unstable branch
Message-Id: <20251120154112.6F1B8C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmemleak: introduce kmemleak_no_scan_phys() helper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-kmemleak-introduce-kmemleak_no_scan_phys-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-introduce-kmemleak_no_scan_phys-helper.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: mm: kmemleak: introduce kmemleak_no_scan_phys() helper
Date: Thu, 20 Nov 2025 14:41:46 +0000

Patch series "liveupdate: Fix boot failure due to kmemleak access to
unmapped pages".

When booting with debug_pagealloc=on while having:
CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y  
CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n  
the system fails to boot due to page faults during kmemleak scanning.

Crash logs:
BUG: unable to handle page fault for address: ffff8880cd400000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 11de00067 P4D 11de00067 PUD 11af2b067 PMD 11aec1067 PTE 800fffff32bff020
Oops: Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
RIP: 0010:scan_block+0x43/0xb0
Call Trace:
 <TASK>
 scan_gray_list+0x2b5/0x2f0
 kmemleak_scan+0x3b1/0xcf0
 kmemleak_scan_thread+0x7d/0xc0
 kthread+0x11c/0x240
 ret_from_fork+0x2d3/0x370
 ret_from_fork_asm+0x11/0x20
 </TASK>

This occurs because:

With debug_pagealloc enabled, __free_pages() invokes
debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for freed
pages in the direct mapping.  Commit 3dc92c311498 ("kexec: add Kexec
HandOver (KHO) generation helpers") releases the KHO scratch region via
init_cma_reserved_pageblock(), unmapping its physical pages.  Subsequent
kmemleak scanning accesses these unmapped pages, triggering fatal page
faults.

This patch introduces kmemleak_no_scan_phys(phys_addr_t), a
physical-address variant of kmemleak_no_scan(), which marks memblock
regions as OBJECT_NO_SCAN.

We invoke this from kho_reserve_scratch() to exclude the reserved
region from scanning before it is released to the buddy allocator.


This patch (of 2):

Introduce kmemleak_no_scan_phys(phys_addr_t), a physical-address variant
to kmemleak_no_scan().  This helper marks memory regions as non-scanable
using physical addresses directly.

It is specifically designed to prevent kmemleak from accessing pages that
have been unmapped by debug_pagealloc after being freed to the buddy
allocator.  The kexec handover (KHO) subsystem will call this helper to
exclude the kho_scratch reservation region from scanning, thereby avoiding
fatal page faults during boot when debug_pagealloc=on.

Link: https://lkml.kernel.org/r/20251120144147.90508-3-ranxiaokai627@163.com
Link: https://lkml.kernel.org/r/20251120144147.90508-2-ranxiaokai627@163.com
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Alexander Graf <graf@amazon.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmemleak.h |    4 ++++
 mm/kmemleak.c            |   15 ++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/include/linux/kmemleak.h~mm-kmemleak-introduce-kmemleak_no_scan_phys-helper
+++ a/include/linux/kmemleak.h
@@ -31,6 +31,7 @@ extern void kmemleak_ignore(const void *
 extern void kmemleak_ignore_percpu(const void __percpu *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
 extern void kmemleak_no_scan(const void *ptr) __ref;
+extern void kmemleak_no_scan_phys(phys_addr_t phys) __ref;
 extern void kmemleak_alloc_phys(phys_addr_t phys, size_t size,
 				gfp_t gfp) __ref;
 extern void kmemleak_free_part_phys(phys_addr_t phys, size_t size) __ref;
@@ -113,6 +114,9 @@ static inline void kmemleak_erase(void *
 static inline void kmemleak_no_scan(const void *ptr)
 {
 }
+static inline void kmemleak_no_scan_phys(phys_addr_t phys)
+{
+}
 static inline void kmemleak_alloc_phys(phys_addr_t phys, size_t size,
 				       gfp_t gfp)
 {
--- a/mm/kmemleak.c~mm-kmemleak-introduce-kmemleak_no_scan_phys-helper
+++ a/mm/kmemleak.c
@@ -1058,12 +1058,12 @@ static void object_set_excess_ref(unsign
  * pointer. Such object will not be scanned by kmemleak but references to it
  * are searched.
  */
-static void object_no_scan(unsigned long ptr)
+static void object_no_scan_flags(unsigned long ptr, unsigned long objflags)
 {
 	unsigned long flags;
 	struct kmemleak_object *object;
 
-	object = find_and_get_object(ptr, 0);
+	object = __find_and_get_object(ptr, 0, objflags);
 	if (!object) {
 		kmemleak_warn("Not scanning unknown object at 0x%08lx\n", ptr);
 		return;
@@ -1328,10 +1328,19 @@ void __ref kmemleak_no_scan(const void *
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
 	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
-		object_no_scan((unsigned long)ptr);
+		object_no_scan_flags((unsigned long)ptr, 0);
 }
 EXPORT_SYMBOL(kmemleak_no_scan);
 
+void __ref kmemleak_no_scan_phys(phys_addr_t phys)
+{
+	pr_debug("%s(%pap)\n", __func__, &phys);
+
+	if (kmemleak_enabled)
+		object_no_scan_flags((unsigned long)phys, OBJECT_PHYS);
+}
+EXPORT_SYMBOL(kmemleak_no_scan_phys);
+
 /**
  * kmemleak_alloc_phys - similar to kmemleak_alloc but taking a physical
  *			 address argument
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

mm-kmemleak-introduce-kmemleak_no_scan_phys-helper.patch
liveupdate-fix-boot-failure-due-to-kmemleak-access-to-unmapped-pages.patch

