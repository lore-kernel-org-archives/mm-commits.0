Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F72849635
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291624; cv=none; b=S5fm85JP7Q1uBTNKlKVd2qxKLiWOf3KCoIegGVy6Fu8yfA8lq2mZs2V+waRj9XpuCaVxOjiHDAzGFoI4oqHSXDSinj5+Y1fYGdExsgqaFHYpVf86hBInPH21a0M1UqpAemUy6AcUpoFOf+emjAnLmMjednAH9zjf3SkF/6VwIog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291624; c=relaxed/simple;
	bh=gZhJmZeIJ19sg6xsXo4Lm4SSIM3a4NEMxuiZIoWh6Mc=;
	h=Date:To:From:Subject:Message-Id; b=tnMB1ZgL4ERilELOq1b0ydMUY2D3s86bHefGPejw8UAMBJh5lJ6O7UWYdQIZDmPCgfJPMK4onXSZ+LLTjEEkznh3XaD/YON+/fWjCsaMauET9xSBXVzcoM3jeb8fp280m6CXIoUDcfp9Q1B//9BtwTx7rZB9cKc+4aCzmyFVsaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZyIX+wTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZyIX+wTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33478C32789;
	Tue, 25 Jun 2024 05:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291624;
	bh=gZhJmZeIJ19sg6xsXo4Lm4SSIM3a4NEMxuiZIoWh6Mc=;
	h=Date:To:From:Subject:From;
	b=ZyIX+wTS9LS4MxMQNSvN/mwaOaokGIkkYS7JSDy7K71kKmVIHC8HlRQB5qW/5BobR
	 j6xLj+ub1a324nOz9s+Ui5fBz4XYXYEXXsBDUbdjaxoeLPn6IYSxOpPQ3HVbrRLuQm
	 m5gx8lLKimHPbuKcpnPOObOA9gm5YFWU/L5/42dU=
Date: Mon, 24 Jun 2024 22:00:23 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,david@redhat.com,abaci@linux.alibaba.com,jiapeng.chong@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-userfaultfd-use-swap-in-double_pt_lock.patch removed from -mm tree
Message-Id: <20240625050024.33478C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: userfaultfd: use swap() in double_pt_lock()
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-use-swap-in-double_pt_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: mm: userfaultfd: use swap() in double_pt_lock()
Date: Fri, 31 May 2024 17:16:43 +0800

Use existing swap() function rather than duplicating its implementation.

./mm/userfaultfd.c:1006:13-14: WARNING opportunity for swap()

Link: https://lkml.kernel.org/r/20240531091643.67778-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9266
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-use-swap-in-double_pt_lock
+++ a/mm/userfaultfd.c
@@ -995,14 +995,8 @@ void double_pt_lock(spinlock_t *ptl1,
 	__acquires(ptl1)
 	__acquires(ptl2)
 {
-	spinlock_t *ptl_tmp;
-
-	if (ptl1 > ptl2) {
-		/* exchange ptl1 and ptl2 */
-		ptl_tmp = ptl1;
-		ptl1 = ptl2;
-		ptl2 = ptl_tmp;
-	}
+	if (ptl1 > ptl2)
+		swap(ptl1, ptl2);
 	/* lock in virtual address order to avoid lock inversion */
 	spin_lock(ptl1);
 	if (ptl1 != ptl2)
_

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are


