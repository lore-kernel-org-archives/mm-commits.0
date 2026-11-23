Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795405716;
	b=ibDW64TlvkPcFb0fxN3BcKSF6y9llOnZsWYZwvjFB7bQKamNKaszrD27XH4UIC/P//QV
	 s1mlL+vCoCsapYBi3VniLenNaqsz3c399B00OjlRFSq6qVdMINEB3VC1bIKgqRT47U1S4
	 PD3X3mqcHfljA2feK2HKCtvwrgyRbg4P9Zd30Sgg8oymBxH8Vrj8XKSflNBlMdGPOrzTy
	 jqazoAbPRo9t4htzvO/0vwL7ehsQzwx/9ZrVO6cKVrMTFvZmXQdNZMr/bh8Ue7uIPwUAg
	 DW8sjE/p5cBTQ6ipESv9YKWNKWaGhBZlYJzsl0TL80lLcrYtH2dsgyf45IsjaWl7obg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795405716;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=W4KT8evZRaGXBRQrCyG7flfyT0ACB7pZ04TPRi3N5tk=;
	b=1/nGDXGlRLouD0b4+IqyfmsL6/1Xkcciazq7bmPagBLumgn+/1hnmWLlenPnMZ4yrGCw
	 L1QCF6kBSm44mdJVeFP8M3xi15HMEVWO0BeOGI49iSpBdZ5FjlQ8xwG8pwmTiTcnOWNY0
	 hCozqwFVSRNXIni0vife+lDG+6GpSoOn7wopB6UYce9RTVxAhsMGG3Y8cbvvDm+eCchDb
	 PDEzWwFApStEJvcoJPUwxMIIbFNJQaYdd4sOfuY0HmIzvFxyKFZ3pxZuOClAD1Cz25una
	 NlntU+YAhZ261Eao+L77rL5TpREes2AE21rxlziCbKrrdUPCJrvph5MPKCVYslVWugA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mTTaJmRa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD19606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 03:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mTTaJmRa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53971F000D0;
	Mon, 23 Nov 2026 03:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795405715;
	bh=W4KT8evZRaGXBRQrCyG7flfyT0ACB7pZ04TPRi3N5tk=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=mTTaJmRaRtb7Ofu/sKprtJz6sozlDeNh8Ft8AMWJDAwb2gJ1M7afCkK94x7VgQnGx
	 CbOE2v0NG/30gCX75FdtRRERBSsNv09R4mWvwoDG6zvvY0L7d+maWOIm9qLgPiAal/
	 xe92xIyupKkdWlXIE3VPioiCL/zKxmSUBP4kKTyM=
Date: Sun, 22 Nov 2026 19:48:35 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,sarthak.sharma@arm.com,
	rppt@kernel.org,rientjes@google.com,mhocko@suse.com,
	mathieu.desnoyers@efficios.com,lkp@intel.com,liam@infradead.org,
	david@kernel.org,cl@gentwo.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <21183f5b-2697-cbe6-6370-dbd27c5e2b60@google.com>
References: <21183f5b-2697-cbe6-6370-dbd27c5e2b60@google.com>
Subject: + mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix.patch added to mm-unstable branch
Message-Id: <20261123034835.B53971F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vmstat_kunit: avoid sparse warning in vm event cleanup
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/vmstat_kunit: avoid sparse warning in vm event cleanup
Date: Sun, 22 Nov 2026 18:51:40 -0800

Sparse warns about -TEST_COUNT in an unreachable 1-byte arm64 per-CPU
case; the actual counter is 8 bytes.  Pass the completed loop count
instead to silence the warning, with no behavior change.

Link: https://lore.kernel.org/r/21183f5b-2697-cbe6-6370-dbd27c5e2b60@google.com
Fixes: 7d1a16abe4cc ("mm: vmstat_kunit: add synthetic benchmark for mm stats")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/20261121133112.48w1QOqw-lkp@intel.com/
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>

 mm/tests/vmstat_kunit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/tests/vmstat_kunit.c~mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix
+++ a/mm/tests/vmstat_kunit.c
@@ -107,7 +107,7 @@ static void vmstat_test_interleaved_zone
 
 /*
  * Test 3: count_vm_event() benchmark.
- * Restores counter balance with count_vm_events(item, -TEST_COUNT).
+ * Restores counter balance after measurement.
  */
 static void vmstat_test_count_vm_event(struct kunit *test)
 {
@@ -124,7 +124,7 @@ static void vmstat_test_count_vm_event(s
 	time2 = get_cycles();
 
 	/* Restore balance */
-	count_vm_events(SLABS_SCANNED, -TEST_COUNT);
+	count_vm_events(SLABS_SCANNED, -(long)i);
 
 	time = time2 - time1;
 	avg_cycles = div_u64(time, TEST_COUNT);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-page_exth-to-memory-management-page-allocator.patch
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
lib-test_hmm-invalidate-all-mirrors-on-device-private-migration-fix.patch
mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages.patch
selinux-recheck-backing-file-permissions-on-remap_file_pages.patch
mm-madvise-notify-userfaultfd-when-installing-guard-regions.patch
mm-highmem-reject-previously-poisoned-pages-in-machine-check-copies.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache.patch
fuse-let-memory-failure-remove-poisoned-page-cache-folios.patch
nilfs2-report-mapping-errors-from-fsync.patch
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-sanity-check-directory-metadata-block-location-fix.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
jfs-validate-xattr-entry-bounds-before-replacing-an-attribute.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

