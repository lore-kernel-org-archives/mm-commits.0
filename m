Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794947698;
	b=vAKTJN2+EF/19xJIuucmq6CVe2FE9ydNsM8ct+673l5kOCduIboAnWACS9RHfpVsDoGw
	 jRiR8+MFeT3CZ1te+cem8MaSuL+WuVS94bKmoGf6aAK74kJggWvVDpbXheY/mv0Ki/GdP
	 eFt1IxVfRl6KKYdoeXFx0pbY5grnIsoFFAkoz9lkFL2oX76d1Ubi/C3ZwQovVOCsKnfpN
	 zhQu8yDAi+cYGlco5SsCzyMsTft5oM5TQrK1fDxM4RfksH63IGP3TdBtX2TEtRKTa+vxe
	 q6f+xudMjkigomMtUuJu3kSGeGg9Anodritdg0ZWX2BOCgOyNBeu/K45yGQjhI7hE8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794947698;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=dBkiyJzzin5ZWmPqUthCYbSZ3+sUhtiaA9PqDsBA+rQ=;
	b=Yc6UA8+A6TojoD7x0Otpz3H8Z7y2iV9nviD/AuZixk8QqBhbwZ8gpGMlyPHjbP7XjAQW
	 PaGILh1toUPZXSS9/Qee1DYtDDDnxCOzWhP0z+SVzSZClWTQm3gwhiyOoxS68O0Zj+8dT
	 ggxKOxseSxiL+CrMm6rIr+C7P47OFGl2P5pYeK69DjQ3UylLgSwXGdozsZxf4juLg+H+D
	 C4l47tEE7chQBk/Yvcvmk1UubQ7EXrcF00OaJGN3ogMKtslQ7LYhhAPg/2AOBIeH9YE6n
	 SB6/obzA1GgFAj1tQABYwU79Qzm/4uHoWiAiN/Oydet0SWq0d2dsZ3hlgRVOxNRAueg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="UaIY/vma";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF0D606A32F
	for <mm-commits@vger.kernel.org>; Tue, 17 Nov 2026 20:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UaIY/vma
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436621F000C9;
	Tue, 17 Nov 2026 20:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794947697;
	bh=dBkiyJzzin5ZWmPqUthCYbSZ3+sUhtiaA9PqDsBA+rQ=;
	h=Date:To:From:Subject;
	b=UaIY/vmacz1Po2Q36mJjz91bNL3JIkzpD3U+fiADxjQedFt9dCaAcAgRXH32y8E7i
	 tDIZWLMRNd1wsauNHLAC6JbrBUn9fKWyVrtZnxmix2+j96LieP8JrHPvfPknMsHK8J
	 hLqxqVXxOSQFrX8bQ/33C0qDAsG1Y45mZ1eYFcvo=
Date: Tue, 17 Nov 2026 12:34:56 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,
	mhocko@kernel.org,mason@kernel.org,hannes@cmpxchg.org,david@kernel.org,
	david@fromorbit.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix.patch removed from -mm tree
Message-Id: <20261117203457.436621F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/list_lru: verify memcg owner before skipping allocation
has been removed from the -mm tree.  Its filename was
     mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix.patch

This patch was dropped because it was folded into mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/list_lru: verify memcg owner before skipping allocation
Date: Thu, 12 Nov 2026 16:08:59 -0800

list_lru_from_memcg() rejects an entry at a reused kmemcg_id when it
belongs to another memcg.  memcg_list_lru_allocated() still treats any
entry at that index as a list for the requested memcg.  Its callers can
therefore skip the allocation of that memcg's ancestor lists.

With child C and parent P's lists both unallocated, a reader can retain C
while it is offlined.  If an unrelated new memcg reuses C's ID and
allocates its own list, the reader mistakes that entry for C's and skips
allocation of P's list.  Once the folio's objcg points to P,
deferred_split_folio() can add it to the root list.  If P later gets a
list, unqueue locks P's list while unlinking the folio from root's list,
which can corrupt that list under concurrent operations.

Require the entry to belong to the requested memcg before returning true. 
Hold RCU over the XArray load and owner comparison because this helper is
also called outside the folio fast path's RCU section.

Link: https://lore.kernel.org/20261112161502.18d9d72c0139b8f69bb88ff4@linux-foundation.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/sashiko-outbox-211977@kernel.org
Cc: Chris Mason <mason@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>

 mm/list_lru.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix
+++ a/mm/list_lru.c
@@ -568,9 +568,19 @@ void memcg_reparent_list_lrus(struct mem
 static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
 					    struct list_lru *lru)
 {
+	struct list_lru_memcg *mlru;
+	bool allocated;
 	int idx = memcg->kmemcg_id;
 
-	return idx < 0 || xa_load(&lru->xa, idx);
+	if (idx < 0)
+		return true;
+
+	rcu_read_lock();
+	mlru = xa_load(&lru->xa, idx);
+	allocated = mlru && mlru->memcg == memcg;
+	rcu_read_unlock();
+
+	return allocated;
 }
 
 static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg.patch
maintainers-add-page_exth-to-memory-management-page-allocator.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-sanity-check-directory-metadata-block-location-fix.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

