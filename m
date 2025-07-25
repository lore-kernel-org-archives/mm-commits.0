Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C912A25B1EA
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 23:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486017; cv=none; b=INbwCuNw8ufr+5kHdX6B+K402mbx7BBvBRSmvIsHOZd9aXsvr0JOc/Qi+Sjg9CipOYFrRe2TVPX/JrVUArq44oYqtOy+qkUctEcrfwXuScm5PUyKdGvkTjHnQa9vS9ZOCTzgdH+9ngkgPcGtD/KDXVEQ2C1aPPnWT2P0q9Prn3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486017; c=relaxed/simple;
	bh=ewJO5JnQs/Mjbmu7CkqI79YBN+wKyXbMLC1tjHR5rF0=;
	h=Date:To:From:Subject:Message-Id; b=dOQ0ZQD9FCLUYCHEn8yuW/koPHh52IdRxOQoaaP+alq66gzySORu7YZ4O6UV5LMGtV3Gc5BE/z3fPMbxFpiJA/QXi19FlN2AoItgB0RumzF3zXCUNVkgqIJzLYSPJTxYZsvRwiBkqrxnUoNGZ+m4FgtgC/1mFjTl0lanpgrGS+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DPqoKX9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DPqoKX9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4229EC4CEE7;
	Fri, 25 Jul 2025 23:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753486017;
	bh=ewJO5JnQs/Mjbmu7CkqI79YBN+wKyXbMLC1tjHR5rF0=;
	h=Date:To:From:Subject:From;
	b=DPqoKX9vJH7PXBaaXkZBnIDygjHGFxsbOs4bymep1A1cuVIGT8E652socUjzZxo0B
	 Qj4RoNRcUi68aE9bmqqVHNLN9Fnz7AGgRiyCgpJp7NaG4/FfPpGC3bO07AHOz1Owk9
	 3ytFxgTyMWfb+IHsznxp8dREEd9IAId/T2vOf7Zg=
Date: Fri, 25 Jul 2025 16:26:56 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-always-define-vm_sealed.patch added to mm-unstable branch
Message-Id: <20250725232657.4229EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mseal: always define VM_SEALED
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mseal-always-define-vm_sealed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mseal-always-define-vm_sealed.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mseal: always define VM_SEALED
Date: Fri, 25 Jul 2025 09:29:41 +0100

Patch series "mseal cleanups", v4.

Perform a number of cleanups to the mseal logic.  Firstly, VM_SEALED is
treated differently from every other VMA flag, it really doesn't make
sense to do this, so we start by making this consistent with everything
else.

Next we place the madvise logic where it belongs - in mm/madvise.c.  It
really makes no sense to abstract this elsewhere.  In doing so, we go to
great lengths to explain very clearly the previously very confusing logic
as to what sealed mappings are impacted here.

In doing so, we retain existing logic regarding treatment of madvise()
discard operations for a sealed, read-only MAP_PRIVATE file-backed
mapping.  This is something we likely need to revisit.

We then abstract out and explain the 'are there are any gaps in this range
in the mm?' check being performed as a prerequisite to mseal being
performed.

Finally, we simplify the actual mseal logic which is really quite
straightforward.

No functional change is intended.


This patch (of 4):

There is no reason to treat VM_SEALED in a special way, in each other case
in which a VMA flag is unavailable due to configuration, we simply assign
that flag to VM_NONE, so make VM_SEALED consistent with all other VMA
flags in this respect.

Additionally, use the next available bit for VM_SEALED, 42, rather than
arbitrarily putting it at 63 and update the declaration to match all other
VMA flags.

No functional change intended.

Link: https://lkml.kernel.org/r/cover.1753431105.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/aeb398a77029b6e7377cd944328bc9bbc3c90537.1753431105.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |    6 ++++--
 tools/testing/vma/vma_internal.h |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-mseal-always-define-vm_sealed
+++ a/include/linux/mm.h
@@ -414,8 +414,10 @@ extern unsigned int kobjsize(const void
 #endif
 
 #ifdef CONFIG_64BIT
-/* VM is sealed, in vm_flags */
-#define VM_SEALED	_BITUL(63)
+#define VM_SEALED_BIT	42
+#define VM_SEALED	BIT(VM_SEALED_BIT)
+#else
+#define VM_SEALED	VM_NONE
 #endif
 
 /* Bits set in the VMA until the stack is in its final location */
--- a/tools/testing/vma/vma_internal.h~mm-mseal-always-define-vm_sealed
+++ a/tools/testing/vma/vma_internal.h
@@ -108,8 +108,10 @@ extern unsigned long dac_mmap_min_addr;
 #define CAP_IPC_LOCK         14
 
 #ifdef CONFIG_64BIT
-/* VM is sealed, in vm_flags */
-#define VM_SEALED	_BITUL(63)
+#define VM_SEALED_BIT	42
+#define VM_SEALED	BIT(VM_SEALED_BIT)
+#else
+#define VM_SEALED	VM_NONE
 #endif
 
 #define FIRST_USER_ADDRESS	0UL
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-add-missing-mm_sloth-file-thp-section-fix.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch
maintainers-add-missing-file-to-cgroup-section.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch

