Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2353C22F15E
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846657; cv=none; b=N4vWTYlQsoWdxOxBW3YuFmhCtdoTFWTxyBaUE6o0Z9J2x0kxDwVwYItnfc/ECJ/E1lnMz94+nxS+2vkrQa2la/sxZv/krEAAo/SMNQQBm1avXRWA8uhLt2buffY10hNbRHDLnaWx6rw8D5M82rjk+9jHSdx6tkvtqry81KRNIwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846657; c=relaxed/simple;
	bh=yEAwdlicClcsRKRhxble1EJ8qlocyYY+FkMpV0EholE=;
	h=Date:To:From:Subject:Message-Id; b=PE/scdkNk0+hZvrEc/6AyWDC103896X/f0DvT8k5rRRcKixInly17aNlldLxDy/TdmwjWMEv/LYJVrikUJPCHUGQntwaz0SVQh5v/7rK+59zaeS6OQW9QUELLcXlKem1zl/KsJT0aZ+IjuFT9IqEYf31X/hJkwkQnrxEl4IqPxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J3IQnjQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J3IQnjQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6071C4CEE4;
	Wed, 21 May 2025 16:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846657;
	bh=yEAwdlicClcsRKRhxble1EJ8qlocyYY+FkMpV0EholE=;
	h=Date:To:From:Subject:From;
	b=J3IQnjQnzhYmilN2cFjRVmpWiFC6ZJzChiCGJHse0QTTKbwLlTL1Gt8ITz0FJV75p
	 If/e0HdsvSmQJxq94Gl2OGxiqmIupgA2mn1NRFPU/5KRrShEf38//DdM/xuTPqXRGv
	 DQD3ujYHODgRIglUfaHSieD3cM2EGDvF+k1k8SjE=
Date: Wed, 21 May 2025 09:57:36 -0700
To: mm-commits@vger.kernel.org,yzhong@purestorage.com,surenb@google.com,cachen@purestorage.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-check-mem_profiling_support-in-alloc_tag_init.patch removed from -mm tree
Message-Id: <20250521165736.E6071C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: check mem_profiling_support in alloc_tag_init
has been removed from the -mm tree.  Its filename was
     alloc_tag-check-mem_profiling_support-in-alloc_tag_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Casey Chen <cachen@purestorage.com>
Subject: alloc_tag: check mem_profiling_support in alloc_tag_init
Date: Tue, 13 May 2025 12:26:02 -0600

If mem_profiling_support is false, for example by
sysctl.vm.mem_profiling=never, alloc_tag_init should skip module tags
allocation, codetag type registration and procfs init.

Link: https://lkml.kernel.org/r/20250513182602.121843-1-cachen@purestorage.com
Signed-off-by: Casey Chen <cachen@purestorage.com>
Reviewed-by: Yuanyuan Zhong <yzhong@purestorage.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/lib/alloc_tag.c~alloc_tag-check-mem_profiling_support-in-alloc_tag_init
+++ a/lib/alloc_tag.c
@@ -244,17 +244,6 @@ static void shutdown_mem_profiling(bool
 	mem_profiling_support = false;
 }
 
-static void __init procfs_init(void)
-{
-	if (!mem_profiling_support)
-		return;
-
-	if (!proc_create_seq(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_seq_op)) {
-		pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
-		shutdown_mem_profiling(false);
-	}
-}
-
 void __init alloc_tag_sec_init(void)
 {
 	struct alloc_tag *last_codetag;
@@ -762,19 +751,34 @@ static int __init alloc_tag_init(void)
 	};
 	int res;
 
+	sysctl_init();
+
+	if (!mem_profiling_support) {
+		pr_info("Memory allocation profiling is not supported!\n");
+		return 0;
+	}
+
+	if (!proc_create_seq(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_seq_op)) {
+		pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
+		shutdown_mem_profiling(false);
+		return -ENOMEM;
+	}
+
 	res = alloc_mod_tags_mem();
-	if (res)
+	if (res) {
+		pr_err("Failed to reserve address space for module tags, errno = %d\n", res);
+		shutdown_mem_profiling(true);
 		return res;
+	}
 
 	alloc_tag_cttype = codetag_register_type(&desc);
 	if (IS_ERR(alloc_tag_cttype)) {
+		pr_err("Allocation tags registration failed, errno = %ld\n", PTR_ERR(alloc_tag_cttype));
 		free_mod_tags_mem();
+		shutdown_mem_profiling(true);
 		return PTR_ERR(alloc_tag_cttype);
 	}
 
-	sysctl_init();
-	procfs_init();
-
 	return 0;
 }
 module_init(alloc_tag_init);
_

Patches currently in -mm which might be from cachen@purestorage.com are


