Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436865;
	b=K0jM3125+7Px50r5+FLqcVDtGXUwALXa5GDbN8i8aIzZc1vcZawS6pUgzfBm/qhApGk9
	 Xa7H+yAyivHjNZBe9XVIclFEDDp0im0sROqu21WS9ADtmxiUjwZ2NTaoVAC1N04YhZsIg
	 zWVCDXPdzBkeO3bbuEl4W+4SqoTfcNW8xoGd5A1bGp4MScECo9/NXuD5jl2cKPm9jr9BP
	 QfimMccDgVYl6WHUXdct/FqiKrdZbBxGcRPr+T9cikPLPVaMrg3xcc1tycs5R+WiJiMe6
	 SgWEy8lFpnw5qBpKBMg6NGI/x7mu7v9sLgHmA9ca2ZJohU12YpHNKY4MjcX3CzFNXMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436865;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=clS/yocDzsODdsvHXo4zjIkAea+wZT0yjPsHI9mo0S0=;
	b=RU5JjHz83LP1uCD1jCfwNPK4kfNKxxNXru90DOMzReIWNSZN4u9kS7PUhd/Binpfa++w
	 nuSwLosc3zhhViOFPTjNqixFaleUC89UPfJQfbFcxaca9eee/pB2Gg+MX+Zy0A0w92ccK
	 PXSWFarxA+FGwC0pH7vpu79DMWMUYZ+hnnaqszaIluQhG1QvnvlE6PT0CXYb8qrFF35uP
	 nynTTi+l5R4lLQoqu78leNx31NaaY6MUHohWxLvKvuHAugNKaZe8ZvQkpkE1Uv3PTvd5v
	 skiMURj8sQZPELpVekKKq8beiSMnG4r+ccsVoNAXZhLqPrQ0rEnxui52u8LZwRaSkBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SgwpXMKF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684E7606A31C
	for <mm-commits@vger.kernel.org>; Wed, 11 Nov 2026 22:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SgwpXMKF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF4B1F00A05;
	Wed, 11 Nov 2026 22:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794436864;
	bh=clS/yocDzsODdsvHXo4zjIkAea+wZT0yjPsHI9mo0S0=;
	h=Date:To:From:Subject;
	b=SgwpXMKFkTYdy6yR4TZ+HWCuyRLXWZ3XFzclsQRkiXbywjIYLJWRQ8zxl+LNX1S1C
	 xgAFv4pDToqMvpsMSmkfNsnWeXkk16CS7SgpmJJIjBVrs1J50bJDOBCx5d/V0By55z
	 NTof4MrDVfr2tOAxcCeIErPE6hOtA9u5DntaaFT0=
Date: Wed, 11 Nov 2026 14:41:04 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,
	jm5905938@gmail.com,david@kernel.org,azpijr@gmail.com,dennylin0707@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-report-inode-limits-without-a-memory-subpool.patch added to mm-new branch
Message-Id: <20261111224104.BFF4B1F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: hugetlbfs: report inode limits without a memory subpool
has been added to the -mm mm-new branch.  Its filename is
     hugetlbfs-report-inode-limits-without-a-memory-subpool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-report-inode-limits-without-a-memory-subpool.patch

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
From: Hungyu Lin <dennylin0707@gmail.com>
Subject: hugetlbfs: report inode limits without a memory subpool
Date: Wed, 11 Nov 2026 13:01:45 +0000

A hugetlbfs mount can limit inodes with nr_inodes independently of size or
min_size.  hugetlbfs_statfs() only fills f_files and f_ffree when a memory
subpool exists, so an inode-only limit is enforced but its inode counts
are reported as zero.

For example, a fresh mount with nr_inodes=4 reports zero total and free
inodes instead of 4 and 3.  This hides the inode limit from tools such as
df -i, even when creating another file fails with ENOSPC.

Report the inode counters when an inode limit is configured, independently
of the memory subpool.  Preserve the existing zero and -1 results for
unlimited inode counts.

Link: https://lore.kernel.org/20261111130145.96534-1-dennylin0707@gmail.com
Fixes: 74a8a65c5261 ("[PATCH] Fix hugetlbfs_statfs() reporting of block limits")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Tested-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
---

 fs/hugetlbfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-report-inode-limits-without-a-memory-subpool
+++ a/fs/hugetlbfs/inode.c
@@ -1121,6 +1121,8 @@ static int hugetlbfs_statfs(struct dentr
 				- sbinfo->spool->used_hpages;
 			buf->f_bavail = buf->f_bfree = free_pages;
 			spin_unlock_irq(&sbinfo->spool->lock);
+		}
+		if (sbinfo->spool || sbinfo->max_inodes >= 0) {
 			buf->f_files = sbinfo->max_inodes;
 			buf->f_ffree = sbinfo->free_inodes;
 		}
_

Patches currently in -mm which might be from dennylin0707@gmail.com are

filemap-prefault-writes-starting-beyond-eof.patch
mm-page-writeback-avoid-overflow-when-reporting-bdi-byte-limits.patch
mm-skip-empty-finite-ranges-in-truncate_pagecache_range.patch
hugetlbfs-report-inode-limits-without-a-memory-subpool.patch
delayacct-preserve-delay-extrema-when-aggregating-taskstats.patch
shmem-clamp-negative-used-block-samples-in-statfs.patch

