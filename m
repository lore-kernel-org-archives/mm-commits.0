Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145571FC110
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 16:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773247593; cv=none; b=pXCEtb0ptdKxT/4hhptqlQ9Mydqxliizk+/a6qW2BFmGNts0ANnnXXfyUTQG6Opw0l4q06lfUQ9762o43CDsnk137Ed4K60IvK+4pJ0WIF3crAdpRI8jFnEZojFIWIhGL8fv+sUdwX+f9n2DIVUutIHpoPCa/tB+dKGds/9LeAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773247593; c=relaxed/simple;
	bh=2E82letygI+4/uceOMbFsW+duYW+YCpibIx/qSenY4U=;
	h=Date:To:From:Subject:Message-Id; b=eleDyWqESjSN4HzaiE9fj7N1WzSbth1fd8RXNdAecSgLr7s06DnKioRET93NLODv+z9CXu+LjAT5nlcT7UHFszRJcb8eDc76tQJmHH8Amsj0KMzDxCG9N21rgklK//L4wOYxc6NFeVMKi7Ep8s5os1UliO7xE+j/Zonfp+dxCCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bVNUp3Kg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bVNUp3Kg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4FFC4CEF7;
	Wed, 11 Mar 2026 16:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773247592;
	bh=2E82letygI+4/uceOMbFsW+duYW+YCpibIx/qSenY4U=;
	h=Date:To:From:Subject:From;
	b=bVNUp3KgMz+4BwyK0mwXlXNkai4SVCTGvtNdX3y1y7uAIUSIucM6App0YoQ55K5U/
	 tKPekwPjW0gkoAOJTmUvC7hn2vobVE6pkg0FLnUP6oLCtn786rzzjS0ZfPAiaunA6P
	 DrM23VYvxhEnUXAjjxTgXiTnteUD8IM+/svT9PYc=
Date: Wed, 11 Mar 2026 09:46:31 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,mclapinski@google.com,graf@amazon.com,epetron@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-make-preserved-pages-compatible-with-deferred-struct-page-init.patch added to mm-unstable branch
Message-Id: <20260311164632.9B4FFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: make preserved pages compatible with deferred struct page init
has been added to the -mm mm-unstable branch.  Its filename is
     kho-make-preserved-pages-compatible-with-deferred-struct-page-init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-make-preserved-pages-compatible-with-deferred-struct-page-init.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Evangelos Petrongonas <epetron@amazon.de>
Subject: kho: make preserved pages compatible with deferred struct page init
Date: Wed, 11 Mar 2026 13:55:39 +0100

When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
initialization is deferred to parallel kthreads that run later in the boot
process.

During KHO restoration, kho_preserved_memory_reserve() writes metadata for
each preserved memory region.  However, if the struct page has not been
initialized, this write targets uninitialized memory, potentially leading
to errors like: BUG: unable to handle page fault for address: ...

Fix this by introducing kho_get_preserved_page(), which ensures all struct
pages in a preserved region are initialized by calling
init_deferred_page() which is a no-op when the struct page is already
initialized.

Link: https://lkml.kernel.org/r/20260311125539.4123672-3-mclapinski@google.com
Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
Co-developed-by: Michal Clapinski <mclapinski@google.com>
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/Kconfig          |    2 --
 kernel/liveupdate/kexec_handover.c |   27 ++++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 3 deletions(-)

--- a/kernel/liveupdate/Kconfig~kho-make-preserved-pages-compatible-with-deferred-struct-page-init
+++ a/kernel/liveupdate/Kconfig
@@ -1,12 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 menu "Live Update and Kexec HandOver"
-	depends on !DEFERRED_STRUCT_PAGE_INIT
 
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
-	depends on !DEFERRED_STRUCT_PAGE_INIT
 	select MEMBLOCK_KHO_SCRATCH
 	select KEXEC_FILE
 	select LIBFDT
--- a/kernel/liveupdate/kexec_handover.c~kho-make-preserved-pages-compatible-with-deferred-struct-page-init
+++ a/kernel/liveupdate/kexec_handover.c
@@ -470,6 +470,31 @@ struct page *kho_restore_pages(phys_addr
 }
 EXPORT_SYMBOL_GPL(kho_restore_pages);
 
+/*
+ * With CONFIG_DEFERRED_STRUCT_PAGE_INIT, struct pages in higher memory regions
+ * may not be initialized yet at the time KHO deserializes preserved memory.
+ * KHO uses the struct page to store metadata and a later initialization would
+ * overwrite it.
+ * Ensure all the struct pages in the preservation are
+ * initialized. kho_preserved_memory_reserve() marks the reservation as noinit
+ * to make sure they don't get re-initialized later.
+ */
+static struct page *__init kho_get_preserved_page(phys_addr_t phys,
+						  unsigned int order)
+{
+	unsigned long pfn = PHYS_PFN(phys);
+	int nid;
+
+	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
+		return pfn_to_page(pfn);
+
+	nid = early_pfn_to_nid(pfn);
+	for (unsigned long i = 0; i < (1UL << order); i++)
+		init_deferred_page(pfn + i, nid);
+
+	return pfn_to_page(pfn);
+}
+
 static int __init kho_preserved_memory_reserve(phys_addr_t phys,
 					       unsigned int order)
 {
@@ -478,7 +503,7 @@ static int __init kho_preserved_memory_r
 	u64 sz;
 
 	sz = 1 << (order + PAGE_SHIFT);
-	page = phys_to_page(phys);
+	page = kho_get_preserved_page(phys, order);
 
 	/* Reserve the memory preserved in KHO in memblock */
 	memblock_reserve(phys, sz);
_

Patches currently in -mm which might be from epetron@amazon.de are

kho-make-preserved-pages-compatible-with-deferred-struct-page-init.patch

