Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329BD1F2BAD
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774386912; cv=none; b=cQyMJZxJVvRPE437MnW8nchFVMrqQ3LgPMcN2P3BNlrwSTlZZEqslxDnBYY9v63cN/aQXv968KkH4sa1U5VLyIlLCIvWblaoTr64VJPsNQkb7Qn9VzLH8dEHjtbhuMRJHSSif2g8zAOY4AZlI7YH0jH9xTQPSgcLIcV461Ty5WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774386912; c=relaxed/simple;
	bh=OixzY+KiL+Db/ZTnnJdc5fw2+PCrfXml3lkwSLMAdm8=;
	h=Date:To:From:Subject:Message-Id; b=u8e0qA+asylPoXeqxs/8HwDVSb3byBbhU0arMSSUW9cnwebq9TZjALxnKRUBhuc9qbj3uWbpdkxJBK/W7kyL1GjGah9v/MeQ0J2endZM/6choH5DRZVUwwJyWQaHA3Lj3AQSjsgHoCHVzDL6bbwj82W0yH+QlduSbxIDybY55Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sami8GBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sami8GBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECF8C19424;
	Tue, 24 Mar 2026 21:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774386911;
	bh=OixzY+KiL+Db/ZTnnJdc5fw2+PCrfXml3lkwSLMAdm8=;
	h=Date:To:From:Subject:From;
	b=Sami8GBvEi5DwBq29yd5q/2+bFO5Or6QMRxKXocmRsgZqnJYGQkJHddYsCcCK9E43
	 w5FgNjhmjCBN4Wdph/9ypz0TpW8MTEMNP5NeS3N8yQQ+3CKvcablMINf0i3F+htp9t
	 b6zwijV/uEzEksmZBZJR7xcajanTQ1wzL1CgctfU=
Date: Tue, 24 Mar 2026 14:15:10 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,roman.gushchin@linux.dev,muchun.song@linux.dev,jack@suse.cz,david@fromorbit.com,mkoutny@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem-v2.patch removed from -mm tree
Message-Id: <20260324211511.7ECF8C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem-v2
has been removed from the -mm tree.  Its filename was
     mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem-v2.patch

This patch was dropped because it was folded into mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem.patch

------------------------------------------------------
From: Michal Koutný <mkoutny@suse.com>
Subject: mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem-v2
Date: Mon, 09 Mar 2026 16:08:08 +0100

update comment, per Qi Zheng

Link: https://lkml.kernel.org/r/20260309-cgroup-ml-nokmem-shrinker-v2-1-3e7a7eefb6c9@suse.com
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/shrinker.c~mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem-v2
+++ a/mm/shrinker.c
@@ -723,6 +723,7 @@ non_memcg:
 	 *  - non-memcg-aware shrinkers
 	 *  - !CONFIG_MEMCG
 	 *  - memcg is disabled by kernel command line
+	 *  - non-slab shrinkers: when memcg kmem is disabled
 	 */
 	size = sizeof(*shrinker->nr_deferred);
 	if (flags & SHRINKER_NUMA_AWARE)
_

Patches currently in -mm which might be from mkoutny@suse.com are

mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem.patch

