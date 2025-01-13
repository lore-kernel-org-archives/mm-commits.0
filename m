Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944414315A;
	Mon, 13 Jan 2025 03:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737454; cv=none; b=mnwKH9M8nNJDa7Zhagdm3EiMMlTwiIuzeIJ/POSox4K3/3O9dpUzeYcJA2m79GYaWr1cKEO6xlIZeWvihck1ZbuSkhBz/9Z98PSLKzutCnk37wjkDd6MCrF6QN+yTOOk5s4e2y9itSkSCZl52Jj8snGHxdDN1qTY2nM0bp1URq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737454; c=relaxed/simple;
	bh=TvUtvpUYlv1fWVcVpP+7gPkh7iC9sdhk/WUpojWweAE=;
	h=Date:To:From:Subject:Message-Id; b=GMMfUrr4b23W9Rj28tfDg83d64vGU9DhCDTlH020LN4LfmsxGMDKe2dvleF3BxOLw+caE0sMsMImH3YyMs+pvz4dgRh2GZHbUWyF5GBPypRSpTOrAwQhgBeIFvSSdMnd4gvhhZQngUt2J9bWn+T7Xv4IZ0BIDcIKerzBGTHRu/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cvRq2W6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cvRq2W6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67071C4CEDF;
	Mon, 13 Jan 2025 03:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737454;
	bh=TvUtvpUYlv1fWVcVpP+7gPkh7iC9sdhk/WUpojWweAE=;
	h=Date:To:From:Subject:From;
	b=cvRq2W6dcRM9EIzKRzd4V4f3qjBQ3zXYkf12ZvOPyacAfW9be1D0fjjnsfAlvY3Dx
	 /hXtrKO0H1fE7jQHCaSNYAvpWq1azVOytSIIZ8RLICqxBk+XzU/QzORzPy7+rT8f76
	 fK6wXxmGJO0KC7cUZvUrYWs2WhSekgvHhW9JyEpI=
Date: Sun, 12 Jan 2025 19:04:13 -0800
To: mm-commits@vger.kernel.org,zzqq0103.hey@gmail.com,stable@vger.kernel.org,lihongbo22@huawei.com,brauner@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] hugetlb-fix-null-pointer-dereference-in-trace_hugetlbfs_alloc_inode.patch removed from -mm tree
Message-Id: <20250113030414.67071C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: fix NULL pointer dereference in trace_hugetlbfs_alloc_inode
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-null-pointer-dereference-in-trace_hugetlbfs_alloc_inode.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


