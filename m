Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9A329B0
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 02:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732934644; cv=none; b=R7ajnQH2taS00es5IK8krpCFEwQYbWYFtihTXUc+EXP1nBeiYTw/NUuABFW02p13cngmpm0m30IeaZ4c1wyc3cbSjI8YbqkEo2f63AcGRKPHy76gD9GU/lkddWMeGwi1c7QlCW/zgH1bu20Ip5P2MOWH9h2keAbPk2djNoGgHnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732934644; c=relaxed/simple;
	bh=/kPFUQkzFg5xrI6YosSuYrZu2qU0zgDBIagsNX7ypLQ=;
	h=Date:To:From:Subject:Message-Id; b=ZWOUUW2UsHxZhDdx+FoKrloeqDwRzq121yJMEh6yqYkTt+OQESbv1NBmV57wM/q/WWOILhMZ7YaS5QRNqxIghCmwVs2/ykzJVhshmv92iHNMK/Fm77a2xVMScBWoVu+339/+nAabKsDqAtIPp/wuzV+Pm3c+iMYGlOtqXroqumo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G5Fq19B+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G5Fq19B+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C181C4CECF;
	Sat, 30 Nov 2024 02:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732934644;
	bh=/kPFUQkzFg5xrI6YosSuYrZu2qU0zgDBIagsNX7ypLQ=;
	h=Date:To:From:Subject:From;
	b=G5Fq19B+w29obXtaQR7jKKMlAvhQTXuXU5yXU0nChB6GK9Ruxgvt1HlmjjMN92wMl
	 d+bLyeqfoUOiJG3ogpR/0JWnFyZKolSxa9J520Zv7iKKbfJxlkv68tL1gpOG9rwhdf
	 s8Nz9yzIMDVYTjT8aypeIlg6vaYvmGE5m81xy76g=
Date: Fri, 29 Nov 2024 18:44:03 -0800
To: mm-commits@vger.kernel.org,logang@deltatee.com,hch@lst.de,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scatterlist-fix-incorrect-func-name-in-kernel-doc.patch added to mm-hotfixes-unstable branch
Message-Id: <20241130024404.1C181C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scatterlist: fix incorrect func name in kernel-doc
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scatterlist-fix-incorrect-func-name-in-kernel-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scatterlist-fix-incorrect-func-name-in-kernel-doc.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: scatterlist: fix incorrect func name in kernel-doc
Date: Fri, 29 Nov 2024 18:24:06 -0800

Fix a kernel-doc warning by making the kernel-doc function description
match the function name:

include/linux/scatterlist.h:323: warning: expecting prototype for sg_unmark_bus_address(). Prototype was for sg_dma_unmark_bus_address() instead

Link: https://lkml.kernel.org/r/20241130022406.537973-1-rdunlap@infradead.org
Fixes: 42399301203e ("lib/scatterlist: add flag for indicating P2PDMA segments in an SGL")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/scatterlist.h~scatterlist-fix-incorrect-func-name-in-kernel-doc
+++ a/include/linux/scatterlist.h
@@ -313,7 +313,7 @@ static inline void sg_dma_mark_bus_addre
 }
 
 /**
- * sg_unmark_bus_address - Unmark the scatterlist entry as a bus address
+ * sg_dma_unmark_bus_address - Unmark the scatterlist entry as a bus address
  * @sg:		 SG entry
  *
  * Description:
_

Patches currently in -mm which might be from rdunlap@infradead.org are

scatterlist-fix-incorrect-func-name-in-kernel-doc.patch

