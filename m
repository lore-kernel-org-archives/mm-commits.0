Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591261;
	b=eNBLtP48XxDGAOVNAEJwEOn1Qoo4g0I6DZnJDaGWrSi+D7MFg4myrD3u2urhjXgcv/a3
	 Nmw3XjoVgFkLfgdUAyQczKtLIMhFBj+Uh0tGSz24BuQOis7asakVt1LsxMY980E1T7ZNd
	 U5BxsWBAHkRHLZ4iyZjQVrd4371Gx6FOlSyqTof3uiBr+8lK93tFqnVSZ5+s/zeffii9D
	 XihFk2BD96dZyyeSiAdqSIAbKNGJ5ydhGKFLg/YnuicoNbg/O5g8PYwXrnBsbHsnKj2Ec
	 +38zFZs8yQ8wtSzjbbNDnMq90v/1QNrqRGb+TVNsr9nj6HQN2ckFBkkQlVG65cqXbfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591261;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=YTkwVwni9aexy38pynut38qLOh0LgqgZHhB7bw1C0GE=;
	b=ooagU6iip9vH3MtXEs8mts/c3zqxorU61mDT4BWzgTmSHLXnh8U3f0GeNaD7UU33sVlC
	 k3K+0VsBctqFk8VWD19T9aCFnowcIGzfiMXKuDLQGsbbEd2TK+lRYRetIByvPJzAbhKpV
	 NLBNCp3vY106GwDh4X1pcQVyfswv3IBJbKS9apKW0f4CYBZirqJCKXwcwJkT6oq8nOtUi
	 Lm90sKI5MvDJ3IeRTQwU3s4WcZO8roJjPUdoJV/1/+i61KO85ojuoO5QKD1yGZUcQUAtJ
	 ho7sCJXT703UGV4SeNSCg0LHUaa9ddU6/9qfDG/iNlHz2S5KUgVhg5v6y2gzM9P8Wjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aOWFuhiF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DB26076F96
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 17:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aOWFuhiF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D634B1F000C4;
	Fri, 13 Nov 2026 17:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794591261;
	bh=YTkwVwni9aexy38pynut38qLOh0LgqgZHhB7bw1C0GE=;
	h=Date:To:From:Subject;
	b=aOWFuhiFWMUxkQUhuKEQ32NY+aTLGgVROcdKm60PxuCS9gqx5PP4/DOaGPichSZ+7
	 Pl594peW7JkT5iRBfvvJdpVTJwZvvYxAubOQeJsy0GStp1Zd/D9LHjMbwN13LjASLj
	 Zl+WxIzBh7itzjRU9rjk2wHEUygbMJYMBWAGOmFY=
Date: Fri, 13 Nov 2026 09:34:20 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-simplify-cma_declare_contiguous_multi-fix.patch added to mm-new branch
Message-Id: <20261113173420.D634B1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm-cma-simplify-cma_declare_contiguous_multi-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-simplify-cma_declare_contiguous_multi-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-simplify-cma_declare_contiguous_multi-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: mm-cma-simplify-cma_declare_contiguous_multi-fix
Date: Fri Nov 13 09:33:48 AM PST 2026

fix typo in comment

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-simplify-cma_declare_contiguous_multi-fix
+++ a/mm/cma.c
@@ -485,7 +485,7 @@ static phys_addr_t __init cma_find_free_
 	phys_addr_t max = 0;
 	u64 i;
 
-	/* no point searching if the system can't addres above 4G */
+	/* no point searching if the system can't address above 4G */
 	if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
 		return 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
mm-cma-simplify-cma_declare_contiguous_multi-fix.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

