Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794101970;
	b=Z30TuH5uc7PMVTtm3kUuak8poKiOvhYhJJzLJ46fQau/HNhvWBb79YdurE++bD2WtkIb
	 CFwccHis/jAaVb84oY/I/vLN1E9krENTZCNJJqW6xhvVw4v7Y79Kod8KJ2DPjG/UOzaEp
	 AMeim1w/+J4yISS4mXyGl/DKCW0BR1BHhfqdxW/x/ZpCaL32nn9ZDP1y+6ZCF19z8m6Aq
	 IovQOAC/ejtfAuuNlbO8H91EntJLXBpQ4GKhwIUspTIGLur60ucHPJTK9E8/0LIjP44AI
	 HwAPYlSoJz00v05Mtu3oHGge+1RM7zu+igAbINQe8oFmRnj1k38/KWJf9hwoJ+YscSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794101970;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=rM9OLcq6xIbwIW732XxG0TxQWzeqvLWK011IfvsNK/0=;
	b=WeCvD5zpktk7Wz6QOAQBbrqN/8pGMO6rDIqC40QEM3ABxAiFWVFF+kocxq49nIOgogHr
	 eleKovRah0xM4TBAHQNWRVFt/4fsTZKFP6O9voaispQmA3E+KQfBYruMXNLGe9sHNTi6x
	 GMhxkclQj9W7TzzShrvBRNDrr1+/aiKJ8U2qOMtcEtowQ9P0FhtIDC8v3+CdOdn/dLk4t
	 rsSabua5ZtqT/PZnjNnlo2KuUUATZryLSbZ570bOzNlYMF6nQryZshu835x0dIsXi2P1O
	 C1mXoNhNMr/XnvLhNhSJIEjNnnYZ8mqukzvP/rclDqFwwVqbKbPciTlDWiSenlAtzPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="hNihAi/T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309E1606A326
	for <mm-commits@vger.kernel.org>; Sun,  8 Nov 2026 01:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hNihAi/T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BE21F0089F;
	Sun,  8 Nov 2026 01:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794101969;
	bh=rM9OLcq6xIbwIW732XxG0TxQWzeqvLWK011IfvsNK/0=;
	h=Date:To:From:Subject;
	b=hNihAi/T1UB/CQpDHJH+JVd6YjbvuQ41yBWhyHYj8XJNOed6n7cw5twW0/CHhzLiR
	 O9swsqkxXNnuzJhQpQ3ilMm2XgSx1NctjqmC6cFncnrXTiTa29yjZzK0p7rKFy0pwz
	 EYJ4ii658PV4aAjoeyYkwIz0oyaOmXGsbhKD9/ac=
Date: Sat, 07 Nov 2026 17:39:28 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	ngocthang2710.1999@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20261108013929.91BE21F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix
Date: Sat Nov  7 05:37:42 PM PST 2026

build fix

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
---

 fs/squashfs/file_direct.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/squashfs/file_direct.c~squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix
+++ a/fs/squashfs/file_direct.c
@@ -118,7 +118,6 @@ mark_errored:
 		put_page(page[i]);
 	}
 
-out:
 	kfree(page);
 	return res;
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
mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix-fix.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

