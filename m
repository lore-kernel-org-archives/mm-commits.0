Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93F0168C4
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473125; cv=none; b=dFqiUtdcOTkQ1IoPMrsZwp8t4m9MdEJjQpG/8OM75ba/L3ypqGJLlv+G9/aAh7nuEFVXOjjVnuH42X+5FTcBiCIBfaR+ztsXOhBiOFPfeOouiaLKSUbh41wbDC1y8TKahvOks8/xR+MbAq65G+3UB79cvjL3pB9jWexhKkeHvaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473125; c=relaxed/simple;
	bh=oUbDIr2QLQnqqgwJ87gd31E7w+BgomxZ6o5aDZwtASI=;
	h=Date:To:From:Subject:Message-Id; b=IdbsBFCL3/y7Dg8vFD8BhgvAf6YTUyCEQHZm8yRgJrqWG98Z1han/UqlFj7i1mB9atpfbxR+58WOge8X4xn97EiQfatMq567jTE4ULm22ijq1/r2WhDcwJGjcnrSCUQDkqeKUsBYtFWKeywt2bMdhZ62K0tnGLekrwPynfzx5mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dmg5Nyew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dmg5Nyew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDC4C116B1;
	Sat, 15 Jun 2024 17:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473125;
	bh=oUbDIr2QLQnqqgwJ87gd31E7w+BgomxZ6o5aDZwtASI=;
	h=Date:To:From:Subject:From;
	b=dmg5Nyewf+vahGAbVYn2c32wdbN6gxL1/XD917c7byTKaNceYRqDQm1DCVTp6GVb4
	 b7mM5wNz3n5CyHvREgdRSy3yfX3jX544waOEKO1wGJU0qn5yzwpf7NXPsL7GQ8UIqU
	 ++zzATnSd7FiQVNI6zJs4SxKfQHWKWgh53a19rnY=
Date: Sat, 15 Jun 2024 10:38:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio-v3.patch removed from -mm tree
Message-Id: <20240615173845.7DDC4C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: fix getting incorrect lruvec when replacing a shmem folio
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio-v3.patch

This patch was dropped because it was folded into mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: fix getting incorrect lruvec when replacing a shmem folio
Date: Sat, 15 Jun 2024 11:49:54 +0800

remove less helpful comments, per Matthew

Link: https://lkml.kernel.org/r/ccad3fe1375b468ebca3227b6b729f3eaf9d8046.1718423197.git.baolin.wang@linux.alibaba.com
Fixes: 85ce2c517ade ("memcontrol: only transfer the memcg data for migration")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio-v3
+++ a/mm/memcontrol.c
@@ -7745,8 +7745,7 @@ void __mem_cgroup_uncharge_folios(struct
  * @new: Replacement folio.
  *
  * Charge @new as a replacement folio for @old. @old will
- * be uncharged upon free. This is only used by the page cache
- * (in replace_page_cache_folio()).
+ * be uncharged upon free.
  *
  * Both folios must be locked, @new->mapping must be set up.
  */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix-fix.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch
mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch

