Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E182222AF
	for <mm-commits@vger.kernel.org>; Wed, 22 Oct 2025 19:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761159726; cv=none; b=LEVKOtnXSBwQLLbUPlm4YoQ+ZoegI+Kv3MJdmaQhfjS9+cBFAFsFfhe5TBh3xOsOxX4NUG0My42Z52IWplqdHsrR90PEQzjqcaak3LAqn6OKNM4+4vDxc3O2BkUloWJgEbLeM7kCZWBiX6Iu8Q/qlcO0LcYaO8RYNjjoH4EowqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761159726; c=relaxed/simple;
	bh=S2OjIeEwS97TtKP//DZyf5fy7pINM9kSai9e5w8PT7w=;
	h=Date:To:From:Subject:Message-Id; b=eSfLiY6E1v4wXYKlnRH+SMlzAO7Xf74wUpp5zB0Uk8UTvxP1TpCFL4J/Zb4q4r1n/ltClrb8G/G5cKR0T7knBDfOGPAaIKngThlgMUXon3/mMxHE1+Z7fxjNMAMggEV59ZkZL95lceIGhEZ/LpJcKqG0eiDC+St3mc4wPBJZqOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2GHIlMvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2GHIlMvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04CFC4CEE7;
	Wed, 22 Oct 2025 19:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761159724;
	bh=S2OjIeEwS97TtKP//DZyf5fy7pINM9kSai9e5w8PT7w=;
	h=Date:To:From:Subject:From;
	b=2GHIlMvKBxYHBpedji/7e+cAD1qI/jt/ELNc1c+mgbxZOvSn7MT6sMd5EwvSj2HWx
	 d04/3Ana20RIXXEIFxa8oRhY1PyAA5A1tUNWsAw4ZqYDwTLMkxsRWPrfS69nLkauYe
	 CxMtTe0zz2ET7K0cYD29fTO0SfofkPZ3E5eEg19w=
Date: Wed, 22 Oct 2025 12:02:04 -0700
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,willy@infradead.org,will@kernel.org,vinicius.gomes@intel.com,vbabka@suse.cz,vasant.hegde@amd.com,urezki@gmail.com,tglx@linutronix.de,rppt@kernel.org,robin.murphy@arm.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.tian@intel.com,joro@8bytes.org,jgg@nvidia.com,jean-philippe@linaro.org,jannh@google.com,david@redhat.com,bp@alien8.de,baolu.lu@linux.intel.com,apopple@nvidia.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-a-ptdesc-flag-to-mark-kernel-page-tables.patch added to mm-new branch
Message-Id: <20251022190204.C04CFC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add a ptdesc flag to mark kernel page tables
has been added to the -mm mm-new branch.  Its filename is
     mm-add-a-ptdesc-flag-to-mark-kernel-page-tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-a-ptdesc-flag-to-mark-kernel-page-tables.patch

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
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: add a ptdesc flag to mark kernel page tables
Date: Wed, 22 Oct 2025 16:26:28 +0800

The page tables used to map the kernel and userspace often have very
different handling rules.  There are frequently *_kernel() variants of
functions just for kernel page tables.  That's not great and has lead to
code duplication.

Instead of having completely separate call paths, allow a 'ptdesc' to be
marked as being for kernel mappings.  Introduce helpers to set and clear
this status.

Note: this uses the PG_referenced bit.  Page flags are a great fit for
this since it is truly a single bit of information.  Use PG_referenced
itself because it's a fairly benign flag (as opposed to things like
PG_lock).  It's also (according to Willy) unlikely to go away any time
soon.

PG_referenced is not in PAGE_FLAGS_CHECK_AT_FREE.  It does not need to be
cleared before freeing the page, and pages coming out of the allocator
should have it cleared.  Regardless, introduce an API to clear it anyway. 
Having symmetry in the API makes it easier to change the underlying
implementation later, like if there was a need to move to a
PAGE_FLAGS_CHECK_AT_FREE bit.

Link: https://lkml.kernel.org/r/20251022082635.2462433-3-baolu.lu@linux.intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

--- a/include/linux/mm.h~mm-add-a-ptdesc-flag-to-mark-kernel-page-tables
+++ a/include/linux/mm.h
@@ -2955,6 +2955,7 @@ static inline pmd_t *pmd_alloc(struct mm
 #endif /* CONFIG_MMU */
 
 enum pt_flags {
+	PT_kernel = PG_referenced,
 	PT_reserved = PG_reserved,
 	/* High bits are used for zone/node/section */
 };
@@ -2981,6 +2982,46 @@ static inline bool pagetable_is_reserved
 }
 
 /**
+ * ptdesc_set_kernel - Mark a ptdesc used to map the kernel
+ * @ptdesc: The ptdesc to be marked
+ *
+ * Kernel page tables often need special handling. Set a flag so that
+ * the handling code knows this ptdesc will not be used for userspace.
+ */
+static inline void ptdesc_set_kernel(struct ptdesc *ptdesc)
+{
+	set_bit(PT_kernel, &ptdesc->pt_flags.f);
+}
+
+/**
+ * ptdesc_clear_kernel - Mark a ptdesc as no longer used to map the kernel
+ * @ptdesc: The ptdesc to be unmarked
+ *
+ * Use when the ptdesc is no longer used to map the kernel and no longer
+ * needs special handling.
+ */
+static inline void ptdesc_clear_kernel(struct ptdesc *ptdesc)
+{
+	/*
+	 * Note: the 'PG_referenced' bit does not strictly need to be
+	 * cleared before freeing the page. But this is nice for
+	 * symmetry.
+	 */
+	clear_bit(PT_kernel, &ptdesc->pt_flags.f);
+}
+
+/**
+ * ptdesc_test_kernel - Check if a ptdesc is used to map the kernel
+ * @ptdesc: The ptdesc being tested
+ *
+ * Call to tell if the ptdesc used to map the kernel.
+ */
+static inline bool ptdesc_test_kernel(const struct ptdesc *ptdesc)
+{
+	return test_bit(PT_kernel, &ptdesc->pt_flags.f);
+}
+
+/**
  * pagetable_alloc - Allocate pagetables
  * @gfp:    GFP flags
  * @order:  desired pagetable order
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-add-a-ptdesc-flag-to-mark-kernel-page-tables.patch
mm-actually-mark-kernel-page-table-pages.patch
x86-mm-use-ptdesc-when-freeing-pmd-pages.patch
mm-introduce-pure-page-table-freeing-function.patch
mm-introduce-deferred-freeing-for-kernel-page-tables.patch

