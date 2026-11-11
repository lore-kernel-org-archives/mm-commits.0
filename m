Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794418370;
	b=4ypONjfi3rx2ebEL0S2A6ozK8XdCULe6NqvqsnH1gPWHBaIDhaTwKkxzKQ4DP8LfaMed
	 w2RCsSex2cQT24S1gbq4ugy/9O4xNX1x3P0FLLHqmRRZ584elqX4iXdsaLi6euEuzb3db
	 YQdBY3tCDc2HIlW+RombkmytIAltrdRmm/LIojz/nWpydbloUdVfKZHO/ySpK7riPaz1l
	 nqTC9qaxkFax2K58wS8hzSxnmnGxcTeus+7t8p6mc7fsXt4gPLw8op3IeVejw644cBnb2
	 EbGNoIQWdkV6r5TkNX1V/aotlA7Xi6ys2joT8CSlRQhtwUp+FIaE6nrFEblMTrq8zew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418370;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=vkcdzdxxj6MapnlA7eahQTbpRpUkFEOut57+Rfn5gCU=;
	b=mJV4AEDyJexGc7mTLIKvhHldd/lKm8DtAHI0VWKdt7smoeOCrF3+ccOzE/sWvLNE+2hc
	 pwx1dX37Ma4eiH4nziQ2U3wtTXZQqjFQl04a5lNCnFLPzbQnDjL4S0P7pN7FlQRH93Q7R
	 obVWh0owIxXWBQzEViybOCHADOBb2IHD/Y5B9SMenqix798AWkfs20s2NL1s6B/1ATIqu
	 5xsP0MqsmviAutk02l3Two2rIY3cFbpWwucCcK7JfALAwLEdlpEKbLftIprV6CoW0Kk1a
	 qrzjHTTB7klA6GGZzY3eHnBiuDF3z4EnGvxm8MI+g5RU4UD3b3/zL92FXM6fdpO8PlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="n/kDz0Ip";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6057E606A324
	for <mm-commits@vger.kernel.org>; Wed, 11 Nov 2026 17:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=n/kDz0Ip
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3261F00A05;
	Wed, 11 Nov 2026 17:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794418370;
	bh=vkcdzdxxj6MapnlA7eahQTbpRpUkFEOut57+Rfn5gCU=;
	h=Date:To:From:Subject;
	b=n/kDz0Ip7rIZJ0DSRc4QWy57YhS7DgQrmAqGtdIh9FTox6TIgww4znZmuWhqJlS/n
	 NRXn64yEFSSr8PMebNZCY7jHNMfaz2yelnAKNdkwiYhM3Uer+U2PkiAkZ66gKC0d7U
	 JbJtrhAMj7SfDicuM9SO/SU/H8pizGMoevhuUOFM=
Date: Wed, 11 Nov 2026 09:32:49 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shakeel.butt@linux.dev,liam@infradead.org,ljs@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch added to mm-new branch
Message-Id: <20261111173250.2B3261F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: only assert VMA locks if CONFIG_DEBUG_VM is set
has been added to the -mm mm-new branch.  Its filename is
     mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch

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
Subject: mm: only assert VMA locks if CONFIG_DEBUG_VM is set
Date: Tue, 10 Nov 2026 16:57:44 +0000

Similar to the mmap lock asserts, we have also asserted VMA locks
regardless of whether or not the kernel is a debug build or not.

Similarly, these are asserting basic assumptions about kernel code which
should never assert in production code.

Since all such bugs are generally asserted using VM_WARN_ON_ONCE() or
similar, it creates an odd and inconsistent situation where some
programmatic asserts are only checked under CONFIG_DEBUG_VM and some are
always checked.

Since the intent is the same as any VM_WARN_ON_ONCE() check, do not assert
if CONFIG_DEBUG_VM is not set.

Implement by updating vma_assert_attached() and vma_assert_detached() to
use VM_WARN_ON_ONCE() rather than WARN_ON_ONCE(), and gating
vma_assert_[write_]locked() and vma_assert_can_modify() on CONFIG_DEBUG_VM.

nommu loses its CONFIG_LOCKDEP asserts if !CONFIG_DEBUG_VM in
vma_assert_[write_]locked(), but this doesn't seem to be a problem.

In addition, there were already inconsistencies - vma_assert_write_locked()
uses VM_WARN_ON_ONCE_VMA() and performs no actions if CONFIG_DEBUG_VM is
not set, and vma_assert_locked() looked up vma->vm_refcnt but also only
asserted if CONFIG_DEBUG_VM was set.

Therefore simply update these functions such that they're predicated on
CONFIG_DEBUG_VM and update their kdoc descriptions accordingly.

Link: https://lore.kernel.org/20261110-tame-vma-asserts-v1-2-be293ff499a7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
---

 include/linux/mmap_lock.h |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/include/linux/mmap_lock.h~mm-only-assert-vma-locks-if-config_debug_vm-is-set
+++ a/include/linux/mmap_lock.h
@@ -354,9 +354,14 @@ int vma_start_write_killable(struct vm_a
 /**
  * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
  * @vma: The VMA to assert.
+ *
+ * Assert only if CONFIG_DEBUG_VM is set.
  */
 static inline void vma_assert_write_locked(const struct vm_area_struct *vma)
 {
+	if (!IS_ENABLED(CONFIG_DEBUG_VM))
+		return;
+
 	if (!IS_ENABLED(CONFIG_MMU)) {
 		mmap_assert_write_locked(vma->vm_mm);
 		return;
@@ -369,11 +374,16 @@ static inline void vma_assert_write_lock
  * vma_assert_locked() - assert that @vma holds either a VMA read or a VMA write
  * lock and is not detached.
  * @vma: The VMA to assert.
+ *
+ * Assert only if CONFIG_DEBUG_VM is set.
  */
 static inline void vma_assert_locked(const struct vm_area_struct *vma)
 {
 	unsigned int refcnt;
 
+	if (!IS_ENABLED(CONFIG_DEBUG_VM))
+		return;
+
 	if (!IS_ENABLED(CONFIG_MMU)) {
 		mmap_assert_locked(vma->vm_mm);
 		return;
@@ -480,12 +490,12 @@ static inline void vma_assert_attached(s
 	if (!IS_ENABLED(CONFIG_MMU))
 		return;
 
-	WARN_ON_ONCE(!vma_is_attached(vma));
+	VM_WARN_ON_ONCE(!vma_is_attached(vma));
 }
 
 static inline void vma_assert_detached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(vma_is_attached(vma));
+	VM_WARN_ON_ONCE(vma_is_attached(vma));
 }
 
 static inline void vma_mark_attached(struct vm_area_struct *vma)
@@ -549,6 +559,9 @@ struct vm_area_struct *lock_next_vma(str
 
 static inline void vma_assert_can_modify(struct vm_area_struct *vma)
 {
+	if (!IS_ENABLED(CONFIG_DEBUG_VM))
+		return;
+
 	if (vma_is_attached(vma))
 		vma_assert_write_locked(vma);
 }
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

