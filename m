Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486CDC2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011136; cv=none; b=cXrNFCz8JcZA5I/idnEBTxgH1dMqWFAVX/PC+UntvhR0DzWH/H1p8AJK8Ac3rcCuIQqlMqHlIsZre4YtDibB3yXu3W+OrpvQ1snLf7+dKY8FIVrPu2kZwFGr2Hazp8LBpCgkmFnr8zjK/vKnHET0GfJY7YgsjhoDxsHtO/3GGws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011136; c=relaxed/simple;
	bh=jm91iysmJGAIch3pBMWx0e3KCdMQ1DlkYVts9nY6IWU=;
	h=Date:To:From:Subject:Message-Id; b=GGfjHwx5blR3gnkCGDV9b45lFI94SVJCJ5kEkHpTkeiP9FF9iaRJ0do3+XPCFS80zhESdLCGV8gu3C6qS6qeiMbC7m3tANt2JAhTUKIeOPz0ZVCSm6pPG0fzMO3L8mn6tEOoMblwMP1OuFGmUUhDqKoCx7AcboLRMgjH84yGyRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nt38uH3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nt38uH3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC3BC4CEE4;
	Mon, 12 May 2025 00:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011136;
	bh=jm91iysmJGAIch3pBMWx0e3KCdMQ1DlkYVts9nY6IWU=;
	h=Date:To:From:Subject:From;
	b=nt38uH3fdk0FDtIj73+WMZhAA2Q5rrtNNxJTCvO5Um7giZmC732SNTZuVV9vus1rT
	 IvmZ8KQ4ZR6ZuBESnbUmqhHs/kNHwdq8SXeJsJdN5B4PfG0qfVtnSTBDicbzLDMRNV
	 sG+PcB+LoSKufVCYFwOAF2/5X19beDLnNDy/yXN0=
Date: Sun, 11 May 2025 17:52:15 -0700
To: mm-commits@vger.kernel.org,dev.jain@arm.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-modify-the-assignment-logic-of-the-scan-and-total_scan-variables.patch removed from -mm tree
Message-Id: <20250512005216.1FC3BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: modify the assignment logic of the scan and total_scan variables
has been removed from the -mm tree.  Its filename was
     mm-vmscan-modify-the-assignment-logic-of-the-scan-and-total_scan-variables.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/vmscan: modify the assignment logic of the scan and total_scan variables
Date: Thu, 17 Apr 2025 17:24:22 +0800

The scan and total_scan variables can be initialized to 0 when they are
defined, replacing the separate assignment statements.

Link: https://lkml.kernel.org/r/20250417092422.1333620-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Acked-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-modify-the-assignment-logic-of-the-scan-and-total_scan-variables
+++ a/mm/vmscan.c
@@ -1725,13 +1725,11 @@ static unsigned long isolate_lru_folios(
 	unsigned long nr_taken = 0;
 	unsigned long nr_zone_taken[MAX_NR_ZONES] = { 0 };
 	unsigned long nr_skipped[MAX_NR_ZONES] = { 0, };
-	unsigned long skipped = 0;
-	unsigned long scan, total_scan, nr_pages;
+	unsigned long skipped = 0, total_scan = 0, scan = 0;
+	unsigned long nr_pages;
 	unsigned long max_nr_skipped = 0;
 	LIST_HEAD(folios_skipped);
 
-	total_scan = 0;
-	scan = 0;
 	while (scan < nr_to_scan && !list_empty(src)) {
 		struct list_head *move_to = src;
 		struct folio *folio;
_

Patches currently in -mm which might be from gehao@kylinos.cn are


