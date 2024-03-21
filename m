Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE08E137C54
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 20:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711053859; cv=none; b=AI5uA+QdiZH8QVdCcaNx+JylokrZNDNTOAHaRODBMywNDfDlizjH9WlqTrqsvyG4lZ+Qr4h2YBr736rsXPvu9dXKZKlUXLYH9mdtmBe3K2yvaRq8SDpVEYxiBAGBuJQ/00MR+ioDtpHdHCyx1RUDgaTwbFICLtM8pyL2DpLbkS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711053859; c=relaxed/simple;
	bh=yGuwmjK4n9NZ0rpbJVXC2o6LMcmS0tYJi78lE7klLSU=;
	h=Date:To:From:Subject:Message-Id; b=uIjXu6dRPwbYEQKAwMvHAUW3oRe3ib+cdEZpL4C5Codirvw+n6s/01Aqir1F3pdvR7kJ1nBYriJXHJuoKdGv7FkN/H8XkyB1QSDsuoIzmzDZ/WLgRNLQd1QSgn9yFE8UEIZx+BUc3v+KH2xs8qfTl//9v+vlrbfFxPIQYSgHZl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ieWbM2UR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ieWbM2UR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8074CC433C7;
	Thu, 21 Mar 2024 20:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711053859;
	bh=yGuwmjK4n9NZ0rpbJVXC2o6LMcmS0tYJi78lE7klLSU=;
	h=Date:To:From:Subject:From;
	b=ieWbM2UREEuVtu4IYfjcQfFv7qE2+6DP3D3moe55Gt7CDVFBiGEYxEB9Jg+L5gzf9
	 oHIvw71faiHPph0VfzCHJ8tjUONFOWiTDRay2MD+nE3KycfIw12LYh4bXlqh9cbqVm
	 IxAdurywQJQ+z5L71MOQlX0NGEQxxBqYuaQdsyUQ=
Date: Thu, 21 Mar 2024 13:44:19 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rhashtable-plumb-through-alloc-tag.patch added to mm-unstable branch
Message-Id: <20240321204419.8074CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rhashtable: plumb through alloc tag
has been added to the -mm mm-unstable branch.  Its filename is
     rhashtable-plumb-through-alloc-tag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rhashtable-plumb-through-alloc-tag.patch

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
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: rhashtable: plumb through alloc tag
Date: Thu, 21 Mar 2024 09:36:53 -0700

This gives better memory allocation profiling results; rhashtable
allocations will be accounted to the code that initialized the rhashtable.

Link: https://lkml.kernel.org/r/20240321163705.3067592-32-surenb@google.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h        |    3 +++
 include/linux/rhashtable-types.h |   11 +++++++++--
 lib/rhashtable.c                 |   28 +++++++++++++++++-----------
 3 files changed, 29 insertions(+), 13 deletions(-)

--- a/include/linux/alloc_tag.h~rhashtable-plumb-through-alloc-tag
+++ a/include/linux/alloc_tag.h
@@ -141,6 +141,8 @@ static inline void alloc_tag_sub(union c
 	ref->ct = NULL;
 }
 
+#define alloc_tag_record(p)	((p) = current->alloc_tag)
+
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 #define DEFINE_ALLOC_TAG(_alloc_tag)
@@ -148,6 +150,7 @@ static inline bool mem_alloc_profiling_e
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
 				 size_t bytes) {}
 static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
+#define alloc_tag_record(p)	do {} while (0)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
--- a/include/linux/rhashtable-types.h~rhashtable-plumb-through-alloc-tag
+++ a/include/linux/rhashtable-types.h
@@ -9,6 +9,7 @@
 #ifndef _LINUX_RHASHTABLE_TYPES_H
 #define _LINUX_RHASHTABLE_TYPES_H
 
+#include <linux/alloc_tag.h>
 #include <linux/atomic.h>
 #include <linux/compiler.h>
 #include <linux/mutex.h>
@@ -88,6 +89,9 @@ struct rhashtable {
 	struct mutex                    mutex;
 	spinlock_t			lock;
 	atomic_t			nelems;
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+	struct alloc_tag		*alloc_tag;
+#endif
 };
 
 /**
@@ -127,9 +131,12 @@ struct rhashtable_iter {
 	bool end_of_table;
 };
 
-int rhashtable_init(struct rhashtable *ht,
+int rhashtable_init_noprof(struct rhashtable *ht,
 		    const struct rhashtable_params *params);
-int rhltable_init(struct rhltable *hlt,
+#define rhashtable_init(...)	alloc_hooks(rhashtable_init_noprof(__VA_ARGS__))
+
+int rhltable_init_noprof(struct rhltable *hlt,
 		  const struct rhashtable_params *params);
+#define rhltable_init(...)	alloc_hooks(rhltable_init_noprof(__VA_ARGS__))
 
 #endif /* _LINUX_RHASHTABLE_TYPES_H */
--- a/lib/rhashtable.c~rhashtable-plumb-through-alloc-tag
+++ a/lib/rhashtable.c
@@ -130,7 +130,8 @@ static union nested_table *nested_table_
 	if (ntbl)
 		return ntbl;
 
-	ntbl = kzalloc(PAGE_SIZE, GFP_ATOMIC);
+	ntbl = alloc_hooks_tag(ht->alloc_tag,
+			kmalloc_noprof(PAGE_SIZE, GFP_ATOMIC|__GFP_ZERO));
 
 	if (ntbl && leaf) {
 		for (i = 0; i < PAGE_SIZE / sizeof(ntbl[0]); i++)
@@ -157,7 +158,8 @@ static struct bucket_table *nested_bucke
 
 	size = sizeof(*tbl) + sizeof(tbl->buckets[0]);
 
-	tbl = kzalloc(size, gfp);
+	tbl = alloc_hooks_tag(ht->alloc_tag,
+			kmalloc_noprof(size, gfp|__GFP_ZERO));
 	if (!tbl)
 		return NULL;
 
@@ -181,7 +183,9 @@ static struct bucket_table *bucket_table
 	int i;
 	static struct lock_class_key __key;
 
-	tbl = kvzalloc(struct_size(tbl, buckets, nbuckets), gfp);
+	tbl = alloc_hooks_tag(ht->alloc_tag,
+			kvmalloc_node_noprof(struct_size(tbl, buckets, nbuckets),
+					     gfp|__GFP_ZERO, NUMA_NO_NODE));
 
 	size = nbuckets;
 
@@ -975,7 +979,7 @@ static u32 rhashtable_jhash2(const void
 }
 
 /**
- * rhashtable_init - initialize a new hash table
+ * rhashtable_init_noprof - initialize a new hash table
  * @ht:		hash table to be initialized
  * @params:	configuration parameters
  *
@@ -1016,7 +1020,7 @@ static u32 rhashtable_jhash2(const void
  *	.obj_hashfn = my_hash_fn,
  * };
  */
-int rhashtable_init(struct rhashtable *ht,
+int rhashtable_init_noprof(struct rhashtable *ht,
 		    const struct rhashtable_params *params)
 {
 	struct bucket_table *tbl;
@@ -1031,6 +1035,8 @@ int rhashtable_init(struct rhashtable *h
 	spin_lock_init(&ht->lock);
 	memcpy(&ht->p, params, sizeof(*params));
 
+	alloc_tag_record(ht->alloc_tag);
+
 	if (params->min_size)
 		ht->p.min_size = roundup_pow_of_two(params->min_size);
 
@@ -1076,26 +1082,26 @@ int rhashtable_init(struct rhashtable *h
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(rhashtable_init);
+EXPORT_SYMBOL_GPL(rhashtable_init_noprof);
 
 /**
- * rhltable_init - initialize a new hash list table
+ * rhltable_init_noprof - initialize a new hash list table
  * @hlt:	hash list table to be initialized
  * @params:	configuration parameters
  *
  * Initializes a new hash list table.
  *
- * See documentation for rhashtable_init.
+ * See documentation for rhashtable_init_noprof.
  */
-int rhltable_init(struct rhltable *hlt, const struct rhashtable_params *params)
+int rhltable_init_noprof(struct rhltable *hlt, const struct rhashtable_params *params)
 {
 	int err;
 
-	err = rhashtable_init(&hlt->ht, params);
+	err = rhashtable_init_noprof(&hlt->ht, params);
 	hlt->ht.rhlist = true;
 	return err;
 }
-EXPORT_SYMBOL_GPL(rhltable_init);
+EXPORT_SYMBOL_GPL(rhltable_init_noprof);
 
 static void rhashtable_free_one(struct rhashtable *ht, struct rhash_head *obj,
 				void (*free_fn)(void *ptr, void *arg),
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are

fix-missing-vmalloch-includes.patch
asm-generic-ioh-kill-vmalloch-dependency.patch
mm-slub-mark-slab_free_freelist_hook-__always_inline.patch
scripts-kallysms-always-include-__start-and-__stop-symbols.patch
fs-convert-alloc_inode_sb-to-a-macro.patch
rust-add-a-rust-helper-for-krealloc.patch
mempool-hook-up-to-memory-allocation-profiling.patch
mm-percpu-introduce-pcpuobj_ext.patch
mm-percpu-add-codetag-reference-into-pcpuobj_ext.patch
mm-vmalloc-enable-memory-allocation-profiling.patch
rhashtable-plumb-through-alloc-tag.patch
maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling.patch
memprofiling-documentation.patch

