Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1571025A333;
	Thu,  3 Jul 2025 20:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751574951; cv=none; b=KxT2tyd8sVWqt/GpT3mX15Rv5Fkoa7+Nb+IEos2sPWnLNfXLSoEkVUQ8HFhphlsLynMm18na3BF3VmWMMBk5ix1GZtLN04R/PofHnnUEEuD8YrzluYr2+6+1+4UBlxMPrS0n9ETE8O7ayhtTCEMwYRlNkv7YxJdHPYQJu23rwk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751574951; c=relaxed/simple;
	bh=wcCeWL9cnkFn3jH/2S0OjNOIlT2v4H09COjmuUme2cg=;
	h=Date:To:From:Subject:Message-Id; b=VZJvRk38+OPSxr5TmQfR1L3VPB/Es8r5eZVBUj9rXXDnXQTy12eG4RnGNxGHRfbLMPHYJPrLsUT9zqo1YO7oB0IMLvdEyHcD5PYBBzGOsMg4KCQnw0+4r7Zf4jGDBGJ9Rfu6CmyRSBFVnflxeIR0G0aDUHcZ7e2r0HsAoa9bgyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xsU4PSTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xsU4PSTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7EAC4CEE3;
	Thu,  3 Jul 2025 20:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751574950;
	bh=wcCeWL9cnkFn3jH/2S0OjNOIlT2v4H09COjmuUme2cg=;
	h=Date:To:From:Subject:From;
	b=xsU4PSTh3/vGcf+ui9Sxr0zMGbHG3vZsSahG5dRB/ndRoceHqWMrTLGxiaBAuv6GF
	 rNRO7GlxMR+4BqxQ/2L0tWVU5lCEyu26NhC/spgJL5ZEL4mRDXy0zg3iHpcD3SqRHW
	 oLtKhKSzL1eHc51OWoNrPP7C5eu44YbkOrVlSswQ=
Date: Thu, 03 Jul 2025 13:35:49 -0700
To: mm-commits@vger.kernel.org,ysk@kzalloc.com,vincenzo.frascino@arm.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,rostedt@goodmis.org,glider@google.com,dvyukov@google.com,byungchul@sk.com,bigeasy@linutronix.de,andreyknvl@gmail.com,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-remove-kasan_find_vm_area-to-prevent-possible-deadlock.patch added to mm-hotfixes-unstable branch
Message-Id: <20250703203550.8B7EAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: remove kasan_find_vm_area() to prevent possible deadlock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-remove-kasan_find_vm_area-to-prevent-possible-deadlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-remove-kasan_find_vm_area-to-prevent-possible-deadlock.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kasan: remove kasan_find_vm_area() to prevent possible deadlock
Date: Thu, 3 Jul 2025 19:10:18 +0100

find_vm_area() couldn't be called in atomic_context.  If find_vm_area() is
called to reports vm area information, kasan can trigger deadlock like:

CPU0                                CPU1
vmalloc();
 alloc_vmap_area();
  spin_lock(&vn->busy.lock)
                                    spin_lock_bh(&some_lock);
   <interrupt occurs>
   <in softirq>
   spin_lock(&some_lock);
                                    <access invalid address>
                                    kasan_report();
                                     print_report();
                                      print_address_description();
                                       kasan_find_vm_area();
                                        find_vm_area();
                                         spin_lock(&vn->busy.lock) // deadlock!

To prevent possible deadlock while kasan reports, remove kasan_find_vm_area().

Link: https://lkml.kernel.org/r/20250703181018.580833-1-yeoreum.yun@arm.com
Fixes: c056a364e954 ("kasan: print virtual mapping info in reports")
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reported-by: Yunseong Kim <ysk@kzalloc.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   45 +-------------------------------------------
 1 file changed, 2 insertions(+), 43 deletions(-)

--- a/mm/kasan/report.c~kasan-remove-kasan_find_vm_area-to-prevent-possible-deadlock
+++ a/mm/kasan/report.c
@@ -370,36 +370,6 @@ static inline bool init_task_stack_addr(
 			sizeof(init_thread_union.stack));
 }
 
-/*
- * This function is invoked with report_lock (a raw_spinlock) held. A
- * PREEMPT_RT kernel cannot call find_vm_area() as it will acquire a sleeping
- * rt_spinlock.
- *
- * For !RT kernel, the PROVE_RAW_LOCK_NESTING config option will print a
- * lockdep warning for this raw_spinlock -> spinlock dependency. This config
- * option is enabled by default to ensure better test coverage to expose this
- * kind of RT kernel problem. This lockdep splat, however, can be suppressed
- * by using DEFINE_WAIT_OVERRIDE_MAP() if it serves a useful purpose and the
- * invalid PREEMPT_RT case has been taken care of.
- */
-static inline struct vm_struct *kasan_find_vm_area(void *addr)
-{
-	static DEFINE_WAIT_OVERRIDE_MAP(vmalloc_map, LD_WAIT_SLEEP);
-	struct vm_struct *va;
-
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		return NULL;
-
-	/*
-	 * Suppress lockdep warning and fetch vmalloc area of the
-	 * offending address.
-	 */
-	lock_map_acquire_try(&vmalloc_map);
-	va = find_vm_area(addr);
-	lock_map_release(&vmalloc_map);
-	return va;
-}
-
 static void print_address_description(void *addr, u8 tag,
 				      struct kasan_report_info *info)
 {
@@ -429,19 +399,8 @@ static void print_address_description(vo
 	}
 
 	if (is_vmalloc_addr(addr)) {
-		struct vm_struct *va = kasan_find_vm_area(addr);
-
-		if (va) {
-			pr_err("The buggy address belongs to the virtual mapping at\n"
-			       " [%px, %px) created by:\n"
-			       " %pS\n",
-			       va->addr, va->addr + va->size, va->caller);
-			pr_err("\n");
-
-			page = vmalloc_to_page(addr);
-		} else {
-			pr_err("The buggy address %px belongs to a vmalloc virtual mapping\n", addr);
-		}
+		pr_err("The buggy address %px belongs to a vmalloc virtual mapping\n", addr);
+		page = vmalloc_to_page(addr);
 	}
 
 	if (page) {
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kasan-remove-kasan_find_vm_area-to-prevent-possible-deadlock.patch

