Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A980F34B434
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 19:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773690474; cv=none; b=jYsGpA1yk0Wa8/dLvVJOcmysuDJSXPLxsYl0yuL+MOT1O4Kdhf3IJHiAxIrEFt6PxvQJxaQQ15HtVFh+N3Mtf26Ee6IhQQhdQwAwYfa7fk+x81h263iWilXaEi3yDcIBoXJecNpeepqmh+4b0dpnznxAJFPfdmjskqFQJAWsSzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773690474; c=relaxed/simple;
	bh=MMNsn2cSzxxajDBxlNJeu2RXhvebboliWy+FYKmpUQA=;
	h=Date:To:From:Subject:Message-Id; b=bh8XR6FtHJ+yLrAFxHTN7YMrkZGp4eGC7Neb0w/znL+WBAllNMDvfip8EqForpSJ44C8kKIUTilml9VWCVSSba+KcEit6iYeJF6Bo9IZRnJBnr3vO7Z2+mjvbKKWDRO+eEdMYLoP5lifJ7K2JSZoEmKp8yvQBNwxbSXf6zdzmZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cw4drQ3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cw4drQ3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57228C19421;
	Mon, 16 Mar 2026 19:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773690474;
	bh=MMNsn2cSzxxajDBxlNJeu2RXhvebboliWy+FYKmpUQA=;
	h=Date:To:From:Subject:From;
	b=cw4drQ3ZCCW2Ts/PGIXRo0Mh76k8o7TfEEuyctNSXn0Eg2cc3bqme8K211MqyhiAf
	 o5wuhzvzGuSFodBoESGlCD6aR3pCo5RXVmc1xDDcrxz8b/mxzAdE/tm2BYAiHSW8Ko
	 QGZ2gqs1L4zjMmZOrAQLkVoiBGIvrkaVjYu9xSkE=
Date: Mon, 16 Mar 2026 12:47:53 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,mclapinski@google.com,graf@amazon.com,epetron@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kho-make-preserved-pages-compatible-with-deferred-struct-page-init.patch removed from -mm tree
Message-Id: <20260316194754.57228C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: make preserved pages compatible with deferred struct page init
has been removed from the -mm tree.  Its filename was
     kho-make-preserved-pages-compatible-with-deferred-struct-page-init.patch

This patch was dropped because an updated version will be issued

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


