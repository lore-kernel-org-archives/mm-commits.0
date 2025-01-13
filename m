Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CCE13777E;
	Mon, 13 Jan 2025 03:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737449; cv=none; b=Lmr6unEXzAgK3u45PFHO4GngYlhgQbj19egDUUPCuQYLby9GgR7DLRP1OXNfvkBUdXzlQxlL7z4kMoleSNQa6Pu8B+JnTuBEK3cwSjJv4EXPHX7ZNRtzHyABKpLcc30vzrOG5bO2iH6nFkWMltBM1Bsja6h07i6ymMFQkr3Auj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737449; c=relaxed/simple;
	bh=ItsLHNveGQSihSFkf2sULOU0N7GO/iSVEX65nufayJA=;
	h=Date:To:From:Subject:Message-Id; b=r02uJAVVdxSzHrTaUksyJyq9nkBLu9RNSkNRAUB1ChxDhkYaNzhvNmt6aRcsCpqZ8Sq0XVSOZKHcKYkDJ89CgACAObSI6ZOtl+lVi09TIbEwuBwsdBKpeCpYUO8x+SDFcn31bf0r8vnrXLlpefHd088S0UduFtMv7JaSLgUELaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FaSzQ6VX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FaSzQ6VX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6C5C4CEDF;
	Mon, 13 Jan 2025 03:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737448;
	bh=ItsLHNveGQSihSFkf2sULOU0N7GO/iSVEX65nufayJA=;
	h=Date:To:From:Subject:From;
	b=FaSzQ6VXs6ISKoHQBNY9am+8W2JHiCUFbTW1b59odNAaYsvZekkltbtB0AGrFnhp4
	 BIIzLAlwt2hPEOUshUhuyYbyxBchcKctW+lHtgsgo9PphjZe//aMnF37oF0UjS67G3
	 DLvngYc2KdD520/URfVr6kk88xsFpH3kzOCU2u6c=
Date: Sun, 12 Jan 2025 19:04:07 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-fix-atomic_set-definition-to-set-the-value-correctly.patch removed from -mm tree
Message-Id: <20250113030408.6C6C5C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools: fix atomic_set() definition to set the value correctly
has been removed from the -mm tree.  Its filename was
     tools-fix-atomic_set-definition-to-set-the-value-correctly.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: tools: fix atomic_set() definition to set the value correctly
Date: Fri, 27 Dec 2024 14:22:20 -0800

Currently vma test is failing because of the new vma_assert_attached()
assertion.  The check is failing because previous refcount_set() inside
vma_mark_attached() is a NoOp.  Fix the definition of atomic_set() to
correctly set the value of the atomic.

Link: https://lkml.kernel.org/r/20241227222220.1726384-1-surenb@google.com
Fixes: 9325b8b5a1cb ("tools: add skeleton code for userland testing of VMA logic")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/shared/linux/maple_tree.h |    2 +-
 tools/testing/vma/linux/atomic.h        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/shared/linux/maple_tree.h~tools-fix-atomic_set-definition-to-set-the-value-correctly
+++ a/tools/testing/shared/linux/maple_tree.h
@@ -2,6 +2,6 @@
 #define atomic_t int32_t
 #define atomic_inc(x) uatomic_inc(x)
 #define atomic_read(x) uatomic_read(x)
-#define atomic_set(x, y) do {} while (0)
+#define atomic_set(x, y) uatomic_set(x, y)
 #define U8_MAX UCHAR_MAX
 #include "../../../../include/linux/maple_tree.h"
--- a/tools/testing/vma/linux/atomic.h~tools-fix-atomic_set-definition-to-set-the-value-correctly
+++ a/tools/testing/vma/linux/atomic.h
@@ -6,7 +6,7 @@
 #define atomic_t int32_t
 #define atomic_inc(x) uatomic_inc(x)
 #define atomic_read(x) uatomic_read(x)
-#define atomic_set(x, y) do {} while (0)
+#define atomic_set(x, y) uatomic_set(x, y)
 #define U8_MAX UCHAR_MAX
 
 #endif	/* _LINUX_ATOMIC_H */
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch
seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch
mm-mark-vmas-detached-upon-exit.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-introduce-__refcount_addinc_not_zero_limited.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch
alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch

