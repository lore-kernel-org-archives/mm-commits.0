Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831DA36B01
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957123; cv=none; b=s0kDz9wXE1DOxKdVo0BAcsAAJnyqa9ZFCNpYlu0ZCGH2zLW9iui8RHI+SuVS/DfQK2OwAzHDKfBemO07QXNN8nxK+ik4C+Qfrqd60TtunoTBEZW7AP445VwcXiCym6xaeOI4SzKHzizYqWCKi9VilVcEknr3OkGdzyvke+uFXkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957123; c=relaxed/simple;
	bh=718sN4bqcz7l5e5aAfelkaYSNi57zqOOh0FbWRrkhiY=;
	h=Date:To:From:Subject:Message-Id; b=oZl7LZUmn7+NRPwPcE0zvp8Hl38h5YgmpwV9DojUkH3vzh1185NE+HeflxFugV9xefXbzxh+QfZp659Fok4StCnrEi5cvwU4eQU3CMCB53qqKVMBkR7dUbWGQ+J2wyhNkHsgd+82X94R53UDoIijW+XSLDp4+ZdCYnbpbDlXsHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mEsRSu8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mEsRSu8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52761C113CC;
	Mon,  6 May 2024 00:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957123;
	bh=718sN4bqcz7l5e5aAfelkaYSNi57zqOOh0FbWRrkhiY=;
	h=Date:To:From:Subject:From;
	b=mEsRSu8G2DW7PFzyJRSSa+i0IrWAR+FrTz4dVQCwMoBibwmontdXMNdQxJ15omKdN
	 Az27VK1ONE8+nP29o6D2BGSG64cJomS8hHfkcnTHxxiEeNOSrqOEbCWr2efI3Aqum+
	 rZFUAQ5ePwp/tOMMmlwH3T1VEcr3X+VoQZzmO2aI=
Date: Sun, 05 May 2024 17:58:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,mszeredi@redhat.com,jack@suse.cz,hcochran@kernelspring.com,axboe@kernel.dk,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-stale-comment-__folio_mark_dirty.patch removed from -mm tree
Message-Id: <20240506005843.52761C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove stale comment __folio_mark_dirty
has been removed from the -mm tree.  Its filename was
     mm-remove-stale-comment-__folio_mark_dirty.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: remove stale comment __folio_mark_dirty
Date: Thu, 25 Apr 2024 21:17:24 +0800

The __folio_mark_dirty will not mark inode dirty any longer.  Remove the
stale comment of it.

Link: https://lkml.kernel.org/r/20240425131724.36778-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Howard Cochran <hcochran@kernelspring.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page-writeback.c~mm-remove-stale-comment-__folio_mark_dirty
+++ a/mm/page-writeback.c
@@ -2721,8 +2721,7 @@ void folio_account_cleaned(struct folio
 }
 
 /*
- * Mark the folio dirty, and set it dirty in the page cache, and mark
- * the inode dirty.
+ * Mark the folio dirty, and set it dirty in the page cache.
  *
  * If warn is true, then emit a warning if the folio is not uptodate and has
  * not been truncated.
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


