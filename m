Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51591E89C
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 06:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757400340; cv=none; b=u+IG4rVljHY8GsFu3cwrPTxTribgqR2hdp8rgvMr8M3ctBofVWsriBqGQ7w0Y+2EJtyGl997V7oLVeTSX/fjDw54S33mSXFDCBBkM7z9Ais1hUiRvyKNM9lz7F2Bg/TPKDktxI9uRyljJbvnd7LitIwEW7f29p9UrUhZt30mrDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757400340; c=relaxed/simple;
	bh=HLZgK+2vlCiBP60mDvIVPOoawJTagdQYNCgaZ6xCvSY=;
	h=Date:To:From:Subject:Message-Id; b=bKaXf1LVtdkaUn8YAh7SIj34d3hOBApd07MmZOUkLDGEkNCFCVUzMqaZ2TmkEMft/JfxK0PAzohyWdSWWmQdshGC5TIMRCB2ASJhBLfElLI1u1FsObmdZy18Wc38iiMOlpYljL+u6VD75BR+sz8FMhVeeJg5/CDqZJMB/Mpp2Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zWZ8ei6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zWZ8ei6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525D8C4CEF4;
	Tue,  9 Sep 2025 06:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757400340;
	bh=HLZgK+2vlCiBP60mDvIVPOoawJTagdQYNCgaZ6xCvSY=;
	h=Date:To:From:Subject:From;
	b=zWZ8ei6wnX1+EIvz0wXZhSrQeB8XWuCS/fBiX6Z3avgbgZA5IohZbLAVIeTD8RWrS
	 Tj4+xEYqH6bPpB9vfuFzOJL7+WeR2eLl8K5QF0vOQmQHToMNdvjKTS2DxJ+V7i19+6
	 ShVcjCAdM52UmPbmSKAmlLdw6I1noz52g3JjWx8k=
Date: Mon, 08 Sep 2025 23:45:39 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@gentwo.org,bhe@redhat.com,vdumitrescu@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] percpu-fix-race-on-alloc-failed-warning-limit.patch removed from -mm tree
Message-Id: <20250909064540.525D8C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: fix race on alloc failed warning limit
has been removed from the -mm tree.  Its filename was
     percpu-fix-race-on-alloc-failed-warning-limit.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Subject: percpu: fix race on alloc failed warning limit
Date: Fri, 22 Aug 2025 15:55:16 -0700

The 'allocation failed, ...' warning messages can cause unlimited log
spam, contrary to the implementation's intent.

The warn_limit variable is accessed without synchronization.  If more than
<warn_limit> threads enter the warning path at the same time, the variable
will get decremented past 0.  Once it becomes negative, the non-zero check
will always return true leading to unlimited log spam.

Use atomic operation to access warn_limit and change condition to test for
non-negative (>= 0) - atomic_dec_if_positive will return -1 once
warn_limit becomes 0.  Continue to print disable message alongside the
last warning.

While the change cited in Fixes is only adjacent, the warning limit
implementation was correct before it.  Only non-atomic allocations were
considered for warnings, and those happened to hold pcpu_alloc_mutex while
accessing warn_limit.

[vdumitrescu@nvidia.com: prevent warn_limit from going negative, per Christoph Lameter]
  Link: https://lkml.kernel.org/r/ee87cc59-2717-4dbb-8052-1d2692c5aaaa@nvidia.com
Link: https://lkml.kernel.org/r/ab22061a-a62f-4429-945b-744e5cc4ba35@nvidia.com
Fixes: f7d77dfc91f7 ("mm/percpu.c: print error message too if atomic alloc failed")
Signed-off-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/percpu.c~percpu-fix-race-on-alloc-failed-warning-limit
+++ a/mm/percpu.c
@@ -1734,7 +1734,7 @@ void __percpu *pcpu_alloc_noprof(size_t
 	bool is_atomic;
 	bool do_warn;
 	struct obj_cgroup *objcg = NULL;
-	static int warn_limit = 10;
+	static atomic_t warn_limit = ATOMIC_INIT(10);
 	struct pcpu_chunk *chunk, *next;
 	const char *err;
 	int slot, off, cpu, ret;
@@ -1904,13 +1904,17 @@ fail_unlock:
 fail:
 	trace_percpu_alloc_percpu_fail(reserved, is_atomic, size, align);
 
-	if (do_warn && warn_limit) {
-		pr_warn("allocation failed, size=%zu align=%zu atomic=%d, %s\n",
-			size, align, is_atomic, err);
-		if (!is_atomic)
-			dump_stack();
-		if (!--warn_limit)
-			pr_info("limit reached, disable warning\n");
+	if (do_warn) {
+		int remaining = atomic_dec_if_positive(&warn_limit);
+
+		if (remaining >= 0) {
+			pr_warn("allocation failed, size=%zu align=%zu atomic=%d, %s\n",
+				size, align, is_atomic, err);
+			if (!is_atomic)
+				dump_stack();
+			if (remaining == 0)
+				pr_info("limit reached, disable warning\n");
+		}
 	}
 
 	if (is_atomic) {
_

Patches currently in -mm which might be from vdumitrescu@nvidia.com are


