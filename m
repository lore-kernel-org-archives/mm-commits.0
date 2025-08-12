Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92732E11B5
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 04:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754972672; cv=none; b=CKfpZ5s63FybvwV6YyU5P4vQp22WXhdLRg3vJRdteR4WnSvlEjlSCws1CNapEr0XQ8UQVbDJLIGLnZ+adlCgXF5LgNOsIiaZA+liQ/ZOOb339saEJlU6gutUdsbX43mzqAcfU+CLtodJzP1BCfu9FDWbotGHRDdgWER5fFpdons=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754972672; c=relaxed/simple;
	bh=N78N/jNx1yFXQ7tM+pHfn17vmQ0PKG5CtsIa/6835iE=;
	h=Date:To:From:Subject:Message-Id; b=OD3rmFiryfkYFeZy+3XVecbBKQKilAxdMeihKmhv1GyRgFQzAQWyvTh355tVogNLGXlCJxFmG3PyRKoV67w7C1kShp59n9dU8y/W9jc7wkiYWY/2b2geA/HKzGZjeJk5rJXW/Y6AVAnaK/p/qVVcPj/xLMOzgY8UVYLJSc/zko4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sz5i5Uk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sz5i5Uk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B5EC4CEF0;
	Tue, 12 Aug 2025 04:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754972671;
	bh=N78N/jNx1yFXQ7tM+pHfn17vmQ0PKG5CtsIa/6835iE=;
	h=Date:To:From:Subject:From;
	b=sz5i5Uk3daPesPiEudKT2yNK+M3L30F+t0xAGlzJA4C5pCXe2TMGZ9CD7b9b1F7LN
	 GpTmQfwANviDM8OAzGeC6bMtkp7nOdPkzpBeu0VYB/e5LgaUXDLjWwmcq7j+4iGUVV
	 I22JoKHaoe2Gqvga7ZSlMvwrJnFS6HWoPo5JzS+I=
Date: Mon, 11 Aug 2025 21:24:30 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,bhe@redhat.com,baohua@kernel.org,chrisl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfilec-introduce-function-alloc_swap_scan_list-v2.patch added to mm-unstable branch
Message-Id: <20250812042431.68B5EC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swapfilec-introduce-function-alloc_swap_scan_list-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfilec-introduce-function-alloc_swap_scan_list-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfilec-introduce-function-alloc_swap_scan_list-v2.patch

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
From: Chris Li <chrisl@kernel.org>
Subject: mm-swapfilec-introduce-function-alloc_swap_scan_list-v2
Date: Fri, 08 Aug 2025 00:48:19 -0700

change int type and break out of loop

Link: https://lkml.kernel.org/r/20250808-swap-scan-list-v2-1-d50e4758ecee@kernel.org
Signed-off-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-introduce-function-alloc_swap_scan_list-v2
+++ a/mm/swapfile.c
@@ -826,7 +826,7 @@ static unsigned int alloc_swap_scan_list
 					 unsigned char usage,
 					 bool scan_all)
 {
-	int found = SWAP_ENTRY_INVALID;
+	unsigned int found = SWAP_ENTRY_INVALID;
 
 	do {
 		struct swap_cluster_info *ci = isolate_lock_cluster(si, list);
@@ -837,7 +837,7 @@ static unsigned int alloc_swap_scan_list
 		offset = cluster_offset(si, ci);
 		found = alloc_swap_scan_cluster(si, ci, offset, order, usage);
 		if (found)
-			return found;
+			break;
 	} while (scan_all);
 
 	return found;
_

Patches currently in -mm which might be from chrisl@kernel.org are

mm-swapfilec-introduce-function-alloc_swap_scan_list.patch
mm-swapfilec-introduce-function-alloc_swap_scan_list-v2.patch

