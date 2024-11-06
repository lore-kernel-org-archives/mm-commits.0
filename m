Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755B218786A
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855600; cv=none; b=gJwGphKDPe+vFvsq0i9Xt6el23JZZ6Fl3CTjgifjO28Lqq0170w4rEnqS8Q1Vlpmc9m79UoOfDWPB9hOyHp+BmbB8h6KxhsMrRQTJNv37NUWmCUZxMo+1VIEqmMHHTRnCX4mLcRQeY4kMko19K0WEewUdtapPDKWB3UPQdLUHTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855600; c=relaxed/simple;
	bh=UToottG+WUwMm+vur5i1lsHsWIcGF0Q8AfwhVebmOm0=;
	h=Date:To:From:Subject:Message-Id; b=qr0fHwLETSg+kH0MO6Yg5GEBDkd9+alOOkib9IOzgITRmIRIZbSkqV46glbzbTMQImoXX1Eo5K3jrBiNlL0kpNlC/snYDJ5yvhjeZafq6rZ/CbfRAXxl9rh+EqykEHYtLUQgcS6SVtt7ltlCgu2WUpFZ+XoC6o1YGg4WVNcv+Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WAZc2kfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WAZc2kfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADB9C4CECF;
	Wed,  6 Nov 2024 01:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855600;
	bh=UToottG+WUwMm+vur5i1lsHsWIcGF0Q8AfwhVebmOm0=;
	h=Date:To:From:Subject:From;
	b=WAZc2kfOyt2ucTV548yVS9RlWI1MXH1K8yBlFyfV4NsTbr5WfXBgnfTJhWIwP+Nva
	 /ixlZBkFaaaBBVhngbxvh7oYn84IwIEiOKWsd9C7o2V7TnBmditnKeNFgjWhO5ysdT
	 PjCIlbajclkwpTNKFGB+T0uBV16cFaOnmAZ57sFo=
Date: Tue, 05 Nov 2024 17:13:19 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,pvmohammedanees2003@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-typo-in-comment.patch removed from -mm tree
Message-Id: <20241106011320.3ADB9C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix typo in comment
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-typo-in-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
Subject: ocfs2: fix typo in comment
Date: Tue, 17 Sep 2024 18:51:56 +0000

Fix "Allcate" -> "Allocate"

Link: https://lkml.kernel.org/r/20240917185156.10580-1-pvmohammedanees2003@gmail.com
Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-fix-typo-in-comment
+++ a/fs/ocfs2/alloc.c
@@ -4767,7 +4767,7 @@ bail:
 }
 
 /*
- * Allcate and add clusters into the extent b-tree.
+ * Allocate and add clusters into the extent b-tree.
  * The new clusters(clusters_to_add) will be inserted at logical_offset.
  * The extent b-tree's root is specified by et, and
  * it is not limited to the file storage. Any extent tree can use this
_

Patches currently in -mm which might be from pvmohammedanees2003@gmail.com are


