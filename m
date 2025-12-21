Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27523157487
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 00:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766277408; cv=none; b=ZQAIfEzahW+D5YDKRWbpweX60iji4NqwNRQX2M+O3t8y2YR65Stn6DyQteGUfTs2oCiEnp7osoCvrSN4cgglw8ZF4dCCVYECsy2PHnAG7CQFQDrJgMBt8NOVonAsmvRs0Hu2sjY4ntkR5jGb9s3aapO+mtkJAEtukAYIlnuK09o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766277408; c=relaxed/simple;
	bh=VJoTCxl4D/CNOQRBqiY1Q1bQMpd9YIhR7ZH0cgD0avM=;
	h=Date:To:From:Subject:Message-Id; b=nIDd9PQBsNt7p1km8uL9CpKGqR87F3FbFE1p7v0IfOF/FjMCEDLdlyB+j36xwYUqAGIJxV6ZzlPu/quCgUspSxWb1Uw7VSANLZqbQdfoniFGmhOJJCOeHHWBg0QdRSbRlrvdLgBEV027WfVJlfLIoXpCQFTFVzpW/TPGRmXgJiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qlrnBt7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qlrnBt7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F81FC4CEF5;
	Sun, 21 Dec 2025 00:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766277406;
	bh=VJoTCxl4D/CNOQRBqiY1Q1bQMpd9YIhR7ZH0cgD0avM=;
	h=Date:To:From:Subject:From;
	b=qlrnBt7hib1HzCyrU1Lw1Fhl68KYD/8E85bsszt8rHelYJMJNwKVOI66LazGzbbVa
	 wldvn7dYYiDRf4S5sBZ2tbPR0lXES1SRU5DPyPLB9td+RaSYSF1QFrJZTNEAVDSWPS
	 a5Y6IPQtvhKZl/4gc4PMZduYtpIMxbQRz1r1yuOw=
Date: Sat, 20 Dec 2025 16:36:46 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,niecheng1@uniontech.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,anshuman.khandual@arm.com,guanwentao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cleanup-vma_iter_bulk_alloc.patch added to mm-new branch
Message-Id: <20251221003646.9F81FC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: cleanup vma_iter_bulk_alloc
has been added to the -mm mm-new branch.  Its filename is
     mm-cleanup-vma_iter_bulk_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cleanup-vma_iter_bulk_alloc.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Wentao Guan <guanwentao@uniontech.com>
Subject: mm: cleanup vma_iter_bulk_alloc
Date: Thu, 6 Nov 2025 19:09:29 +0800

commit d24062914837 ("fork: use __mt_dup() to duplicate maple tree in
dup_mmap()"), removed the only user and mas_expected_entries has been
removed, since commit e3852a1213ffc ("maple_tree: Drop bulk insert
support").  Also cleanup the mas_expected_entries in maple_tree.h.

No functional change.

Link: https://lkml.kernel.org/r/20251106110929.3522073-1-guanwentao@uniontech.com
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Cheng Nie <niecheng1@uniontech.com>
Cc: Guan Wentao <guanwentao@uniontech.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    1 -
 mm/vma.h                   |    6 ------
 2 files changed, 7 deletions(-)

--- a/include/linux/maple_tree.h~mm-cleanup-vma_iter_bulk_alloc
+++ a/include/linux/maple_tree.h
@@ -528,7 +528,6 @@ bool mas_nomem(struct ma_state *mas, gfp
 void mas_pause(struct ma_state *mas);
 void maple_tree_init(void);
 void mas_destroy(struct ma_state *mas);
-int mas_expected_entries(struct ma_state *mas, unsigned long nr_entries);
 
 void *mas_prev(struct ma_state *mas, unsigned long min);
 void *mas_prev_range(struct ma_state *mas, unsigned long max);
--- a/mm/vma.h~mm-cleanup-vma_iter_bulk_alloc
+++ a/mm/vma.h
@@ -558,12 +558,6 @@ static inline unsigned long vma_iter_end
 	return vmi->mas.last + 1;
 }
 
-static inline int vma_iter_bulk_alloc(struct vma_iterator *vmi,
-				      unsigned long count)
-{
-	return mas_expected_entries(&vmi->mas, count);
-}
-
 static inline
 struct vm_area_struct *vma_iter_prev_range(struct vma_iterator *vmi)
 {
_

Patches currently in -mm which might be from guanwentao@uniontech.com are

mm-cleanup-vma_iter_bulk_alloc.patch

