Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA7D79945
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103915; cv=none; b=aDz4L34lYvuZ/tiOdTsNu9prhm18hTdzGkMp88sed3QDPd3zLGB/BUvbUX4D4/TyUEWXRJKD560O2nODMArFaFpCHQ9CK8obv5Ap611g/sEoXmabaVg2T8xvUylyXzWSV2ylGqbDjRdfuRRSl0FwZKxiDVMsGHFlayGT2GwsO0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103915; c=relaxed/simple;
	bh=iy9bdCV4EyLbRO++/83A+ZigpsVCVi1dp0S4pfc1enY=;
	h=Date:To:From:Subject:Message-Id; b=telgUqFACt8GqeiAHTqUe7InWc3V3lLrRiBEar0fFeEvjA77wv7p8CyoUhOQtKaX2yeoYLB+qR4b0I19/Ok2WOqGxbYJjRsUO6SMCd7Jb6Q1o84G++AKT9Szo8F7XM3PgBESRoDsMVnZbnlST0TaiBb1UzGCw9oGmBn+b/CxdFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z0kkcSY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z0kkcSY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEDDC116B1;
	Fri, 26 Apr 2024 03:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103915;
	bh=iy9bdCV4EyLbRO++/83A+ZigpsVCVi1dp0S4pfc1enY=;
	h=Date:To:From:Subject:From;
	b=z0kkcSY24MK8iUdR5w28oV9yiCqOllPSzR2ICgAlF+AgjvdfcmkeDU6ofmhkSSPsQ
	 Ip810VRfVx/aMhGP947tuev6uYUfCfQ3u3OEoDJ9tec3ekD482pgOM1zRFFkGTubjg
	 GvutJ12J3qJi0fbaRiNtGscyrtN+9F+x9yPP4KFY=
Date: Thu, 25 Apr 2024 20:58:35 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-percpu-add-codetag-reference-into-pcpuobj_ext.patch removed from -mm tree
Message-Id: <20240426035835.AEEDDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: percpu: add codetag reference into pcpuobj_ext
has been removed from the -mm tree.  Its filename was
     mm-percpu-add-codetag-reference-into-pcpuobj_ext.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: mm: percpu: add codetag reference into pcpuobj_ext
Date: Thu, 21 Mar 2024 09:36:50 -0700

To store codetag for every per-cpu allocation, a codetag reference is
embedded into pcpuobj_ext when CONFIG_MEM_ALLOC_PROFILING=y.  Hooks to use
the newly introduced codetag are added.

Link: https://lkml.kernel.org/r/20240321163705.3067592-29-surenb@google.com
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

 mm/percpu-internal.h |   11 +++++++++--
 mm/percpu.c          |   26 ++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 2 deletions(-)

--- a/mm/percpu.c~mm-percpu-add-codetag-reference-into-pcpuobj_ext
+++ a/mm/percpu.c
@@ -1699,6 +1699,32 @@ static void pcpu_memcg_free_hook(struct
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
+				      size_t size)
+{
+	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
+		alloc_tag_add(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
+			      current->alloc_tag, size);
+	}
+}
+
+static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
+{
+	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts))
+		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag, size);
+}
+#else
+static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
+				      size_t size)
+{
+}
+
+static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
+{
+}
+#endif
+
 /**
  * pcpu_alloc - the percpu allocator
  * @size: size of area to allocate in bytes
--- a/mm/percpu-internal.h~mm-percpu-add-codetag-reference-into-pcpuobj_ext
+++ a/mm/percpu-internal.h
@@ -36,9 +36,12 @@ struct pcpuobj_ext {
 #ifdef CONFIG_MEMCG_KMEM
 	struct obj_cgroup	*cgroup;
 #endif
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+	union codetag_ref	tag;
+#endif
 };
 
-#ifdef CONFIG_MEMCG_KMEM
+#if defined(CONFIG_MEMCG_KMEM) || defined(CONFIG_MEM_ALLOC_PROFILING)
 #define NEED_PCPUOBJ_EXT
 #endif
 
@@ -86,7 +89,11 @@ struct pcpu_chunk {
 
 static inline bool need_pcpuobj_ext(void)
 {
-	return !mem_cgroup_kmem_disabled();
+	if (IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING))
+		return true;
+	if (!mem_cgroup_kmem_disabled())
+		return true;
+	return false;
 }
 
 extern spinlock_t pcpu_lock;
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are


