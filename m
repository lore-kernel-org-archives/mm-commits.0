Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8135435CBC3
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762906602; cv=none; b=Dr+X2iAxcCmCdjo09xTBATlgjxJC7xPxyEB6KlYmGbsiYlJUd7JeczeE+huFrMySTJesunxTyAruwOivxl0l2GLtX630G7ldJlcehCqBtkktkUSaTnJCIrTSUrOSx1sNnLlG/Ee3kDJWPFO6JwJH1ed0qac/joix9AgpNsjb00I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762906602; c=relaxed/simple;
	bh=t5kiYu1c02DyPgrEEDy/otgefhPzol/d7P5bRnYdmuo=;
	h=Date:To:From:Subject:Message-Id; b=FqTjt4wiEm0FFi9amXt/sj3D8WDRH1/eS0AfB3eYvpuvY2zECRxFN+faCIgIAnAr+H54ilcLPhRSeeEsgi3aiXV2NMsGLF6bBGQPFqYB7xqX76eLc1qd03RW/T/iBiU/r63uk7otthui4e1hEIyjsB5o/BMNd00/5PpAUSkx1gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0k1Tt6Cv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0k1Tt6Cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53394C4CEF5;
	Wed, 12 Nov 2025 00:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762906602;
	bh=t5kiYu1c02DyPgrEEDy/otgefhPzol/d7P5bRnYdmuo=;
	h=Date:To:From:Subject:From;
	b=0k1Tt6CvtVNIbx1TPHf3IVB+nNxFtdkZuT3LjOBEe8ucAMynPOyKFHS2/xhnpuGsF
	 RvGs3XSCHRTZHJfgEkSp4i2mYUYIx/5pQovUV6WFVTTLy3M0g9AJsLBTwtCAx2b3TZ
	 3ETnUNWEeph6Lrdmf6VZIMum8oSfccnjvXIOHngk=
Date: Tue, 11 Nov 2025 16:16:41 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,rdunlap@infradead.org,osandov@osandov.com,lorenzo.stoakes@oracle.com,linux@israelbatista.dev.br,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-change-type-of-state-in-struct-memory_block-fix.patch removed from -mm tree
Message-Id: <20251112001642.53394C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-change-type-of-state-in-struct-memory_block-fix
has been removed from the -mm tree.  Its filename was
     mm-change-type-of-state-in-struct-memory_block-fix.patch

This patch was dropped because it was folded into mm-change-type-of-state-in-struct-memory_block.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-change-type-of-state-in-struct-memory_block-fix
Date: Wed Oct 29 02:53:40 PM PDT 2025

fix whitespace, per Randy

Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Israel Batista <linux@israelbatista.dev.br>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memory.h~mm-change-type-of-state-in-struct-memory_block-fix
+++ a/include/linux/memory.h
@@ -78,7 +78,7 @@ enum memory_block_state {
 
 struct memory_block {
 	unsigned long start_section_nr;
-	enum memory_block_state state; /* serialized by the dev->lock */
+	enum memory_block_state state;	/* serialized by the dev->lock */
 	int online_type;		/* for passing data to online routine */
 	int nid;			/* NID for this memory block */
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-change-type-of-state-in-struct-memory_block.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix-fix.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
liveupdate-luo_file-implement-file-systems-callbacks-fix.patch
mm-shmem-use-shmem_f_-flags-instead-of-vm_-flags-fix.patch

