Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34B023182D
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343215; cv=none; b=V8DA9CSCjrjeM3nZcEwff5VHGbn+QKUSY1L/PMOsiGQyRohUJF8c4ucCnQM/lGKHgeT8t6dwqdIPtZj//3FvySnXYKnDgiqZ1x7XVRA/4ioXqxCOthdT995L67owQoOqARtVItnDSK4Ib7Yy3kKZntdNAOxxspX1tRc5L4Tib30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343215; c=relaxed/simple;
	bh=5HtW2Gv3j8fGDZ+wlaifsOCmSYZWoOf+KOnc8l8vUac=;
	h=Date:To:From:Subject:Message-Id; b=jbPJD2JHC6Tb71cYhnRQ+KxPA8lKr0L4sizUbczRbEV8vBU/w9bguxhZvnESh1FKqsn3HIgYDHMJUM5d1WGD2lxZDf4f7GY33GnC2eMJYw3GkkLbRgIPfHH45ajlPFfjPw7L98zPEp5btip4Pw3oc/oaOtUuBjY8YjDfCIHlEGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Iuuv1qtp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Iuuv1qtp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CE8C16AAE;
	Mon, 17 Nov 2025 01:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343214;
	bh=5HtW2Gv3j8fGDZ+wlaifsOCmSYZWoOf+KOnc8l8vUac=;
	h=Date:To:From:Subject:From;
	b=Iuuv1qtphFfoNMEG7tYeMsOMiA291ehgRqMrDQE8i+KefuSttWmSViIEMlCrfk/xH
	 VtnhtYXSvQ19U/yGZCgiarOPv5aV+wEUjM2QxgF7D35xnYF8ZSZf3ErNGncEU1/TDH
	 U0MKp/Tj6kApQDZBUuzZRPgzmmd6qGP/R/TlTxUY=
Date: Sun, 16 Nov 2025 17:33:34 -0800
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,willy@infradead.org,will@kernel.org,vinicius.gomes@intel.com,vbabka@suse.cz,vasant.hegde@amd.com,urezki@gmail.com,tglx@linutronix.de,rppt@kernel.org,robin.murphy@arm.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.tian@intel.com,joro@8bytes.org,jgg@nvidia.com,jean-philippe@linaro.org,jannh@google.com,david@redhat.com,bp@alien8.de,baolu.lu@linux.intel.com,apopple@nvidia.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-a-ptdesc-flag-to-mark-kernel-page-tables.patch removed from -mm tree
Message-Id: <20251117013334.C1CE8C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add a ptdesc flag to mark kernel page tables
has been removed from the -mm tree.  Its filename was
     mm-add-a-ptdesc-flag-to-mark-kernel-page-tables.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
@@ -2962,6 +2962,7 @@ static inline pmd_t *pmd_alloc(struct mm
 #endif /* CONFIG_MMU */
 
 enum pt_flags {
+	PT_kernel = PG_referenced,
 	PT_reserved = PG_reserved,
 	/* High bits are used for zone/node/section */
 };
@@ -2988,6 +2989,46 @@ static inline bool pagetable_is_reserved
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


