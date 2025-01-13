Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B8B8249F
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 02:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737000; cv=none; b=lsnZ4pKdlletX+CcXYQfP6KnkmeB/nGqJngzVgCpFDK+XmGi+xZLiQz1SAWa7f+Z7+5f1DkG57Rjyz6dnepYohwLa/fV11D+kVzgMVHPtZtV09fM8mpvAJj8N5kFSCfAH6cxScG/OTEhjJcRDDwZlb1y31LxegyNUYSZgkgGuJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737000; c=relaxed/simple;
	bh=qNpKGxWGblJk2cDcKUDoGbA0p6Wjrl4SltchELuCrYQ=;
	h=Date:To:From:Subject:Message-Id; b=eq5WAE1h5xZpcxLdpP+5MoNmXdJ38rJLsP1M+KWTsVHEoAPBceHK+VhkOIpLG/1t75XCnnlwSJY8YS7d81l/9O6BRSGzgHTbIEgpIiOTkSHOeOkdXPTDDx1/zKfGCwL30BMaA5KUWsKUcA5k5bf0vu0N7ZtPzt8+IiQ/sJ334dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oIT4SOsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oIT4SOsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3498C4CEDF;
	Mon, 13 Jan 2025 02:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736736999;
	bh=qNpKGxWGblJk2cDcKUDoGbA0p6Wjrl4SltchELuCrYQ=;
	h=Date:To:From:Subject:From;
	b=oIT4SOsMoFx4Tog6tiM3Pw0wYzVPNYrpX+CEf01iAltVRtTKkTTISBYxNtJaJLTo8
	 f5m0NIOj7cMhTUwLkL+GXniaeuSF3LOGZDVXGHszDfyDdyNtAE6ZNfZFC7+lfAPgrQ
	 nu1XI57Mig5IclCrYgWZMpmZzuoJFM0DWNGGGBK8=
Date: Sun, 12 Jan 2025 18:56:39 -0800
To: mm-commits@vger.kernel.org,zzqq0103.hey@gmail.com,willy@infradead.org,shr@devkernel.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2.patch removed from -mm tree
Message-Id: <20250113025639.B3498C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2
has been removed from the -mm tree.  Its filename was
     mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2.patch

This patch was dropped because it was folded into mm-fix-div-by-zero-in-bdi_ratio_from_pages.patch

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2
Date: Tue, 7 Jan 2025 17:47:23 -0800


check for -EINVAL in bdi_set_min_bytes() and bdi_set_max_bytes()

Link: https://lkml.kernel.org/r/20250108014723.166637-1-shr@devkernel.io
Reported-by: cheung wall <zzqq0103.hey@gmail.com>
Closes: https://lore.kernel.org/linux-mm/87pll35yd0.fsf@devkernel.io/T/#t
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page-writeback.c~mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2
+++ a/mm/page-writeback.c
@@ -799,6 +799,8 @@ int bdi_set_min_bytes(struct backing_dev
 		return ret;
 
 	min_ratio = bdi_ratio_from_pages(pages);
+	if (min_ratio == -EINVAL)
+		return -EINVAL;
 	return __bdi_set_min_ratio(bdi, min_ratio);
 }
 
@@ -818,6 +820,8 @@ int bdi_set_max_bytes(struct backing_dev
 		return ret;
 
 	max_ratio = bdi_ratio_from_pages(pages);
+	if (max_ratio == -EINVAL)
+		return -EINVAL;
 	return __bdi_set_max_ratio(bdi, max_ratio);
 }
 
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-fix-div-by-zero-in-bdi_ratio_from_pages.patch
mm-fix-div-by-zero-in-bdi_ratio_from_pages-v3.patch

