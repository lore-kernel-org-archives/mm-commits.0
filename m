Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37881A32
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248793; cv=none; b=aSmGxo0SQUdxf/rBx1RpqiQGJL8skMNL6oygQ1VOPc5d6xCm0W57JF9hnOrCpf2nfx2mg9CawdY+g6gJtbL0OGo2zkQcIOd5n6SRMxP0wpI+Wu5F3xgfVaU58LcERdPUj16gpY1CTfXeVARgiOglQcdC5OB6O8eF6gy9XnUzT+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248793; c=relaxed/simple;
	bh=/GF0ggSw56LcuKn+xM/dewvdofg/GjnOLvAo1T33kfE=;
	h=Date:To:From:Subject:Message-Id; b=g6aAFOpRfG65vVUm+2ZIKrSuo2NkTU+Ub2Y0qsf1Pyg3wJyvXvQ446WdXC8ReZNnBjDWx2bpcw7ngzQtv7q7F/w7aY2dGz9g1SKRijeDuNUj3ybFAwPZRSsxDCsNEYll9MoeQ/s0R8hLpnPlk96QhlmnoivO2ZF73+3UujrzcdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BB8XtnnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BB8XtnnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C41FC4CEC7;
	Mon,  2 Sep 2024 03:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248793;
	bh=/GF0ggSw56LcuKn+xM/dewvdofg/GjnOLvAo1T33kfE=;
	h=Date:To:From:Subject:From;
	b=BB8XtnnBvvnR9V7wcGmcejIjGc574fpzzdtNNpRqtYKtSI1wtphgrviJSISTb0gjj
	 eGIPjOwogO7eXKJDm+k+rQgIc7sv8kTG9+w2dN0IdTggwTn6f4rHkgLnVIPwuVVMAZ
	 H6OUd7PQl/HiyCMqjzkS43HLxzkXjwW54Px4GAiU=
Date: Sun, 01 Sep 2024 20:46:32 -0700
To: mm-commits@vger.kernel.org,jannh@google.com,adobriyan@gmail.com,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-procfs-remove-build-id-related-code-duplication-in-procmap_query.patch removed from -mm tree
Message-Id: <20240902034633.0C41FC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/procfs: remove build ID-related code duplication in PROCMAP_QUERY
has been removed from the -mm tree.  Its filename was
     fs-procfs-remove-build-id-related-code-duplication-in-procmap_query.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrii Nakryiko <andrii@kernel.org>
Subject: fs/procfs: remove build ID-related code duplication in PROCMAP_QUERY
Date: Mon, 29 Jul 2024 10:40:44 -0700

A piece of build ID handling code in PROCMAP_QUERY ioctl() was
accidentally duplicated.  It wasn't meant to be part of ed5d583a88a9
("fs/procfs: implement efficient VMA querying API for /proc/<pid>/maps")
commit, which is what introduced duplication.

It has no correctness implications, but we unnecessarily perform the same
work twice, if build ID parsing is requested.  Drop the duplication.

Link: https://lkml.kernel.org/r/20240729174044.4008399-1-andrii@kernel.org
Fixes: ed5d583a88a9 ("fs/procfs: implement efficient VMA querying API for /proc/<pid>/maps")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reported-by: Jann Horn <jannh@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/fs/proc/task_mmu.c~fs-procfs-remove-build-id-related-code-duplication-in-procmap_query
+++ a/fs/proc/task_mmu.c
@@ -543,21 +543,6 @@ static int do_procmap_query(struct proc_
 		}
 	}
 
-	if (karg.build_id_size) {
-		__u32 build_id_sz;
-
-		err = build_id_parse(vma, build_id_buf, &build_id_sz);
-		if (err) {
-			karg.build_id_size = 0;
-		} else {
-			if (karg.build_id_size < build_id_sz) {
-				err = -ENAMETOOLONG;
-				goto out;
-			}
-			karg.build_id_size = build_id_sz;
-		}
-	}
-
 	if (karg.vma_name_size) {
 		size_t name_buf_sz = min_t(size_t, PATH_MAX, karg.vma_name_size);
 		const struct path *path;
_

Patches currently in -mm which might be from andrii@kernel.org are


