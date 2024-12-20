Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19F51A9B27
	for <mm-commits@vger.kernel.org>; Fri, 20 Dec 2024 22:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734734353; cv=none; b=sQIcpJz/fgL0fROWlAp+DL/vj6ttqgCp+ZeFfZbSUr3hHcIHN5YBJR/ci22u8+f37KrdbVbiolcC7K/Rqz762zU3dNXznbr+M6LkqsKRyzG7LjhVjaSlcrP4tKGsPLF7azjCC06piUHBR+rICaFY8fKPsNgs4CPzZHfsA1FLeoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734734353; c=relaxed/simple;
	bh=SbOXESvjwzFC3Ilhy+QICI/8vnCCwYTNxavJnLLWamg=;
	h=Date:To:From:Subject:Message-Id; b=KO/pq0vN1lYzjDmq1ArD3ANpMky1rw0CdUyk/SAg9lDASnnX10b5nn7WKOvGx02LETya9oLQTiYEgB7Y1gBcn9YsN1TRsr6GX3NFgN24HcPq9db0nfR5OeY6oVLHiMPJv250zXPAqmsKerhmL6K2ubbPeYMVDetdfXMFqUjPbB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Et/wycFo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Et/wycFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37ADDC4CECD;
	Fri, 20 Dec 2024 22:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734734353;
	bh=SbOXESvjwzFC3Ilhy+QICI/8vnCCwYTNxavJnLLWamg=;
	h=Date:To:From:Subject:From;
	b=Et/wycFovi/+g+YddFBCeV5ZNrAOf3tHLLjo5iizymNPu0opqh2WaacNP1Kd6MJFy
	 IbxfQ7E03u3AYV0QD48J/Z2jmiS1wGPSY89SD63M4SgwLaAdVvevcGOP1JTOhM5Tz3
	 9v7MjcgVyBxj7j0drpxowepFI1SJMEZXYcbUTyCE=
Date: Fri, 20 Dec 2024 14:39:12 -0800
To: mm-commits@vger.kernel.org,yangge1116@126.com,muchun.song@linux.dev,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + replace-free-hugepage-folios-after-migration-fix-2.patch added to mm-unstable branch
Message-Id: <20241220223913.37ADDC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: replace-free-hugepage-folios-after-migration-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     replace-free-hugepage-folios-after-migration-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/replace-free-hugepage-folios-after-migration-fix-2.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: replace-free-hugepage-folios-after-migration-fix-2
Date: Fri Dec 20 02:38:13 PM PST 2024

make the replace_free_hugepage_folios() stub static inline

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: yangge <yangge1116@126.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~replace-free-hugepage-folios-after-migration-fix-2
+++ a/include/linux/hugetlb.h
@@ -1060,7 +1060,8 @@ static inline int isolate_or_dissolve_hu
 	return -ENOMEM;
 }
 
-int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
+static inline int replace_free_hugepage_folios(unsigned long start_pfn,
+					       unsigned long end_pfn)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv-checkpatch-fixes.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
replace-free-hugepage-folios-after-migration-fix.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
xarray-port-tests-to-kunit-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

