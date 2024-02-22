Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5216D10EB
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560164; cv=none; b=kMZ6IfASIYAMhbzw0iGYeUT3Muke4y9qYLqQnS2lVJsr6dO3j9U1Q+LTJt9vs1nfrlvfPCCJcePGhDqFB5zqndRsHanAHbIjhcfEtgI3xGnPTlSzknJPaOsjSVewF7GyO01Emi23eeCyaPPDE6WmK9yQPNZRw+9E0qIGrg4I8aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560164; c=relaxed/simple;
	bh=IUQQLxQwmq1sPoTJJJVHj/XWzha2Mbau6UV53zCxZXQ=;
	h=Date:To:From:Subject:Message-Id; b=kusK2woizttzMzuDaOahU6yyNmzAEA9SRGkmwXWQ1iue3ZcwI2ExfWrzxkcllhorlUaSw2UVWsDmuPOlu4vgtQJi+hP4xOSna2/R2rmI4Vfwbt6SSKjd+k0zcqCAAywvGLvaFC4ozg+O9i4chj37DOpEy4aQdvraH105J5WDUlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ItC2KOCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ItC2KOCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F21C43399;
	Thu, 22 Feb 2024 00:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560164;
	bh=IUQQLxQwmq1sPoTJJJVHj/XWzha2Mbau6UV53zCxZXQ=;
	h=Date:To:From:Subject:From;
	b=ItC2KOCzJrU8qSdNrD0gmuj3PbngvMGrMusUie4UrRmjSEHwlxqAHzk+9q7EpxwdI
	 dJ9lfkbA7YcpFPCXGI/GQ1kVOTyXKz1hgDwVDgAM3KsJN0LUpi2oi5ctprtt8fCe+j
	 DEI1bqjchAj0HD8SXfXabKhbdZqFOoQUbZ5+h2w4=
Date: Wed, 21 Feb 2024 16:02:43 -0800
To: mm-commits@vger.kernel.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-change-the-type-of-file-from-int-to-bool.patch removed from -mm tree
Message-Id: <20240222000244.25F21C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: change the type of file from int to bool
has been removed from the -mm tree.  Its filename was
     mm-vmscan-change-the-type-of-file-from-int-to-bool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-page_alloc-make-bad_range-return-bool.patch

