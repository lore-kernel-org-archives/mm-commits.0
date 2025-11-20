Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB0B32C952
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763674744; cv=none; b=ju17b9QBKczvWrC5WKbVxpfPogdDn1iP1cU4vl+Xvz1N4aVKCHer8nQoK3f4sY4yJYQURhLcPZ5C1StN6vqSmSOX3z09BsbNQT4nijlEVm5y8L1mNXUs5rn6346zFc6zoWxMflWiMYd7Xmb01JygRKk1VzbcMV2FSxqwLGMd9ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763674744; c=relaxed/simple;
	bh=PM5UWAWbZYoqjNYajbqnYjli6geFk879WjZxVyWIEG0=;
	h=Date:To:From:Subject:Message-Id; b=RiTMR8QmAS5JCApwWcOGlVuPirRbGnkYAdOK7bJpunpyejKRHWLfBo4GehG221D3vfwOBFM/PCiEo2e665+5LfjqLw0mRBxQ2wLKJlaGwZc4TOfe2t2DdPGl4ADfCHNnKUVr9L8OKbky9gFtvDKDLQj7w3e7s5u7x5mdrRjjC30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IoaHgsjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IoaHgsjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6703BC116B1;
	Thu, 20 Nov 2025 21:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763674743;
	bh=PM5UWAWbZYoqjNYajbqnYjli6geFk879WjZxVyWIEG0=;
	h=Date:To:From:Subject:From;
	b=IoaHgsjv/okU+D3faScBgwOedSy0567sFoG/S8JKQ8pfEOxxkG9WXbYMpsDhxtAnu
	 urk/skU2bZ3g7xc5ngCPAZHbtr6g+NSWvsgsJWd1DlK7KPGmccwgQnzUtYMmJSR/q+
	 NxZ5L0bBJoXacuVtG7/kZ/FhfQzNc6plgRzyH8KQ=
Date: Thu, 20 Nov 2025 13:39:02 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,gorcunov@gmail.com,david@kernel.org,avagin@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-propagate-vm_softdirty-on-merge-fix.patch removed from -mm tree
Message-Id: <20251120213903.6703BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-propagate-vm_softdirty-on-merge-fix
has been removed from the -mm tree.  Its filename was
     mm-propagate-vm_softdirty-on-merge-fix.patch

This patch was dropped because it was folded into mm-propagate-vm_softdirty-on-merge.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-propagate-vm_softdirty-on-merge-fix
Date: Wed Nov 19 02:22:57 PM PST 2025

update comments, per Lorenzo

Link: https://lkml.kernel.org/r/0019e0b8-ee1e-4359-b5ee-94225cbe5588@lucifer.local
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrey Vagin <avagin@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |    7 +++----
 tools/testing/vma/vma_internal.h |    7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-propagate-vm_softdirty-on-merge-fix
+++ a/include/linux/mm.h
@@ -548,10 +548,9 @@ extern unsigned int kobjsize(const void
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_STICKY - If one VMA has flags which must be 'sticky', that is ones
- *             which should propagate to all VMAs, but the other does not,
- *             the merge should still proceed with the merge logic applying
- *             sticky flags to the final VMA.
+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.
  */
 #define VM_IGNORE_MERGE VM_STICKY
 
--- a/tools/testing/vma/vma_internal.h~mm-propagate-vm_softdirty-on-merge-fix
+++ a/tools/testing/vma/vma_internal.h
@@ -133,10 +133,9 @@ extern unsigned long dac_mmap_min_addr;
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
- *             which should propagate to all VMAs, but the other does not,
- *             the merge should still proceed with the merge logic applying
- *             sticky flags to the final VMA.
+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.
  */
 #define VM_IGNORE_MERGE VM_STICKY
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-propagate-vm_softdirty-on-merge.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-correctly-handle-uffd-pte-markers-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix.patch
lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch
uaccess-gate-_copy__user-on-inline_copy_from_user-fix.patch

