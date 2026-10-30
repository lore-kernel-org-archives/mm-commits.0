Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793343124;
	b=fqPneddB/CK5cJ+bMeddm/dzJr9Oiubf9tNjn3l0YeuDsNxZAqZ7GRSN4joaJSDgjtsG
	 2BwcuzcvaROKJq/LVesDvgH81VGXQcEJoY9KBon8EaaiCsTIX6uw3TMVz7FE07Mbm3i0a
	 ABxWGyZv+5tcx7wEG1zbtGT5ix0Ypj3gdBiZBDMmrh862jqMkvKIPl6lkC2Cjm+QMIBvN
	 7JqvI0eMHvM79HVIJSgbMKmRrvJfnYDd1Yf4Tsu8wYsRN94FYjG17LgyJ+E5OWh4SMlsG
	 bw++sRhfIDpOG9BKnUd59LgtaXXIPVTvUJR5C7xToYvEnUoO9PrbgaalqLwHCDnoikg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793343124;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=H1k8lzxAxgKjsGcDIHK7UeVY6JVb+4szgq53D43Gz9M=;
	b=Fp9DsvVjtQXWcEtPIglcjSEW5NBQV7ULdaPV+/2Vmk72I0FXyug1tGIiras2VPkwnZ4p
	 JdBYBlyrFiMVvEJtEVCEXRu8w/k1uDc869FG4uJJ7RVVXM3YqVpeHiBSaN0cj1fGdFxu2
	 F8vrnel2j/sh3qLmHrfdTAoMku5VFuh8L/GUQ0Xe00XVtmTHZkT68BEjE7fmDidEWofPz
	 o06RDo+GBL8jp6PHIo5qzPmnUDkYOcnbYlWGt+e2AQgjI3zpeKBssS6f4vNCwCDjvZ+ya
	 OF1wFup82TX2lRlDf1Mh7ZNBwSeBobyTI6uVJz1/oZfKu+AxXJnaW0VtI33Bu+3lrZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eHoKw6rP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28400606A31E
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 06:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eHoKw6rP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B861F000C1;
	Fri, 30 Oct 2026 06:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793343123;
	bh=H1k8lzxAxgKjsGcDIHK7UeVY6JVb+4szgq53D43Gz9M=;
	h=Date:To:From:Subject;
	b=eHoKw6rP7BuR3rT3jYulj2+dUboVphC2FXH3QJUGClS1FHIxe2vRiCDkqW6gW9jct
	 9QVWvxIUj1nBB/b7VNBAWqyM4OhlHJSV8PHcpxbrHk73pVxSGFCusEZ4Uh+tYDq3d6
	 NzUkmaFX/u3tcaVqxUCTgMGeyZL7tnX1i4PK0Xk4=
Date: Thu, 29 Oct 2026 23:52:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,
	sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,
	peterx@redhat.com,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kas@kernel.org,
	jgg@ziepe.ca,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-mm-introduce-size_to_shift-helper.patch added to mm-new branch
Message-Id: <20261030065203.A4B861F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: kselftest: mm: introduce size_to_shift() helper
has been added to the -mm mm-new branch.  Its filename is
     kselftest-mm-introduce-size_to_shift-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-mm-introduce-size_to_shift-helper.patch

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
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: introduce size_to_shift() helper
Date: Tue, 13 Oct 2026 11:37:05 +0100

Introduce size_to_shift() for future users that need to
obtain shift of a huge-page which is other than pmd_psize().

Link: https://lore.kernel.org/20261013-fix_hpage_macro-v7-3-3d77129e0557@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
---

 tools/testing/selftests/mm/vm_util.c |    2 +-
 tools/testing/selftests/mm/vm_util.h |   12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/vm_util.c~kselftest-mm-introduce-size_to_shift-helper
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -194,7 +194,7 @@ uint64_t pmd_pshift(void)
 	if (__pmd_psize == -1ull)
 		__pmd_psize = pmd_psize();
 
-	__pmd_pshift = (__pmd_psize > 0) ? ffsl(__pmd_psize) - 1 : 0;
+	__pmd_pshift = size_to_shift(__pmd_psize);
 
 	return __pmd_pshift;
 }
--- a/tools/testing/selftests/mm/vm_util.h~kselftest-mm-introduce-size_to_shift-helper
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -159,6 +159,18 @@ static inline int sz2ord(size_t size, si
 	return __builtin_ctzll(size / pagesize);
 }
 
+static inline uint64_t size_to_shift(uint64_t size)
+{
+	/*
+	 * The function returns the corresponding shift only when the size
+	 * is a power of two; otherwise, it returns 0.
+	 */
+	if (!size || (size & (size - 1)))
+		return 0;
+
+	return ffsl(size) - 1;
+}
+
 void *sys_mremap(void *old_address, unsigned long old_size,
 		 unsigned long new_size, int flags, void *new_address);
 
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize.patch
kselftest-mm-remove-hpage_size-and-hpage_shift-macro.patch
kselftest-mm-introduce-size_to_shift-helper.patch

