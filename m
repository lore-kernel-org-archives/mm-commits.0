Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7A279945
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103914; cv=none; b=bTzndJ43HZT63fJMjKI1qnqwXAurS9SbMli5P/TfBaMKnyZqQTH+4UWMpBZNzktRRzn/VOlfFKN+ZgvtieauGB2NgUCLl3n+Rnhq1L5LmRhFNtBtBWQpf7k5wklzdh+msa3L7vJH8qA2ASQp+r/NY+HVruLtFzRMuDKTYDMrxdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103914; c=relaxed/simple;
	bh=mbm0p0x+KqccgxKZz0nORQYxKCEKM4rYxm4tf0P6vqs=;
	h=Date:To:From:Subject:Message-Id; b=X3RJdywXgWkB7gm0lF3Q8xmBe59RX1XdRWR/FTt490kcZkTk4ZkV48EeZb0/pI9Nv5Mp0SP7E1Frg2oogEz8ooRDexv6pHJqqigS+Nf+PNkcFTL3heWebYCSLnHpC2RyxLNzQNnw6KdpkHA/0MKhWlVjJgqpnSwYpMjc6MSGjpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UG4XZKDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UG4XZKDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F98DC113CD;
	Fri, 26 Apr 2024 03:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103914;
	bh=mbm0p0x+KqccgxKZz0nORQYxKCEKM4rYxm4tf0P6vqs=;
	h=Date:To:From:Subject:From;
	b=UG4XZKDFEv/lfmbBzt5Ik4ce1v195jNVniqlgAhscjbjr3D97Qmy4JrZxzyDFzRsV
	 vdQwmNTBqeZEytutJM67qcWN82+SvdkK+s8AbSrvjfkssF1ZYsiQwk8Nl2o7JAvn9T
	 Bu4eYYBExs4oa7VouVQRAYuw4RsetP6iO2nieZEw=
Date: Thu, 25 Apr 2024 20:58:34 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-percpu-introduce-pcpuobj_ext.patch removed from -mm tree
Message-Id: <20240426035834.7F98DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: percpu: introduce pcpuobj_ext
has been removed from the -mm tree.  Its filename was
     mm-percpu-introduce-pcpuobj_ext.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: mm: percpu: introduce pcpuobj_ext
Date: Thu, 21 Mar 2024 09:36:49 -0700

Upcoming alloc tagging patches require a place to stash per-allocation
metadata.

We already do this when memcg is enabled, so this patch generalizes the
obj_cgroup * vector in struct pcpu_chunk by creating a pcpu_obj_ext type,
which we will be adding to in an upcoming patch - similarly to the
previous slabobj_ext patch.

Link: https://lkml.kernel.org/r/20240321163705.3067592-28-surenb@google.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-internal.h |   19 +++++++++++++++++--
 mm/percpu.c          |   30 +++++++++++++++---------------
 2 files changed, 32 insertions(+), 17 deletions(-)

--- a/mm/percpu.c~mm-percpu-introduce-pcpuobj_ext
+++ a/mm/percpu.c
@@ -1392,9 +1392,9 @@ static struct pcpu_chunk * __init pcpu_a
 		panic("%s: Failed to allocate %zu bytes\n", __func__,
 		      alloc_size);
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef NEED_PCPUOBJ_EXT
 	/* first chunk is free to use */
-	chunk->obj_cgroups = NULL;
+	chunk->obj_exts = NULL;
 #endif
 	pcpu_init_md_blocks(chunk);
 
@@ -1463,12 +1463,12 @@ static struct pcpu_chunk *pcpu_alloc_chu
 	if (!chunk->md_blocks)
 		goto md_blocks_fail;
 
-#ifdef CONFIG_MEMCG_KMEM
-	if (!mem_cgroup_kmem_disabled()) {
-		chunk->obj_cgroups =
+#ifdef NEED_PCPUOBJ_EXT
+	if (need_pcpuobj_ext()) {
+		chunk->obj_exts =
 			pcpu_mem_zalloc(pcpu_chunk_map_bits(chunk) *
-					sizeof(struct obj_cgroup *), gfp);
-		if (!chunk->obj_cgroups)
+					sizeof(struct pcpuobj_ext), gfp);
+		if (!chunk->obj_exts)
 			goto objcg_fail;
 	}
 #endif
@@ -1480,7 +1480,7 @@ static struct pcpu_chunk *pcpu_alloc_chu
 
 	return chunk;
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef NEED_PCPUOBJ_EXT
 objcg_fail:
 	pcpu_mem_free(chunk->md_blocks);
 #endif
@@ -1498,8 +1498,8 @@ static void pcpu_free_chunk(struct pcpu_
 {
 	if (!chunk)
 		return;
-#ifdef CONFIG_MEMCG_KMEM
-	pcpu_mem_free(chunk->obj_cgroups);
+#ifdef NEED_PCPUOBJ_EXT
+	pcpu_mem_free(chunk->obj_exts);
 #endif
 	pcpu_mem_free(chunk->md_blocks);
 	pcpu_mem_free(chunk->bound_map);
@@ -1646,9 +1646,9 @@ static void pcpu_memcg_post_alloc_hook(s
 	if (!objcg)
 		return;
 
-	if (likely(chunk && chunk->obj_cgroups)) {
+	if (likely(chunk && chunk->obj_exts)) {
 		obj_cgroup_get(objcg);
-		chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT] = objcg;
+		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
 
 		rcu_read_lock();
 		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
@@ -1663,13 +1663,13 @@ static void pcpu_memcg_free_hook(struct
 {
 	struct obj_cgroup *objcg;
 
-	if (unlikely(!chunk->obj_cgroups))
+	if (unlikely(!chunk->obj_exts))
 		return;
 
-	objcg = chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT];
+	objcg = chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup;
 	if (!objcg)
 		return;
-	chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT] = NULL;
+	chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = NULL;
 
 	obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
 
--- a/mm/percpu-internal.h~mm-percpu-introduce-pcpuobj_ext
+++ a/mm/percpu-internal.h
@@ -32,6 +32,16 @@ struct pcpu_block_md {
 	int			nr_bits;	/* total bits responsible for */
 };
 
+struct pcpuobj_ext {
+#ifdef CONFIG_MEMCG_KMEM
+	struct obj_cgroup	*cgroup;
+#endif
+};
+
+#ifdef CONFIG_MEMCG_KMEM
+#define NEED_PCPUOBJ_EXT
+#endif
+
 struct pcpu_chunk {
 #ifdef CONFIG_PERCPU_STATS
 	int			nr_alloc;	/* # of allocations */
@@ -64,8 +74,8 @@ struct pcpu_chunk {
 	int			end_offset;	/* additional area required to
 						   have the region end page
 						   aligned */
-#ifdef CONFIG_MEMCG_KMEM
-	struct obj_cgroup	**obj_cgroups;	/* vector of object cgroups */
+#ifdef NEED_PCPUOBJ_EXT
+	struct pcpuobj_ext	*obj_exts;	/* vector of object cgroups */
 #endif
 
 	int			nr_pages;	/* # of pages served by this chunk */
@@ -74,6 +84,11 @@ struct pcpu_chunk {
 	unsigned long		populated[];	/* populated bitmap */
 };
 
+static inline bool need_pcpuobj_ext(void)
+{
+	return !mem_cgroup_kmem_disabled();
+}
+
 extern spinlock_t pcpu_lock;
 
 extern struct list_head *pcpu_chunk_lists;
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are


