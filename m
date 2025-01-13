Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445B613AD05
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 02:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737002; cv=none; b=bUG4U2L66cmzmP1BmD+ce18v4IP4R1+c4ZsUfcVQxVvYiiE0J9N5ncHWhYN2hNqCrz7b6Wy6enzJZsTIeF5i/MUJ4Lx6rCBoLtt6+GDO0eWTT+ZfiBDRqqd5YN+zS/CRCNpsZKYq43KHi1hvUtrh76reEs5iIeXq6zCpqAkQz08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737002; c=relaxed/simple;
	bh=IE4n0rEnWn5r+kNrA6zV5vbnx75C5ZyAiqg8Xe71SqA=;
	h=Date:To:From:Subject:Message-Id; b=tmp62KUPy9hvLy2rfvKhx08os1J5xYJ0vPqvT6IPOS2aSc3nF/04b69WuljUiN6zR2vIsaR1eK/63FhHW/vDgp67Sh9oWHpyDP/5iQQYlGqawKKX8v2Ocsxmyb3J/DXiUMJTFOkYIV6DN2tpd1qdhdWU98HrAh5E/l/v0VyNCAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xWA5E+P5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xWA5E+P5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A302AC4CEE0;
	Mon, 13 Jan 2025 02:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737001;
	bh=IE4n0rEnWn5r+kNrA6zV5vbnx75C5ZyAiqg8Xe71SqA=;
	h=Date:To:From:Subject:From;
	b=xWA5E+P5TwlaI1G4usCZXXT7XiNcbxjun5Cz52o8ID9fkqzLlJ0VayQVYkbjIJeaq
	 2PZCcs341LDmQ0q1kVSBNeut+sBOzYsQG3vjl/yhctActTO33XVAtTdY2UODoOGXG9
	 YuFF5/dxiJ/ZZkX+3VVpywC/yfEeFtoGpNkHheZw=
Date: Sun, 12 Jan 2025 18:56:41 -0800
To: mm-commits@vger.kernel.org,zzqq0103.hey@gmail.com,willy@infradead.org,shr@devkernel.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-div-by-zero-in-bdi_ratio_from_pages-v3.patch removed from -mm tree
Message-Id: <20250113025641.A302AC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-fix-div-by-zero-in-bdi_ratio_from_pages-v3
has been removed from the -mm tree.  Its filename was
     mm-fix-div-by-zero-in-bdi_ratio_from_pages-v3.patch

This patch was dropped because it was folded into mm-fix-div-by-zero-in-bdi_ratio_from_pages.patch

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

