Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46AA3EA98
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 02:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736736819; cv=none; b=AaY9F67MAe+a5I/TrmUimyKVhWOzAzjuV5OayQV9ufU4mYd7/DekcMic5LjuXWlVKrdrc4BDn54abHVY1SI/i3Zz93eZJfkyvmqZS2VwUuxTXLQhjPFndS3L+uUdnyztVZRY9Ezt0cOTTeMS8eJBIZeknuSLsgQANxQSXMNhqUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736736819; c=relaxed/simple;
	bh=B5o1r1eTSaplNEH5fvjzBIq6TrwrVbm+b0S/XhwPXdc=;
	h=Date:To:From:Subject:Message-Id; b=qcho4BtVHDYFsVSemgaESSmP2yinDTUYpEL06+VPMhixYkxCoijhQuHr3KVahBeK3julLvPUa/VJZNznRnZUlXm0+uw77ly5m8vtv/oPRKHwSnAJ2dLMaPt/VhcoZ7YqX3iYbkl/VflXxlBL4sUptT6aIZs3v2wz/pYvumropxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ujdh+LXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ujdh+LXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCA2C4CEDF;
	Mon, 13 Jan 2025 02:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736736819;
	bh=B5o1r1eTSaplNEH5fvjzBIq6TrwrVbm+b0S/XhwPXdc=;
	h=Date:To:From:Subject:From;
	b=ujdh+LXsp1t2GFlldbnDVezyXwVi+DtZZ60gaOhtK5Tv06S0QWLepriHsXF9NrWcN
	 gd/Sd5QMLdWxZlJQsuJtuaZcaRJEu7QnXRGrJqvmuG9CDH5vcGuUK/duDKYLn+rr4m
	 NePGgkZEsCDOD92inOOzJU0708qPEBWgvuwzVUxQ=
Date: Sun, 12 Jan 2025 18:53:38 -0800
To: mm-commits@vger.kernel.org,zzqq0103.hey@gmail.com,willy@infradead.org,shr@devkernel.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-div-by-zero-in-bdi_ratio_from_pages-v3.patch removed from -mm tree
Message-Id: <20250113025339.4CCA2C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-fix-div-by-zero-in-bdi_ratio_from_pages-v3
has been removed from the -mm tree.  Its filename was
     mm-fix-div-by-zero-in-bdi_ratio_from_pages-v3.patch

This patch was dropped because it was folded into mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2.patch

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm-fix-div-by-zero-in-bdi_ratio_from_pages-v3
Date: Wed, 8 Jan 2025 22:34:11 -0800

During testing it has been detected, that it is possible to get div by
zero error in bdi_set_min_bytes. The error is caused by the function
bdi_ratio_from_pages(). bdi_ratio_from_pages() calls
global_dirty_limits. If the dirty threshold is 0, the div by zero is
raised. This can happen if the root user is setting:

echo 0 > /proc/sys/vm/dirty_ratio

The following is a test case:

echo 0 > /proc/sys/vm/dirty_ratio
cd /sys/class/bdi/<device>
echo 1 > strict_limit
echo 8192 > min_bytes

==> error is raised.

The problem is addressed by returning -EINVAL if dirty_ratio or
dirty_bytes is set to 0.

Link: https://lkml.kernel.org/r/20250109063411.6591-1-shr@devkernel.io
Reported-by: cheung wall <zzqq0103.hey@gmail.com>
Closes: https://lore.kernel.org/linux-mm/87pll35yd0.fsf@devkernel.io/T/#t
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/page-writeback.c~mm-fix-div-by-zero-in-bdi_ratio_from_pages-v3
+++ a/mm/page-writeback.c
@@ -792,15 +792,15 @@ int bdi_set_min_bytes(struct backing_dev
 {
 	int ret;
 	unsigned long pages = min_bytes >> PAGE_SHIFT;
-	unsigned long min_ratio;
+	long min_ratio;
 
 	ret = bdi_check_pages_limit(pages);
 	if (ret)
 		return ret;
 
 	min_ratio = bdi_ratio_from_pages(pages);
-	if (min_ratio == -EINVAL)
-		return -EINVAL;
+	if (min_ratio < 0)
+		return min_ratio;
 	return __bdi_set_min_ratio(bdi, min_ratio);
 }
 
@@ -813,15 +813,15 @@ int bdi_set_max_bytes(struct backing_dev
 {
 	int ret;
 	unsigned long pages = max_bytes >> PAGE_SHIFT;
-	unsigned long max_ratio;
+	long max_ratio;
 
 	ret = bdi_check_pages_limit(pages);
 	if (ret)
 		return ret;
 
 	max_ratio = bdi_ratio_from_pages(pages);
-	if (max_ratio == -EINVAL)
-		return -EINVAL;
+	if (max_ratio < 0)
+		return max_ratio;
 	return __bdi_set_max_ratio(bdi, max_ratio);
 }
 
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-fix-div-by-zero-in-bdi_ratio_from_pages.patch
mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2.patch

