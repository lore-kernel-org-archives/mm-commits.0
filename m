Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B142AD16
	for <mm-commits@vger.kernel.org>; Sat,  1 Nov 2025 02:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761962849; cv=none; b=pWiwAWHlz5iKBLKr2s2Feom/mMnjpH/dGceeR1YVkZBBo5w+fHXLrpbSh78NhlElz2e3yaht4tuTpoXrUAir6O601IdNNNiT6BV0kRPGaWUiGwW4gJUj5YfyaNFvP+t37XILeShqZDOKzcA/wxZUQfq/K2GOXxu0uEPIPMqsI3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761962849; c=relaxed/simple;
	bh=07/G0PRp0+dC5L7miEgg2ZTDg7NBKDKuQlfehW41ypY=;
	h=Date:To:From:Subject:Message-Id; b=O9a7W2cAXvlYQLZx6+yVkvyu+VdnAtkVRqQxfu1xpI9KhATBUVG0Pl3zBq6knF8nnnVYOY0xHGFk205O6W4fqDHKvzeQA4Vb46j4nER/+lvx3aysRu6Yt/yfO3AA4JFzTESp/pmIYOtWJLVEujZXXsMrigV6Z1LzdqzAIstUrxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zOzFXA2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zOzFXA2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3911EC4CEE7;
	Sat,  1 Nov 2025 02:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761962849;
	bh=07/G0PRp0+dC5L7miEgg2ZTDg7NBKDKuQlfehW41ypY=;
	h=Date:To:From:Subject:From;
	b=zOzFXA2SK5aslAWOCmH3OYa4LDkjnBV6jmKYKUoZRej4nA0tzNAeF1fh4U9xx+2FX
	 2tuYuEvic6BX7cIgv7lZxLmBppVFLyBzGtk6kh5Ej9AYrLeNLaH7UQX4n7T1I9Hcik
	 OCjy0Ut4fOEQH874rhvv3ygNf5FahljBwEzC5zEE=
Date: Fri, 31 Oct 2025 19:07:28 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix.patch added to mm-new branch
Message-Id: <20251101020729.3911EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: kernel-doc fixup
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: kernel-doc fixup
Date: Fri, 31 Oct 2025 19:50:55 -0400

Link: https://lkml.kernel.org/r/BE7AC5F3-9E64-4923-861D-C2C4E0CB91EB@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix
+++ a/mm/huge_memory.c
@@ -3587,7 +3587,7 @@ static void __split_folio_to_order(struc
  *    uniform_split is true.
  * 2. buddy allocator like (non-uniform) split: the given @folio is split into
  *    half and one of the half (containing the given page) is split into half
- *    until the given @page's order becomes @new_order. This is done when
+ *    until the given @folio's order becomes @new_order. This is done when
  *    uniform_split is false.
  *
  * The high level flow for these two methods are:
@@ -3596,14 +3596,14 @@ static void __split_folio_to_order(struc
  *    along with stats update.
  * 2. non-uniform split: folio_order - @new_order calls to
  *    __split_folio_to_order() are expected to be made in a for loop to split
- *    the @folio to one lower order at a time. The folio containing @page is
- *    split in each iteration. @xas is split into half in each iteration and
+ *    the @folio to one lower order at a time. The folio containing @split_at
+ *    is split in each iteration. @xas is split into half in each iteration and
  *    can fail. A failed @xas split leaves split folios as is without merging
  *    them back.
  *
  * After splitting, the caller's folio reference will be transferred to the
- * folio containing @page. The caller needs to unlock and/or free after-split
- * folios if necessary.
+ * folio containing @split_at. The caller needs to unlock and/or free
+ * after-split folios if necessary.
  *
  * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
  * split but not to @new_order, the caller needs to check)
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-do-not-change-split_huge_page-target-order-silently.patch
mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order.patch
mm-huge_memory-add-split_huge_page_to_order.patch
mm-memory-failure-improve-large-block-size-folio-handling.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix.patch

