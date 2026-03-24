Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B37733BBCD
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774386796; cv=none; b=a26HaIe+f+JT6iwh9egRZVycFZHVwbV3EdU1wi4fJutJGSHqJXa0bcNEYAAPXewHwLVpr218HT5usVrQb8G9vrDGAUi8GbdZIgdj6DzId1Io06K319RIIUAsjUZiyjXTm+SKAcawKszwz5Ak7+ka5C1QfWnJJGK0onCLvay8NB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774386796; c=relaxed/simple;
	bh=3BBOSm1bRw2NrjJUA86n70LwpNSf/RmMqmch6gj4xd8=;
	h=Date:To:From:Subject:Message-Id; b=AFrlCKC4QkHSU+Ppeny7nioTgsR17bqkK/4NXNIkILFPa2WVTdjavIgpCAdR6jeYqFiR2iKom2Wl0WeVk0imKH9SQI4mxczDx+7tAJtnoqbQeQk18fNG9+CpIKKMNwHLCVWEWMDFT0h1Ak1nUdWx+6WDU4lIOGekt6Y0DenxKZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JTE/1OYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JTE/1OYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09654C19424;
	Tue, 24 Mar 2026 21:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774386796;
	bh=3BBOSm1bRw2NrjJUA86n70LwpNSf/RmMqmch6gj4xd8=;
	h=Date:To:From:Subject:From;
	b=JTE/1OYctElwFOX4hmonfxRULBl+X66T2I5eVlEzi1ulNHRpv+cOVEdllvIFnDeo7
	 90vEiDpnAIIF5llD242RWMvBRwxhZ8g8qlhRIrsAOdpbXB4cI1zPGiJY6BVkXy2xsB
	 zj9XK5GwcJ3B+siPfws89PWDosc4iuUtYX/wNARk=
Date: Tue, 24 Mar 2026 14:13:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yanglincheng@kylinos.cn,ryan.roberts@arm.com,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,vernon2gm@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-skip-lazy-free-folios-fix.patch removed from -mm tree
Message-Id: <20260324211316.09654C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-khugepaged-skip-lazy-free-folios-fix
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-skip-lazy-free-folios-fix.patch

This patch was dropped because it was folded into mm-khugepaged-skip-lazy-free-folios.patch

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
mm-khugepaged-skip-lazy-free-folios.patch

