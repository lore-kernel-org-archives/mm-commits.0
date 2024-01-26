Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C091B7494
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235406; cv=none; b=gKsCmcJ494QF8rXyfrV2HLCIo6NWHY+VyyXTM6GYUcWMjb1mUs2MkwB//p363HAh4L3LiRUnWnCNxwslOqParbgNeoZyNEiklMKZbvO26lYTDnYf+JXPAtxsPdyO2r/7q4wnHOIczW00bH66qPDKykdD2KmsDkEFywcorzqvqrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235406; c=relaxed/simple;
	bh=aw8CUIY3hD6jKKGX2AWV4fYqsecEenKKyEohnJxDMJQ=;
	h=Date:To:From:Subject:Message-Id; b=DEZbgY2oixaHr0KZM4dCTbBw6Ws/Vp8pFFkR/Gaul0DJI7x+s8cjb31H9IABvBpslWFkj/U6kKbQ9IdMxdgUvpOuE8+YF/vNj/+pGdvSYCghHDGi+Vtc+h9sVm5FUa4mgzf1Znrk7ci+rhexvRxhtSEDJvrhpLNv2sWCeX30BQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=frHbXFS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="frHbXFS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD32BC433F1;
	Fri, 26 Jan 2024 02:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235406;
	bh=aw8CUIY3hD6jKKGX2AWV4fYqsecEenKKyEohnJxDMJQ=;
	h=Date:To:From:Subject:From;
	b=frHbXFS+uHCM2FfHajTQ9BmeUUt54WphujTb/oC1Dvl3w0j6c+NrgB9HfJ9hS2Fno
	 2VdmoYSKqyELJXGyih8+14TwYJ0GpEhXX01iYartai3+/OUlTqtpBfDxN3M4p2HBPt
	 wEYaycf+nBWWND62gU80RucgURA2tli3cSJuJ34Y=
Date: Thu, 25 Jan 2024 18:16:43 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + highmem-add-kernel-doc-for-memcpy__folio.patch added to mm-unstable branch
Message-Id: <20240126021645.CD32BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: highmem: add kernel-doc for memcpy_*_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     highmem-add-kernel-doc-for-memcpy__folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-add-kernel-doc-for-memcpy__folio.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: highmem: add kernel-doc for memcpy_*_folio()
Date: Wed, 24 Jan 2024 18:12:15 +0000

This was inadvertently skipped when adding the new functions.

Link: https://lkml.kernel.org/r/20240124181217.1761674-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/include/linux/highmem.h~highmem-add-kernel-doc-for-memcpy__folio
+++ a/include/linux/highmem.h
@@ -439,6 +439,13 @@ static inline void memzero_page(struct p
 	kunmap_local(addr);
 }
 
+/**
+ * memcpy_from_folio - Copy a range of bytes from a folio.
+ * @to: The memory to copy to.
+ * @folio: The folio to read from.
+ * @offset: The first byte in the folio to read.
+ * @len: The number of bytes to copy.
+ */
 static inline void memcpy_from_folio(char *to, struct folio *folio,
 		size_t offset, size_t len)
 {
@@ -460,6 +467,13 @@ static inline void memcpy_from_folio(cha
 	} while (len > 0);
 }
 
+/**
+ * memcpy_to_folio - Copy a range of bytes to a folio.
+ * @folio: The folio to write to.
+ * @offset: The first byte in the folio to store to.
+ * @from: The memory to copy from.
+ * @len: The number of bytes to copy.
+ */
 static inline void memcpy_to_folio(struct folio *folio, size_t offset,
 		const char *from, size_t len)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

memcg-convert-mem_cgroup_move_charge_pte_range-to-use-a-folio.patch
memcg-return-the-folio-in-union-mc_target.patch
memcg-use-a-folio-in-get_mctgt_type.patch
memcg-use-a-folio-in-get_mctgt_type_thp.patch
mm-add-pfn_swap_entry_folio.patch
proc-use-pfn_swap_entry_folio-where-obvious.patch
mprotect-use-pfn_swap_entry_folio.patch
highmem-add-kernel-doc-for-memcpy__folio.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

