Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90010206F22
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 22:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741301717; cv=none; b=Jls/plMLGPuEwJYgP8x+HOFhYyEGjhvvhRB1PIBE9dHkDHcaSgQxZ+s0XuVp0Ka0xbhu/xjE4qW3FUiA+c6s6/3Bac5JtM36rWHLE7YRvD07MhsfQAtWQ27YBZKG2UgX5Aj1EeyXTajc+PafdE27eH28B6jEUU+IR67lgc6tGho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741301717; c=relaxed/simple;
	bh=hszmRGI/Zg/piAHlNFvDZyTxZBtXC3J3fUHj0jiD6vQ=;
	h=Date:To:From:Subject:Message-Id; b=PYWo4S7I/AgOLs61yTzZP8XunrbP9v6+JT0xySxZOAEIzeTHsGW2Z8bEUK6w3/ClMz7ST2JcVqP/k3StvrEhlW59kLeCR+8qN6KM2PayYZHddZpT4akmqjMrWHTl38yQO9pTnuQBcm+AJqcPS92HnNelXKV6AHy3ERpyGxSFVSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ux2OetOc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ux2OetOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C0FC4CEE0;
	Thu,  6 Mar 2025 22:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741301717;
	bh=hszmRGI/Zg/piAHlNFvDZyTxZBtXC3J3fUHj0jiD6vQ=;
	h=Date:To:From:Subject:From;
	b=ux2OetOcOOYjKLmT1A4u01ns0XTXxR/DFJMKZvHi82TFWUi9DxhNdbzeuLmmECIYu
	 nfg5zNJiP3EFI9/TdjzSNP0XkLvWXKl1XZJGTk/B1q1qKKcIWiLbhG939ocjKR+U/c
	 7yqFes90YHM3mabrL0MhOVPt7TR2CoPU0eiOchys=
Date: Thu, 06 Mar 2025 14:55:16 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,willy@infradead.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + page_io-zswap-do-not-crash-the-kernel-on-decompression-failure-fix.patch added to mm-unstable branch
Message-Id: <20250306225517.00C0FC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: page_io: zswap: do not crash the kernel on decompression failure (fix)
has been added to the -mm mm-unstable branch.  Its filename is
     page_io-zswap-do-not-crash-the-kernel-on-decompression-failure-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/page_io-zswap-do-not-crash-the-kernel-on-decompression-failure-fix.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: page_io: zswap: do not crash the kernel on decompression failure (fix)
Date: Thu, 6 Mar 2025 14:24:53 -0800

Fix the documentation of zswap_load() - should say load a folio (rather
than a page), and should be explicit that the folio is unlocked and marked
up-to-date in the success case.

Link: https://lkml.kernel.org/r/20250306222453.1269456-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~page_io-zswap-do-not-crash-the-kernel-on-decompression-failure-fix
+++ a/mm/zswap.c
@@ -1629,10 +1629,11 @@ check_old:
 }
 
 /**
- * zswap_load() - load a page from zswap
+ * zswap_load() - load a folio from zswap
  * @folio: folio to load
  *
- * Return: 0 on success, or one of the following error codes:
+ * Return: 0 on success, with the folio unlocked and marked up-to-date, or one
+ * of the following error codes:
  *
  *  -EIO: if the swapped out content was in zswap, but could not be loaded
  *  into the page due to a decompression failure. The folio is unlocked, but
_

Patches currently in -mm which might be from nphamcs@gmail.com are

page_io-zswap-do-not-crash-the-kernel-on-decompression-failure.patch
page_io-zswap-do-not-crash-the-kernel-on-decompression-failure-fix.patch

