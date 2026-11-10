Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293127;
	b=iXgdbtlO9UJFzs4Lh/xeY+Seq0w7tES6Ihq+UJnkdKaMtl2aq13E6Yuo6qS1cA+oUVm9
	 /TOWNUEqwgmkbbUro+hoOM4q2yWbQ3dBzH/2Kjr+eST3NVcdAaqM4iKT/4pYJbh1QHTBq
	 4FJM+lCYWWCVFa3jeooMWRj+tWa/l55+2nFMJ/sH2cw2lW9imVYbCxTqAMRp5p+XC94IM
	 zfhlAJ26zFCTfwWA6d/26fabsfOALCuz3rSgdgbk0oOSXEWtFPwMZ4rTAoShUJV/PWCUf
	 p8aH2Sn850RCrK/aKUkyRfDsdnaOCZvm+gvwlZJ0gxsz+fZc8fCB80zK1hUV9HjzTKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293127;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ru3BcMbgmxRIR6sxTtfSKZKs8T3zqxXSXaUeuypHz4I=;
	b=kQHWYyjlrVrlPZT9F9JD50ung0kI2OFnsk8qaz4siPbGHvhGtK0sTPVby2aDGTrhhgHP
	 fsq1AJRlwF/dw/Iy/Yexd+BdNXVfarc56vjRA9a2RByJ9Px8Rq5YmOUQhoUKp5a8vm4Iz
	 5cHtBRh72MQiapiwok5J3qmSQyDGX+fTI/++ecIR11HwrSTjydC7cP/qRpI25XsSmi/i3
	 s12T2RAYpt1sZ4tfYeYu0SabY55WK+l61IZ9waFRwWj/EdC3QOqUqy7TQRuFjiUY+BwsA
	 Ir8w5b1fcuB+Fzy4GySVIRJOLK+XvazF6Boe4sCZLg+ksG5O93hPlSwuVkfG8f7jYSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WRRaO+VJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1683D606A326;
	Tue, 10 Nov 2026 06:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WRRaO+VJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FF21F0089F;
	Tue, 10 Nov 2026 06:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293126;
	bh=ru3BcMbgmxRIR6sxTtfSKZKs8T3zqxXSXaUeuypHz4I=;
	h=Date:To:From:Subject;
	b=WRRaO+VJ6wmNBvttB4Bx4Ao+Cugl0L4kTTGimQc4NxqzzoDgIzPglm7TmYiHP3e7p
	 SwpST0K7/CKa+1/OEHU1edzHRCMvdIPDVsGzB9mN+4MbnZvOKj5CqeJitwWGtS1HOt
	 MQDgT3eU+rnAJ10hOdv0IY6EroemjyHHVwMnBhs4=
Date: Mon, 09 Nov 2026 22:45:26 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	stable@vger.kernel.org,rakie.kim@sk.com,joshua.hahnjy@gmail.com,
	harry@kernel.org,gourry@gourry.net,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mempolicy-use-one-node-set-for-interleave-weights.patch removed from -mm tree
Message-Id: <20261110064526.C0FF21F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mempolicy: use one node set for interleave weights
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-use-one-node-set-for-interleave-weights.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/mempolicy: use one node set for interleave weights
Date: Fri, 30 Oct 2026 12:10:46 -0400

Switching weighted interleave back to automatic mode while memory is being
onlined can cause a kernel divide error on x86, and a panic if
panic_on_oops is set.

reduce_interleave_weights() scans N_MEMORY three times, but hotplug can
cause N_MEMORY to change at runtime - and torn reads on that nodemask can
cause a total sum of zero bandwidth.  A node that was hot-unplugged and
then hotplugged back can then cause this loop to generate a div/0.

Record the nodes visited while summing their bandwidth, then use that same
set when scaling and reducing the weights.  This gives us a consistent
state even if N_MEMORY changes.

Link: https://lore.kernel.org/20261030161046.1497894-1-gourry@gourry.net
Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/mempolicy.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-one-node-set-for-interleave-weights
+++ a/mm/mempolicy.c
@@ -207,15 +207,22 @@ static u8 get_il_weight(int node)
  */
 static void reduce_interleave_weights(unsigned int *bw, u8 *new_iw)
 {
+	nodemask_t nodes = NODE_MASK_NONE;
 	u64 sum_bw = 0;
 	unsigned int cast_sum_bw, scaling_factor = 1, iw_gcd = 0;
 	int nid;
 
-	for_each_node_state(nid, N_MEMORY)
+	/*
+	 * N_MEMORY can change while wi_state_lock is held. Remember the
+	 * nodes contributing to sum_bw so all passes use the same set.
+	 */
+	for_each_node_state(nid, N_MEMORY) {
+		node_set(nid, nodes);
 		sum_bw += bw[nid];
+	}
 
 	/* Scale bandwidths to whole numbers in the range [1, weightiness] */
-	for_each_node_state(nid, N_MEMORY) {
+	for_each_node_mask(nid, nodes) {
 		/*
 		 * Try not to perform 64-bit division.
 		 * If sum_bw < scaling_factor, then sum_bw < U32_MAX.
@@ -234,7 +241,7 @@ static void reduce_interleave_weights(un
 	}
 
 	/* 1:2 is strictly better than 16:32. Reduce by the weights' GCD. */
-	for_each_node_state(nid, N_MEMORY)
+	for_each_node_mask(nid, nodes)
 		new_iw[nid] /= iw_gcd;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
mm-migrate_device-allocate-deferred-split-sublists-for-new-huge-folios.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

