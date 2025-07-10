Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574371A285;
	Thu, 10 Jul 2025 04:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120558; cv=none; b=RgxWngxfxuLvmJeEjmxqu0GwhZMD/M1+XBVUgFdVUUPHoV1wxc+fE+nLhU3Iemgitkos/SGyrDGRADUVRPcMA5WwC6ojy6jY54AqpaElzM7UFOjORV0d3XMW0T1jXTm+tuQCFN3udEloTk/W6Z287XtANdFgp+kIsQGWlDQ29x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120558; c=relaxed/simple;
	bh=lnU2YcXxXdDssmJGrKSLvPBl19D1HS4ZMB9kCoBG4KA=;
	h=Date:To:From:Subject:Message-Id; b=MJov/52j2zz1vLwv3z6+MuqRNDE2vsX+69uiyWJVhd9yQbSv8QsS3rzVPR+w5vJWUZmRJaGsfkBB83WdLK0VXWN55FjcBggA4GlhtZaHD1nZViloGmjyXjRK3MMGelhKEXiDepUTFiMDfRGJh+3h3uvcey03ViMCMFMYeW0pkEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YaWnubM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YaWnubM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF2CC4CEE3;
	Thu, 10 Jul 2025 04:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120558;
	bh=lnU2YcXxXdDssmJGrKSLvPBl19D1HS4ZMB9kCoBG4KA=;
	h=Date:To:From:Subject:From;
	b=YaWnubM6XLrvNr6cx+OW1V5C1aykJQvlXYmqIo4MKTWQhj7lqqwhqDrI0a73M7bDt
	 8y7CvXmsAYWRdU/E2n6XYAmpZCzAALRKwEnwihYlsZmXhSZ4DCbd5bTkgE1QoFfF8e
	 p/Za/Hzk/O4amcL1TEk/Vjnv/VjbVErx2913J1/8=
Date: Wed, 09 Jul 2025 21:09:17 -0700
To: mm-commits@vger.kernel.org,ysk@kzalloc.com,vincenzo.frascino@arm.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,rostedt@goodmis.org,glider@google.com,dvyukov@google.com,byungchul@sk.com,bigeasy@linutronix.de,andreyknvl@gmail.com,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-remove-kasan_find_vm_area-to-prevent-possible-deadlock.patch removed from -mm tree
Message-Id: <20250710040918.2CF2CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: remove kasan_find_vm_area() to prevent possible deadlock
has been removed from the -mm tree.  Its filename was
     kasan-remove-kasan_find_vm_area-to-prevent-possible-deadlock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
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


