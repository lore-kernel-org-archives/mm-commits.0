Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794335594;
	b=d08wz/xeTCQHIvJHRhPWoG6EoyTiq0yiRefp/9S2ldpmmEEB7aq/SX3iQGttdu7/U4sZ
	 U+YWE0OCrdlhK2U6b/p3mtu5WUZk+ubSozWs0mRteE6+RyeZzi1uXdeMB77na8L3x/hV8
	 5SY8niScgt6BaJHjjEHZqR5EGy5IfHGu5dycfg+B42EUI67MYCPoubzKf6NPcoLN8JFxJ
	 eqi8Ya+ORftAx9hLPSrn8Im9QfnB+eLj7nrtXcO6CPi86PjAA2Gp+b29OZf7GDGHdLOsf
	 m6zjlXWsBTeMGQsC0w6ApM04HpiicSLX7EDshe/U1r6K0hCNBm1IFNBtXazReGe+q5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794335594;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=LPhT8XgsfyA+tziVzXyQGQzf6fBtf8K2Mn8QnrNmD6Q=;
	b=I5YyXJJ8f5lXTtF9OsQsyrx8cxEt7KNqDDhZsRquDnZqKlxZP4QVu1u0MpVTu6VWDFG6
	 tiyqFWVUYTy1Nxe/M95Z/sUKFcqveHDwBnbJkUEo6SZUg+Hurpd7yZ+atHEAtskdF511O
	 g4K2J217s0LuX3gKd55LrZspKZQsx03e620WjIDKPTssnf/N7nJ5n1Xdf2KhHIjmqzaWe
	 M0HbTCCIQBTEiCRrFIpNl8xJP1+kBUODjKCBkUo5PMdwQxlWedKZdXK4lUf295tv95qSJ
	 aiJ+Ze6ZUMUtMo64aykyS+zckhMQUotGk/pxLTzfgN+o96/MokwLVlumgRJNYZ/zuLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mBfwycT5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA30606A320
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 18:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mBfwycT5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4106C1F0089F;
	Tue, 10 Nov 2026 18:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794335593;
	bh=LPhT8XgsfyA+tziVzXyQGQzf6fBtf8K2Mn8QnrNmD6Q=;
	h=Date:To:From:Subject;
	b=mBfwycT5ohKT5T6OEZ7VoXu6GwFUvCQibSXcdLa7AmGgZFcUQcfcrU7ae6sdZFU0p
	 4lJ5GwCinKFdNLOSFsf+gpXcnPeDTu+LIPv4jbRsB+/OD44jKg3eOQDillcbLRmayF
	 F/i1pzgUjjsk3rZJic7Hm9N88F1JiuN2eOUz3d18=
Date: Tue, 10 Nov 2026 10:33:07 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shakeel.butt@linux.dev,san55@wisc.edu,pfalcato@suse.de,liam@infradead.org,
	lance.yang@linux.dev,kas@kernel.org,jannh@google.com,david@kernel.org,
	ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch added to mm-new branch
Message-Id: <20261110183313.4106C1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vma: predicate vma_assert_stabilised() on CONFIG_DEBUG_VM
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch

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
Subject: mm/vma: predicate vma_assert_stabilised() on CONFIG_DEBUG_VM
Date: Tue, 10 Nov 2026 15:10:40 +0000

I introduced commit 17fd82c3abe0 ("mm/vma: add and use
vma_assert_stabilised()") with the intent of picking up programmatic bugs
when debugging mm code, but kept the general practice of asserting even
when CONFIG_DEBUG_VM is not set in line with existing code.

However, it turns out doing so can cause performance regressions,
especially when asserted in vma_has_anon_rmap() which is referenced in a
number of hotpaths.

Since the intent was always a debug-only assertion, explicitly check for
CONFIG_DEBUG_VM and do not assert if it isn't set.

Really all of the assert paths need to be predicated on this, but start
with this one only, out of caution.

Additionally, since a detached VMA is trivially stabilised (nothing to
stabilise against), check for this case at the outset, and update
vma_has_anon_rmap() to not explicitly need to check for this.

This also, importantly, avoids reading any VMA fields if CONFIG_DEBUG_VM is
not set.

Target the commit which introduced vma_has_anon_rmap() for the fix, as this
is where the issue started manifesting in practice.

Link: https://lore.kernel.org/20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org
Fixes: 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence KCSAN")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Seunghyun An <san55@wisc.edu>
Closes: https://lore.kernel.org/linux-mm/20261110000002.1834454-1-san55@wisc.edu/
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Seunghyun An <san55@wisc.edu>=0A=
  Link: https://lore.kernel.org/MN2PR06MB6639D846B30A3357B01BC61DD2722@MN2PR06MB6639.namprd06.prod.outlook.com
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
---

 include/linux/mmap_lock.h |   19 ++++++++++++++-----
 mm/vma.h                  |    3 +--
 2 files changed, 15 insertions(+), 7 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm
+++ a/include/linux/mmap_lock.h
@@ -408,6 +408,11 @@ static inline void vma_assert_locked(con
 	vma_assert_write_locked(vma);
 }
 
+static inline bool vma_is_attached(const struct vm_area_struct *vma)
+{
+	return refcount_read(&vma->vm_refcnt);
+}
+
 /**
  * vma_assert_stabilised() - assert that this VMA cannot be changed from
  * underneath us either by having a VMA or mmap lock held.
@@ -418,9 +423,18 @@ static inline void vma_assert_locked(con
  *
  * With lockdep disabled we may sometimes race with other threads acquiring the
  * mmap read lock simultaneous with our VMA read lock.
+ *
+ * Assert only if CONFIG_DEBUG_VM is set.
  */
 static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
 {
+	if (!IS_ENABLED(CONFIG_DEBUG_VM))
+		return;
+
+	/* Detached VMAs are trivially stabilised. */
+	if (!vma_is_attached(vma))
+		return;
+
 	/*
 	 * If another thread owns an mmap lock, it may go away at any time, and
 	 * thus is no guarantee of stability.
@@ -454,11 +468,6 @@ static inline void vma_assert_stabilised
 	vma_assert_locked(vma);
 }
 
-static inline bool vma_is_attached(const struct vm_area_struct *vma)
-{
-	return refcount_read(&vma->vm_refcnt);
-}
-
 /*
  * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
  * assertions should be made either under mmap_write_lock or when the object
--- a/mm/vma.h~mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm
+++ a/mm/vma.h
@@ -278,8 +278,7 @@ static inline pgoff_t vmg_end_pgoff(cons
  */
 static inline bool vma_has_anon_rmap(const struct vm_area_struct *vma)
 {
-	if (vma_is_attached(vma))
-		vma_assert_stabilised(vma);
+	vma_assert_stabilised(vma);
 	/* KCSAN gets confused about the optimistic check. Silence it. */
 	return data_race(vma->anon_vma);
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch

