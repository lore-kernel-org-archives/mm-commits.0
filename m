Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8243EA98;
	Mon, 13 Jan 2025 02:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736736822; cv=none; b=epDe2aDVheke6jbPVQvZX+zoCWemDR2ciObxfndJXiN3Dk/lZ5qnZuILlSByObDZ6s3Cl4ECxE6D53jkGpsupqZyORZlQEuxuzmPGP80yZrClBd+ifmKOYa3kGSq95fmv4AAHzPVrVMQBuMWZeWnbvIc8MZ7+HinCg7dKVT0g+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736736822; c=relaxed/simple;
	bh=gNepMSvwmFWCyphcLQpWZE9s8SIEhnn8g1QwRrAduOg=;
	h=Date:To:From:Subject:Message-Id; b=EY/C2rAODRn7pSiR1LZA1x5oU7m+W54ppecxiT6BZ2fsoJWCwoV593CMZsSzo/+MtT7Ln1ZPlDdbnwU3vyLqPcebhpXMOpnCT7tNJISPg+jv2HcQD+jAmwhRY2OEs4G5chkDC/870A25g+Hvz8rxsFkSbHWJArp0eDta9rY+4ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0lh+tMLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0lh+tMLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB554C4CEDF;
	Mon, 13 Jan 2025 02:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736736821;
	bh=gNepMSvwmFWCyphcLQpWZE9s8SIEhnn8g1QwRrAduOg=;
	h=Date:To:From:Subject:From;
	b=0lh+tMLeg2z9bh3kRX3nT/zEN5Uis96RMIlmH72tCUS8IFinBYjLS+7yWTOew0i99
	 //HldTed4KzUXbHQqOHKobYQK+x2fHqi3H7KKJvIMmxHCjuMCE2MyOYlJI58u2qVF1
	 AVqFVgdbEB3C7uOFVJeiu5cE6+AqdqWPQcFz9ZOk=
Date: Sun, 12 Jan 2025 18:53:41 -0800
To: mm-commits@vger.kernel.org,zzqq0103.hey@gmail.com,stable@vger.kernel.org,lihongbo22@huawei.com,brauner@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hugetlb-fix-null-pointer-dereference-in-trace_hugetlbfs_alloc_inode.patch removed from -mm tree
Message-Id: <20250113025341.AB554C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: fix NULL pointer dereference in trace_hugetlbfs_alloc_inode
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-null-pointer-dereference-in-trace_hugetlbfs_alloc_inode.patch

This patch was dropped because it was folded into mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2.patch

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: hugetlb: fix NULL pointer dereference in trace_hugetlbfs_alloc_inode
Date: Mon, 6 Jan 2025 11:31:17 +0800

hugetlb_file_setup() will pass a NULL @dir to hugetlbfs_get_inode(), so we
will access a NULL pointer for @dir.  Fix it and set __entry->dr to 0 if
@dir is NULL.  Because ->i_ino cannot be 0 (see get_next_ino()), there is
no confusing if user sees a 0 inode number.

Link: https://lkml.kernel.org/r/20250106033118.4640-1-songmuchun@bytedance.com
Fixes: 318580ad7f28 ("hugetlbfs: support tracepoint")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Cheung Wall <zzqq0103.hey@gmail.com>
Closes: https://lore.kernel.org/linux-mm/02858D60-43C1-4863-A84F-3C76A8AF1F15@linux.dev/T/#
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Cc: cheung wall <zzqq0103.hey@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/hugetlbfs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/hugetlbfs.h~hugetlb-fix-null-pointer-dereference-in-trace_hugetlbfs_alloc_inode
+++ a/include/trace/events/hugetlbfs.h
@@ -23,7 +23,7 @@ TRACE_EVENT(hugetlbfs_alloc_inode,
 	TP_fast_assign(
 		__entry->dev		= inode->i_sb->s_dev;
 		__entry->ino		= inode->i_ino;
-		__entry->dir		= dir->i_ino;
+		__entry->dir		= dir ? dir->i_ino : 0;
 		__entry->mode		= mode;
 	),
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-fix-div-by-zero-in-bdi_ratio_from_pages-v2.patch

