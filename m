Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125BB1EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450045; cv=none; b=tFFZIiCo9Vnx9p2NWOjFqPC0k0gv+6vIgMoVMjWRq73Y513ceIvMhfS7aYEsFlJ76BrcRqXZtw0gHuzxq5eehavFIv1Fq4/CoUBw200EujyEaxlvxeEzhKZOKw900rWR6dYrOC9lsDziwXphvawf6F9RYbcHM7gnA3Km51JlxzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450045; c=relaxed/simple;
	bh=W74YRgVwFQjLe0u6dZSzuDl4ApKPhYP9POy1er0fRG8=;
	h=Date:To:From:Subject:Message-Id; b=EPVX8N+a9MGK1/8Jjq0p/P86P2nWam8XU1LPNv4gmIAs/K5AdKblSx0XkI3jjnbzf+/cRWHzyGK2o1QTXLTlYycOj/PCdxTPY18tCYUR2zUK5TW+ddykuE/DN0c1rVfa6eZaQW5plyIbF17zJqof0aBqqiWeImApurtT6f7/wIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oqDryyk8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oqDryyk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB18BC4CEE3;
	Sun, 13 Jul 2025 23:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450044;
	bh=W74YRgVwFQjLe0u6dZSzuDl4ApKPhYP9POy1er0fRG8=;
	h=Date:To:From:Subject:From;
	b=oqDryyk89DhGBwV4FqYKcvqoQ20scpqjbPu9qwPILBZeCF68Rs1Zs1bO06Ow9sZf5
	 U+Otq6aHg4pyPw00ExzbSp81Kh8mPqofZC1w5bPv8fFKDn5NNh6hWsmJol4rSieYTM
	 M2krVv+akLZ62LkiG6QCdgzEi3YwDsXwLyMnr48Y=
Date: Sun, 13 Jul 2025 16:40:44 -0700
To: mm-commits@vger.kernel.org,liuqiye2025@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-spelling-issue-in-swaph.patch removed from -mm tree
Message-Id: <20250713234044.DB18BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix spelling issue in swap.h
has been removed from the -mm tree.  Its filename was
     mm-fix-spelling-issue-in-swaph.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xuanye Liu <liuqiye2025@163.com>
Subject: mm: fix spelling issue in swap.h
Date: Wed, 2 Jul 2025 15:12:35 +0800

recliam -> reclaim

Link: https://lkml.kernel.org/r/20250702071235.212794-1-liuqiye2025@163.com
Signed-off-by: Xuanye Liu <liuqiye2025@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/swap.h~mm-fix-spelling-issue-in-swaph
+++ a/include/linux/swap.h
@@ -415,7 +415,7 @@ extern unsigned long try_to_free_pages(s
 #define MIN_SWAPPINESS 0
 #define MAX_SWAPPINESS 200
 
-/* Just recliam from anon folios in proactive memory reclaim */
+/* Just reclaim from anon folios in proactive memory reclaim */
 #define SWAPPINESS_ANON_ONLY (MAX_SWAPPINESS + 1)
 
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
_

Patches currently in -mm which might be from liuqiye2025@163.com are

mm-simplify-min_brk-handling-in-brk.patch

