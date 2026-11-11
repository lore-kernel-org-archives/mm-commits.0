Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794418372;
	b=C8C5yTT+o1DMOpbXAoHOYTl/fk2kClgKgmxb87OXz1wnpN8WWQV3sFC/cjjCXA3UlSQy
	 7KvwYwYO7RC1205r2aFfBUze2cFE3UVr8H68wruoP9f3mWPpfTcjVAORNRy2iHTB12VZQ
	 Nhp8i93AYbGf37Eu6BnUnv4Q8zD3sFYUBttPIVMJlYCA90Rds8pC/zQCdUoeCkYXO6OgN
	 F1FLrV+mN36/f+ry+SR/j4XL0aY6hRND30Tznq/qgBaL8KPVCHd8jShk3mxgqNZE3wAGT
	 K7TkBbSx7PscHRQOTOcDGwDGxqN2txDIYAGoAuwBOUszsx/1WjdYgMzMcTuHN+wa3rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418372;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=kbE71JI7enNuhVXYu6SuGHHohXJWImjXTt0V4EDimBw=;
	b=kUvvzIHNE9Y9BSF2ewK30mFhmzCYDFKIGeup5Hg4vLxW+Pei1GAAFV4wgwXjJhca9uJf
	 3DJIHg/qTJaATWF6fmYB5mVR9wWujfoIc0CQ8EgvJ6Wmjyo9Kfr+jdb2CoxJyYWPCXL6E
	 KnsJxMtfDYuQUOx62xa3qb/lrqrCxqzmarioV+T+c9P021hEN7MME96phUU/J+iwfQiPo
	 4N/rxn0Tf+u+KRfYci96XLyOvW5idl3EKXJvT9gEUrUU8HTiLLds0RYcWfJnnm6BUkMQS
	 hTAoqdnKmlu6AlcNrXgQTJ6Z+toX8LAEL5yPqowehjbOo2jCb+GJm/niou0LGZGyi8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iJpBDWiO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1936606A321
	for <mm-commits@vger.kernel.org>; Wed, 11 Nov 2026 17:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iJpBDWiO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5191F00A05;
	Wed, 11 Nov 2026 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794418372;
	bh=kbE71JI7enNuhVXYu6SuGHHohXJWImjXTt0V4EDimBw=;
	h=Date:To:From:Subject;
	b=iJpBDWiOHPio9fSL2kV6Ptuj3XU09YD0/mpGQWNZsZwDc1+wcGYDdJWS2JLsB1G1W
	 f4psQr8BehvlAsIcraxYfUDEOCUGbfiItx5dRhj+FptERmUatsx9Yw9GhH/Re7judH
	 qg9QtSrVQ2YfzqJUtQSSNGGKp/Kb0Zh56gJisNzE=
Date: Wed, 11 Nov 2026 09:32:51 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shakeel.butt@linux.dev,liam@infradead.org,ljs@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch added to mm-new branch
Message-Id: <20261111173252.5D5191F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: convert WARN_ON_ONCE()'s to VM_WARN_ON_ONCE() in VMA lock code
has been added to the -mm mm-new branch.  Its filename is
     mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch

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
Subject: mm: convert WARN_ON_ONCE()'s to VM_WARN_ON_ONCE() in VMA lock code
Date: Tue, 10 Nov 2026 16:57:45 +0000

Now that VMA assertions are predicated on CONFIG_DEBUG_VM, it makes sense
to convert existing unconditional WARN_ON_ONCE()'s in VMA lock code to
VM_WARN_ON_ONCE()'s.

These are asserting programmatic invariants which are in most other cases
asserted using VM_WARN_ON_ONCE(), and there is simply no need for these to
be unconditionally checked, so no longer do so.

Link: https://lore.kernel.org/20261110-tame-vma-asserts-v1-3-be293ff499a7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
---

 mm/mmap_lock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mmap_lock.c~mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code
+++ a/mm/mmap_lock.c
@@ -146,7 +146,7 @@ int __vma_start_write(struct vm_area_str
 
 	err = __vma_start_exclude_readers(&ves);
 	if (err) {
-		WARN_ON_ONCE(ves.detached);
+		VM_WARN_ON_ONCE(ves.detached);
 		return err;
 	}
 
@@ -161,7 +161,7 @@ int __vma_start_write(struct vm_area_str
 	if (ves.exclusive) {
 		__vma_end_exclude_readers(&ves);
 		/* VMA should remain attached. */
-		WARN_ON_ONCE(ves.detached);
+		VM_WARN_ON_ONCE(ves.detached);
 	}
 
 	return 0;
@@ -193,7 +193,7 @@ void __vma_exclude_readers_for_detach(st
 		__vma_end_exclude_readers(&ves);
 	}
 	/* If an error arose but we were detached anyway, we don't care. */
-	WARN_ON_ONCE(!ves.detached);
+	VM_WARN_ON_ONCE(!ves.detached);
 }
 
 /* Do the VMA, mm seqcounts indicate the VMA is write locked? */
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

