Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1313603E8
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 07:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783236723; cv=none; b=Ho0wu2CgD+DlTXRLW/AmQ3x8DyrUcj7UV/7C0LRmhCDRtVr3BllbqndmD9stLG8z0pqwISTJ4Dp8ibChqfPvULjpxH9I87sLYz4v3fOWbwKCXkwn9rI8OCl1Qu+hntdSNPzZBx8MDb1dCuY3KOBIRd3kB2Nyx+TEi5VR7Lbvdn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783236723; c=relaxed/simple;
	bh=2h9SZDjbWYiOQDHH7df+1ZLhlF3pI1OHK6n2Lb9eo0E=;
	h=Date:To:From:Subject:Message-Id; b=cTs/js1xxr37XlTVdhRy/QuWY0jnYYPdGfdauT0Um44q9aQHXkwqttFPBjUQZvpkBCgELsJqXjefxL6IZri01HU4038tleZuzedZv5hD3KhScaXiuGxDwSxlnFYtkTaqcQkfCp6+wK+R4R2MrAiK2RYcDi0qGoJbhcf25BCTBQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AGDvYffJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AGDvYffJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB291F000E9;
	Sun,  5 Jul 2026 07:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783236721;
	bh=87yPhfAKlgZ/1L36iYJ498N2fmPQloYuB9VmC3wjWJE=;
	h=Date:To:From:Subject;
	b=AGDvYffJp+Wmc0Q51Rb/2KIpwvK5hQZcZ7vsUH3M49UsDm2Qb62V6sM++fS6mFQcA
	 dbY/JZ+10CWk/FRqoy6Ct4YK4h4gr95Ig/BS7FQgMgusB69Muxo79ZMPEYu0zQnh+/
	 rGyM8CmvtzvON9uAbOmGDzSXJqCWE94xEsXjmYhk=
Date: Sun, 05 Jul 2026 00:32:01 -0700
To: mm-commits@vger.kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-factor-out-can_spin_trylock.patch added to mm-new branch
Message-Id: <20260705073201.ACB291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: factor out can_spin_trylock()
has been added to the -mm mm-new branch.  Its filename is
     mm-factor-out-can_spin_trylock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-factor-out-can_spin_trylock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
@@ -1716,4 +1716,27 @@ static inline void mm_prepare_for_swap_e
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
@@ -5408,15 +5408,7 @@ static void *__kmalloc_nolock_noprof(DEC
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

mm-page_alloc-drop-flag-conversion-optimisation.patch
mm-secretmem-disable-under-highmem.patch
mm-page_alloc-rename-alloc_trylock-alloc_nolock.patch
mm-page_alloc-some-renames-to-clarify-alloc_flags-scopes.patch
mm-name-some-args-in-a-function-declaration.patch
mm-split-out-internal-page_alloch.patch
mm-page_alloc-unify-__alloc_frozen_pages_noprof.patch
mm-page_alloc-relax-gfp-warn-in-nolock-allocs.patch
mm-move-some-stuff-to-mm-page_alloch.patch
perf-x86-intel-use-higher-level-allocator-api.patch
kvm-vmx-use-higher-level-allocator-api.patch
x86-virt-use-higher-level-allocator-api.patch
sgi-xp-use-higher-level-allocator-api.patch
net-funeth-switch-to-higher-level-allocator-api.patch
mm-remove-__alloc_pages_node.patch
mm-move-__alloc_pages-to-mm-page_alloch.patch
mm-replace-__gfp_no_codetag-with-alloc_no_codetag.patch
mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma.patch
mm-factor-out-can_spin_trylock.patch

