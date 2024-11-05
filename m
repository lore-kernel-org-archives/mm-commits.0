Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D72FDF5C
	for <mm-commits@vger.kernel.org>; Tue,  5 Nov 2024 03:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730775645; cv=none; b=k3puuFxcJmqASNy1X5EsNtObsQSNXWUg1QnKYNutLoonXqHOjrXGGLVVhLggx+VvAUYEw4QH4WkonG/5V2CYmSn/0OruzrECnabcKJfgedBNw+ohrMhN40tU9Wt9Qyie0+aUYtw471fCzg9gOOGTXKanhIXIh+anI25gaKZqqsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730775645; c=relaxed/simple;
	bh=OjWtRGWT32tfMKm2dsEjnEbtiWwLbg2yiALpO7jvdB0=;
	h=Date:To:From:Subject:Message-Id; b=aLrviaPANcq9V9C6CHnMqX4zVyVM7cN+F1BG0T6W1ApRF2HVByTGoWP+FwlY4hLqr0GLVZEKNyDiokIje3ErT515h5qWCkDfi/ayzm3yZI8ErJVNVazXBDlj5U1GGTI5mJ8euB9sX+/pT20/XAbeRyhBRYDSzZDqZhmz+Ret3L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fUVSFtzs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fUVSFtzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109C8C4CECE;
	Tue,  5 Nov 2024 03:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730775645;
	bh=OjWtRGWT32tfMKm2dsEjnEbtiWwLbg2yiALpO7jvdB0=;
	h=Date:To:From:Subject:From;
	b=fUVSFtzsK05gSnjJvScqOyrVzts0MucA0aBL7o3bCeAOK/LxMff9c0Ajy+wzIxrht
	 sTB7L4Ij0m8XLpIvSOZN1UQT3HYh2MdDYQ6FtWZSaQNkJI5nKsDTRuLhDtKP3ZvPAe
	 1GNQvR7naxKWI0AXGdUz6W6SS4mUbwTN8BFDEX8Y=
Date: Mon, 04 Nov 2024 19:00:44 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,robin.murphy@arm.com,joro@8bytes.org,idosch@nvidia.com,idosch@idosch.org,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmemleak-iommu-iova-fix-transient-kmemleak-false-positive.patch added to mm-unstable branch
Message-Id: <20241105030045.109C8C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmemleak: iommu/iova: fix transient kmemleak false positive
has been added to the -mm mm-unstable branch.  Its filename is
     kmemleak-iommu-iova-fix-transient-kmemleak-false-positive.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmemleak-iommu-iova-fix-transient-kmemleak-false-positive.patch

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
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: kmemleak: iommu/iova: fix transient kmemleak false positive
Date: Mon, 4 Nov 2024 11:19:44 +0000

The introduction of iova_depot_pop() in 911aa1245da8 ("iommu/iova: Make
the rcache depot scale better") confused kmemleak by moving a struct
iova_magazine object from a singly linked list to rcache->depot and
resetting the 'next' pointer referencing it.  Unlike doubly linked lists,
the content of the object being referred is never changed on removal from
a singly linked list and the kmemleak checksum heuristics do not detect
such scenario.  This leads to false positives like:

unreferenced object 0xffff8881a5301000 (size 1024):
  comm "softirq", pid 0, jiffies 4306297099 (age 462.991s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 e7 7d 05 00 00 00 00 00  .........}......
    0f b4 05 00 00 00 00 00 b4 96 05 00 00 00 00 00  ................
  backtrace:
    [<ffffffff819f5f08>] __kmem_cache_alloc_node+0x1e8/0x320
    [<ffffffff818a239a>] kmalloc_trace+0x2a/0x60
    [<ffffffff8231d31e>] free_iova_fast+0x28e/0x4e0
    [<ffffffff82310860>] fq_ring_free_locked+0x1b0/0x310
    [<ffffffff8231225d>] fq_flush_timeout+0x19d/0x2e0
    [<ffffffff813e95ba>] call_timer_fn+0x19a/0x5c0
    [<ffffffff813ea16b>] __run_timers+0x78b/0xb80
    [<ffffffff813ea5bd>] run_timer_softirq+0x5d/0xd0
    [<ffffffff82f1d915>] __do_softirq+0x205/0x8b5

Introduce kmemleak_transient_leak() which resets the object checksum
requiring another scan pass before it is reported (if still unreferenced).
Call this new API in iova_depot_pop().

Link: https://lkml.kernel.org/r/20241104111944.2207155-1-catalin.marinas@arm.com
Link: https://lore.kernel.org/r/ZY1osaGLyT-sdKE8@shredder/
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Ido Schimmel <idosch@idosch.org>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kmemleak.rst |    1 
 drivers/iommu/iova.c                 |    6 +++
 include/linux/kmemleak.h             |    4 ++
 mm/kmemleak.c                        |   39 +++++++++++++++++++++++++
 4 files changed, 50 insertions(+)

--- a/Documentation/dev-tools/kmemleak.rst~kmemleak-iommu-iova-fix-transient-kmemleak-false-positive
+++ a/Documentation/dev-tools/kmemleak.rst
@@ -161,6 +161,7 @@ See the include/linux/kmemleak.h header
 - ``kmemleak_free_percpu``	 - notify of a percpu memory block freeing
 - ``kmemleak_update_trace``	 - update object allocation stack trace
 - ``kmemleak_not_leak``	 - mark an object as not a leak
+- ``kmemleak_transient_leak``	 - mark an object as a transient leak
 - ``kmemleak_ignore``		 - do not scan or report an object as leak
 - ``kmemleak_scan_area``	 - add scan areas inside a memory block
 - ``kmemleak_no_scan``	 - do not scan a memory block
--- a/drivers/iommu/iova.c~kmemleak-iommu-iova-fix-transient-kmemleak-false-positive
+++ a/drivers/iommu/iova.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/iova.h>
+#include <linux/kmemleak.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
@@ -673,6 +674,11 @@ static struct iova_magazine *iova_depot_
 {
 	struct iova_magazine *mag = rcache->depot;
 
+	/*
+	 * As the mag->next pointer is moved to rcache->depot and reset via
+	 * the mag->size assignment, mark it as a transient false positive.
+	 */
+	kmemleak_transient_leak(mag->next);
 	rcache->depot = mag->next;
 	mag->size = IOVA_MAG_SIZE;
 	rcache->depot_size--;
--- a/include/linux/kmemleak.h~kmemleak-iommu-iova-fix-transient-kmemleak-false-positive
+++ a/include/linux/kmemleak.h
@@ -26,6 +26,7 @@ extern void kmemleak_free_part(const voi
 extern void kmemleak_free_percpu(const void __percpu *ptr) __ref;
 extern void kmemleak_update_trace(const void *ptr) __ref;
 extern void kmemleak_not_leak(const void *ptr) __ref;
+extern void kmemleak_transient_leak(const void *ptr) __ref;
 extern void kmemleak_ignore(const void *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
 extern void kmemleak_no_scan(const void *ptr) __ref;
@@ -93,6 +94,9 @@ static inline void kmemleak_update_trace
 static inline void kmemleak_not_leak(const void *ptr)
 {
 }
+static inline void kmemleak_transient_leak(const void *ptr)
+{
+}
 static inline void kmemleak_ignore(const void *ptr)
 {
 }
--- a/mm/kmemleak.c~kmemleak-iommu-iova-fix-transient-kmemleak-false-positive
+++ a/mm/kmemleak.c
@@ -935,6 +935,28 @@ static void make_black_object(unsigned l
 }
 
 /*
+ * Reset the checksum of an object. The immediate effect is that it will not
+ * be reported as a leak during the next scan until its checksum is updated.
+ */
+static void reset_checksum(unsigned long ptr)
+{
+	unsigned long flags;
+	struct kmemleak_object *object;
+
+	object = find_and_get_object(ptr, 0);
+	if (!object) {
+		kmemleak_warn("Not resetting the checksum of an unknown object at 0x%08lx\n",
+			      ptr);
+		return;
+	}
+
+	raw_spin_lock_irqsave(&object->lock, flags);
+	object->checksum = 0;
+	raw_spin_unlock_irqrestore(&object->lock, flags);
+	put_object(object);
+}
+
+/*
  * Add a scanning area to the object. If at least one such area is added,
  * kmemleak will only scan these ranges rather than the whole memory block.
  */
@@ -1203,6 +1225,23 @@ void __ref kmemleak_not_leak(const void
 EXPORT_SYMBOL(kmemleak_not_leak);
 
 /**
+ * kmemleak_transient_leak - mark an allocated object as transient false positive
+ * @ptr:	pointer to beginning of the object
+ *
+ * Calling this function on an object will cause the memory block to not be
+ * reported as a leak temporarily. This may happen, for example, if the object
+ * is part of a singly linked list and the ->next reference to it is changed.
+ */
+void __ref kmemleak_transient_leak(const void *ptr)
+{
+	pr_debug("%s(0x%px)\n", __func__, ptr);
+
+	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+		reset_checksum((unsigned long)ptr);
+}
+EXPORT_SYMBOL(kmemleak_transient_leak);
+
+/**
  * kmemleak_ignore - ignore an allocated object
  * @ptr:	pointer to beginning of the object
  *
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

kmemleak-iommu-iova-fix-transient-kmemleak-false-positive.patch

