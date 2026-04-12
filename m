Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0D9306D3F;
	Sun, 12 Apr 2026 17:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776016780; cv=none; b=ISxOU6eIWisPuFtRLzPIUqB+5XvhTIAdoZXVZjN+sxk+pDpXSCLsl0WBZOPXmTRHr0rDIHeRtaryKJ7p/E6/+Xr60/lbdY65DjFTMjR/NrQ2Aj6gj3PbFget9Osk+mTWCr6NPEeylUoYnKpQInmneQ6Va/hnDkBqD/sA1gMPDJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776016780; c=relaxed/simple;
	bh=H38C9lXFFH7JppXQBFcINmMslqcwk543HUUxAUI4mdI=;
	h=Date:To:From:Subject:Message-Id; b=GsYZfBhDZsefL2Fsq67zT3UNgAmSc/jqHfMaSWQ/x7X4QUOvx4/M8P3V1v/RWR7uLNcnysnrKhldckcT8VSXC9DRhIkIIJAlKZ3mUjKpqpstJ+rgnv35WRrIWw81zXCeP6T2fWw/9w2KUBcLKJ+HcKy2A5//jul31Yog8XxHGbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NqKysavk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NqKysavk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1A7C19425;
	Sun, 12 Apr 2026 17:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776016780;
	bh=H38C9lXFFH7JppXQBFcINmMslqcwk543HUUxAUI4mdI=;
	h=Date:To:From:Subject:From;
	b=NqKysavkjzVZXJ/GHiM1TRwItz5rqzh65W1tA7HHeCx1FEW7v4hq5dnFWe32lTlaV
	 yREgCJpbgEYlGnlS7UQkp7RRbysYDzRdC6I+nJELEQ/1KfjEchHHeKyITH5PxSJHot
	 Xh2+x7Yhl2ehM8edCFeIpNrIUfFg8d6gXtMkeWfc=
Date: Sun, 12 Apr 2026 10:59:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baohua@kernel.org,lgs201920130244@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-fix-refcount-leak-in-thpsize_create-error-path.patch added to mm-hotfixes-unstable branch
Message-Id: <20260412175939.EC1A7C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: thp: Fix refcount leak in thpsize_create() error path
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-thp-fix-refcount-leak-in-thpsize_create-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-fix-refcount-leak-in-thpsize_create-error-path.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Guangshuo Li <lgs201920130244@gmail.com>
Subject: mm: thp: Fix refcount leak in thpsize_create() error path
Date: Sat, 11 Apr 2026 14:21:52 +0800

After kobject_init_and_add(), the lifetime of the embedded struct
kobject is expected to be managed through the kobject core reference
counting.

In thpsize_create(), if kobject_init_and_add() fails, thpsize is freed
directly with kfree() rather than releasing the kobject reference with
kobject_put(). This may leave the reference count of the embedded struct
kobject unbalanced, resulting in a refcount leak and potentially leading
to a use-after-free.

Fix this by using kobject_put(&thpsize->kobj) in the failure path and
letting thpsize_release() handle the final cleanup.

Link: https://lkml.kernel.org/r/20260411062152.2092967-1-lgs201920130244@gmail.com
Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-thp-fix-refcount-leak-in-thpsize_create-error-path
+++ a/mm/huge_memory.c
@@ -729,11 +729,8 @@ static struct thpsize *thpsize_create(in
 
 	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
 				   "hugepages-%lukB", size);
-	if (ret) {
-		kfree(thpsize);
-		goto err;
-	}
-
+	if (ret)
+		goto err_put;
 
 	ret = sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
 	if (ret)
_

Patches currently in -mm which might be from lgs201920130244@gmail.com are

device-dax-fix-refcount-leak-in-__devm_create_dev_dax-error-path.patch
mm-thp-fix-refcount-leak-in-thpsize_create-error-path.patch

