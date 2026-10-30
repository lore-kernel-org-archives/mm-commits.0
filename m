Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793377158;
	b=sy1Uc9CcNujjPI1paYK8hSN/bSCGPRPaLozuI4RmnlDZoJwhTEqTSwu3GEEDx8JZHVS5
	 FlPrF3COb8lH7t/DqrCtb33E987cuUcLvssmcJAECJ00vhxqivtV0Gxu5At+LJFM1VKZ5
	 uVn0iExORWdSmcmxz6Z2F9Guo97NzXc0apyRxMCI5chsZexGRnENInyujnVnW//+zcPnx
	 JZAEtEn1r7nb2CtkKPDXiiA+i5niQchQzhSDzQnWXxr98OWT2T5l8ll50/ELBa2JxAt9F
	 Ut0Zy5mWsa0gUjgbWpMwJjVq+xfkthNS55FGe+3HBzB5oXIYMAY/IPzr6Tj3jDjya2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793377158;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=RxROFSyFWRH+6gE4hjBVL+rigwOtdEpYHMih5SK0RW8=;
	b=nouAVCypIUqFqRuvz71m7VnuTN8311GEPlCi1cqyXm+Tr6xGj+SOFmwiYTO8psmL0SVA
	 SxSUuEY53wPQQ6HgMcGyPngmk/ny2rZxV3VIMwBJ9bwXRxbzfZ+z9dzQOJ0VJGCKuTKq5
	 dhAYr2LDPbyljoH32r9k/QQITUNas7bZLLWRxdfdUtNl2bEyvzF5csRalIjM7orJ/FylG
	 TSDt3D8fq5rMHJLnQWN2tRCWZgziF3WGJo7pI58Mfk9WhVZ6EPSC/DKMV5Sypd2oRRXmj
	 gHcD/eKG5WYZbjJtQUClAZrSTH/3TBsj8aOITUdkc6L4k29r2kp+SSwSWyO2OJHe2fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fes0PrLT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7F3606A31A;
	Fri, 30 Oct 2026 16:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fes0PrLT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AAB1F000C1;
	Fri, 30 Oct 2026 16:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793377158;
	bh=RxROFSyFWRH+6gE4hjBVL+rigwOtdEpYHMih5SK0RW8=;
	h=Date:To:From:Subject;
	b=fes0PrLT5rOWYCHMcsy7O50mp3X8UYDVMMpUXsZzLrMDlusv5JYbZ4Fm/fIV9KaPF
	 /OyZ/UFVYs+mlXABMauOSDe/W7RR1hTvVM0NQVE2+effTiL5dS3/AdHyOJJ1k9Bxxm
	 3YloRsrZIHj5sqLvKqMp5RgpSbT97tKi68g8vcLs=
Date: Fri, 30 Oct 2026 09:19:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	stable@vger.kernel.org,rakie.kim@sk.com,joshua.hahnjy@gmail.com,
	harry@kernel.org,gourry@gourry.net,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-use-one-node-set-for-interleave-weights.patch added to mm-hotfixes-unstable branch
Message-Id: <20261030161918.36AAB1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mempolicy: use one node set for interleave weights
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mempolicy-use-one-node-set-for-interleave-weights.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-use-one-node-set-for-interleave-weights.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
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

openrisc-export-mulsi3.patch
mm-mempolicy-use-one-node-set-for-interleave-weights.patch
maintainers-add-ipc-maintainers.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

