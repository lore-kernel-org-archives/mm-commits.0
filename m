Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336039;
	b=zUflNTOZsPUNW2HQoSQ8KFOXSSM57/K7AdA2E5qAfdfkBuModwgb26lolH1In7ejfyis
	 jvHCyObCfYqA9QFytZ72Yjmtx+pQAWVQpwy9J8ZJIJfwTUtLKbvq4OGWOD468J3o1vx8T
	 VG16XKY2CKCGyQoVkYaPkBAfdMO+rsE+j4NK2n8N67lKTmas/0BI8HqoLEOfqVz30TQU0
	 Z0p8quEpd5r4oq+jcTQHVerwMBwvqj1uE/5whmDvk1w+xZXL53gVJL0fBZLPrXV/aUHHa
	 YtFhi2iwe6BSDO/P2rHeNh0V/wHN2PtJp/5A91YbR2C+pQtFiFxoSEP29r3cOyJHY8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336039;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=DIldKeNeuhLiRPiI/OtV0XXMnmRnt6burl4ioJ23fwM=;
	b=nNAaPp9JKWJWpfCLkj5TA8iROK6LEj2Y3itcgwSmfR7vv7NqT3G99J5YCAYIGEfSBGd1
	 DShJUuD5dESeGPEFtIPt2262QhCtLVVtZ1LO1GTrDVDJWH12ZUcSLmUjcsMzfz5Ki60RW
	 foV7+ajI3n4Q+XmpMsYkcTZKKXJbtm6QYkhzsyXedvoycY0UGXjow3Li2TqWGdH0W4BkE
	 4Jfwox/kBq3CbXDZXg1nShEqqq59bpckRQ6kAR4MWrr6E5EXh2rpNrG8iRRmgarrNgUG8
	 1Kykq1LDQvsuU1w0hV0i2AcvifjuxHWs9R82GKwzM9zPvEZIWQQsrps15gzaaKVbvJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=C5A1vMr6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DF9606A32E
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 04:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=C5A1vMr6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099601F000C1;
	Fri, 30 Oct 2026 04:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793336039;
	bh=DIldKeNeuhLiRPiI/OtV0XXMnmRnt6burl4ioJ23fwM=;
	h=Date:To:From:Subject;
	b=C5A1vMr6vOwmr9268p3jta9KG3f4CHUScaB9UU8BL++Km2E0ExlltWlJNvtbS1N48
	 G/yIoxLBtT62UO2GCQ0ro+aIg5q2S7KxqXqd7/thHmM2eA5lpHi9BaU4a59bOfC9nh
	 PA39HZjtTRG/r8GZRFsEWNdCiOdBp8Ls9MRBCXM4=
Date: Thu, 29 Oct 2026 21:53:58 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,harry@kernel.org,
	dennis@kernel.org,cl@gentwo.org,joshua.hahnjy@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-clean-up-callers-of-pcpu_obj_full_size.patch added to mm-new branch
Message-Id: <20261030045359.099601F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/percpu: clean up callers of pcpu_obj_full_size()
has been added to the -mm mm-new branch.  Its filename is
     mm-percpu-clean-up-callers-of-pcpu_obj_full_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-clean-up-callers-of-pcpu_obj_full_size.patch

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
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/percpu: clean up callers of pcpu_obj_full_size()
Date: Tue, 20 Oct 2026 19:30:11 -0700

The size of a pcpu allocation can be interpreted in two ways:
1. The size of the allocation attributable to a single CPU.
2. The total size of the allocation across all CPUs, including the
   allocation overhead (for obj_cgroup membership).

In most accounting paths for percpu memory, we need the second
definition (full size). Make this more obvious by coalescing the
callers of pcpu_obj_full_size() and renaming the parameter to full_size
to distinguish between the two definitions above.

No functional changes intended.

Link: https://lore.kernel.org/20261021023011.3199331-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
---

 mm/percpu.c |   63 ++++++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 29 deletions(-)

--- a/mm/percpu.c~mm-percpu-clean-up-callers-of-pcpu_obj_full_size
+++ a/mm/percpu.c
@@ -1611,7 +1611,7 @@ static struct pcpu_chunk *pcpu_chunk_add
 }
 
 #ifdef CONFIG_MEMCG
-static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
+static bool pcpu_memcg_pre_alloc_hook(size_t full_size, gfp_t gfp,
 				      struct obj_cgroup **objcgp)
 {
 	struct obj_cgroup *objcg;
@@ -1623,7 +1623,7 @@ static bool pcpu_memcg_pre_alloc_hook(si
 	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
-	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))
+	if (obj_cgroup_charge(objcg, gfp, full_size))
 		return false;
 
 	*objcgp = objcg;
@@ -1632,7 +1632,7 @@ static bool pcpu_memcg_pre_alloc_hook(si
 
 static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 				       struct pcpu_chunk *chunk, int off,
-				       size_t size)
+				       size_t full_size)
 {
 	if (!objcg)
 		return;
@@ -1643,14 +1643,15 @@ static void pcpu_memcg_post_alloc_hook(s
 
 		rcu_read_lock();
 		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-				pcpu_obj_full_size(size));
+				full_size);
 		rcu_read_unlock();
 	} else {
-		obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
+		obj_cgroup_uncharge(objcg, full_size);
 	}
 }
 
-static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
+static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off,
+				 size_t full_size)
 {
 	struct obj_cgroup *objcg;
 
@@ -1662,57 +1663,59 @@ static void pcpu_memcg_free_hook(struct
 		return;
 	chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = NULL;
 
-	obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
+	obj_cgroup_uncharge(objcg, full_size);
 
 	rcu_read_lock();
-	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-			-pcpu_obj_full_size(size));
+	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B, -full_size);
 	rcu_read_unlock();
 
 	obj_cgroup_put(objcg);
 }
 
 #else /* CONFIG_MEMCG */
-static bool
-pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp, struct obj_cgroup **objcgp)
+static bool pcpu_memcg_pre_alloc_hook(size_t full_size, gfp_t gfp,
+				      struct obj_cgroup **objcgp)
 {
 	return true;
 }
 
 static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 				       struct pcpu_chunk *chunk, int off,
-				       size_t size)
+				       size_t full_size)
 {
 }
 
-static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
+static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off,
+				 size_t full_size)
 {
 }
 #endif /* CONFIG_MEMCG */
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
-				      size_t size)
+				      size_t full_size)
 {
 	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
 		alloc_tag_add(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
-			      current->alloc_tag, pcpu_obj_full_size(size));
+			      current->alloc_tag, full_size);
 	}
 }
 
-static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
+static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off,
+				     size_t full_size)
 {
 	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts))
 		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
-			      pcpu_obj_full_size(size));
+			      full_size);
 }
 #else
 static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
-				      size_t size)
+				      size_t full_size)
 {
 }
 
-static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
+static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off,
+				     size_t full_size)
 {
 }
 #endif
@@ -1744,7 +1747,7 @@ void __percpu *pcpu_alloc_noprof(size_t
 	int slot, off, cpu, ret;
 	unsigned long flags;
 	void __percpu *ptr;
-	size_t bits, bit_align;
+	size_t bits, bit_align, full_size;
 
 	gfp = current_gfp_context(gfp);
 	/*
@@ -1773,6 +1776,7 @@ void __percpu *pcpu_alloc_noprof(size_t
 	size = ALIGN(size, PCPU_MIN_ALLOC_SIZE);
 	bits = size >> PCPU_MIN_ALLOC_SHIFT;
 	bit_align = align >> PCPU_MIN_ALLOC_SHIFT;
+	full_size = pcpu_obj_full_size(size);
 
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE ||
 		     !is_power_of_2(align))) {
@@ -1781,7 +1785,7 @@ void __percpu *pcpu_alloc_noprof(size_t
 		return NULL;
 	}
 
-	if (unlikely(!pcpu_memcg_pre_alloc_hook(size, gfp, &objcg)))
+	if (unlikely(!pcpu_memcg_pre_alloc_hook(full_size, gfp, &objcg)))
 		return NULL;
 
 	if (!is_atomic) {
@@ -1793,7 +1797,7 @@ void __percpu *pcpu_alloc_noprof(size_t
 		if (gfp & __GFP_NOFAIL) {
 			mutex_lock(&pcpu_alloc_mutex);
 		} else if (mutex_lock_killable(&pcpu_alloc_mutex)) {
-			pcpu_memcg_post_alloc_hook(objcg, NULL, 0, size);
+			pcpu_memcg_post_alloc_hook(objcg, NULL, 0, full_size);
 			return NULL;
 		}
 	}
@@ -1903,12 +1907,11 @@ area_found:
 	kmemleak_alloc_percpu(ptr, size, gfp);
 
 	trace_percpu_alloc_percpu(_RET_IP_, reserved, is_atomic, size, align,
-				  chunk->base_addr, off, ptr,
-				  pcpu_obj_full_size(size), gfp);
+				  chunk->base_addr, off, ptr, full_size, gfp);
 
-	pcpu_memcg_post_alloc_hook(objcg, chunk, off, size);
+	pcpu_memcg_post_alloc_hook(objcg, chunk, off, full_size);
 
-	pcpu_alloc_tag_alloc_hook(chunk, off, size);
+	pcpu_alloc_tag_alloc_hook(chunk, off, full_size);
 
 	return ptr;
 
@@ -1938,7 +1941,7 @@ fail:
 		mutex_unlock(&pcpu_alloc_mutex);
 	}
 
-	pcpu_memcg_post_alloc_hook(objcg, NULL, 0, size);
+	pcpu_memcg_post_alloc_hook(objcg, NULL, 0, full_size);
 
 	return NULL;
 }
@@ -2242,6 +2245,7 @@ void free_percpu(void __percpu *ptr)
 	struct pcpu_chunk *chunk;
 	unsigned long flags;
 	int size, off;
+	size_t full_size;
 	bool need_balance = false;
 
 	if (!ptr)
@@ -2262,10 +2266,11 @@ void free_percpu(void __percpu *ptr)
 		WARN_ON_ONCE(1);
 		return;
 	}
+	full_size = pcpu_obj_full_size(size);
 
-	pcpu_alloc_tag_free_hook(chunk, off, size);
+	pcpu_alloc_tag_free_hook(chunk, off, full_size);
 
-	pcpu_memcg_free_hook(chunk, off, size);
+	pcpu_memcg_free_hook(chunk, off, full_size);
 
 	/*
 	 * If there are more than one fully free chunks, wake up grim reaper.
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-percpu-clean-up-callers-of-pcpu_obj_full_size.patch

