Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9373B2F0683
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 23:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755041388; cv=none; b=X0nj9PMpjzWhswwd/y9sb72bJAH3FpAlLsnXb4Dpk/4Q638jAWB5jxomE/RY9b+hYP2zVLlpUZ1+8Np4kp3SOOCkKjk0a0HsgCz0tjj68bd3njYGqZI8GUNJcqN5qW1H+TFVkErhUfMnIniAxRgEMPK1Lp91NWxBhyCj74GYGg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755041388; c=relaxed/simple;
	bh=025T/+eIV3h7mVtGLJqWI4MydAGQpFS6N7URQRdh3bU=;
	h=Date:To:From:Subject:Message-Id; b=qSo/mOmtI5QRPM9xUDmkLDXSl7mkV0zTVovGxGk0WlZmUo4NuWt6NfC9awP7Ll5vWZqxEWk5ORE8jS/ePuk+HET2kjzvw9VjW3lwXwTZjzPvZepKeu60p0sYf7ukWqcVT6Iz/PgEktUm3lD5b0euKI0IjM4o73nWpycfJCvkmO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nlvl8FqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nlvl8FqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D653C4CEF0;
	Tue, 12 Aug 2025 23:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755041388;
	bh=025T/+eIV3h7mVtGLJqWI4MydAGQpFS6N7URQRdh3bU=;
	h=Date:To:From:Subject:From;
	b=Nlvl8FqYOLLX2V3jsNXBIvZ87IDaTiJbCHzro9gDlUJpAxUOhkEeTP8ij7Jpsv+7S
	 y5KrmlMLVySDThSJUuY7QiVRGw4+/TqnEJiBeGm8xnMiNHFydGfd2lTFbwQCFM9ZLn
	 7IqGZF5dIZVUD0LxCNrfjklq1TUTWL6Nt4fOaTas=
Date: Tue, 12 Aug 2025 16:29:47 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,bhe@redhat.com,baohua@kernel.org,chrisl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swaph-remove-deleted-field-from-comments.patch added to mm-new branch
Message-Id: <20250812232948.1D653C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap.h: Remove deleted field from comments
has been added to the -mm mm-new branch.  Its filename is
     mm-swaph-remove-deleted-field-from-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swaph-remove-deleted-field-from-comments.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm: swap.h: Remove deleted field from comments
Date: Tue, 12 Aug 2025 00:10:59 -0700

The comment for struct swap_info_struct.lock incorrectly mentions fields
that have already been deleted from the structure.

Update the comments to accurately reflect the current struct
swap_info_struct.

There is no functional change.

Link: https://lkml.kernel.org/r/20250812-swap-scan-list-v3-2-6d73504d267b@kernel.org
Signed-off-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/include/linux/swap.h~mm-swaph-remove-deleted-field-from-comments
+++ a/include/linux/swap.h
@@ -320,11 +320,8 @@ struct swap_info_struct {
 	struct completion comp;		/* seldom referenced */
 	spinlock_t lock;		/*
 					 * protect map scan related fields like
-					 * swap_map, lowest_bit, highest_bit,
-					 * inuse_pages, cluster_next,
-					 * cluster_nr, lowest_alloc,
-					 * highest_alloc, free/discard cluster
-					 * list. other fields are only changed
+					 * swap_map, inuse_pages and all cluster
+					 * lists. other fields are only changed
 					 * at swapon/swapoff, so are protected
 					 * by swap_lock. changing flags need
 					 * hold this lock and swap_lock. If
_

Patches currently in -mm which might be from chrisl@kernel.org are

mm-swapfilec-introduce-function-alloc_swap_scan_list.patch
mm-swaph-remove-deleted-field-from-comments.patch

