Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7718527453
	for <mm-commits@vger.kernel.org>; Sun, 17 Aug 2025 18:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755456881; cv=none; b=q2X0pJIk2vLj3+T+/pPjrHsVkELNCAXpZlLEBv62Rq4G2Jmvcwz8/VsQvTChI7FEPqJdNO53dYLiSpETaaXfgkSKin4a28x+T02/rzAV6/A3CauSLdRS8ji05KC/dwY5KIapS4eRpyZfnSSMH+h1Ar0IrMpa0B95pkvrqeMjvCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755456881; c=relaxed/simple;
	bh=OEqPPGPp1YV2XbTtggTk556I6P3kzF9eJLH75A/avzs=;
	h=Date:To:From:Subject:Message-Id; b=NU3nEMlzOHocbjMTdeeDPfhSHWjnr+E8RWHf41FVN2JFuaCjNRRKGqR9qzlyoCzGbgcULaYhK8sVExnRtu8F3Z3ZX+kAc3QVtYDgoA9qYSNzPwJmQH+14n/tdvtQLY8HbVBqkkWqq7G7DvejHjsfzCQ0dfDaL/2uCS20Q1I5jaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BANM4Rry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BANM4Rry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24C4C4CEEB;
	Sun, 17 Aug 2025 18:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755456881;
	bh=OEqPPGPp1YV2XbTtggTk556I6P3kzF9eJLH75A/avzs=;
	h=Date:To:From:Subject:From;
	b=BANM4RrymbIlbUSBuDaOE1RdJU58I4aDychY1OKv0Y/q0gCMI925EOc6rj3cCQN9v
	 Erub13iWUyDrPjGFP0DSaRt2+6G3lR8C1MRQoo6HuBN2ZqabhQvkoDPsMZJTuwim5E
	 oXogTCz3gOC/osZmJrV4k/w7TWOTinyPbq9Yr3as=
Date: Sun, 17 Aug 2025 11:54:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + slab-use-memdesc_flags_t.patch added to mm-new branch
Message-Id: <20250817185440.E24C4C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: slab: use memdesc_flags_t
has been added to the -mm mm-new branch.  Its filename is
     slab-use-memdesc_flags_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/slab-use-memdesc_flags_t.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: slab: use memdesc_flags_t
Date: Tue, 5 Aug 2025 18:22:55 +0100

The slab flags are memdesc flags and contain the same information in the
upper bits as the other memdescs (like node ID).

Link: https://lkml.kernel.org/r/20250805172307.1302730-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    2 +-
 mm/slub.c |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/mm/slab.h~slab-use-memdesc_flags_t
+++ a/mm/slab.h
@@ -50,7 +50,7 @@ typedef union {
 
 /* Reuses the bits in struct page */
 struct slab {
-	unsigned long flags;
+	memdesc_flags_t flags;
 
 	struct kmem_cache *slab_cache;
 	union {
--- a/mm/slub.c~slab-use-memdesc_flags_t
+++ a/mm/slub.c
@@ -657,17 +657,17 @@ static inline unsigned int slub_get_cpu_
  */
 static inline bool slab_test_pfmemalloc(const struct slab *slab)
 {
-	return test_bit(SL_pfmemalloc, &slab->flags);
+	return test_bit(SL_pfmemalloc, &slab->flags.f);
 }
 
 static inline void slab_set_pfmemalloc(struct slab *slab)
 {
-	set_bit(SL_pfmemalloc, &slab->flags);
+	set_bit(SL_pfmemalloc, &slab->flags.f);
 }
 
 static inline void __slab_clear_pfmemalloc(struct slab *slab)
 {
-	__clear_bit(SL_pfmemalloc, &slab->flags);
+	__clear_bit(SL_pfmemalloc, &slab->flags.f);
 }
 
 /*
@@ -675,12 +675,12 @@ static inline void __slab_clear_pfmemall
  */
 static __always_inline void slab_lock(struct slab *slab)
 {
-	bit_spin_lock(SL_locked, &slab->flags);
+	bit_spin_lock(SL_locked, &slab->flags.f);
 }
 
 static __always_inline void slab_unlock(struct slab *slab)
 {
-	bit_spin_unlock(SL_locked, &slab->flags);
+	bit_spin_unlock(SL_locked, &slab->flags.f);
 }
 
 static inline bool
@@ -1046,7 +1046,7 @@ static void print_slab_info(const struct
 {
 	pr_err("Slab 0x%p objects=%u used=%u fp=0x%p flags=%pGp\n",
 	       slab, slab->objects, slab->inuse, slab->freelist,
-	       &slab->flags);
+	       &slab->flags.f);
 }
 
 void skip_orig_size_check(struct kmem_cache *s, const void *object)
@@ -2755,17 +2755,17 @@ static void discard_slab(struct kmem_cac
 
 static inline bool slab_test_node_partial(const struct slab *slab)
 {
-	return test_bit(SL_partial, &slab->flags);
+	return test_bit(SL_partial, &slab->flags.f);
 }
 
 static inline void slab_set_node_partial(struct slab *slab)
 {
-	set_bit(SL_partial, &slab->flags);
+	set_bit(SL_partial, &slab->flags.f);
 }
 
 static inline void slab_clear_node_partial(struct slab *slab)
 {
-	clear_bit(SL_partial, &slab->flags);
+	clear_bit(SL_partial, &slab->flags.f);
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-introduce-memdesc_flags_t.patch
mm-convert-page_to_section-to-memdesc_section.patch
mm-introduce-memdesc_nid.patch
mm-introduce-memdesc_zonenum.patch
slab-use-memdesc_flags_t.patch
slab-use-memdesc_nid.patch
mm-introduce-memdesc_is_zone_device.patch
mm-reimplement-folio_is_device_private.patch
mm-reimplement-folio_is_device_coherent.patch
mm-reimplement-folio_is_fsdax.patch
mm-add-folio_is_pci_p2pdma.patch

