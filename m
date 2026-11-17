Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794942829;
	b=QQqZirXprRY3UE7HQb4xtn30pF4U3QgLiyTwVlbQQT9+YgxFTrvq9XPr7uU8mvHeulHk
	 JaJJ1womoT4kC/dQ0JrfjdCdfUtZac695NsTvG5zi8/A4rphp5NV3CgNFN3dVWzCcJcls
	 UYes5kjsWLd90HnuFTOTrKx7HFB2xN/yYdr3pixJVYEKhm2Xsx0RIgOdcbUbbUdGyXxEf
	 Es5xP2gjDDjug3W/gg0VzJu9qyNVfsecEa0TYSrZQYotY/lPza//Yuw/ieUR9WkVYXf1G
	 lVw7YiKuzUQguIPGhBAftNVcCUzFP62bXENwyz0vJh0n9t//HghuU7otnysaZwPUXrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794942829;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=pWe8pCpTiG+nh/e9o3pYMbte4l84UoD7Wq+omSkx+Z4=;
	b=mR6fjF0CIroIDZQ870Btts1mD/uJJD89pD72JfSpVaToMA7L3ur/kEIbSVK4Mb4uMQrg
	 g0g2GmadxSag+GVOOmf7xZNwwJNWcUUVXn4ydaKI2PL1K0EtB3NY5g3Q/Mu0G4X3kfxCV
	 vIJAlYRixhkDuBCnUEgz0B7ULTJamAhwKqYMEMw/4JwxYzZ2GFf2BTmu9KDQSZGs38rRS
	 aYJLCV1hG7plhRU637pYG4efIqa69tXO7UzR5Gm1GS4JUBGzIuNL8axsEMwjM0KY1Pzpu
	 rLVvZqmp83qIrpJUQKpOIgrco0RQo74ulhj5QAgLYUMa1grqLcbjkVf8fi3HvkpmHrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ckWPz4HR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC82606A31C
	for <mm-commits@vger.kernel.org>; Tue, 17 Nov 2026 19:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ckWPz4HR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484EF1F000C4;
	Tue, 17 Nov 2026 19:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794942829;
	bh=pWe8pCpTiG+nh/e9o3pYMbte4l84UoD7Wq+omSkx+Z4=;
	h=Date:To:From:Subject;
	b=ckWPz4HR7BlUYELT+7KwjtnSih8imM/rAfpXuY3Ks7XJSHVID042ZLBxPDJGsSTY3
	 j0pLljmZv0cSPbkqLKmDpjeMDWOvG3hlAiCYli617zehhBbel2eV3712D8evrTwJGb
	 5YNPCOcv7Iy9ibJv5TRIElru4vcoPcxr+9cuDZWk=
Date: Tue, 17 Nov 2026 11:13:48 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-page_exth-to-memory-management-page-allocator.patch added to mm-hotfixes-unstable branch
Message-Id: <20261117191349.484EF1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: add page_ext.h to MEMORY MANAGEMENT - PAGE ALLOCATOR
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-page_exth-to-memory-management-page-allocator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-page_exth-to-memory-management-page-allocator.patch

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
Subject: MAINTAINERS: add page_ext.h to MEMORY MANAGEMENT - PAGE ALLOCATOR
Date: Tue Nov 17 11:05:44 AM PST 2026

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-page_exth-to-memory-management-page-allocator
+++ a/MAINTAINERS
@@ -17779,6 +17779,7 @@ F:	include/linux/compaction.h
 F:	include/linux/gfp.h
 F:	include/linux/page-isolation.h
 F:	include/linux/pageblock-flags.h
+F:	include/linux/page_ext.h
 F:	include/trace/events/compaction.h
 F:	include/trace/events/page_isolation.h
 F:	include/trace/events/page_ref.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix.patch
maintainers-add-page_exth-to-memory-management-page-allocator.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-sanity-check-directory-metadata-block-location-fix.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

