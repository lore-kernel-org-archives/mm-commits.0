Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E3B35C68B
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 20:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787861322; cv=none; b=sF7jxHTmqpmWNuVy8bg6J2DjIUDr9EMYde00zVd4L0DdmhuhMK3/MJ/JGYaruP4lVzVrWXvO8ya8H3Ij2BdbUBWKInxtdA2A59GwPtDJKoZ20oXeJa54H8y88zEPcu2NHFPJbv1rPttJmQufFWcrLUE6n98nADgr/aA1liMkCpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787861322; c=relaxed/simple;
	bh=Z+gumZSvHmoidiIi+aBYinYGBkz+ebkkLR5He7+9zoE=;
	h=Date:To:From:Subject:Message-Id; b=ZwVJ0m9cI0omFRs5iEKWIPDerlKfcBoGJk2pfoHRLRA0YYMOGNUPfp57bSEX1EULBwRVT7o39NzvyiQGRxnPef9V7lJ4DfKOdu0R0ZVp3TG6D1gsXE30UZhECykKfG1AT3+pbPWERcwfOzB+eKHdnSDBwwmpo+02EBbuv6halBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X0SdS5PR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X0SdS5PR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538FE1F000E9;
	Thu, 27 Aug 2026 20:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787861320;
	bh=nHBdungg5TWtXK1wm5kCH29fpO29jS2xlwaY/Qj5bro=;
	h=Date:To:From:Subject;
	b=X0SdS5PRsFXuEhsrMG+T/ZHd/RwygYbl2vKM9hffDlCXTVh/WKwdpgrRo4+md+R1I
	 0NJtHO7OrjnkAtkYpuEQUxqorKv3wdUEhX+7gQ8PPRHbyfDrPYF8eLGT/jPvi4ZIUe
	 4PS7vvh0my/uDQt/GPUVYx4M7kRWVXyyYAT9VkAA=
Date: Thu, 27 Aug 2026 13:08:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,liam@infradead.org,lance.yang@linux.dev,kirill@shutemov.name,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-remove-myself-as-thp-co-maintainer.patch removed from -mm tree
Message-Id: <20260827200840.538FE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: remove Lorenzo as THP co-maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-remove-myself-as-thp-co-maintainer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: MAINTAINERS: remove Lorenzo as THP co-maintainer
Date: Wed, 26 Aug 2026 10:56:39 +0100

Unfortunately my workload is such that I simply no longer have the time to
give THP the focus that it deserves.

So, at least temporarily, step down from the role.

Link: https://lore.kernel.org/20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-myself-as-thp-co-maintainer
+++ a/MAINTAINERS
@@ -17397,7 +17397,6 @@ F:	mm/swapfile.c
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 R:	Liam R. Howlett <liam@infradead.org>
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap.patch
mm-secretmem-properly-account-locked-pages.patch

