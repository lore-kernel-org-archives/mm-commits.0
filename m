Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252928BEC
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337146; cv=none; b=KYVaz6NojDOlxtLiXtR2TLWr99TaJ91qqk1tX/6GM3DFdjn0MuOKq0ZEYfnYvjKwILdwCykoExJgJw4JHbGt8iGhIwegDQ1OMAzSYX284FdUoBDydGuxbIqclgX+eooD6iF9XfocvtGfS5yb7i8yaAlrWz5oj7vSxldxz9TGVD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337146; c=relaxed/simple;
	bh=YPluNyEHGH0BIcXS8oAobsFAiyd/RaSChZpwxhdJ5+0=;
	h=Date:To:From:Subject:Message-Id; b=lMOmidIW6iqx24RHs1OYiOuDhNfTElJylR5isesG/eBNAUirTbReaRNy7dZAwD1ViNs8Gpm84izgCsWF1rZPs/byQOXZMee+/Hn6k32v1+OfccxR8kRBYQwUP6I6OH669JLGAHkBtDMD+EyCZqd4PxTNb9pyuuHKuXPVNBY61Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NWQotIgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NWQotIgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C2FC4CED6;
	Mon, 20 Jan 2025 01:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337145;
	bh=YPluNyEHGH0BIcXS8oAobsFAiyd/RaSChZpwxhdJ5+0=;
	h=Date:To:From:Subject:From;
	b=NWQotIgC5J5TiSRlBI2N0TOtBuopmBJHGH30PwrCzfhJLdU0S0BW6dIISZiNeb/uQ
	 4c4mcT4pW+DaHjxkbeGvj+VuKIPWaAOKgM/SelHRZP1p7YdHj2gZB4DS6UwKkuaQVR
	 E45wetHIqhLMOxGJmR2tMCyk/HpUICUJC1mkWFoE=
Date: Sun, 19 Jan 2025 17:39:04 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-readahead-add-readahead_control-dropbehind-member.patch removed from -mm tree
Message-Id: <20250120013905.86C2FC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/readahead: add readahead_control->dropbehind member
has been removed from the -mm tree.  Its filename was
     mm-readahead-add-readahead_control-dropbehind-member.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jens Axboe <axboe@kernel.dk>
Subject: mm/readahead: add readahead_control->dropbehind member
Date: Fri, 20 Dec 2024 08:47:43 -0700

If ractl->dropbehind is set to true, then folios created are marked as
dropbehind as well.

Link: https://lkml.kernel.org/r/20241220154831.1086649-6-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Chris Mason <clm@meta.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 +
 mm/readahead.c          |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/pagemap.h~mm-readahead-add-readahead_control-dropbehind-member
+++ a/include/linux/pagemap.h
@@ -1358,6 +1358,7 @@ struct readahead_control {
 	pgoff_t _index;
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
+	bool dropbehind;
 	bool _workingset;
 	unsigned long _pflags;
 };
--- a/mm/readahead.c~mm-readahead-add-readahead_control-dropbehind-member
+++ a/mm/readahead.c
@@ -181,7 +181,13 @@ static void read_pages(struct readahead_
 static struct folio *ractl_alloc_folio(struct readahead_control *ractl,
 				       gfp_t gfp_mask, unsigned int order)
 {
-	return filemap_alloc_folio(gfp_mask, order);
+	struct folio *folio;
+
+	folio = filemap_alloc_folio(gfp_mask, order);
+	if (folio && ractl->dropbehind)
+		__folio_set_dropbehind(folio);
+
+	return folio;
 }
 
 /**
_

Patches currently in -mm which might be from axboe@kernel.dk are


