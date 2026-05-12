Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFE73859FA
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 21:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778621899; cv=none; b=e/bNwNynhk9DadIp9HH64hWN5Y7jfF36QeziPLESM6K20i7K0Zmy6f4xlzgAdueH4+oiLfqsZX7rS9yqpBL+3rLjpgKDu8g0hp5Zb61TVEuy+3cLHi0J0YCh66mTdNsFtICCBEum3PZi81lktYlV00/mwOhWb+FhmaUmnyXr5sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778621899; c=relaxed/simple;
	bh=JDmtabrmtkgudonhpGTLj3QWPdOipm5R0sCRut5oLM4=;
	h=Date:To:From:Subject:Message-Id; b=KpR94QLAORy+GOAy6LkKwP033+ydJOkesaeIECBgsdA26Ktw3t38mO+IDFxufktVo90KeNItybk87oM4M1jS14s1IKLpnD0p3eSj0f/trVCXDHKehldqaFZXarg4O6xZkjuQTrMJR+VM9ixX1kEX6kusGyYy1gSLZ5nGVAO25s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wPXhvEzk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wPXhvEzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C10C2BCB8;
	Tue, 12 May 2026 21:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778621899;
	bh=JDmtabrmtkgudonhpGTLj3QWPdOipm5R0sCRut5oLM4=;
	h=Date:To:From:Subject:From;
	b=wPXhvEzkr0PJ1Kl9Fma54UJGOkYkxJAX2ImngSCBI/jAXC8eHRuW4IAPPq/UY5GGd
	 51gIwQ1yNs1CFyLJvUpS+v1r+IJBhjandfbaYYpz675UsJ96BOcG4n9SK2HkB9Yktf
	 zy3OGJ7G6QL7hf83ZczxRXttBSxCXWYJkvvjVhyY=
Date: Tue, 12 May 2026 14:38:18 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,agarwal.vineet2006@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-fix-double-increment-of-nr_regions.patch added to mm-new branch
Message-Id: <20260512213819.14C10C2BCB8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: fix double increment of nr_regions
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-fix-double-increment-of-nr_regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-fix-double-increment-of-nr_regions.patch

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
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: mm/damon/sysfs-schemes: fix double increment of nr_regions
Date: Tue, 12 May 2026 09:41:57 +0530

damos_sysfs_populate_region_dir() increments sysfs_regions->nr_regions
twice when adding a new region: once explicitly before
kobject_init_and_add(), and once again through the post-increment used for
the kobject name.

As a result, nr_regions no longer matches the actual number of live
regions, and region directory names skip numbers (1, 3, 5, ...).

Use the already incremented value for naming instead of incrementing
nr_regions a second time.

Link: https://lore.kernel.org/20260512041157.109845-1-agarwal.vineet2006@gmail.com
Fixes: 66178e4ec30a ("mm/damon/sysfs: use damos_walk() for update_schemes_tried_{bytes,regions}")
Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-fix-double-increment-of-nr_regions
+++ a/mm/damon/sysfs-schemes.c
@@ -2998,7 +2998,7 @@ void damos_sysfs_populate_region_dir(str
 	if (kobject_init_and_add(&region->kobj,
 				&damon_sysfs_scheme_region_ktype,
 				&sysfs_regions->kobj, "%d",
-				sysfs_regions->nr_regions++)) {
+				sysfs_regions->nr_regions)) {
 		kobject_put(&region->kobj);
 	}
 }
_

Patches currently in -mm which might be from agarwal.vineet2006@gmail.com are

selftests-mm-khugepaged-initialize-file-contents-via-mmap.patch
mm-khugepaged-return-eagain-for-scan_page_has_private-in-madv_collapse.patch
selftests-mm-check-file-initialization-writes-in-split_huge_page_test.patch
mm-damon-sysfs-schemes-fix-double-increment-of-nr_regions.patch

