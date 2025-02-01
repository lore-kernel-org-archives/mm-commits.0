Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66793153565;
	Sat,  1 Feb 2025 11:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410842; cv=none; b=HnY+yZ6IwGupzxsR6GQgkhrRzj3X2NQA6Jn2FyHdxpkqOph/QzcXPL+Sm4zn+xeJAEQ7avDcGMw9qHY3J/Cp6xc7S3PEUkx8XTIJqjSRu4wnk5CuiPfhK5xZ2wt73cyV1cviknQLVh2XTz7TrkUhrHCxe1GtUJ/gZPqLNXiUo80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410842; c=relaxed/simple;
	bh=zBCqq3uKPEihIFYtZDGYlXJ2kx8u708lL4THsg0wVHw=;
	h=Date:To:From:Subject:Message-Id; b=LhrPy0c18eCNkGwa64oR+N/MP5R49kHEm8HFVdNg0/YJKuFIBK/1a2NLlMcAkPXkxWj78731s9bDA7tu3I8PeizCVZ9kS1j8G9C+bYW+RL95jxUAeyiC9ETklEQtqtu1tAahRiDWqWNCbP5vzkpCaK3T4L38n9rF42HrJOfSJxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zWhFK3Wr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zWhFK3Wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF52CC4CEE1;
	Sat,  1 Feb 2025 11:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410841;
	bh=zBCqq3uKPEihIFYtZDGYlXJ2kx8u708lL4THsg0wVHw=;
	h=Date:To:From:Subject:From;
	b=zWhFK3WrmTMXHG37N8w2abaKnics6EXcDJCmFlQWYaTaA4G9qRquM0qxxgg72aj8+
	 PbpkTsxppzdp6sdK0jS9Onco1K+9200GYCn0Ou8gpX9ll7O+wFCHXTyLWqdYr7Bq4q
	 LzB0dihyG3xrUKAqbvE+0/+uANlw+4Mox2ravQxg=
Date: Sat, 01 Feb 2025 03:54:01 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kaiyang2@cs.cmu.edu,donettom@linux.ibm.com,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics.patch removed from -mm tree
Message-Id: <20250201115401.CF52CC4CEE1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: accumulate nr_demoted for accurate demotion statistics
has been removed from the -mm tree.  Its filename was
     mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: mm/vmscan: accumulate nr_demoted for accurate demotion statistics
Date: Fri, 10 Jan 2025 20:21:32 +0800

In shrink_folio_list(), demote_folio_list() can be called 2 times. 
Currently stat->nr_demoted will only store the last nr_demoted( the later
nr_demoted is always zero, the former nr_demoted will get lost), as a
result number of demoted pages is not accurate.

Accumulate the nr_demoted count across multiple calls to
demote_folio_list(), ensuring accurate reporting of demotion statistics.

[lizhijian@fujitsu.com: introduce local nr_demoted to fix nr_reclaimed double counting]
  Link: https://lkml.kernel.org/r/20250111015253.425693-1-lizhijian@fujitsu.com
Link: https://lkml.kernel.org/r/20250110122133.423481-1-lizhijian@fujitsu.com
Fixes: f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA balancing operations")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Acked-by: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Tested-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics
+++ a/mm/vmscan.c
@@ -1086,7 +1086,7 @@ static unsigned int shrink_folio_list(st
 	struct folio_batch free_folios;
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(demote_folios);
-	unsigned int nr_reclaimed = 0;
+	unsigned int nr_reclaimed = 0, nr_demoted = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
 	struct swap_iocb *plug = NULL;
@@ -1550,8 +1550,9 @@ keep:
 	/* 'folio_list' is always empty here */
 
 	/* Migrate folios selected for demotion */
-	stat->nr_demoted = demote_folio_list(&demote_folios, pgdat);
-	nr_reclaimed += stat->nr_demoted;
+	nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	nr_reclaimed += nr_demoted;
+	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
 		/* Folios which weren't demoted go back on @folio_list */
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are


