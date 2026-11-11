Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794418368;
	b=Q+UQHqiIk3j+tf1/wYrhk4OXx71JUPBEn86eouy8As04SgrIR9KV7YR3oI0ZvaEfslNz
	 Qejx6H9ZQ7sDOzu98XNGCu3jZSmb6A93lWFpBvv5pL6uAL1rgx2Wq38JKjwFsGKZJyTyF
	 +VxUiABhKTrADrz46Jw/1muNU+dnQ0zpPpEBHfE4RCfVTfAXdBW/fHEG1eUYOG0q9i4fw
	 RmW8xalmkOsqxlZRx/RPKEhNgsIACFewIxBsBJf61siWcAf7VMEOvXx/G9fpYSTVXcDV8
	 9wU21yaxVkTyI2AowexFFs7E0d847wnUSPtKV1JVTLL4iEMsHh7pO4nWJQ2uyZ4JRvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418368;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=i/Wl68WndN2EKuzpehAg9aUM1ETe8HosTQwm03IpDl0=;
	b=3A1YqQw60doFznzPs4rMORKlEHtIeBS2Qk2UKHDiNgu18QL6O+Q3rlMEWvk3PeiWoCHY
	 qgMRAc7qOEhv2zA5vmo9DDj/Dk/6JfX3fFbBCzwDzzhy9H//+Zsmu0gHgGNAIUB/RdN/0
	 yUOeBLhc1Tg6ttkzTuxT7lWaZXs8z4YeTCq4PnfnrHXKkHOKsKKtAhpQQD9KgBZk/RiOc
	 9cmdZHA58NrGoZ4qmwMNCWZeOaUGw3prOeXKbJv186FudsqBiEqx+MVHboUQnqSWeIMMF
	 VNPYZn+dP8DWGDrFXRI00WjdbxnijJfZkRR82yARjgpqGKFrTE9nOHD191E+xO9iqtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PxzXF17S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B29606A31C
	for <mm-commits@vger.kernel.org>; Wed, 11 Nov 2026 17:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PxzXF17S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7ED1F00A05;
	Wed, 11 Nov 2026 17:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794418368;
	bh=i/Wl68WndN2EKuzpehAg9aUM1ETe8HosTQwm03IpDl0=;
	h=Date:To:From:Subject;
	b=PxzXF17SyNtmJQW7mLcnD2tonbl0UoN2gd1q5/DcF42NAV0KrsEs9/Kdcbgwe2DQk
	 AV/4+Jrf1DtojCg6tLS0zusH9Wq4AXUr1VzxylNguFc/JpeTjg8zUVGgijQLC8V0+z
	 Z7use8W+hepIiCEViiAudbmKBaGseT6FMeDPVyfA=
Date: Wed, 11 Nov 2026 09:32:47 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shakeel.butt@linux.dev,liam@infradead.org,ljs@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch added to mm-new branch
Message-Id: <20261111173247.EA7ED1F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: only assert mmap locks if CONFIG_DEBUG_VM or lockdep is set
has been added to the -mm mm-new branch.  Its filename is
     mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: only assert mmap locks if CONFIG_DEBUG_VM or lockdep is set
Date: Tue, 10 Nov 2026 16:57:43 +0000

Patch series "mm: only assert mmap and VMA locks if CONFIG_DEBUG_VM is
set".

Currently these asserts are all performed at runtime regardless of whether
or not the kernel is intended for debugging mm code (i.e. whether or not
CONFIG_DEBUG_VM is set).

These are explicitly programmatic checks - that is, checking basic
correctness in mm code which interacts with these locks.

The problem with this is that checks like this are generally asserted in mm
code using VM_WARN_ON_ONCE() and similar, and thus only checked if
CONFIG_DEBUG_VM is set.

So having some assertions which are unconditional and some not without it
being clear, creates something of an unintended two-tier system.

Since what is being asserted in these cases is exactly the same kind of
condition as those asserted in VM_WARN_ON_ONCE() assertions, simply
predicate them on CONFIG_DEBUG_VM.

Retain assertions for mmap lock asserts if CONFIG_LOCKDEP is specified in
order that expected lockdep assertions continue to function.

The VMA lock implementation already performs lockdep tracking regardless of
whether CONFIG_DEBUG_VM is set or not, so no changes are required there.


This patch (of 3):

For a long while we have asserted the mmap lock being held regardless of
whether or not the kernel is a debug build or not.

In general, given that these have been added as programmatic asserts that
nobody did something stupid, production kernels are simply wasting their
time checking for this.

It also means there is a two tier system - where some programmatic
asserts (e.g. VM_WARN_ON_ONCE()-checked conditions) are only checked for if
CONFIG_DEBUG_VM is enabled, whereas others are checked unconditionally.

If we genuinely want to unconditionally check for the mmap lock being held
at runtime, then that should be made clear in the code doing it.

Regardless, if CONFIG_LOCKDEP is enabled, ensure that the lockdep
assertions are performed.

Link: https://lore.kernel.org/20261110-tame-vma-asserts-v1-0-be293ff499a7@kernel.org
Link: https://lore.kernel.org/20261110-tame-vma-asserts-v1-1-be293ff499a7@kernel.org
Link: https://lore.kernel.org/linux-mm/20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org/ [0]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
---

 include/linux/mmap_lock.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/mmap_lock.h~mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set
+++ a/include/linux/mmap_lock.h
@@ -75,12 +75,14 @@ static inline void __mmap_lock_trace_rel
 
 static inline void mmap_assert_locked(const struct mm_struct *mm)
 {
-	rwsem_assert_held(&mm->mmap_lock);
+	if (IS_ENABLED(CONFIG_DEBUG_VM) || IS_ENABLED(CONFIG_LOCKDEP))
+		rwsem_assert_held(&mm->mmap_lock);
 }
 
 static inline void mmap_assert_write_locked(const struct mm_struct *mm)
 {
-	rwsem_assert_held_write(&mm->mmap_lock);
+	if (IS_ENABLED(CONFIG_DEBUG_VM) || IS_ENABLED(CONFIG_LOCKDEP))
+		rwsem_assert_held_write(&mm->mmap_lock);
 }
 
 #ifdef CONFIG_LOCKDEP
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-remove-myself-from-mm-core-reviewership.patch
maintainers-remove-myself-from-mm-misc-reclaim-reviewership.patch
maintainers-remove-myself-from-mm-rust-reviewerships.patch
credits-add-entry-for-thp-maintenance.patch
mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
revert-mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch
mm-khugepaged-scan-mms-more-efficiently-under-mmap_lock-contention.patch
mm-khugepaged-release-contended-mmap-read-lock-after-scanning-enough-vmas.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch

