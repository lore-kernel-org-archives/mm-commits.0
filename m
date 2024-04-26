Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA17D2F36
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101258; cv=none; b=qEgbCkt2EsnZ+LPGHwuKbp82fd3r0ix9N9aUfPM+0DJhM7g5MY/5xeflZ5r3V7ODC1i4UaJS2BZnP3GmgFKjyf/T8f3PoYuW5kpFMFJsu1qVHAqOZX9xOwD49W7srch40XtoVWBNUCdh+JuBVuz5SNDFMqPpXBi1aziV06dvKvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101258; c=relaxed/simple;
	bh=4zbNAgpzZElgl8+CAKFNaQMq3ezvePH27DGNDn5wrOQ=;
	h=Date:To:From:Subject:Message-Id; b=ZiAPeLdAEXxPPg4I3X7y/TFA1xA0q0T1adaVqwlofB/Gk41lk2Q0X8wJIprb72HJeRDEXYHy0DYxb19rekOLV8rI2yt4/DX2GELqjT7QYLLrAT+8KDwdbHZG8DCDz2zI7yUrv1AU6dOtBZ2JqWcBRzF+l7c7ZR76FVqYhP3hokw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LzPvjFiR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LzPvjFiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F01BC113CD;
	Fri, 26 Apr 2024 03:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101258;
	bh=4zbNAgpzZElgl8+CAKFNaQMq3ezvePH27DGNDn5wrOQ=;
	h=Date:To:From:Subject:From;
	b=LzPvjFiR0ekPwVtHD/t3bn275wueCd3LSgU2bVksFINW8zvLMxLEqUQnHAIsr019I
	 byo7Y+XMsy/cEh8k0NCG2/LaEPti1JdokWrFkqPD/ViVrkDmV7nS+9phsL0a+J0m8A
	 JngzbMOBgk3bHLiCcX/4+YMwXDrpvKcPGqUyjxkk=
Date: Thu, 25 Apr 2024 20:14:17 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] rhashtable-plumb-through-alloc-tag-fix.patch removed from -mm tree
Message-Id: <20240426031418.2F01BC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: rhashtable: undo _noprof additions in the documentation
has been removed from the -mm tree.  Its filename was
     rhashtable-plumb-through-alloc-tag-fix.patch

This patch was dropped because it was folded into rhashtable-plumb-through-alloc-tag.patch

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
Tested-by: Kees Cook <keescook@chromium.org>
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
lib-introduce-support-for-page-allocation-tagging.patch
lib-introduce-early-boot-parameter-to-avoid-page_ext-memory-overhead.patch
mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags.patch
change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts.patch
mm-enable-page-allocation-tagging.patch
mm-create-new-codetag-references-during-page-splitting.patch
mm-fix-non-compound-multi-order-memory-accounting-in-__free_pages.patch
mm-page_ext-enable-early_page_ext-when-config_mem_alloc_profiling_debug=y.patch
lib-add-codetag-reference-into-slabobj_ext.patch
mm-slab-add-allocation-accounting-into-slab-allocation-and-free-paths.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends.patch
mm-percpu-enable-per-cpu-allocation-tagging.patch
rhashtable-plumb-through-alloc-tag.patch
lib-add-memory-allocations-report-in-show_mem.patch
codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch
codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch
codetag-debug-introduce-objexts_alloc_fail-to-mark-failed-slab_ext-allocations.patch
mm-change-inlined-allocation-helpers-to-account-at-the-call-site.patch
userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

