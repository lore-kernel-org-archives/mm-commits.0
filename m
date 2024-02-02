Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D391420B3
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876025; cv=none; b=S/r/KTIBKWGoS11dk4bTyEpygTAVS9Y0zT1rLjRTkpMLwtA64oqUR6J34CbAWaNlBfGoIfe8fYRzreelXkAWv6DfkKxm1j8TQ9JjlwYQXL2R9lvPYddT7o0ke/hBZzSxt79yjPwD8Tre+PDQYg9gx+TGMT1l6B+0v8x9yVp18Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876025; c=relaxed/simple;
	bh=8qnCnPnvtfnvP9VJ7bbmkqVX9rVVbJTXuCDr/68AwN4=;
	h=Date:To:From:Subject:Message-Id; b=T/aVf7RUNBTSwxSMVQwAvGHxdTFrgsZOIIm0lMP1vVvrc70R5i7pLBtJaTKm8HPgiL+9nX3FfOGd131SPfpI/jAu+C2ZQhMRzKkURvnmBcf7cSXw/AKu5VvwrNeq/H43mWs0H++ulJqkMoAOLw65OQOtfSAnTnYQ8MtGM1SIjGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VeknlKQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VeknlKQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E324CC433F1;
	Fri,  2 Feb 2024 12:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876025;
	bh=8qnCnPnvtfnvP9VJ7bbmkqVX9rVVbJTXuCDr/68AwN4=;
	h=Date:To:From:Subject:From;
	b=VeknlKQBo73jCCD/vha6GJSHutYnMcxS5zMXpG/NgFRd8bdp7YUgiGpZnJgxMGViP
	 UGDUi3juvhzAPBp4nan8uw4EKM835D1FpZlbdvHVy00hcWGBJqH3cysyhYtQiLUUVs
	 c+StNiT9Jt0ckkiSK/UvUba5OJccesjDmZlWTMLA=
Date: Fri, 02 Feb 2024 04:13:42 -0800
To: mm-commits@vger.kernel.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-change-the-type-of-file-from-int-to-bool.patch added to mm-unstable branch
Message-Id: <20240202121344.E324CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: change the type of file from int to bool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-change-the-type-of-file-from-int-to-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-change-the-type-of-file-from-int-to-bool.patch

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
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/vmscan: change the type of file from int to bool
Date: Wed, 31 Jan 2024 18:38:02 +0800

Change the type of file from int to bool because is_file_lru return bool

Link: https://lkml.kernel.org/r/20240131103802.122920-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-change-the-type-of-file-from-int-to-bool
+++ a/mm/vmscan.c
@@ -1998,7 +1998,7 @@ static void shrink_active_list(unsigned
 	LIST_HEAD(l_inactive);
 	unsigned nr_deactivate, nr_activate;
 	unsigned nr_rotated = 0;
-	int file = is_file_lru(lru);
+	bool file = is_file_lru(lru);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	lru_add_drain();
@@ -2412,7 +2412,7 @@ static void get_scan_count(struct lruvec
 	denominator = ap + fp;
 out:
 	for_each_evictable_lru(lru) {
-		int file = is_file_lru(lru);
+		bool file = is_file_lru(lru);
 		unsigned long lruvec_size;
 		unsigned long low, min;
 		unsigned long scan;
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-vmscan-change-the-type-of-file-from-int-to-bool.patch

