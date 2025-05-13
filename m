Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A51B672
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 20:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747166690; cv=none; b=bz90Xtaaz8Af41cyv+YFqWwO1M2QsLAx/tqEGJhmBvBf2GJ6cKt2zp904RJzwRgXCwGwrSB9SCPWtOYyIgtUlIkZc8oe9iuXeOUqn6s60NcwyQlMKcs8abXj92ysYPlFi3oPtA8+Ixtt5rgnKPD9XUAHsm/muvLnXQF0QyTx/bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747166690; c=relaxed/simple;
	bh=ViFrgLFOfZXx0hIad2xKBsPx9MyjUYsVAzXIg0fvrHo=;
	h=Date:To:From:Subject:Message-Id; b=JB9GSj6gpXnUbY31PLKtgYsZVwIINprBmFC4xktj+EhlmXMc/xCiOez22cCyp5UPOdJCn1hgZKv2NKEb10rqnkpriXjlIdIpNGe22qg95C6Z3FWNdOkxbKTPCU2LZN910+NC5BhD3i9DDmksidKJDYOKVH0sqOWA0tMBu5pqJUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZLpnCgWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZLpnCgWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308F8C4CEE4;
	Tue, 13 May 2025 20:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747166690;
	bh=ViFrgLFOfZXx0hIad2xKBsPx9MyjUYsVAzXIg0fvrHo=;
	h=Date:To:From:Subject:From;
	b=ZLpnCgWmtlb0EimOcT36pNkT6HlVelDHZpII6AxL53keFBbfxwne1nZDTRLBi12hx
	 LP/5C+11mCqyDDskrnu1Zf9aP8rbdQCracBSkLgmvB+UlXRqf4+/mtXkC2nZf9a8M+
	 FToZYO47eEojXJMIsz4GXj2dAoaR8Z6EKadaxRM4=
Date: Tue, 13 May 2025 13:04:49 -0700
To: mm-commits@vger.kernel.org,yzhong@purestorage.com,surenb@google.com,cachen@purestorage.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-check-mem_profiling_support-in-alloc_tag_init.patch added to mm-new branch
Message-Id: <20250513200450.308F8C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: check mem_profiling_support in alloc_tag_init
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-check-mem_profiling_support-in-alloc_tag_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-check-mem_profiling_support-in-alloc_tag_init.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

alloc_tag-check-mem_profiling_support-in-alloc_tag_init.patch

