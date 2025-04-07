Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DF029A5
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 00:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743986749; cv=none; b=UKOW+ryjQS9H+MYpok5e1XSEaEYzpEuhpfB65XvEn+Rp6xX3GY68mVGa5KuIvNU0XR0bkT6fKSd3SSkHJYaxzAnN6zM6GCWTcd1Ep5n8BaHklniKKePG8cgKhSeYXW5Z4WWJgvAaKJ8hCH9FkasrK4hFXHpxVLzNWj+GJLe5MXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743986749; c=relaxed/simple;
	bh=OTz3gJhRjJx1MdNoMs+m5Ze1sYHIP500VWWWole2KuM=;
	h=Date:To:From:Subject:Message-Id; b=Nut8qEM6Fc5089dYMvQPjbEqSqx6iGJRuA1ewYVhY7+dqnNHs2iDgQQZbKlvRAnj1fhZ+tWNkqIO5LPOjKbraxsnEW3ZSgmt71haUqKAsMjPV/20d2LR4SmeZdPyWsT9PsSRZ/q7wz8mGaUBCwRRYGkGm+RxA7ea4vutzHhdvg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VP+xjr1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VP+xjr1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CE0C4CEE3;
	Mon,  7 Apr 2025 00:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743986748;
	bh=OTz3gJhRjJx1MdNoMs+m5Ze1sYHIP500VWWWole2KuM=;
	h=Date:To:From:Subject:From;
	b=VP+xjr1MOyEgIvjLU9GOxcpPnGqy54Xx3sBEZhIqQK7ksJtbIA6OqCxmiICEXuCxs
	 Qw3XqV1B1sO/cnZwJd7LmZXArclh77RYWdG0O5OT5Dx9P77I/gQf5iLDFyzOzl6z2T
	 9i8sRNBHpQnuMJ/rFc164nrKd9efnITFbRSp2maE=
Date: Sun, 06 Apr 2025 17:45:47 -0700
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-modernize-writeback-interface-v3.patch added to mm-new branch
Message-Id: <20250407004548.66CE0C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: modernize writeback interface
has been added to the -mm mm-new branch.  Its filename is
     zram-modernize-writeback-interface-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-modernize-writeback-interface-v3.patch

This patch will later appear in the mm-new branch at
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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: modernize writeback interface
Date: Fri, 4 Apr 2025 10:52:50 +0900

simplify parse_page_index() range checks, per Brian

Link: https://lkml.kernel.org/r/20250404015327.2427684-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Brian Geffon <bgeffon@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-modernize-writeback-interface-v3
+++ a/drivers/block/zram/zram_drv.c
@@ -853,9 +853,9 @@ static int parse_page_index(char *val, u
 	ret = kstrtoul(val, 10, lo);
 	if (ret)
 		return ret;
-	*hi = *lo + 1;
-	if (*lo >= nr_pages || *hi > nr_pages)
+	if (*lo >= nr_pages)
 		return -ERANGE;
+	*hi = *lo + 1;
 	return 0;
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix.patch
zram-modernize-writeback-interface.patch
zram-modernize-writeback-interface-v3.patch

