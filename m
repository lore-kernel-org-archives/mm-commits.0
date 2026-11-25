Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795589532;
	b=bEQvaAlF+beZ2f7rSmrXYWkW4BNoBLMPJ0Wh+HHgW2HTrlau1eDt4bwsrKjBXm+1ZJqZ
	 Zdu5A9yqYTJ9ft6OjLqMQRPwtFNlVx5ha2Npy+k5vLwG/0M94wR8KwlWXtwUt6IEBjWK8
	 T+BFfDwJ2kBlfJjUkzChkSayRvj3nXjfYXspJKkv6tuVaJudQnerCTOofb0ViTFZxey1o
	 Pq0co7yKprryqRXXTtljLvDNNyYhb8qfvo/44vHM/lPkrZVGV8bXwstHX1mh1lHy+RqU7
	 8vMuYcV3ICUTI6IfflmeJZ3pm3TOWlv7apfXMmsCQkYAO7gWNEsT4NEOMOOhQ6Dlhog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589532;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=int0CE+GrC4t+Em4g7mSk1k4sf918h+g7daBqpZK1iU=;
	b=APLh73HHEHmC0M1HR0r7SGG3Pj6TRFR+Mzs0dXxUF97CfO7QESe/ku4WojIqzUkMjwqu
	 xl+pRxZnNhdad1VgQCV7nBMPVwCYHZlAMXvGPtiR5zIgfswwTnBXXGnu184SvO9WCei1b
	 SLRIuEGceR95GrbfUqD9dmgaFPEfE6X1w2SIMM+9/uZejm2TBOPd9gCLcyzN7qH5d6j+o
	 x72i1bcSvchhode6jnyme8pL63s+fSSbdWHjCrNXTSF3nLeWiApdzXx2kRXsk8lIXRmNS
	 H96Hwf+IGdc9coYHhwkX211Oq07v9KSafgAX08QyU3onF+owZTdf9sABPb3Zv/CV1Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WCpC4tqL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD80606A31E;
	Wed, 25 Nov 2026 06:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WCpC4tqL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E151F000C0;
	Wed, 25 Nov 2026 06:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795589531;
	bh=int0CE+GrC4t+Em4g7mSk1k4sf918h+g7daBqpZK1iU=;
	h=Date:To:From:Subject;
	b=WCpC4tqLN2qiNWrUR5f1sDKB8WkBiaGpCW1vbhgCHPoVQKfKeq8vTHJhbhlkBIy+W
	 I5ZyfRfqiBS8B0vYL7DR03FFIkwj48ftRvgCKeNsZrkc8zZFsPNdXbBgAHsKDfPEqW
	 pZStoGhD3ib4yDU3kOVZORgX5Zzt4lmdH+gKuf8s=
Date: Tue, 24 Nov 2026 22:52:11 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,
	shuah@kernel.org,rppt@kernel.org,rcampbell@nvidia.com,mpenttil@redhat.com,
	mhocko@suse.com,liam@infradead.org,leon@kernel.org,jm5905938@gmail.com,
	jgg@ziepe.ca,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-test_hmm-invalidate-all-mirrors-on-device-private-migration-fix.patch removed from -mm tree
Message-Id: <20261125065211.83E151F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: lib/test_hmm: fix device-private backing subpage selection
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-invalidate-all-mirrors-on-device-private-migration-fix.patch

This patch was dropped because it was folded into lib-test_hmm-invalidate-all-mirrors-on-device-private-migration.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/test_hmm: fix device-private backing subpage selection
Date: Sun, 22 Nov 2026 11:22:16 -0800

BACKING_PAGE() evaluates to void * because zone_device_data is void *. 
Adding folio_page_idx() to it advances by bytes, so a device-private PMD
subpage can select the wrong RAM backing page.  The new
migrate_anon_huge_fault() selftest fails when it reads the last subpage.

Assign the backing address to a struct page * before adding the subpage
index.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>

 lib/test_hmm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-invalidate-all-mirrors-on-device-private-migration-fix
+++ a/lib/test_hmm.c
@@ -294,9 +294,9 @@ static int dmirror_do_fault(struct dmirr
 
 		if (is_device_private_page(page)) {
 			struct folio *folio = page_folio(page);
+			struct page *backing = BACKING_PAGE(&folio->page);
 
-			page = BACKING_PAGE(&folio->page) +
-				folio_page_idx(folio, page);
+			page = backing + folio_page_idx(folio, page);
 		}
 		entry = page;
 		if (*pfns & HMM_PFN_WRITE)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vma-drop-mm-asynchronously-in-vma_start_read-fix.patch
mm-vma-drop-mm-asynchronously-in-vma_start_read-fix-2.patch
kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch
mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix.patch
lib-test_hmm-invalidate-all-mirrors-on-device-private-migration.patch
mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages.patch
afs-do-not-put-error-pointer-after-address-lookup-failure.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-0.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-1.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-2.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-3.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-4.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-5.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-6.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-7.patch
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
lib-asn1_encoder-fix-encoding-of-zero-oid-components.patch
proc-serialize-task-owner-updates.patch
proc-dont-lock-task-inodes-whose-owner-has-not-changed.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

