Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C5D34B438
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 19:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773690125; cv=none; b=QhRUMe31t3juklXk4X1uicyhTgklNKFWSf7/HbwDz0o8yGRNeQvVA+XF8jNNRDxpIiA3r0k75Bnkhlpmky+cSXOzcdNZAIHlVoMVfAhMNg5dyIEczgk9MH3CNRF0coA8sS2AEe8uhN4L2/843rmevlAUza4V9o8AYd99tXTpoxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773690125; c=relaxed/simple;
	bh=EM5Wb/Vn4OMkMx2LkxVCaRvLQ3QBY6UWYvJK+iYXYdI=;
	h=Date:To:From:Subject:Message-Id; b=rVgMMCHDw9b8ALW4ylOE93V/QVnqGp5SmEpkddBFhvaKQ0c4PGRy4r+Rgvhs/7M5OtX6Yt/c0s2AX9kN6ZZSfgFzBc+zsmLIh+CWpseqG+qaAhO7n2CBVNDpmsnXmFzHOdxm5WSqKreVic3iMwZRHZRwKsDmTLnlDR/C/k0CNZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UU9PX+kQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UU9PX+kQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A01C19421;
	Mon, 16 Mar 2026 19:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773690125;
	bh=EM5Wb/Vn4OMkMx2LkxVCaRvLQ3QBY6UWYvJK+iYXYdI=;
	h=Date:To:From:Subject:From;
	b=UU9PX+kQNapB9REHbHbERMAJHEkm//U+62uuWGgAQk7onPNzt4Jdbm6HDUa/GGUOe
	 nfEnhK6ELqppAqHo6z6YuAtiy/x1Wdpi1OMurQpyabis9qDY1UhPlCglzrDv5cBmC4
	 xvERX0xi3ZZM9mzOqWzgP4ezTEMHcEjc0kRX5Aw4=
Date: Mon, 16 Mar 2026 12:42:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yanglincheng@kylinos.cn,ryan.roberts@arm.com,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,vernon2gm@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-skip-lazy-free-folios-fix.patch added to mm-unstable branch
Message-Id: <20260316194205.16A01C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-khugepaged-skip-lazy-free-folios-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-skip-lazy-free-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-skip-lazy-free-folios-fix.patch

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
From: Vernon Yang <vernon2gm@gmail.com>
Subject: mm-khugepaged-skip-lazy-free-folios-fix
Date: Thu, 26 Feb 2026 15:55:45 +0800

add comment about VM_DROPPABLE in code, make it clearer

Link: https://lkml.kernel.org/r/i4uowkt4h2ev47obm5h2vtd4zbk6fyw5g364up7kkjn2vmcikq@auepvqethj5r
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-skip-lazy-free-folios-fix
+++ a/mm/khugepaged.c
@@ -578,6 +578,10 @@ static enum scan_result __collapse_huge_
 		folio = page_folio(page);
 		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
 
+		/*
+		 * If the vma has the VM_DROPPABLE flag, the collapse will
+		 * preserve the lazyfree property without needing to skip.
+		 */
 		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
@@ -1332,6 +1336,10 @@ static enum scan_result hpage_collapse_s
 		}
 		folio = page_folio(page);
 
+		/*
+		 * If the vma has the VM_DROPPABLE flag, the collapse will
+		 * preserve the lazyfree property without needing to skip.
+		 */
 		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
_

Patches currently in -mm which might be from vernon2gm@gmail.com are

mm-khugepaged-refine-scan-progress-number-fix.patch
mm-khugepaged-skip-lazy-free-folios-fix.patch

