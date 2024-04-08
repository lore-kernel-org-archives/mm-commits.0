Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8607F51B
	for <mm-commits@vger.kernel.org>; Mon,  8 Apr 2024 19:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712603278; cv=none; b=miSiEm5O5WS/AQcee4yP7SpBV9odK0BFJd9j2kDU2VYhP5dKCbqRrXNSC/kCe1+qbyy0hmKsz0+g6USw1dEdBqm3WOkwcaexxqDHpog+MOeF62O8NPP/vvx9/D1WLdpTmKaUOB0yjKKIxgtjMXBx/U+2iOgQugHKatr3IK4asFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712603278; c=relaxed/simple;
	bh=wnJGlMlhUZ3FKttXJ3KDitTqdqjtoJgrJ93p83rDLU8=;
	h=Date:To:From:Subject:Message-Id; b=tPEUom3WnzhbKp+c73U3wE8RxgzkEErDeF8adrBQH6iWkzC8QTEm4+vP/wlIiYea04ZUk/4m7aQumAxr5s0tn/BeXgyn3pveIMGqrifoFq2VEn27WpHbb8Sd35Ko3dmHBvXvM9PrfhMwmmDAiBSO4u14pTppB9K5lAT17UDEEZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GzK/7lK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GzK/7lK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C77C433C7;
	Mon,  8 Apr 2024 19:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712603277;
	bh=wnJGlMlhUZ3FKttXJ3KDitTqdqjtoJgrJ93p83rDLU8=;
	h=Date:To:From:Subject:From;
	b=GzK/7lK1BozVd4Kn7rV5fhJUT8aNGxIWTaEpFybod2ULOpnglUxRrDjZM0J98quEa
	 FfjAAhmg8pyXTGQuf2ygO+0Ojo+IYq7L4ilZCzNILQKp8RMOm9yQ63PRqOFhJ5imYr
	 vK1n9ooKxf6A3tLRUK9H44GudF5IWcDgXbmFxl2o=
Date: Mon, 08 Apr 2024 12:07:56 -0700
To: mm-commits@vger.kernel.org,klarasmodin@gmail.com,kent.overstreet@linux.dev,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags-fix.patch added to mm-unstable branch
Message-Id: <20240408190757.54C77C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup! increase PERCPU_MODULE_RESERVE to accommodate allocation tags
has been added to the -mm mm-unstable branch.  Its filename is
     mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags-fix.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: fixup! increase PERCPU_MODULE_RESERVE to accommodate allocation tags
Date: Sat, 6 Apr 2024 14:40:43 -0700

The increase of per-cpu reserved area for modules was not enough to
accommodate all allocation tags in certain use cases.  Increase some more
to fix the issue.

Link: https://lkml.kernel.org/r/20240406214044.1114406-1-surenb@google.com
Fixes: a11cb5c8e248 ("mm: percpu: increase PERCPU_MODULE_RESERVE to accommodate allocation tags")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Klara Modin <klarasmodin@gmail.com>
Tested-by: Klara Modin <klarasmodin@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/percpu.h~mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags-fix
+++ a/include/linux/percpu.h
@@ -15,7 +15,7 @@
 /* enough to cover all DEFINE_PER_CPUs in modules */
 #ifdef CONFIG_MODULES
 #ifdef CONFIG_MEM_ALLOC_PROFILING
-#define PERCPU_MODULE_RESERVE		(8 << 12)
+#define PERCPU_MODULE_RESERVE		(8 << 13)
 #else
 #define PERCPU_MODULE_RESERVE		(8 << 10)
 #endif
_

Patches currently in -mm which might be from surenb@google.com are

fix-missing-vmalloch-includes-fix-2.patch
fix-missing-vmalloch-includes-fix-6.patch
mm-introduce-slabobj_ext-to-support-slab-object-extensions.patch
mm-introduce-__gfp_no_obj_ext-flag-to-selectively-prevent-slabobj_ext-creation.patch
mm-slab-introduce-slab_no_obj_ext-to-avoid-obj_ext-creation.patch
slab-objext-introduce-objext_flags-as-extension-to-page_memcg_data_flags.patch
lib-code-tagging-framework.patch
lib-code-tagging-module-support.patch
lib-prevent-module-unloading-if-memory-is-not-freed.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-2.patch
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

