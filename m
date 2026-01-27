Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC8131619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486657; cv=none; b=YBf61eIrI/ujFEMvgjs0FOQuM32nyrdRoIOM2pLdrfOEZ0wu+bRPgkAWKGd8X22I5OjIU5tnwKuv5bRGTK+R3BVvAXS2BG+EpwOIgMXZm+7jc3b8acQ4JkgE1efkZoXp30kwtWd3vFjlFC3FcsRGSn/xGjAYnffYlGS1TpYpRyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486657; c=relaxed/simple;
	bh=F2Zm1sb4st/I+KxA2lHuBFZ3o6YCMvP0R5IVHEMVCe8=;
	h=Date:To:From:Subject:Message-Id; b=BHlCnqZamun2nCeYZSThdqYO4U27zgcFB39hk2dkkt5xMWDBq0JRICHZTK8u26/Kk7vE4Bzlc42sTwe+mF9G8Pr5suloKihDQ4R8kIriiYgbhivsKXCzMDiWyjBpuhIo8FASrWxRx7U105x7AzOC6pLalnih97Y2eJ+ctu2gsf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UvZtCtnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UvZtCtnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9949DC116C6;
	Tue, 27 Jan 2026 04:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486657;
	bh=F2Zm1sb4st/I+KxA2lHuBFZ3o6YCMvP0R5IVHEMVCe8=;
	h=Date:To:From:Subject:From;
	b=UvZtCtnLLGiVJvCCODxa/lA2o3Gm3SAAJLkj42hEVV+Yu8Wgmaq/MaV8IDtTT7hnp
	 c49kIZdUNVCHF2446UQmrKvg7kati3tgXb6POh0RnceHhJC2hzfWWgugX0MZXkUQgD
	 dF5UWi/t8ZFVx8zMWwcy/3bHUzwkMP7pGPyXtp4M=
Date: Mon, 26 Jan 2026 20:04:17 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch removed from -mm tree
Message-Id: <20260127040417.9949DC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: skip unfaulted VMAs on anon_vma clone, unlink
has been removed from the -mm tree.  Its filename was
     mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/rmap: skip unfaulted VMAs on anon_vma clone, unlink
Date: Sun, 18 Jan 2026 14:50:39 +0000

For both anon_vma_clone() and unlink_anon_vmas(), if the source VMA or the
VMA to be linked are unfaulted (e.g.  !vma->anon_vma), then the functions
do nothing.  Simply exit early in these cases.

In the unlink_anon_vmas() case we can also remove a conditional that
checks whether vma->anon_vma is set.

Link: https://lkml.kernel.org/r/085a25f7528e1c8c687276e9b856e88dc8f105ca.1768746221.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chriscli@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/mm/rmap.c~mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink
+++ a/mm/rmap.c
@@ -313,6 +313,9 @@ int anon_vma_clone(struct vm_area_struct
 
 	check_anon_vma_clone(dst, src);
 
+	if (!src->anon_vma)
+		return 0;
+
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
@@ -478,7 +481,10 @@ void unlink_anon_vmas(struct vm_area_str
 	mmap_assert_locked(vma->vm_mm);
 
 	/* Unfaulted is a no-op. */
-	VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
+	if (!vma->anon_vma) {
+		VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
+		return;
+	}
 
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
@@ -502,15 +508,13 @@ void unlink_anon_vmas(struct vm_area_str
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
-	if (vma->anon_vma) {
-		vma->anon_vma->num_active_vmas--;
 
-		/*
-		 * vma would still be needed after unlink, and anon_vma will be prepared
-		 * when handle fault.
-		 */
-		vma->anon_vma = NULL;
-	}
+	vma->anon_vma->num_active_vmas--;
+	/*
+	 * vma would still be needed after unlink, and anon_vma will be prepared
+	 * when handle fault.
+	 */
+	vma->anon_vma = NULL;
 	unlock_anon_vma_root(root);
 
 	/*
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

selftests-mm-remove-virtual_address_range-test.patch
mm-vma-rename-vma_lock_offset-to-vm_refcnt_exclude_readers_flag.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment.patch
mm-vma-rename-is_vma_write_only-separate-out-shared-refcount-put.patch
mm-vma-adduse-vma-lockdep-acquire-release-defines.patch
mm-vma-de-duplicate-__vma_enter_locked-error-path.patch
mm-vma-clean-up-__vma_enter-exit_locked.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns.patch
mm-vma-improve-and-document-__is_vma_write_locked.patch
mm-vma-improve-and-document-__is_vma_write_locked-fix.patch
mm-vma-update-vma_assert_locked-to-use-lockdep.patch
mm-vma-update-vma_assert_locked-to-use-lockdep-fix.patch
mm-vma-add-and-use-vma_assert_stabilised.patch
mm-vma-remove-__private-sparse-decoration-from-vma_flags_t.patch
mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch
mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch
tools-bitmap-add-missing-bitmap_.patch
mm-add-basic-vma-flag-operation-helper-functions.patch
mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch
mm-make-vm_area_desc-utilise-vma_flags_t-only.patch
tools-testing-vma-separate-vma-userland-tests-into-separate-files.patch
tools-testing-vma-separate-out-vma_internalh-into-logical-headers.patch
tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

