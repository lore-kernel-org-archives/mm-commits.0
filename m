Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEC985260
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 03:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737452; cv=none; b=mwyqx5LrvNbLiRL7P7tl0hHKwIPuWnAcuNwSEDxBzxNpmG06jN7nJ+zHzE2x2n3/k5AZJjCY0G8qCwK8ZCIc7NbASdzKj0S/HJg8jQOPUHjGfC4Oc3sntS6Xt74HzkUsOI1FeVyY5JXRjUCzYtyGUc9nx6cQ9aEiIUup+sgwa6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737452; c=relaxed/simple;
	bh=ClNQidBIJl9Ijs3dxmdPS830dHY4zPZ6cr+IkYJY0sM=;
	h=Date:To:From:Subject:Message-Id; b=BQbee31rLdNbvg9UMB+fWqg2iI6QPQQ5OGv3cun09R4Mwc+6smMcEWAmZQ6QzRI0SiHjs/6wiOutOAoA4k/kUEdXRlRzqB1VJekS+5K/dhO02A6IRE4WkiZh53UL/WOv/vPURLYFJUyeWUMklInmceCbONnrtRKMHyOL6m2aIoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zOcGFgkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zOcGFgkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAD3C4CEDF;
	Mon, 13 Jan 2025 03:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737452;
	bh=ClNQidBIJl9Ijs3dxmdPS830dHY4zPZ6cr+IkYJY0sM=;
	h=Date:To:From:Subject:From;
	b=zOcGFgkp+9Opjm28Ax5uSSETc+wGyegvk3ZCEYwWzANLL0MoSPE1PmtupJg4erCSC
	 9eIjjhPd+l3Hn4f2lS1Xx0Tfabh8FLhuKE34Eno41ab4Nrt9NSzbnw/E6IjGQbKVdM
	 Vn2JoNuVfPxCXQKaR6lDZRKtigT1FyvifjoabZ+U=
Date: Sun, 12 Jan 2025 19:04:11 -0800
To: mm-commits@vger.kernel.org,zzqq0103.hey@gmail.com,willy@infradead.org,david@redhat.com,shr@devkernel.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-div-by-zero-in-bdi_ratio_from_pages.patch removed from -mm tree
Message-Id: <20250113030412.2DAD3C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix div by zero in bdi_ratio_from_pages
has been removed from the -mm tree.  Its filename was
     mm-fix-div-by-zero-in-bdi_ratio_from_pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: fix div by zero in bdi_ratio_from_pages
Date: Fri, 3 Jan 2025 17:20:37 -0800

During testing it has been detected, that it is possible to get div by
zero error in bdi_set_min_bytes.  The error is caused by the function
bdi_ratio_from_pages().  bdi_ratio_from_pages() calls global_dirty_limits.
If the dirty threshold is 0, the div by zero is raised.  This can happen
if the root user is setting:

echo 0 > /proc/sys/vm/dirty_ratio

The following is a test case:

echo 0 > /proc/sys/vm/dirty_ratio
cd /sys/class/bdi/<device>
echo 1 > strict_limit
echo 8192 > min_bytes

==> error is raised.

The problem is addressed by returning -EINVAL if dirty_ratio or
dirty_bytes is set to 0.

[shr@devkernel.io: check for -EINVAL in bdi_set_min_bytes() and bdi_set_max_bytes()]
  Link: https://lkml.kernel.org/r/20250108014723.166637-1-shr@devkernel.io
[shr@devkernel.io: v3]
  Link: https://lkml.kernel.org/r/20250109063411.6591-1-shr@devkernel.io
Link: https://lkml.kernel.org/r/20250104012037.159386-1-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reported-by: cheung wall <zzqq0103.hey@gmail.com>
Closes: https://lore.kernel.org/linux-mm/87pll35yd0.fsf@devkernel.io/T/#t
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Qiang Zhang <zzqq0103.hey@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/page-writeback.c~mm-fix-div-by-zero-in-bdi_ratio_from_pages
+++ a/mm/page-writeback.c
@@ -692,6 +692,8 @@ static unsigned long bdi_ratio_from_page
 	unsigned long ratio;
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
+	if (!dirty_thresh)
+		return -EINVAL;
 	ratio = div64_u64(pages * 100ULL * BDI_RATIO_SCALE, dirty_thresh);
 
 	return ratio;
@@ -790,13 +792,15 @@ int bdi_set_min_bytes(struct backing_dev
 {
 	int ret;
 	unsigned long pages = min_bytes >> PAGE_SHIFT;
-	unsigned long min_ratio;
+	long min_ratio;
 
 	ret = bdi_check_pages_limit(pages);
 	if (ret)
 		return ret;
 
 	min_ratio = bdi_ratio_from_pages(pages);
+	if (min_ratio < 0)
+		return min_ratio;
 	return __bdi_set_min_ratio(bdi, min_ratio);
 }
 
@@ -809,13 +813,15 @@ int bdi_set_max_bytes(struct backing_dev
 {
 	int ret;
 	unsigned long pages = max_bytes >> PAGE_SHIFT;
-	unsigned long max_ratio;
+	long max_ratio;
 
 	ret = bdi_check_pages_limit(pages);
 	if (ret)
 		return ret;
 
 	max_ratio = bdi_ratio_from_pages(pages);
+	if (max_ratio < 0)
+		return max_ratio;
 	return __bdi_set_max_ratio(bdi, max_ratio);
 }
 
_

Patches currently in -mm which might be from shr@devkernel.io are


