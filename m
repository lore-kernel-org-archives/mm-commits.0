Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11F37C0B2
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103921; cv=none; b=YfHoeHeyheMqAS4MSwv2hoJRvtF3byccLFzwKp5bpsYBtvKdDJ/evNjMt9PVEAvIa43XW9pJ/EHbZwhEEVT33zqcfgJRnWdiT1YNxhDIlTpte4y7rd45Jsa277yQJhYjo0N5V2SFFuL7KyFnWKB2m+Z7VUAXqY69LVBQ1JKH8yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103921; c=relaxed/simple;
	bh=oYBveyNW4uZRxj941tWYGTT9MYpNQLPWL3ElP8rWjks=;
	h=Date:To:From:Subject:Message-Id; b=t7IRBa4Qy0QcApNNLFmI6Buu40b2eYFuuOECX2gkyXyHn1NsZQ0aTVVj0d0h4Fu5H7yvEQ7zyZ6tHyallXX3e/6gDCr40XO/BTR3khP2pQNqNhkfaGYVMa8aPrb4qR90WHLUSmLFFvQBp1m+553yoO/OxFON0/lPOWofS5G0WV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PeiSaS9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PeiSaS9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F6DC113CD;
	Fri, 26 Apr 2024 03:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103921;
	bh=oYBveyNW4uZRxj941tWYGTT9MYpNQLPWL3ElP8rWjks=;
	h=Date:To:From:Subject:From;
	b=PeiSaS9b/jh5S9LWCcHj7fz1zghUGaR3mKLsDudfrhS5g8VbJxXe04NVxl0M5CgQs
	 dbmuUoteHOENvLHQFU0jHGxynPqpGuCLt5xXZDSn22RujGAAVCfQs8tfbtD3U3SjHD
	 Zvi4UP3JB9oNWjP7tLDamKdtp0Kr/4l9xr5pOI9o=
Date: Thu, 25 Apr 2024 20:58:40 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rhashtable-plumb-through-alloc-tag.patch removed from -mm tree
Message-Id: <20240426035841.67F6DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rhashtable: plumb through alloc tag
has been removed from the -mm tree.  Its filename was
     rhashtable-plumb-through-alloc-tag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: rhashtable: plumb through alloc tag
Date: Thu, 21 Mar 2024 09:36:53 -0700

This gives better memory allocation profiling results; rhashtable
allocations will be accounted to the code that initialized the rhashtable.

[surenb@google.com: undo _noprof additions in the documentation]
  Link: https://lkml.kernel.org/r/20240326231453.1206227-1-surenb@google.com
Link: https://lkml.kernel.org/r/20240321163705.3067592-32-surenb@google.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Kees Cook <keescook@chromium.org>
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
 lib/rhashtable.c                 |   22 ++++++++++++++--------
 3 files changed, 26 insertions(+), 10 deletions(-)

--- a/include/linux/alloc_tag.h~rhashtable-plumb-through-alloc-tag
+++ a/include/linux/alloc_tag.h
@@ -152,6 +152,8 @@ static inline void alloc_tag_sub(union c
 	ref->ct = NULL;
 }
 
+#define alloc_tag_record(p)	((p) = current->alloc_tag)
+
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 #define DEFINE_ALLOC_TAG(_alloc_tag)
@@ -159,6 +161,7 @@ static inline bool mem_alloc_profiling_e
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
 
@@ -1076,7 +1082,7 @@ int rhashtable_init(struct rhashtable *h
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(rhashtable_init);
+EXPORT_SYMBOL_GPL(rhashtable_init_noprof);
 
 /**
  * rhltable_init - initialize a new hash list table
@@ -1087,15 +1093,15 @@ EXPORT_SYMBOL_GPL(rhashtable_init);
  *
  * See documentation for rhashtable_init.
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


