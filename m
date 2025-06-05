Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA37328E17
	for <mm-commits@vger.kernel.org>; Thu,  5 Jun 2025 21:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749160360; cv=none; b=NbUrY3yMJcdKY+xe0j7gx9KXoo2hxwASU9DvKkxmNape/lauFt1MFTQN51U7COCxBN+8SFLwgwveIvYOgDS6iFIgaEbasr5agjILHS/eK3X7tZC3fEYxixdacYoaqOEI1ft+e7xcqv/8pA+BohJkV37HIevtRNsnrxafI7FrVaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749160360; c=relaxed/simple;
	bh=BtrzFwfrzhiKTi/vprCb+1d3YhNyuxVglNeqguvM8QY=;
	h=Date:To:From:Subject:Message-Id; b=Mh6rIEZFsdWk5puELuP2VFIOy5o2GTBUmJPpdR2SRQGq1OCh4UohRx1gvZVqmjxQ9IOpYos0hL36P5cM1SC3gzh4WxUaw8/6qmZC76Ln751Eea+0+BkRC0eR0vfduY6RONhLTUOrTdwKSh3iAqcF/DrYnegODSKO6TAWGSmUBwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hxiGqw3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hxiGqw3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E6BC4CEEB;
	Thu,  5 Jun 2025 21:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749160359;
	bh=BtrzFwfrzhiKTi/vprCb+1d3YhNyuxVglNeqguvM8QY=;
	h=Date:To:From:Subject:From;
	b=hxiGqw3N7D0jtWPsCXJtPaPYUtjIZ1C7ZDSL0BwZpgsTpnVdxUKaeejtJf6jqEqMr
	 Si7J+zpyqItDDXrTfANHWRRzdmV1q2mEmZquqJ5Y/YrNqzZNRbb/PJuAxX7adH8CZn
	 iKVOfg1PAvxAV0ol3DKnN8nJOy7g2EfeGOmZFJnY=
Date: Thu, 05 Jun 2025 14:52:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-fix-return-value-of-page_cache_next_miss-when-no-hole-is-found.patch added to mm-new branch
Message-Id: <20250605215239.58E6BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: fix return value of page_cache_next_miss() when no hole is found
has been added to the -mm mm-new branch.  Its filename is
     readahead-fix-return-value-of-page_cache_next_miss-when-no-hole-is-found.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-fix-return-value-of-page_cache_next_miss-when-no-hole-is-found.patch

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
From: Chi Zhiling <chizhiling@kylinos.cn>
Subject: readahead: fix return value of page_cache_next_miss() when no hole is found
Date: Thu, 5 Jun 2025 13:49:35 +0800

max_scan in page_cache_next_miss always decreases to zero when no hole is
found, causing the return value to be index + 0.

Fix this by preserving the max_scan value throughout the loop.

Link: https://lkml.kernel.org/r/20250605054935.2323451-1-chizhiling@163.com
Fixes: 901a269ff3d5 ("filemap: fix page_cache_next_miss() when no hole found")
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/filemap.c~readahead-fix-return-value-of-page_cache_next_miss-when-no-hole-is-found
+++ a/mm/filemap.c
@@ -1778,8 +1778,9 @@ pgoff_t page_cache_next_miss(struct addr
 			     pgoff_t index, unsigned long max_scan)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
+	unsigned long nr = max_scan;
 
-	while (max_scan--) {
+	while (nr--) {
 		void *entry = xas_next(&xas);
 		if (!entry || xa_is_value(entry))
 			return xas.xa_index;
_

Patches currently in -mm which might be from chizhiling@kylinos.cn are

readahead-fix-return-value-of-page_cache_next_miss-when-no-hole-is-found.patch

