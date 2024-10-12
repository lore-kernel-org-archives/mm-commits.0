Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB6D12C489
	for <mm-commits@vger.kernel.org>; Sat, 12 Oct 2024 22:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728770443; cv=none; b=jY1CRU6VwS7UTvBFmibstEr247FWvrHA6/k1cr2kKCEw+edPWhtBmpvunYTURMJv35b2QOgd7A9CG5mxp30DnRhsebSGmW651pOoejGS8xIW7F2ldR38du9fpWipWCEBqdMSNtn/z54zRZfrV+XtY8UxjX9VBNgVU7Mb0zBpscw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728770443; c=relaxed/simple;
	bh=dTcbQf0mJl4WlyZPQvHzzNrlWirSxRHW8r5RSyE00fk=;
	h=Date:To:From:Subject:Message-Id; b=VrkzKRjwFu6N7DggNGT27XKs9g6MQQqQr7++QwlteaYJrWYz/BBj11Ktns079F7CMbGelNLpGhFTe0TNSdxceStqHAUNLDBf/ih3GN6cD1ygOaKv2EmlFaHzftR+YJiTIqhGsTTIdnZpsXNea1lT4OPTkVtHoyYLPmPGUdO8raM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XvLN49UC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XvLN49UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603B5C4CEC6;
	Sat, 12 Oct 2024 22:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728770443;
	bh=dTcbQf0mJl4WlyZPQvHzzNrlWirSxRHW8r5RSyE00fk=;
	h=Date:To:From:Subject:From;
	b=XvLN49UCbRzMGor9XdVKF9/Ow7ab+NKi4QdwbC2fO0Npxuhc5GE4EYrz8R7CfDUVI
	 lcR2ZnrgyX/3u11BtO0+/OgexeO6pUaerse67tAdvF3r5JNBH9zxDa0WAoumcYkOT5
	 J6UrWT9P1iyhEZeuKos5pKZAauiqQ17OZxkT9lX4=
Date: Sat, 12 Oct 2024 15:00:42 -0700
To: mm-commits@vger.kernel.org,robin.murphy@arm.com,petr@tesarici.cz,mhklinux@outlook.com,catalin.marinas@arm.com,sui.jingfeng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scatterlist-fix-a-typo.patch added to mm-nonmm-unstable branch
Message-Id: <20241012220043.603B5C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scatterlist: fix a typo
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scatterlist-fix-a-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scatterlist-fix-a-typo.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Sui Jingfeng <sui.jingfeng@linux.dev>
Subject: scatterlist: fix a typo
Date: Sat, 12 Oct 2024 18:08:17 +0800

Replace the 'One' with 'On'.

Link: https://lkml.kernel.org/r/20241012100817.323007-1-sui.jingfeng@linux.dev
Fixes: af2880ec4402 ("scatterlist: add dedicated config for DMA flags")
Signed-off-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Reviewed-by: Petr Tesarik <petr@tesarici.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/scatterlist.h~scatterlist-fix-a-typo
+++ a/include/linux/scatterlist.h
@@ -273,7 +273,7 @@ static inline void sg_unmark_end(struct
 }
 
 /*
- * One 64-bit architectures there is a 4-byte padding in struct scatterlist
+ * On 64-bit architectures there is a 4-byte padding in struct scatterlist
  * (assuming also CONFIG_NEED_SG_DMA_LENGTH is set). Use this padding for DMA
  * flags bits to indicate when a specific dma address is a bus address or the
  * buffer may have been bounced via SWIOTLB.
_

Patches currently in -mm which might be from sui.jingfeng@linux.dev are

scatterlist-fix-a-typo.patch

