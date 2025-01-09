Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EF84F5E0
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 06:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736404842; cv=none; b=NfvFBggfWjCXe1HDWLHEkNFkJg7toGT2Xu3icb8LR8dQtkVOG3yTlthF8Ed02PYI2nlIaXLKBOGb5Mlrmy6nHOIWnjroUrbGamwTSnmJI6rFSPtuF2xD95lD730FxqY5EPbNaKQkaqOGZZlbeCy1AOZzOp/hzaWZ8joxauwFD9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736404842; c=relaxed/simple;
	bh=9dGUdihMLwumBHb7JfDliFtee6NT3C65YUwG3KWVLMw=;
	h=Date:To:From:Subject:Message-Id; b=GR3WmfIr/OKo6AaGWDpHPPorVPl5/WFejBsY2S1OxpzigRVNNWJXHO1TFQmdUORLWBT+rfSAE04qpeIwGRJwrR/tX5i9X5HIHTuE3wxhlxX1z5uDxtTmbgSOewdHyoqS0X7de36KOqsS8Mcm5KotDlSvxYiuHm5VrqDsgqVI6Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JcfRG004; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JcfRG004"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24099C4CED2;
	Thu,  9 Jan 2025 06:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736404842;
	bh=9dGUdihMLwumBHb7JfDliFtee6NT3C65YUwG3KWVLMw=;
	h=Date:To:From:Subject:From;
	b=JcfRG004QMf/DO9wJF5XP8Dx++bhjsei7whH8ccz83mfwaTabXevF3VzZuz4dnhEl
	 KuB33EOM34gHjYnN5IFtxHJdD8N5FB0k0pB7ea3i5Y18JDEkkXMpDSMAiNjh152ghQ
	 RxsPpgpptBOfDF5QyWnnC5a83NjTKnMm2S/9rD+c=
Date: Wed, 08 Jan 2025 22:40:41 -0800
To: mm-commits@vger.kernel.org,zzqq0103.hey@gmail.com,willy@infradead.org,shr@devkernel.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-div-by-zero-in-bdi_ratio_from_pages-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20250109064042.24099C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-fix-div-by-zero-in-bdi_ratio_from_pages-v3
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-div-by-zero-in-bdi_ratio_from_pages-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-div-by-zero-in-bdi_ratio_from_pages-v3.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
mm-fix-div-by-zero-in-bdi_ratio_from_pages-v3.patch

