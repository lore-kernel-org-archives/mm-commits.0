Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCA43B992C
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068126; cv=none; b=KfSfKbeXCKk25ZXMF3tRqlJPXio5PT5HTucpTQuj41FG3K6/olZr8GTJyfwyB7idmm4V1xcyo4wn8ZfNwuDcvuB5tnD+FABJmZrlDGgi66mYOBmPM/+680sAeK7G9UI+SFkEVqJnA8olp60Sk4DD4N9hk4wmM5hRS38vi5KokHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068126; c=relaxed/simple;
	bh=IhKdjDZZHvER6mnQa2FG3XigtUC6fAz+s6uQlI1tKCA=;
	h=Date:To:From:Subject:Message-Id; b=HswfAr6l0PUaNpfWktYeN6/YZGOeQ2HV0craWCVCcpGKjyvNf9jUuZgkNB1EK0IfCFESRzq90Ck5QbCBSIyTcFHuT/e4Jh7hYmRqIZdPouqlITrKp2+6AhzvPImZsO2ef+J0ZldeF9b86f9yQnH+q9YK6SPNuz9p5l7Ckypiv4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AyQ+HKYw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AyQ+HKYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173ED1F00A3A;
	Fri,  7 Aug 2026 02:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068125;
	bh=MGwzU3dHMPGx7p148D3x9GMr1KMUGraLETW464aFrAk=;
	h=Date:To:From:Subject;
	b=AyQ+HKYwNFjTvsS98Q4cUlhnJnGshvYaY3EGII3kGSXeO3FuAJR80ZEy9VGOM0TRz
	 aHpotbOLMS2EPw3w2WlxHcCMQWo4ov1Jj4qBSydbbfMz0y1kH5g0JbYBxa1GhnT1lX
	 LeWD7aUU7QW4yPicQq3vWOYI/WPG71Q0jeo3MIFk=
Date: Thu, 06 Aug 2026 19:02:04 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlbfs-release-subpool-on-fill_super-failure.patch removed from -mm tree
Message-Id: <20260807020205.173ED1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlbfs: release subpool on fill_super failure
has been removed from the -mm tree.  Its filename was
     hugetlbfs-release-subpool-on-fill_super-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yichong Chen <chenyichong@uniontech.com>
Subject: hugetlbfs: release subpool on fill_super failure
Date: Mon, 20 Jul 2026 10:18:59 +0800

hugetlbfs_fill_super() allocates a hugepage subpool when size or min_size
mount options are specified.  hugepage_new_subpool() may also reserve huge
pages for min_size.

If root dentry creation fails after the subpool is created, the failure
path frees the subpool with kfree().  This bypasses hugepage_put_subpool()
and can leave min_size reservations charged.

Use hugepage_put_subpool() on the failure path, matching the normal
put_super path.

Link: https://lore.kernel.org/20260720021900.1376309-1-chenyichong@uniontech.com
Fixes: 7ca02d0ae586 ("hugetlbfs: accept subpool min_size mount option and setup accordingly")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-release-subpool-on-fill_super-failure
+++ a/fs/hugetlbfs/inode.c
@@ -1419,7 +1419,8 @@ hugetlbfs_fill_super(struct super_block
 		goto out_free;
 	return 0;
 out_free:
-	kfree(sbinfo->spool);
+	if (sbinfo->spool)
+		hugepage_put_subpool(sbinfo->spool);
 	kfree(sbinfo);
 	return -ENOMEM;
 }
_

Patches currently in -mm which might be from chenyichong@uniontech.com are


