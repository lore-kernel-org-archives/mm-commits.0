Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793978809;
	b=1ToYrGHBbAZerBi3vYK8t7Lfl7CW6imsxxUa7HgAD20hJ9hrubDWpayu90+BLf8SMkUx
	 se5dgUVjCIhHl6yfV8ROe944U9dQXuYs2Ol1g6W37KnsxpWa47RAGt3hrhEuqq/2WYW7u
	 NEBETjHjNyq887WA3H8BfwrwqUqeCXripusvZ3o4CwRWmWfWpQY8CQ4Mngt7n0kmZ2sVa
	 clYVAky1Y9qogyrltVHMx+HOQ9JzZYVSHdtoB/PumKbA/C7IYJrdOprg4/WvCiAxtsux5
	 c7Y+4RqWbs16go3/dT8S0KSpa9H/N7jt8vJSDRqy5irvVXm/aU1feyxbhAatg2L2Ptw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793978809;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=GnKKImVWnHBTT7XwkW/AeAFy7UwYRiHgOA6TjHfD23I=;
	b=RfSdUI35jwgM2Y8QyWvHU4gQMIuCNz4gkhgm4BNCqedmcB78ct8NMtv5+2kF2oE09nJZ
	 iYIqYelQWMZC1Ll7VFuXjrpq1nKoVUDlOjoTGWRRy2eoi/nD566LKOFke8Y7IYQFoW1CJ
	 nLRIPlGmB2fVzPg26EjqI67QoGgSOR0JVVpCONTnbBG4C5IRV6bAc+Xr3C4OSLvrX/bDO
	 1BTkEMasdUibP6QPH+paRUeOWFeL43pL+cc+BDujsY4kbN8ahRUZrikff1eYsmy58ctl/
	 U46tnoDcWRbuVFOMDFdr9IGmXN146lNIv5nqtO9mw8Mgjxg+OokGCTan74dVcmNymEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=i31ukq3l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53863606EE86
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 15:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=i31ukq3l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EB61F008A7;
	Fri,  6 Nov 2026 15:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793978808;
	bh=GnKKImVWnHBTT7XwkW/AeAFy7UwYRiHgOA6TjHfD23I=;
	h=Date:To:From:Subject;
	b=i31ukq3lHPi7xwou/lVRc855LammWscNEM+i/BxjJ6PZR4nn3RRGDnzNnWgsulzEA
	 sAUcUrx6628whvTM5lpDcLTtc0xZrHqEBXy7bfrtDaUoqNew+rFsJXWN+BtPRnRY6B
	 QwG5ihQ3gXAhtCdnOTUGVct+u74eoAR3Lj0L4aiI=
Date: Fri, 06 Nov 2026 07:26:48 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,hao.ge@linux.dev,
	abhishekbapat@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch added to mm-new branch
Message-Id: <20261106152648.C2EB61F008A7@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch

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
Subject: alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix
Date: Fri Nov  6 07:24:18 AM PST 2026

mark alloc_tag_is_traced __always_inline also, per Hao Ge

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Abhishek Bapat <abhishekbapat@google.com>
Cc: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
---

 include/linux/alloc_tag.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h~alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix
+++ a/include/linux/alloc_tag.h
@@ -156,7 +156,7 @@ static inline void alloc_tag_clear_trace
 	atomic_andnot(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
 }
 
-static inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
+static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
 {
 	return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_ON);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mempolicy-use-one-node-set-for-interleave-weights.patch
maple_tree-fix-reverse-iterator-state-when-the-root-disappears.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix.patch
selftests-mm-test-fork-of-pmd-mapped-shmem-thps-fix.patch
iommufd-enforce-memfd-write-seals-for-file-mappings.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

