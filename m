Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D03D1E9B1A
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 01:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783991741; cv=none; b=Nu7JhkJnGb99oQrezwHryAj/yydfGveDkFoVmjJUIEPYB+yOfgoERvPmKVTAic90AGCxHbfI4AeKyIs/5tkR+LX8Nzby0oSqe1yKcV48KKo8RpqQlzF6Qxn/INAjtZ/5ETDwKWrbxas7wpxEZii1S9KbIrs3k4aYqG0z6G4BcEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783991741; c=relaxed/simple;
	bh=qZRe3lxsvBeLS3mE1RSGibT8YCYOEPXs6SArPv0n3/g=;
	h=Date:To:From:Subject:Message-Id; b=Ah/pUBSrLgPxayd+1igMzOVxYlMDdNZNErMnLZ850QCcLH7O2P5t52bBVh5neG+/pHf6QqBM346M1kw6c2ppaMsa1rZeKT0pIKQ7nx88cPxCnZdc7rVSZRcfdYwWxT0EH01DAIdKRbMwKA+W+DB/xOarzFCQjj0qolB8EtXzfhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yfXYZ8Wi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yfXYZ8Wi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2C61F000E9;
	Tue, 14 Jul 2026 01:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783991740;
	bh=jLN7n/tAqNi6UNTfDXPgZZwd7WifxQ7Pt9+SxL2xZMo=;
	h=Date:To:From:Subject;
	b=yfXYZ8WifDni5q+KrU+wqIRba0vJKN3qSeNDh4HONuT4I44aJHoOjd77CdY9WR/jQ
	 Ip1KoP8XJb/hWfsfbL8CuyABFLfappvPzmZ8MKON8mwncI6gd3v94Yd1biZY15l+hu
	 hcTQkU1YpW9Kj9LwUpMI4qLM+Ezth6MtffFxtqEg=
Date: Mon, 13 Jul 2026 18:15:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,zenghongling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-kobject-cleanup-in-thpsize_create-error.patch added to mm-new branch
Message-Id: <20260714011540.4A2C61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_memory: fix kobject cleanup in thpsize_create error
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-fix-kobject-cleanup-in-thpsize_create-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-kobject-cleanup-in-thpsize_create-error.patch

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
From: Hongling Zeng <zenghongling@kylinos.cn>
Subject: mm: huge_memory: fix kobject cleanup in thpsize_create error
Date: Mon, 13 Jul 2026 13:41:54 +0800

When kobject_init_and_add() fails, the kobject API requires calling
kobject_put() to properly clean up the memory, not direct kfree().

According to the kobject API documentation, kobject_init_and_add() calls
kobject_init() internally.  If the subsequent kobject_add() fails, the
kobject has still been initialized and must be cleaned up via the
reference count mechanism (kobject_put), not direct kfree().

Direct kfree() leaves the kobject's internal state (including the
reference count and kset membership) uncleaned, which can cause:
 - Memory leaks of kobject internal structures
 - Potential use-after-free if there are pending references
 - Inconsistent state with the rest of the error handling code

This fix matches the pattern used elsewhere in the kernel and in the same
function (err_put label) which correctly uses kobject_put().

Link: https://lore.kernel.org/20260713054154.120915-1-zenghongling@kylinos.cn
Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hongling Zeng <zenghongling@kylinos.cn>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-kobject-cleanup-in-thpsize_create-error
+++ a/mm/huge_memory.c
@@ -818,10 +818,8 @@ static struct thpsize *thpsize_create(in
 
 	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
 				   "hugepages-%lukB", size);
-	if (ret) {
-		kfree(thpsize);
-		goto err;
-	}
+	if (ret)
+		goto err_put;
 
 
 	ret = sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
_

Patches currently in -mm which might be from zenghongling@kylinos.cn are

mm-huge_memory-fix-kobject-cleanup-in-thpsize_create-error.patch

