Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932332904
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560138; cv=none; b=fzb7vsLYzXuT9Jm1Yb24Rmo9XTlocpfKajDHiovhDTO7aexjC5okyZN6aswltf2TRger24IMqpWFyun3Rvko/cUQUWIr6qg3nXitVefpA2qN3eFYGuqSRHShMMzvl2aVGFG3tiiDonrUaQs26kUiOb4P2fxUaANw326QFarYny0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560138; c=relaxed/simple;
	bh=BpYKIFVZzqDUCprwTVsQX3r4dLK9hG5D4KvYek5hWsg=;
	h=Date:To:From:Subject:Message-Id; b=csLOPI4uu0BtTVGKxup25I+PmvQ84pq+YwbZbaSFWgEEJUXlLf5MaoGK7EesAqrOm+RpremrjxV5J8etXojFHvVCnmQou2PL2yiUA8XngfK+FpT2bYJP/Xt2rSAwmt4QOxrPnTfbid13DfdBz3pirauQuQ6nffe++qgTqxi21L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q9WmUioB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q9WmUioB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B3DC433C7;
	Thu, 22 Feb 2024 00:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560138;
	bh=BpYKIFVZzqDUCprwTVsQX3r4dLK9hG5D4KvYek5hWsg=;
	h=Date:To:From:Subject:From;
	b=Q9WmUioB5B1UBoT7ig6+n1GjL9EDL9mkufQXIMMdLbRM2LdbKUBpADQoRH9qbKKsh
	 eJlYOas2ApMSjB7g38xGUU1gp7jZKNUvU/cLJraRyXAlkfHainf++rME6cVUn2/nji
	 GaB41qW9Q5EOrwRZzYGejdZ1axHsiRUHLnZJ8Q/o=
Date: Wed, 21 Feb 2024 16:02:17 -0800
To: mm-commits@vger.kernel.org,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-use-sz_8k-128k-helper-macro.patch removed from -mm tree
Message-Id: <20240222000218.69B3DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: use SZ_{8K, 128K} helper macro
has been removed from the -mm tree.  Its filename was
     mm-mmap-use-sz_8k-128k-helper-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/mmap: use SZ_{8K, 128K} helper macro
Date: Wed, 31 Jan 2024 11:19:13 +0800

Use SZ_{8K, 128K} helper macro instead of the number in init_user_reserve
and reserve_mem_notifier. This is more readable.

Link: https://lkml.kernel.org/r/20240131031913.2058597-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-sz_8k-128k-helper-macro
+++ a/mm/mmap.c
@@ -3845,7 +3845,7 @@ static int init_user_reserve(void)
 
 	free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
 
-	sysctl_user_reserve_kbytes = min(free_kbytes / 32, 1UL << 17);
+	sysctl_user_reserve_kbytes = min(free_kbytes / 32, SZ_128K);
 	return 0;
 }
 subsys_initcall(init_user_reserve);
@@ -3866,7 +3866,7 @@ static int init_admin_reserve(void)
 
 	free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
 
-	sysctl_admin_reserve_kbytes = min(free_kbytes / 32, 1UL << 13);
+	sysctl_admin_reserve_kbytes = min(free_kbytes / 32, SZ_8K);
 	return 0;
 }
 subsys_initcall(init_admin_reserve);
@@ -3898,12 +3898,12 @@ static int reserve_mem_notifier(struct n
 	case MEM_ONLINE:
 		/* Default max is 128MB. Leave alone if modified by operator. */
 		tmp = sysctl_user_reserve_kbytes;
-		if (0 < tmp && tmp < (1UL << 17))
+		if (tmp > 0 && tmp < SZ_128K)
 			init_user_reserve();
 
 		/* Default max is 8MB.  Leave alone if modified by operator. */
 		tmp = sysctl_admin_reserve_kbytes;
-		if (0 < tmp && tmp < (1UL << 13))
+		if (tmp > 0 && tmp < SZ_8K)
 			init_admin_reserve();
 
 		break;
_

Patches currently in -mm which might be from yajun.deng@linux.dev are


