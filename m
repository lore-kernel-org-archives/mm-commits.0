Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9900C12F363
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711570890; cv=none; b=PZg/H8feZIrATjJHW+8nwhldz0uo+9jg2o7wXw6Th0c1AXiFUTpaC4gmXBiWclzisO1i9Q2uWgiMHxz8CbqCxHVw7+lkcSm/P2zxu8KQgah10pghoj6zAdomw+7JaQ5Es1QHdwOpObfmpDA0DSbdraeD+/mt5TTJkkXLsN76jQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711570890; c=relaxed/simple;
	bh=efA66WZgEJ9X/GH4D+suoVS0QtCGBh3WA0EZ7tLW+iE=;
	h=Date:To:From:Subject:Message-Id; b=dL7ef1vid2TRNJkIq5ssOUkv6buHrTCPOhft9SfraApcF8jCY8cXVWJ9xyHa1/qVzVYMM0RTcAiDAruuaG+DX1hTP5Ui6KU4K/VQ5cbvbEGDIiqx8x1Oc0L+z5n6w52TtuX0fDucCsBd6IA9PmV4WTflZuXIGM9XEwHCbzPbESQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ismaSsCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ismaSsCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E0AC433C7;
	Wed, 27 Mar 2024 20:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711570890;
	bh=efA66WZgEJ9X/GH4D+suoVS0QtCGBh3WA0EZ7tLW+iE=;
	h=Date:To:From:Subject:From;
	b=ismaSsCNo3QyTgCGHXo/ibxhAwSQvpiALGKSKaiVlh3cg3W51vddEvS5tsEAoEBQn
	 LIcIru5nsk+fa9pSKhcpoFwK6grlKy8uCnwiW8oUq26PtWIo0LB8H/lYWsGGMIwnTY
	 1kr8PL8FVyJlG1dvCHPmHG9nZ7e3m5QXKFWEoWwE=
Date: Wed, 27 Mar 2024 13:21:29 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,kent.overstreet@linux.dev,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rhashtable-plumb-through-alloc-tag-fix.patch added to mm-unstable branch
Message-Id: <20240327202130.10E0AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: rhashtable: undo _noprof additions in the documentation
has been added to the -mm mm-unstable branch.  Its filename is
     rhashtable-plumb-through-alloc-tag-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rhashtable-plumb-through-alloc-tag-fix.patch

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
Subject: Documentation: rhashtable: undo _noprof additions in the documentation
Date: Tue, 26 Mar 2024 16:14:47 -0700

Patch series "Documentation fixes for memory allocation profiling".

With the introduction of [1] kernel-doc can handle _noprof function names.
This patchset changes back _noprof documentation changes introduced in
memory allocation profiling patchset [2].

[1] https://lore.kernel.org/all/20240326054149.2121-1-rdunlap@infradead.org/
[2] https://lore.kernel.org/all/20240321163705.3067592-1-surenb@google.com/


This patch (of 6):

With kernel-doc script change to handle xyz_noprof() names, the previous
documentation changes and not needed anymore.

Link: https://lkml.kernel.org/r/20240326231453.1206227-1-surenb@google.com
Link: https://lkml.kernel.org/r/20240326231453.1206227-2-surenb@google.com
Fixes: 11c91be0e244 ("rhashtable: plumb through alloc tag")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rhashtable.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/rhashtable.c~rhashtable-plumb-through-alloc-tag-fix
+++ a/lib/rhashtable.c
@@ -979,7 +979,7 @@ static u32 rhashtable_jhash2(const void
 }
 
 /**
- * rhashtable_init_noprof - initialize a new hash table
+ * rhashtable_init - initialize a new hash table
  * @ht:		hash table to be initialized
  * @params:	configuration parameters
  *
@@ -1085,13 +1085,13 @@ int rhashtable_init_noprof(struct rhasht
 EXPORT_SYMBOL_GPL(rhashtable_init_noprof);
 
 /**
- * rhltable_init_noprof - initialize a new hash list table
+ * rhltable_init - initialize a new hash list table
  * @hlt:	hash list table to be initialized
  * @params:	configuration parameters
  *
  * Initializes a new hash list table.
  *
- * See documentation for rhashtable_init_noprof.
+ * See documentation for rhashtable_init.
  */
 int rhltable_init_noprof(struct rhltable *hlt, const struct rhashtable_params *params)
 {
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
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix.patch
lib-introduce-support-for-page-allocation-tagging.patch
lib-introduce-early-boot-parameter-to-avoid-page_ext-memory-overhead.patch
mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags.patch
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
mm-percpu-enable-per-cpu-allocation-tagging.patch
mm-percpu-enable-per-cpu-allocation-tagging-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix-2.patch
rhashtable-plumb-through-alloc-tag-fix.patch
lib-add-memory-allocations-report-in-show_mem.patch
codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch
codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch
codetag-debug-introduce-objexts_alloc_fail-to-mark-failed-slab_ext-allocations.patch

