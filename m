Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A171F5437
	for <mm-commits@vger.kernel.org>; Sat, 30 May 2026 00:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780101643; cv=none; b=Zd8ajxhQ5WIAPUx2YYltj4VYBwLA+cmSaXjlkoGyI+d6I/jIlz2zBWGoQ5Y4ON6fOC1FNwqr5ATLf2u+F4zyfy9Q7qnibWvPiDTY0bYnqednUnv0iuS1Ju1IQI74N9IUpnyu8iRd/uL4bxA2K1lj3L6TBO605PP/9GZBCeCUHEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780101643; c=relaxed/simple;
	bh=CVLZKfgnSfYSFhJMjr4fNDzoxpZkQSB52Q94xkAUHlw=;
	h=Date:To:From:Subject:Message-Id; b=P+1S2+8v3IwzmQukXTCf3NwCJxwqesLe9dsDYT5Uwtdc1/e9cdXA4nPqTcS2Og9i9nuOTKHPyjDvsAOnkB45K1EOhE765Z58aE75GVBJsBBPeycbN76C/R2Ee8XFnR317hpdsZJRLfJeZdycIto9VIZji5tdntPelSmESQvHwYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hPtGsLpj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hPtGsLpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4465A1F00893;
	Sat, 30 May 2026 00:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780101641;
	bh=eaMaeOSSk/illiYs/kBvJ3IU2qYZ2MEsjAePp2M/vAY=;
	h=Date:To:From:Subject;
	b=hPtGsLpjaKATXKpF6UDxenVz+rzP4ymxPsgUyLXCUTI7UEm5g2K6q0oq+cLHrsOP3
	 ox35HV/5aXI/QCLvUTzDXICfQzrUyilb2RG6N8KiIauzIVCChkteekFSViAlQUouzI
	 uJnbBXFQj5mx09CEwi/PiDC0FFlWx8n35gRkVtGM=
Date: Fri, 29 May 2026 17:40:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,rmclure@linux.ibm.com,r@hev.cc,pfalcato@suse.de,pasha.tatashin@soleen.com,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kevin.brodsky@arm.com,kees@kernel.org,kas@kernel.org,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-mapping_max_folio_order-for-force_thp_readahead-order-fix.patch added to mm-new branch
Message-Id: <20260530004041.4465A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: add comment explaining design decision
has been added to the -mm mm-new branch.  Its filename is
     mm-use-mapping_max_folio_order-for-force_thp_readahead-order-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-mapping_max_folio_order-for-force_thp_readahead-order-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Usama Arif <usama.arif@linux.dev>
Subject: add comment explaining design decision
Date: Fri, 29 May 2026 05:31:05 -0700

Link: https://lore.kernel.org/fb47629e-6533-4c87-ac0b-e3a48a890ef4@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Heiher <r@hev.cc>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rohan McLure <rmclure@linux.ibm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/filemap.c~mm-use-mapping_max_folio_order-for-force_thp_readahead-order-fix
+++ a/mm/filemap.c
@@ -3319,6 +3319,14 @@ static struct file *do_sync_mmap_readahe
 
 	/* Use the readahead code, even if readahead is disabled */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
+		/*
+		 * Preserve PMD-sized readahead where it already fits in
+		 * the page cache. Otherwise cap the new fallback path at
+		 * 2MB: this is the common PMD-sized hugepage size, and it
+		 * avoids memory pressure from very large forced readahead
+		 * when mapping_max_folio_order() is high (for example,
+		 * 128MB with 64K base pages on arm64).
+		 */
 		if (HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
 			force_thp_readahead = true;
 			thp_order = HPAGE_PMD_ORDER;
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-make-mmap_miss-accounting-symmetric-for-vm_seq_read.patch
mm-bypass-mmap_miss-heuristic-for-vm_exec-readahead.patch
mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch
mm-use-mapping_max_folio_order-for-force_thp_readahead-order-fix.patch

