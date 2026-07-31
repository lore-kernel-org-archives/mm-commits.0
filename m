Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A016233938B
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465816; cv=none; b=N45QOHSqAVrzHXhi23lFKDEmRr/l1sxhaWcpN4IwYL14DvJY8kzisbl29R6Olr2w1s6tIbj0uzq6mj3HQRRKv41tvrTiR89FH3gty3nQdEtO/KLGw3/OtLwJFTeuZwIzrdV7wWj4UmeX6H94M1miCuLIRBS5D4nVm2Gh48InwR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465816; c=relaxed/simple;
	bh=sA7TL1sfh/LfRjoZYilu3P7XGUBW1m+tC4/o5xyw8gQ=;
	h=Date:To:From:Subject:Message-Id; b=ouS3Tasu/tYmGRsryazQm8fz1upGvcB0s4pSpBV+m26NmEi4+rHfSkMahR0rr2qhLpVuMq54he3M3X7qjAaTmFcvjP/XnQxvXaUfc01gv/wV4nkc/G8EvySwFec/mh4Y57Vm+JDYXmuyR5f62F3M+wfoszHBUDHZZMPJHKqZptQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oims7mSi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oims7mSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7670A1F00A3A;
	Fri, 31 Jul 2026 02:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465815;
	bh=+NMbvMZ0w3xi5dM4eoYS/ZWcDUpFQxYHDFJj82EAWSg=;
	h=Date:To:From:Subject;
	b=Oims7mSit/MQ+RjnSY26RT9yKqxHlGUe0vXYhh465Dhl+H6qsrbd4u81baZeybbON
	 E/gyr3paZm0NPgbMvw+b0uKLGOZkKEbPmWi4725TON/XMZG4akwLszF6y/WO8s0Ocx
	 rGW260qgDSVx4540zVmPSdxYTTeGUrHOIR0KbZgY=
Date: Thu, 30 Jul 2026 19:43:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,harry@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-factor-out-can_spin_trylock.patch removed from -mm tree
Message-Id: <20260731024335.7670A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: factor out can_spin_trylock()
has been removed from the -mm tree.  Its filename was
     mm-factor-out-can_spin_trylock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm: factor out can_spin_trylock()
Date: Fri, 03 Jul 2026 12:31:58 +0000

Deduplicate checks for whether the current context is safe for
spin_trylock().

Does this function really belong in mm/internal.h or is it generic?  Not
sure.  If someone ends up duplicating this logic elsewhere in the kernel,
that would be a shame.  But if it goes in some generic header, someone
treats it as documentation about where it's guaranteed safe to
spin_trylock(), and then it emerges that there are other subtle
preconditions that didn't affect the mm usecase, that would be worse.  So,
just be conservative and keep it local.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-18-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Harry Yoo <harry@kernel.org>
Link: https://lore.kernel.org/all/397859cb-b127-4cc6-9c71-044afc99bf0c@kernel.org/
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |   23 +++++++++++++++++++++++
 mm/page_alloc.c |   17 +----------------
 mm/slub.c       |   10 +---------
 3 files changed, 25 insertions(+), 25 deletions(-)

--- a/mm/internal.h~mm-factor-out-can_spin_trylock
+++ a/mm/internal.h
@@ -1713,4 +1713,27 @@ static inline void mm_prepare_for_swap_e
 	}
 }
 
+static inline bool can_spin_trylock(void)
+{
+	/*
+	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
+	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
+	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
+	 * mark the task as the owner of another rt_spin_lock which will
+	 * confuse PI logic, so return immediately if called from hard IRQ or
+	 * NMI.
+	 *
+	 * Note, irqs_disabled() case is ok. spin_trylock() can be called
+	 * from raw_spin_lock_irqsave region.
+	 */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
+		return false;
+
+	/* On UP, spin_trylock() always succeeds even when it is locked */
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return false;
+
+	return true;
+}
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/page_alloc.c~mm-factor-out-can_spin_trylock
+++ a/mm/page_alloc.c
@@ -5291,22 +5291,7 @@ static inline bool alloc_order_allowed(g
 
 static inline bool alloc_nolock_allowed(void)
 {
-	/*
-	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
-	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
-	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
-	 * mark the task as the owner of another rt_spin_lock which will
-	 * confuse PI logic, so return immediately if called from hard IRQ or
-	 * NMI.
-	 *
-	 * Note, irqs_disabled() case is ok. This function can be called
-	 * from raw_spin_lock_irqsave region.
-	 */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
-		return false;
-
-	/* On UP, spin_trylock() always succeeds even when it is locked */
-	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+	if (!can_spin_trylock())
 		return false;
 
 	/* Bailout, since _deferred_grow_zone() needs to take a lock */
--- a/mm/slub.c~mm-factor-out-can_spin_trylock
+++ a/mm/slub.c
@@ -5380,15 +5380,7 @@ static void *__kmalloc_nolock_noprof(DEC
 	if (unlikely(!size))
 		return ZERO_SIZE_PTR;
 
-	/*
-	 * See the comment for the same check in
-	 * alloc_frozen_pages_nolock_noprof()
-	 */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
-		return NULL;
-
-	/* On UP, spin_trylock() always succeeds even when it is locked */
-	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+	if (!can_spin_trylock())
 		return NULL;
 
 retry:
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-secretmem-dont-allow-highmem-folios.patch
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

