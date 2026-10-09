Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88EB411FA7
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525504; cv=none; b=MBRdRrqy56xb4lLClgRSjM+L5O+g1xJ5BfgilUQV+q6yLo+rIvEDrPcXK1TfZrYq1Ow4kWYtwv4o8nFMVpd5Z/nrCCXeGW5ooOHhftCrJ/Ze1zUVc/ZFf+d4OeEi2w3/gp2Ystmj4hpcOVJRUzoK/Fc26qyQK5RPffQ8pOOazyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525504; c=relaxed/simple;
	bh=rpAmzin5KsSCV43q+0wTCjTfe3c2tQhQiiEAowizWO4=;
	h=Date:To:From:Subject:Message-Id; b=eMTPzpKWJIIOE1lOFcxmX0R8/88t/S0M+dzR4viKX05xUEYwjGqWqFk4oP2UkdxekVobbGLCXwAJ3o60LYv0/0lcJkRWF6tcPOcjfUYho1Db6aA9D1nCAo5T9CoruKWZL/c0DnQtA8G1+cOSuktilB4viaH7dUQGN2Ty87k8GYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GPiwrgFp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GPiwrgFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732821F000FF;
	Fri,  9 Oct 2026 05:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525503;
	bh=yxA4heo2M9RlY8TYIFrRPphdRKTezwT4lbGLVJd66Dk=;
	h=Date:To:From:Subject;
	b=GPiwrgFpYkA9Utz+l6vgV5fJEF5AELzkQ/ZZVRAfUgXJ6mvN0zz8FdBtYDhbqtajJ
	 MHIWUtdkycTWxjMVZWmcZ8m0MubQo5s+ZCrkr22hFaoBa06YuUuQs+su5o8+0QvrCZ
	 1/0m4CFmHbKFM4+e4yTJC+jKvVNjGiYhLZend7m0=
Date: Thu, 08 Oct 2026 22:58:23 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,nphamcs@gmail.com,luizcap@redhat.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-unneeded-swap_extend_table_try_free-in-swap_dup_entries_cluster.patch removed from -mm tree
Message-Id: <20261009055823.732821F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: remove unneeded swap_extend_table_try_free() in swap_dup_entries_cluster()
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-unneeded-swap_extend_table_try_free-in-swap_dup_entries_cluster.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm, swap: remove unneeded swap_extend_table_try_free() in swap_dup_entries_cluster()
Date: Mon, 7 Sep 2026 17:13:56 +0800

Since commit 0475fde0f68de ("mm, swap: avoid leaving unused extend table
after alloc race"), extend table is always allocated when any swap count
reach MAX - 1 and is always freed when swap count decrease to MAX - 1 or
MAX - 2 with cluster lock held.  So the extend table will always be freed
properly when decrease swap count in __swap_cluster_put_entry().  So
swap_extend_table_try_free() outside of __swap_cluster_put_entry() is
unneeded and can be removed.

Link: https://lore.kernel.org/20260907091356.53026-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Youngjun Park <youngjun.park@lge.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Nhat Pham <nphamcs@gmail.com>
---

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-remove-unneeded-swap_extend_table_try_free-in-swap_dup_entries_cluster
+++ a/mm/swapfile.c
@@ -1725,7 +1725,6 @@ restart:
 failed:
 	while (ci_off-- > ci_start)
 		__swap_cluster_put_entry(ci, ci_off);
-	swap_extend_table_try_free(ci);
 	swap_cluster_unlock(ci);
 	return err;
 }
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


