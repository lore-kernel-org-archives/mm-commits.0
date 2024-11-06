Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A037D7DA6A
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855599; cv=none; b=cd3QJk+efYnAugLyGf2MlVCIGCSBAasPdEeq6+KDR9BkCuG+Flzbh+3WbP8DRMYYOVsnG7SeOoc8CxXo5f1wIwAZN9v6K/wAxfug3RWlVmT7jwEndRrNEArHdfzoe55SaJ0SGdP7ij6wYApnYPKGsXkbIOpC2JzMDe/Jtxm+Rj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855599; c=relaxed/simple;
	bh=01evcIe8z5Knm69s+wPm7pJm4PhgmiKUyqyQfQpAseE=;
	h=Date:To:From:Subject:Message-Id; b=KFUCP5Zy4/TkNumxLkRIDIABoXD8ASUrT1H7Z4bUPn5ajOd6FXAM4rnmWs6gRoa0Vc9AKp6kla6m3YtQ/G2A8AKXgGxcoVME4kg6KJZ99yJY10pOG/ZNcISuUfPMrkKwMGkZj8aAaPCXWm3/HvJ7QUMvRFrkP/an/b660CvrcM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lfNSA0Xs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lfNSA0Xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1156DC4CECF;
	Wed,  6 Nov 2024 01:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855599;
	bh=01evcIe8z5Knm69s+wPm7pJm4PhgmiKUyqyQfQpAseE=;
	h=Date:To:From:Subject:From;
	b=lfNSA0XsfiyZXJZHkGS3K3JrZxi6GpxGrax22g/RnSdATwZnua/6GbDHnOz3LMNRl
	 UN+TFEb5Asvw0/7ZMRHVbhb16Jsmswr+1uWQqehob1zIJnLgGwxJsSfoKpm97VU0zu
	 NyXiVS0RGf5ns74nrBkuGCdHfGVcuWfbN08y5jos=
Date: Tue, 05 Nov 2024 17:13:18 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,gechangwei@live.cn,zhangzekun11@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-unused-declartion-in-header-file.patch removed from -mm tree
Message-Id: <20241106011319.1156DC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove unused declaration in header file
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unused-declartion-in-header-file.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Zekun <zhangzekun11@huawei.com>
Subject: ocfs2: remove unused declaration in header file
Date: Fri, 6 Sep 2024 13:57:42 +0800

The definition of ocfs2_global_read_dquot() has been removed since commit
fb8dd8d78014 ("ocfs2: Fix quota locking").  Let's remove the empty
declartion

Link: https://lkml.kernel.org/r/20240906055742.105024-1-zhangzekun11@huawei.com
Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota.h |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/quota.h~ocfs2-remove-unused-declartion-in-header-file
+++ a/fs/ocfs2/quota.h
@@ -97,7 +97,6 @@ ssize_t ocfs2_quota_write(struct super_b
 			  const char *data, size_t len, loff_t off);
 int ocfs2_global_read_info(struct super_block *sb, int type);
 int ocfs2_global_write_info(struct super_block *sb, int type);
-int ocfs2_global_read_dquot(struct dquot *dquot);
 int __ocfs2_sync_dquot(struct dquot *dquot, int freeing);
 static inline int ocfs2_sync_dquot(struct dquot *dquot)
 {
_

Patches currently in -mm which might be from zhangzekun11@huawei.com are


