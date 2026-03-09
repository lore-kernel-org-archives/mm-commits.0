Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AA540759E
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 17:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079198; cv=none; b=iv6PdOucbyo+Yb5cACVHFQWCPVgg+WpWqgfxNBPn6o8/SPW/w9PEIpFFcVfiaa3xQKDJyWBGZQ0gMFSLaJy89oI+6FF7mjV4S6nLY1ssa7txBL7i2m9/hLHPA6h3mkCj1XW5QfP0OImzLqJx4JdkMaWpqlGOqRSknpfzrg2fFwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079198; c=relaxed/simple;
	bh=F8JBEwfbvXMyLGROyLHROtzRGZF47P3OuKz65Y/z1MI=;
	h=Date:To:From:Subject:Message-Id; b=CUGFxKLKxLaaZ1OpEIL8/jPGy6oKJJLJY2B5b1X2lP1DitZshTtgV4/Woy6jqCLfl+cOyHSvn3tlMDfzI+GThcVgkG/lczj3dEk9mnY/wuhCzKGU2deOIGvGD+7futm73RwEF57fMSZlrRwIMzdzYgrUMVTusKJ8/4hPmYMJmTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mRNKOjRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mRNKOjRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AC7C4CEF7;
	Mon,  9 Mar 2026 17:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773079198;
	bh=F8JBEwfbvXMyLGROyLHROtzRGZF47P3OuKz65Y/z1MI=;
	h=Date:To:From:Subject:From;
	b=mRNKOjRB+0Md1kUP3VSXGplgoVlpG6Ps8ArbdmQ99DPhD3dYGiBxwi+IM/fxcWD8a
	 DNYNqPPI3BYLOZXIN/MpSsGhbpRss76xfePCRVxKp8onlNdvcTKKb2yQLSH8RMw8Is
	 FIfn0vyc0fX6850aUXxomeMrWMwmj44gXkOFlAh8=
Date: Mon, 09 Mar 2026 10:59:57 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,roman.gushchin@linux.dev,muchun.song@linux.dev,jack@suse.cz,david@fromorbit.com,mkoutny@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem-v2.patch added to mm-unstable branch
Message-Id: <20260309175958.53AC7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem-v2.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem-v2.patch

