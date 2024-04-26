Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF6633EA
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714100885; cv=none; b=VDxG/nHjR+cLunTSDGv+PfJNqJ1Ug3uriyPH/5Xjppolca3R0F9E92YLsBC9yBG24jSJ9LZ3x7yKQPNHjTljzO9IkvABQQu1dCO3s0JwiYfM7MRh2ttavjBuVOpYdJ5k+i3FA+aprVCeHWzpjoWfFvHNnewPrODABTw6LySIx68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714100885; c=relaxed/simple;
	bh=SE6B+FxYVDzK6f3/YlxUEags+B8gT5qQjaZVPUq0XSA=;
	h=Date:To:From:Subject:Message-Id; b=lKezb6Ir75GXP+dCiCqqJRRWrBmFZyfK7aiZQw5jEK2yxS0LjekPlpo3maZSmK3p7ViMN1a+mfjofR/GCGn6yoRPFr0KIn/4EV5kU9+xlTW/3PkKtrkFvR2ZK1TIQ3IxrtjHoNyCi4Pz0x0Im4rdSCc5eYDDrMFxsmhdO+E/Jzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xmm1RLZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xmm1RLZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616E1C113CC;
	Fri, 26 Apr 2024 03:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714100885;
	bh=SE6B+FxYVDzK6f3/YlxUEags+B8gT5qQjaZVPUq0XSA=;
	h=Date:To:From:Subject:From;
	b=xmm1RLZacFLvAMtF3MDZXO91GSkALUDnpgCbz26GLaY0U7C45TZcAOtAUvuPD3oE/
	 PvLEpLz7a2QhbfRunwJJdjGKRBliC77D60kflaBzXfYgYs9ON3a5oJ/ewgsCq01BX4
	 C8gY1IU7EDKVG/KrA9xaezIm4BAWeFSMqKjy+NIY=
Date: Thu, 25 Apr 2024 20:07:59 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,rdunlap@infradead.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix.patch removed from -mm tree
Message-Id: <20240426030805.616E1C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: fs/proc: fix allocinfo title
has been removed from the -mm tree.  Its filename was
     lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix.patch

This patch was dropped because it was folded into lib-add-allocation-tagging-support-for-memory-allocation-profiling.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: Documentation: fs/proc: fix allocinfo title
Date: Tue, 26 Mar 2024 00:38:13 -0700

Fix "Title underline too short." warning in the documentation.

Link: https://lkml.kernel.org/r/20240326073813.727090-1-surenb@google.com
Fixes: d08b311b6d49 ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/filesystems/proc.rst~lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix
+++ a/Documentation/filesystems/proc.rst
@@ -955,7 +955,7 @@ reclaimed to achieve this.
 
 
 allocinfo
-~~~~~~~
+~~~~~~~~~
 
 Provides information about memory allocations at all locations in the code
 base. Each allocation in the code is identified by its source file, line
_

Patches currently in -mm which might be from surenb@google.com are

mm-introduce-slabobj_ext-to-support-slab-object-extensions.patch
mm-introduce-__gfp_no_obj_ext-flag-to-selectively-prevent-slabobj_ext-creation.patch
mm-slab-introduce-slab_no_obj_ext-to-avoid-obj_ext-creation.patch
slab-objext-introduce-objext_flags-as-extension-to-page_memcg_data_flags.patch
lib-code-tagging-framework.patch
lib-code-tagging-module-support.patch
lib-prevent-module-unloading-if-memory-is-not-freed.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-2.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-4.patch
lib-introduce-support-for-page-allocation-tagging.patch
lib-introduce-early-boot-parameter-to-avoid-page_ext-memory-overhead.patch
mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags.patch
mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags-fix.patch
change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts.patch
mm-enable-page-allocation-tagging.patch
mm-enable-page-allocation-tagging-fix.patch
mm-create-new-codetag-references-during-page-splitting.patch
mm-fix-non-compound-multi-order-memory-accounting-in-__free_pages.patch
mm-page_ext-enable-early_page_ext-when-config_mem_alloc_profiling_debug=y.patch
lib-add-codetag-reference-into-slabobj_ext.patch
mm-slab-add-allocation-accounting-into-slab-allocation-and-free-paths.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix.patch
mempool-hook-up-to-memory-allocation-profiling-fix.patch
mempool-hook-up-to-memory-allocation-profiling-fix-2.patch
mm-percpu-enable-per-cpu-allocation-tagging.patch
mm-percpu-enable-per-cpu-allocation-tagging-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix-2.patch
rhashtable-plumb-through-alloc-tag-fix.patch
lib-add-memory-allocations-report-in-show_mem.patch
codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch
codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch
codetag-debug-introduce-objexts_alloc_fail-to-mark-failed-slab_ext-allocations.patch
mm-change-inlined-allocation-helpers-to-account-at-the-call-site.patch
userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

