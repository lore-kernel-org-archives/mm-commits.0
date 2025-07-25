Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8531C549F;
	Fri, 25 Jul 2025 01:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753406112; cv=none; b=IiAwV3I4knGK7Xd1HKgX1QGRum6EHyXev5xBV+NBiM6axg1/wrf0XcZ4NvVk0iPsPfwNBUrOkHme29HJAQTmW+R3lxAhWRCfCAMPqddFDLE2iA5/t/yr/gfka4FF3q+6sYwhKbEMJe9CnxHwHa6ok0CxbL5WxX/UhlRP1xv4NPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753406112; c=relaxed/simple;
	bh=89Yza8Xv2Li3h+dr5UEgW+Lj7H39SWvzgfWawX74SGI=;
	h=Date:To:From:Subject:Message-Id; b=hGYpibpXhfGDNvzn3dxum5a2Yd3huryu1LhUOfjEaMxkVDn1IYhMHW2+6qxnBIobFSZbdkrQnM1qUgAKzoasQ8fPUNGv0XoX8LutBwlHasUIi/JG9D9RBpKeMjqOpAN1DvOtzI+hI1x0CoZhIoVJ4R9KPvIF3sGuZYHDJQreEBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J5wVkoao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J5wVkoao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E66C4CEED;
	Fri, 25 Jul 2025 01:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753406111;
	bh=89Yza8Xv2Li3h+dr5UEgW+Lj7H39SWvzgfWawX74SGI=;
	h=Date:To:From:Subject:From;
	b=J5wVkoaoZ6l+0UR3AR6J+bmeRzpJW0gCvII3y4CHk3WlPGzrdhHBlcja25vIoZnyl
	 1jM6vUgp744URl7F+gLw6XX7PDdOtoCghaOnsn/BBub720j/or6FWn4KrnD711wMpv
	 EKS5Nrjm5MB+6bgE5xoEuiqQ2LgJNsMzrg/Wg8Zc=
Date: Thu, 24 Jul 2025 18:15:11 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kasong@tencent.com,hannes@cmpxchg.org,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop-fix.patch removed from -mm tree
Message-Id: <20250725011511.81E66C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: correctly use maxpages in swapon syscall to avoid potential deadloop
has been removed from the -mm tree.  Its filename was
     mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop-fix.patch

This patch was dropped because it was folded into mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: correctly use maxpages in swapon syscall to avoid potential deadloop
Date: Fri, 18 Jul 2025 14:51:39 +0800

ensure si->pages == si->max - 1 after setup_swap_extents()

Link: https://lkml.kernel.org/r/20250522122554.12209-3-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20250718065139.61989-1-shikemeng@huaweicloud.com
Fixes: 661383c6111a ("mm: swap: relaim the cached parts that got scanned")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/swapfile.c~mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop-fix
+++ a/mm/swapfile.c
@@ -3357,6 +3357,12 @@ SYSCALL_DEFINE2(swapon, const char __use
 		error = nr_extents;
 		goto bad_swap_unlock_inode;
 	}
+	if (si->pages != si->max - 1) {
+		pr_err("swap:%u != (max:%u - 1)\n", si->pages, si->max);
+		error = -EINVAL;
+		goto bad_swap_unlock_inode;
+	}
+
 	maxpages = si->max;
 
 	/* OK, set up the swap map and apply the bad block list */
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch
mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch
mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch
mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch

