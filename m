Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9139B4F218
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 21:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707427663; cv=none; b=o3AEIz7EJdvvUZ4s56iQInkhGHCamXxGfizVhOMFwFxIlVuF3sxqrBxGKX04/XObGREfqPMw+Joi1Kp69nm2g/diW0DJY7RmFJHJ/mnbUeB9hh6mvftpL31Fy6tAJJ3nxXaJJgxTSphpW0yliFyK6K+vCOtTzepuAQkGGeDxKf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707427663; c=relaxed/simple;
	bh=d8/A1mDf0mNyfWp2seP5x8ZnFTK1beGGSQzVYd5R3Kk=;
	h=Date:To:From:Subject:Message-Id; b=lFnISbYk/3OQ0J/iDXJoM0FWO8I5tsUL2wOhrsZSW9Dp9ZjLw9eNuOL+s2zv3Pj8fcMoiP7upoDKR7Mct09Biw8LVvzfi1OeoXtvpshn8/vhJyR5TemM7FHAPqF09JcGZGjHSdnxD6R2IL7M6EJ/LZ5ynfQuFXeo5vooE5lNJQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I03EyFyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I03EyFyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3A0C43390;
	Thu,  8 Feb 2024 21:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707427663;
	bh=d8/A1mDf0mNyfWp2seP5x8ZnFTK1beGGSQzVYd5R3Kk=;
	h=Date:To:From:Subject:From;
	b=I03EyFyJpocGPCyJcjlNT8yskg5gvUD69MTMaGp2DCxgcqOZJVNhSKML7aB0M8iyj
	 nYyt1CsiPw16vF0nHi4c4LqWE1hb2Kw3+7OQDwDW1y+oc9mj+7AOWLTytGxs8jMZg/
	 epM0BHv2uVpwfiolKNi4z84tGFLxGW3cEHkL79Rk=
Date: Thu, 08 Feb 2024 13:27:42 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,torvalds@linux-foundation.org,snitzer@kernel.org,mpatocka@redhat.com,linux@armlinux.org.uk,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dm-cleanup-alloc_dax-error-handling.patch added to mm-unstable branch
Message-Id: <20240208212743.0E3A0C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dm: cleanup alloc_dax() error handling
has been added to the -mm mm-unstable branch.  Its filename is
     dm-cleanup-alloc_dax-error-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dm-cleanup-alloc_dax-error-handling.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: dm: cleanup alloc_dax() error handling
Date: Thu, 8 Feb 2024 13:49:11 -0500

Now that alloc_dax() returns ERR_PTR(-EOPNOTSUPP) rather than NULL, the
callers do not have to handle NULL return values anymore.

Link: https://lkml.kernel.org/r/20240208184913.484340-11-mathieu.desnoyers@efficios.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c~dm-cleanup-alloc_dax-error-handling
+++ a/drivers/md/dm.c
@@ -2124,8 +2124,8 @@ static struct mapped_device *alloc_dev(i
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
 	dax_dev = alloc_dax(md, &dm_dax_ops);
-	if (IS_ERR_OR_NULL(dax_dev)) {
-		if (IS_ERR(dax_dev) && PTR_ERR(dax_dev) != -EOPNOTSUPP)
+	if (IS_ERR(dax_dev)) {
+		if (PTR_ERR(dax_dev) != -EOPNOTSUPP)
 			goto bad;
 	} else {
 		set_dax_nocache(dax_dev);
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

nvdimm-pmem-fix-leak-on-dax_add_host-failure.patch
nvdimm-pmem-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dm-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dcssblk-handle-alloc_dax-eopnotsupp-failure.patch
virtio-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dax-check-for-data-cache-aliasing-at-runtime.patch
introduce-cpu_dcache_is_aliasing-across-all-architectures.patch
dax-fix-incorrect-list-of-data-cache-aliasing-architectures.patch
nvdimm-pmem-cleanup-alloc_dax-error-handling.patch
dm-cleanup-alloc_dax-error-handling.patch
dcssblk-cleanup-alloc_dax-error-handling.patch
virtio-cleanup-alloc_dax-error-handling.patch

