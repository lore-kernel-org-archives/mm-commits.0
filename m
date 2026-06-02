Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E930A3C3BED
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439131; cv=none; b=RaP0ORiGysxQV1xjmgN/zkkTBZXywJuFxC/eKVYDaWIdeHt0o1LbQdCbx93cLyne2tmbXvGnhAu1O9riwmMP+g8Ip7ItfC48nw3RwwOQyPDNXfkKjbmts84mzk5+5eGWDvmJJuBDZ9z/4ixUBwx9LZAjdYuJRr4ULDOZ/FB8ffM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439131; c=relaxed/simple;
	bh=MCSM+RX4ryGwIWB1r8hko4o+eEMvHyACOS+TESq6HPM=;
	h=Date:To:From:Subject:Message-Id; b=eT01QTHW2ftf0xg3RcPMPbsSD4c2R7uQSD74XqmE3c2/Y9I5uwgIsfIcAgfXW5kps81uVUzsBLA+GzBN0mBf8W0EiSJJ7xI3cy6rhZhMgHIMVjCeATxZ2L8aM0IL9luykdVuiwSJDztnu0UDp17fY38//mXqPtIzECep8N6nRCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P5dp/qYv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P5dp/qYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E611F00893;
	Tue,  2 Jun 2026 22:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439129;
	bh=weP1u22eDrCJ3gMufwcDW9gu5TdECvPvXd7WF7stJpE=;
	h=Date:To:From:Subject;
	b=P5dp/qYvsjjacBOdU0w5vA8I220WRF+G73ud4RH5JAaAaCmouKD7wlB8aNCuGih4C
	 tJa6aifyGQdkAwWs1bTFrdpdnhTHPtQVrQCRpk76rlaw3sU6zCoZ+nJK+NuX2kVvOS
	 M0aHlm8mhfBSlW5Vc16eiJwU69OVEeQUiQjhV9F8=
Date: Tue, 02 Jun 2026 15:25:29 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,leon.hwang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-admin-guide-mm-fix-typos-in-transhugerst.patch removed from -mm tree
Message-Id: <20260602222529.C0E611F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/admin-guide/mm: fix typos in transhuge.rst
has been removed from the -mm tree.  Its filename was
     documentation-admin-guide-mm-fix-typos-in-transhugerst.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Leon Hwang <leon.hwang@linux.dev>
Subject: Documentation/admin-guide/mm: fix typos in transhuge.rst
Date: Wed, 20 May 2026 13:17:51 +0800

Fix these two typos:

1. approporiately -> appropriately
2. presure -> pressure

Link: https://lore.kernel.org/20260520051751.74396-1-leon.hwang@linux.dev
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leon Hwang <leon.hwang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~documentation-admin-guide-mm-fix-typos-in-transhugerst
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -57,7 +57,7 @@ prominent because the size of each page
 variant and there is less memory to clear in each page fault. Some
 architectures also employ TLB compression mechanisms to squeeze more
 entries in when a set of PTEs are virtually and physically contiguous
-and approporiately aligned. In this case, TLB misses will occur less
+and appropriately aligned. In this case, TLB misses will occur less
 often.
 
 THP can be enabled system wide or restricted to certain tasks or even
@@ -210,7 +210,7 @@ PMD-mappable transparent hugepage::
 	cat /sys/kernel/mm/transparent_hugepage/hpage_pmd_size
 
 All THPs at fault and collapse time will be added to _deferred_list,
-and will therefore be split under memory presure if they are considered
+and will therefore be split under memory pressure if they are considered
 "underused". A THP is underused if the number of zero-filled pages in
 the THP is above max_ptes_none (see below). It is possible to disable
 this behaviour by writing 0 to shrink_underused, and enable it by writing
_

Patches currently in -mm which might be from leon.hwang@linux.dev are


